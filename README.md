# execute-immediate-issue
This small repo is for the benefit of Supraja at Snowflake Support to demonstrate an issue.

# Problems using EXECUTE IMMEDIATE FROM

The desire is to use Github Actions with "EXECUTE IMMEDIATE FROM" to orchestrate our deployments.  

I would like to have all my ```EXECUTE IMMEDIATE FROM``` commands for all our DDL operations live in a single driver script. However, when attempting to create a new database or schema the first EXECUTE IMMEDIATE FROM call succeeds, but the second one fails. 

Go to [sf_deploy_prd.sql](apps/sf_deploy_prd.sql) to see my driver script. This also contains the errors that occur on their respective lines.  Interestingly, calls to build tables, views or any other kind of database object can be called sequentially from within my driver script with no issue. It only seems to be when building databases and/or schemas that this occurs. 

## Successful (but not optimal) workaround  

If I move all my ```EXECUTE IMMEDIATE FROM``` database/schema build commands from [sf_deploy_prd.sql](apps/sf_deploy_prd.sql) and put them in [main.yml](/.github/workflows/main.yml) instead, BOTH [pnc_sales_bronze_schema.sql](apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/bronze/pnc_sales_bronze_schema.sql) AND [pnc_sales_silver_schema.sql](pps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/silver/pnc_sales_silver_schema.sql) will complete successfully!  Therefore I am certain this is not a syntax issue with my code.  

### Possible theory   

The issue seems to be some type of session or CLI confusion when using nested ```EXECUTE IMMEDIATE FROM``` to effect changes that involving a database or schema.  As noted, the issue does NOT occur when building tables/views etc.


## Details of failure
- Execution flow:  

When a commit to the repository happens Github Actions triggers [main.yml](/.github/workflows/main.yml).  
main.yml then calls:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[sf_deploy_prd.sql](apps/sf_deploy_prd.sql) calls:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[pnc_sales_bronze_schema.sql](apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/bronze/pnc_sales_bronze_schema.sql) calls:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[build_schema.sql](apps/build_schema.sql)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[pnc_sales_silver_schema.sql](apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/silver/pnc_sales_silver_schema.sql)    << Fails when it reaches here   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[build_schema.sql](apps/build_schema.sql)

![alt text](.images/separate_vars.png)





