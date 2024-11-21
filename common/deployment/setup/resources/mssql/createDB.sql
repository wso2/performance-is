CREATE DATABASE IDENTITY_DB;
CREATE DATABASE UM_DB;
CREATE DATABASE REG_DB;
GO

USE IDENTITY_DB;
GO
:r /home/ubuntu/wso2is/dbscripts/identity/mssql.sql
:r /home/ubuntu/wso2is/dbscripts/consent/mssql.sql
GO
:r /home/ubuntu/workspace/is/truncate_non_empty_table.sql

USE UM_DB;
GO
:r /home/ubuntu/wso2is/dbscripts/mssql.sql

USE REG_DB;
GO
:r /home/ubuntu/wso2is/dbscripts/mssql.sql
