USE ROLE security_admin;

GRANT ROLE create_global TO ROLE data_engineer;
GRANT ROLE db_analytics_rw TO ROLE data_engineer;
GRANT ROLE db_analytics_r TO ROLE analyst;

GRANT ROLE data_engineer,analyst TO ROLE sysadmin;


GRANT USAGE ON DATABASE ANALYTICS TO ROLE db_analytics_r;
GRANT USAGE ON ALL SCHEMAS IN DATABASE ANALYTICS TO ROLE db_analytics_r;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE ANALYTICS TO ROLE db_analytics_r;
GRANT SELECT ON ALL TABLES IN DATABASE ANALYTICS TO ROLE db_analytics_r;
GRANT SELECT ON FUTURE TABLES IN DATABASE ANALYTICS TO ROLE db_analytics_r;

GRANT CREATE SCHEMA, USAGE ON DATABASE ANALYTICS TO ROLE db_analytics_rw;
GRANT USAGE ON ALL SCHEMAS IN DATABASE ANALYTICS TO ROLE db_analytics_rw;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE ANALYTICS TO ROLE db_analytics_rw;
GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN DATABASE ANALYTICS TO ROLE db_analytics_rw;
GRANT SELECT,INSERT,UPDATE,DELETE ON FUTURE TABLES IN DATABASE ANALYTICS TO ROLE db_analytics_rw;

SET user='devhobday';
GRANT ROLE data_engineer TO USER IDENTIFIER($user);