-- Required for invoking XML data types.
SET QUOTED_IDENTIFIER ON;
GO

-- Stored procedure for generating drop foreign key statements.
CREATE OR ALTER PROCEDURE usp_generate_drop_create_fk_cmd
(
	@tableName  NVARCHAR(50),
	@dropCmd    NVARCHAR(MAX) OUTPUT,
	@createCmd  NVARCHAR(MAX) OUTPUT
)
AS
	BEGIN
       	SELECT @dropCmd += N'ALTER TABLE ' + QUOTENAME(cs.name) + '.' + QUOTENAME(ct.name)
		    + ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';'
			FROM sys.foreign_keys AS fk
			INNER JOIN sys.tables AS ct
			  ON fk.parent_object_id  = ct.object_id
			INNER JOIN sys.schemas AS cs
			  ON ct.schema_id = cs.schema_id
			WHERE fk.referenced_object_id = (SELECT object_id FROM sys.tables AS ct WHERE ct.name = @tableName);

		SELECT @createCmd += N'ALTER TABLE '
		  + QUOTENAME(cs.name) + '.' + QUOTENAME(ct.name)
		  + ' ADD CONSTRAINT ' + QUOTENAME(fk.name)
		  + ' FOREIGN KEY (' + STUFF((SELECT ',' + QUOTENAME(c.name)
		    FROM sys.columns AS c
		    INNER JOIN sys.foreign_key_columns AS fkc
		    ON fkc.parent_column_id = c.column_id
		    AND fkc.parent_object_id = c.object_id
		    WHERE fkc.constraint_object_id = fk.object_id
		    ORDER BY fkc.constraint_column_id
		    FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 1, N'')
		  + ') REFERENCES ' + QUOTENAME(rs.name) + '.' + QUOTENAME(rt.name)
		  + '(' + STUFF((SELECT ',' + QUOTENAME(c.name)
		    FROM sys.columns AS c
		    INNER JOIN sys.foreign_key_columns AS fkc
		    ON fkc.referenced_column_id = c.column_id
		    AND fkc.referenced_object_id = c.object_id
		    WHERE fkc.constraint_object_id = fk.object_id
		    ORDER BY fkc.constraint_column_id
		    FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 1, N'') + ');'
		FROM sys.foreign_keys AS fk
		INNER JOIN sys.tables AS rt
		  ON fk.referenced_object_id = rt.object_id
		INNER JOIN sys.schemas AS rs
		  ON rt.schema_id = rs.schema_id
		INNER JOIN sys.tables AS ct
		  ON fk.parent_object_id = ct.object_id
		INNER JOIN sys.schemas AS cs
		  ON ct.schema_id = cs.schema_id
		WHERE rt.is_ms_shipped = 0
		  AND ct.is_ms_shipped = 0
		  AND fk.referenced_object_id = (SELECT object_id FROM sys.tables AS ct WHERE ct.name = @tableName);
	    RETURN;
	END;
GO

-- Temporary table for holding foreign key dropping and creating statements.
DROP TABLE IF EXISTS #temp_foreign_key_scripts;
CREATE TABLE #temp_foreign_key_scripts
(
  drop_script NVARCHAR(MAX),
  create_script NVARCHAR(MAX)
);

DECLARE @dropForeignKeysStatement   NVARCHAR(MAX) = N'',
        @createForeignKeysStatement NVARCHAR(MAX) = N'';

-- Generate commands for dropping and creating foreign keys.
-- Add tables with foreign key references.
EXEC usp_generate_drop_create_fk_cmd N'IDN_OAUTH2_AUTHORIZATION_CODE',
    @dropForeignKeysStatement OUTPUT,
    @createForeignKeysStatement OUTPUT;
EXEC usp_generate_drop_create_fk_cmd N'IDN_OAUTH2_ACCESS_TOKEN',
    @dropForeignKeysStatement OUTPUT,
    @createForeignKeysStatement OUTPUT;

INSERT #temp_foreign_key_scripts VALUES (@dropForeignKeysStatement, @createForeignKeysStatement);

-- Drop relevant foreign keys.
EXEC sp_executesql @dropForeignKeysStatement;

-- Add tables that need to be truncated.
TRUNCATE TABLE IDN_AUTH_SESSION_STORE;
TRUNCATE TABLE IDN_AUTH_TEMP_SESSION_STORE;
TRUNCATE TABLE IDN_OAUTH2_AUTHORIZATION_CODE;
TRUNCATE TABLE IDN_OAUTH2_ACCESS_TOKEN_SCOPE;
TRUNCATE TABLE IDN_OAUTH2_ACCESS_TOKEN;
TRUNCATE TABLE IDN_AUTH_SESSION_META_DATA;
TRUNCATE TABLE IDN_AUTH_SESSION_APP_INFO;
TRUNCATE TABLE IDN_AUTH_USER_SESSION_MAPPING;

-- Recreate the foreign keys.
EXEC sp_executesql @createForeignKeysStatement;

SET QUOTED_IDENTIFIER OFF;
GO
