drop database if exists IDENTITY_DB;

create database IDENTITY_DB character set latin1;

use IDENTITY_DB; source ~/wso2is/dbscripts/identity/mysql.sql;
use IDENTITY_DB; source ~/wso2is/dbscripts/consent/mysql.sql;
