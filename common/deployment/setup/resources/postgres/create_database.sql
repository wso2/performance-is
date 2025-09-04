create database "thunderdb";
create database "runtimedb";

\c thunderdb
\i /home/ubuntu/thunder/dbscripts/thunderdb/postgres.sql
\c runtimedb
\i /home/ubuntu/thunder/dbscripts/runtimedb/postgres.sql
