create database IDENTITY_DB CHARACTER SET latin1;
create database UM_DB CHARACTER SET latin1;
create database REG_DB CHARACTER SET latin1;

use IDENTITY_DB; source ~/wso2is/dbscripts/identity/mysql.sql;
use IDENTITY_DB; source ~/wso2is/dbscripts/consent/mysql.sql;
use UM_DB; source ~/wso2is/dbscripts/mysql.sql;
use REG_DB; source ~/wso2is/dbscripts/mysql.sql;

-- add tables that could vary in different IS packs
use IDENTITY_DB;
CREATE TABLE IF NOT EXISTS IDN_AUTH_TEMP_SESSION_STORE(id int);
