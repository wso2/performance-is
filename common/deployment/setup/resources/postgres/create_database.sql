create database "IDENTITY_DB";
create database "UM_DB";
create database "REG_DB";

\c IDENTITY_DB
\i /home/ubuntu/wso2is/dbscripts/identity/postgresql.sql
\c IDENTITY_DB
\i /home/ubuntu/wso2is/dbscripts/consent/postgresql.sql
\c UM_DB
\i /home/ubuntu/wso2is/dbscripts/postgresql.sql
\c REG_DB
\i /home/ubuntu/wso2is/dbscripts/postgresql.sql
