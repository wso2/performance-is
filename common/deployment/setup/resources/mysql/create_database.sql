create database IDENTITY_DB;
create database UM_DB;
create database REG_DB;

use IDENTITY_DB; source ~/wso2is/dbscripts/identity/mysql.sql;
use IDENTITY_DB; source ~/wso2is/dbscripts/consent/mysql.sql;
use UM_DB; source ~/wso2is/dbscripts/mysql.sql;
use REG_DB; source ~/wso2is/dbscripts/mysql.sql;
