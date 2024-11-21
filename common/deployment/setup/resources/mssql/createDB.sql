create database IDENTITY_DB;
create database UM_DB;
create database REG_DB;

use IDENTITY_DB; source ~/wso2is/dbscripts/identity/mssql.sql;
use IDENTITY_DB; source ~/wso2is/dbscripts/consent/mssql.sql;
use UM_DB; source ~/wso2is/dbscripts/mssql.sql;
use REG_DB; source ~/wso2is/dbscripts/mssql.sql;
