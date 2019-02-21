create database IDENTITY_DB;
create database UM_DB;
create database REG_DB;

use IDENTITY_DB; source ~/wso2is/dbscripts/identity/mysql-5.7.sql;
use UM_DB; source ~/wso2is/dbscripts/mysql5.7.sql;
use REG_DB; source ~/wso2is/dbscripts/mysql5.7.sql;