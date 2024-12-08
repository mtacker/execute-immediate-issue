# execute-immediate-issue
This small repo is for the benefit of Supraja at Snowflake Support to demonstrate an issue.

# Problems using EXECUTE IMMEDIATE FROM

The desire is to use Github Actions with "EXECUTE IMMEDIATE FROM" to orchestrate our deployments.  

I would like to have all my ```EXECUTE IMMEDIATE FROM``` commands for all our DDL operations live in a single driver script. However, when attempting to create a new database or schema the first EXECUTE IMMEDIATE FROM call succeeds, but the second one fails. If I flip my lines around the same thing happens, first succeeds, second still fails.

Go to [sf_deploy_prd.sql](apps/sf_deploy_prd.sql) to see my driver script. I've added comments whein sf_deploy_prd.sql to indicate where re the errors occur. Interestingly, calls to build tables, views or any other kind of database object can be fun sequentially from within my driver script just fine. It only when running my scripts that build databases and/or schemas that this issue occurs. And I suspect even further that the issue has to do with the extensive use of SET statements in the failing scripts.  Note> this is NOT an issue with syntax in my schema build scripts. I know that because I can run them all sequentially from main.yml and everythign runs just fine! I can build roles, schemas and databases without issue that way!  This is in no way a show-stopper from using ```EXECUTE IMMEDIATE FROM``` to do my deployments. It's just an inconvenience because I'm going to have to shove all my 'schema build' scripts in main.yml. Just not optimal as noted below:  

## Successful (but not optimal) workaround  

If I move all my ```EXECUTE IMMEDIATE FROM``` database/schema build commands from [sf_deploy_prd.sql](apps/sf_deploy_prd.sql) and put them in [main.yml](/.github/workflows/main.yml) instead, BOTH [pnc_sales_bronze_schema.sql](apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/bronze/pnc_sales_bronze_schema.sql) AND [pnc_sales_silver_schema.sql](pps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/silver/pnc_sales_silver_schema.sql) will complete successfully!  Therefore I am certain this is not a syntax issue with my code.  

### Possible theory   

The issue seems to be some type of session or CLI confusion when using nested ```EXECUTE IMMEDIATE FROM``` to effect changes that involving a database or schema.  As noted, the issue does NOT occur when building tables/views etc.


## Execution Flow

The whole purpose of this is to be able to do deployments to any of our 3 Snowflake Accounts.  For instance, let's say these are the Snowflake accounts listed in my connections.toml file:  

[DEV]
account = "b98765.us-east-1"

[QA]
account = "a12345.us-east-1"

[PRD]
account = "x87654.us-east-1"


Then commits to these named branches will cause Github Actions to trigger [main.yml](/.github/workflows/main.yml) and build against the Snowflake Account that matches the branch name (DEV/QA/PRD).  
NOTE> There are other minor setups not listed here such as adding your Github secrets to provide account and credential details as well as setting up the local (snowflake) repo. 

The execution flow within this repo will be:  
main.yml then calls:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[sf_deploy_prd.sql](apps/sf_deploy_prd.sql) calls:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[pnc_sales_bronze_schema.sql](apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/bronze/pnc_sales_bronze_schema.sql) calls:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[build_schema.sql](apps/build_schema.sql)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[pnc_sales_silver_schema.sql](apps/pnc/snowflake_objects/databases/pnc_sales_db/schemas/silver/pnc_sales_silver_schema.sql)    << Fails when it reaches here   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[build_schema.sql](apps/build_schema.sql)

![alt text](.images/separate_vars.png)




