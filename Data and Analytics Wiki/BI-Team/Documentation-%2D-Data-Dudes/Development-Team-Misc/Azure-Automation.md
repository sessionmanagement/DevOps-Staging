## Azure Automation setup


## Setup
Account setup with the following name
- aa-dev-aus-data-reporting
- aa-prod-aus-data-reporting


### Identity
Make sure the System assigned Identity is enabled 

![image.png](/.attachments/image-ca8515de-696e-464e-9f0d-e28627d74f9c.png)

### Scaling Database
using a powershell script we are scaling databases up and down according to the tier they need to be on
|Role | Resource Name
|--|--|
\#EAL Application Readers (DevOps/AppOps)| rg-prod-aus-svc-datareporting|
SQL Server Contributor| eal-sql01|
\#EAL Application Readers (DevOps/AppOps)| rg-prod-aus-svc-datalanding|
SQL Server Contributor| sql-prod-aus-svc-datawarehouse-01|

## Roles
Below is the following Roles the Automation Account as been assigned to

#### Schedule
|Schedule Start Time|Server|Database|Tier|
|--|--|--|--|
12:01am| eal-sql01 |Recordbase_EmergeAotearoa_Elite| S0
05:45am| eal-sql01 |Recordbase_EmergeAotearoa_Elite| S2
08:30am| eal-sql01 |Recordbase_EmergeAotearoa_Elite| S0
04:30am| sql-prod-aus-svc-datawarehouse-01 |EDW| S6
08:45am| sql-prod-aus-svc-datawarehouse-01 |EDW| S3
17:00am| sql-prod-aus-svc-datawarehouse-01 |EDW| S0


