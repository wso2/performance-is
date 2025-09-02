create database "thunderdb";
create database "runtimedb";

\c thunderdb
\i /home/ubuntu/wso2is/dbscripts/thunderdb/postgres.sql
\c runtimedb
\i /home/ubuntu/wso2is/dbscripts/runtimedb/postgres.sql
