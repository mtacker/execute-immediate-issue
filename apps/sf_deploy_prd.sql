--------------------------------------------------------------------------------------------
--  SCRIPT:    Code from this script updates objects in Snowflake production account.
--             
--             
--
--   YY-MM-DD WHO          CHANGE DESCRIPTION
--   -------- ------------ -----------------------------------------------------------------
--   Driver script for building databases, schemas, tables, views etc
--------------------------------------------------------------------------------------------










-- SCHEMAS     
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/bronze/pnc_sales_bronze_schema.sql;  
--------------------------------------------------------------------------------------------
-- Where EXECUTE IMMEDIATE FROM fails
--------------------------------------------------------------------------------------------
-- EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/adm/snowflake_objects/databases/adm_platform_db/schemas/tags/tags_schema.sql;

-- First 'EXECUTE IMMEDIATE FROM' succeeds, but the Second statement fails with error:
--
-- Uncaught exception of  │
-- │ type 'STATEMENT_ERROR' in file                                               │
-- │ @SNOWFLAKE_GIT_REPO/branches/master/apps/sf_deploy_prd.sql on line 36 at     │
-- │ position 0:                                                                  │
-- │ Cannot perform operation. This session does not have a current database.     │
-- │ Call 'USE DATABASE', or use a qualified name.   
-- *******************************************************************************
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/silver/pnc_sales_silver_schema.sql;  
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/gold/pnc_sales_gold_schema.sql;  

-- TABLES
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/bronze/tables/customer.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/bronze/tables/product.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/bronze/tables/orders.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/silver/tables/customer.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/silver/tables/orders.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/silver/tables/product.sql;
EXECUTE IMMEDIATE FROM @SNOWFLAKE_GIT_REPO/branches/master/apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/gold/tables/shipping.sql;

-- VIEWS

-- PROCEDURES