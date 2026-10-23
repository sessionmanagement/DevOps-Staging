# Infrastructure Inventory

**Purpose:** Complete inventory of all Azure resources, databases, storage accounts, and services that comprise the BI data platform. This page is the reference for DR recovery — every component listed here must be verified as operational after a disaster recovery event.

---

## Azure Subscription & Resource Groups

| Resource | Value | Environment |
|----------|-------|-------------|
| **Subscription ID** | `3ad070fe-7936-4060-a09c-338ac9352378` | All |
| **Region (Primary)** | Australia East | Production, Dev |
| **Region (Secondary)** | Australia Southeast | Some services |

| Resource Group | Environment | Key Contents |
|----------------|-------------|-------------|
| `rg-prod-aus-svc-datareporting` | Production | Synapse workspaces, EDW SQL server, storage accounts |
| `rg-prod-aus-svc-datalanding` | Production | Azure Data Factory, Data Landing SQL server |
| `rg-test-aus-svc-datareporting` | Test | Test Synapse, test SQL, test storage |
| `rg-dev-aus-svc-datareporting` | Dev | Dev Synapse, dev SQL, dev storage |

---

## SQL Servers & Databases

### Production

| Server | Database | Purpose | Backup Type | PITR Window |
|--------|----------|---------|-------------|-------------|
| `sql-prod-aus-svc-datawarehouse-01` | `sqldb-prod-datawarehouse-01` | Enterprise Data Warehouse (EDW) | Azure PITR | 35 days |
| `sql-prod-aus-svc-datawarehouse-01` | `sqldb-prod-manager` | Manager DB (monitoring, DQ, audit) | Azure PITR | 7 days |
| `sql-prod-aus-svc-fk-01` | `Framework` | ETL metadata & configuration | Azure PITR | 7 days |
| `sql-prod-aue-svc-datalanding` | `sqldb-prod-entprod-01` | Data Landing Area SQL | Azure PITR | _Verify_ |
| `eal-sql01` | `Recordbase_EmergeAotearoa_Elite` | RecordBase EAL | Azure PITR | 7 days |
| `eal-sql01` | `Recordbase_MindAndBody_Elite` | RecordBase M&B | Azure PITR | 7 days |

### Development

| Server | Database | Purpose |
|--------|----------|---------|
| `sql-dev-aue-svc-datawarehouse-01` | `sqldb-dev-datawarehouse-01` | Dev EDW |
| `sql-dev-aus-svc-fk-01` | `Framework` (dev) | Dev Framework |

### Test

| Server | Database | Purpose | Notes |
|--------|----------|---------|-------|
| `sql-test-aus-svc-datawarehouse-01` | Test EDW | Cloned from Production | Auto-generated via ADF copy pipeline |

### EDW Auto-Scaling Schedule

| Time (NZST) | Action | Target Tier | Reason |
|-------------|--------|-------------|--------|
| 04:30 AM | Scale UP | S6 | Morning data load preparation |
| 08:45 AM | Scale DOWN | S3 | Business hours |
| 17:00 PM | Scale DOWN | S0 | Evening minimal compute |

> **DR Note:** After restoring the EDW database, verify the auto-scaling automation account/logic app is also operational.

---

## Synapse Workspaces

| Workspace | Endpoint | Environment | Resource Group |
|-----------|----------|-------------|----------------|
| `synapseausprod` | `synapseausprod.dev.azuresynapse.net` | Production | `rg-prod-aus-svc-datareporting` |
| `synapseausdev` | `synapseausdev.dev.azuresynapse.net` | Dev | `rg-dev-aus-svc-datareporting` |

**Synapse Dev URL:**
```
https://web.azuresynapse.net/en/home?workspace=/subscriptions/3ad070fe-7936-4060-a09c-338ac9352378/resourceGroups/rg-dev-aus-svc-datareporting/providers/Microsoft.Synapse/workspaces/synapseausdev
```

### Synapse Integration Runtime

| Runtime | Region | Purpose |
|---------|--------|---------|
| `IntegrationRuntimeAUSE` | Australia East | Primary data movement |
| `AutoResolveIntegrationRuntime` | Auto | Default/fallback |

---

## Azure Data Factory

| Name | Resource Group | Pipelines | Triggers | Region |
|------|---------------|-----------|----------|--------|
| `adf-prod-aus-datalanding-01` | `rg-prod-aus-svc-datalanding` | 20+ | 13 active | Australia Southeast |

---

## Storage Accounts (ADLS Gen2)

| Account | Environment | Purpose | Soft Delete | Containers |
|---------|-------------|---------|-------------|------------|
| `stprodaussvcsyn` | Production | ODS Data Lake, DLA staging | **Enabled** | ods, staging, reference |
| `stprodaussvcdatalanding01` | Production | Raw data landing from source systems | _Verify_ | Per source system |
| `stprodaussvcwaharoa01` | Production | Zavanti / Waharoa property data | _Verify_ | Property data |
| `stdevaussvcsyn` | Dev | Dev data lake | _Verify_ | Dev datasets |
| `sttestaussvcsyn` | Test | Test data lake | _Verify_ | Test replication |

---

## Azure Key Vault

| Vault | Environment | Purpose | Purge Protection |
|-------|-------------|---------|-----------------|
| `kv-prod-aus-svc-syn-01` | Production | All credentials, API keys, connection strings, service principal secrets | **90 days enabled** |

> **CRITICAL:** This Key Vault is referenced by ALL ADF/Synapse linked services. Loss of this vault prevents all pipeline execution.

---

## Azure DevOps Repositories

| Repository | DevOps Project | Purpose | Deploy Method | Key Branches |
|------------|---------------|---------|---------------|-------------|
| **EDW** | Data and Analytics | EDW database schema (SSDT) | DACPAC | main, Test, Production |
| **ODS** | Data and Analytics | ODS database schema (SSDT) | DACPAC | main, Test, Production |
| **Datalanding** | Data and Analytics | DLA view definitions (SSDT) | DACPAC | main, Test, Production |
| **Data Framework** | Data and Analytics | Framework DB + BIML config | DACPAC + BCP | main, Test, Production |
| **Manager** | Data and Analytics | Manager DB schema | DACPAC | main, Test, Production |
| **Synapse Integration** | Data and Analytics | Synapse pipelines, linked services, triggers | ARM templates | main, Test, Production |
| **ADF Data Landing** | Data and Analytics | ADF pipeline definitions | ARM templates | main, adf_publish |
| **Synapse Data Landing** | Data and Analytics | Secondary Synapse workspace | Workspace publish | main, workspace_publish |
| **Reports and Datasets** | Data and Analytics | Power BI reports, semantic models | Manual / Azure DevOps | main |
| **Data-and-Analytics.wiki** | Data and Analytics | This wiki | Direct commit | wikiMaster |

**Azure DevOps Organisation:** `https://dev.azure.com/EmergeAotearoa/Data%20and%20Analytics`

---

## Service Principal & Authentication

| Component | Auth Method | Credential Location |
|-----------|-------------|-------------------|
| ADF Pipeline execution | Managed Identity | Azure-managed |
| Synapse Pipeline execution | Managed Identity | Azure-managed |
| DACPAC deployments (CI/CD) | Service Principal | Azure DevOps variable groups |
| SQL access tokens | `Get-AzAccessToken -ResourceUrl https://database.windows.net` | Pipeline-generated |
| Framework BCP migration | SQL username/password | Azure DevOps variable groups |
| Power BI connections | Entra ID ClaimsToken | Power BI Service |
| Storage account access | Managed Identity + SAS tokens | Key Vault |

---

## CI/CD Variable Groups (Azure DevOps)

Each deployment pipeline references environment-specific variable groups:

| Pipeline | Dev Group | Test Group | Prod Group | Key Variables |
|----------|-----------|------------|------------|--------------|
| EDW | EDW_Dev | EDW_Test | EDW_Prod | `server_name`, `database_name`, `AzureServicePrincipal` |
| ODS | ODS_Dev | ODS_Test | ODS_Prod | `ods_server_name`, `ods_database_name` |
| Datalanding | DLA_Dev | DLA_Test | DLA_Prod | `dla_server_name`, `dla_database_name`, SQLCMD vars |
| Framework | FW_Dev | FW_Test | FW_Prod | `framework_server_name`, `framework_database_name`, `framework_config_username/password` |
| Manager | Manager_Dev | Manager_Test | Manager_Prod | `server_name`, `database_name` |

> **DR Note:** If Azure DevOps variable groups are lost, all CI/CD pipelines will fail. Document or back up variable group values externally.

---

## Trigger Schedule Summary

Full schedule documented in [Data Landing Triggers](/BI-Team/Documentation-%2D-Data-Dudes/Business-processes/Data-Landing-Triggers)

| Time (NZST) | System | Pipeline |
|-------------|--------|----------|
| 00:00 | MS Graph, EcoPortal | Daily_Midnight_Trigger |
| 00:05 | EmpLive API | Emplive API trigger |
| 00:30 | Tapui Waka | Daily_Tapui_Waka_Trigger |
| 01:00 | IntelliHR, Business Central | Daily triggers |
| 01:00 (Fri) | DataPay Payslips | Weekly Friday |
| 01:15 | DataPay | Daily_DataPay_Trigger |
| 03:15 | Akoranga | Daily_Akoranga_Trigger (Mon–Sat) |
| 05:00 | Synapse ODS/EDW loads | Daily Synapse triggers |
| 09:00 (Sat) | Job Timeline | Weekly Saturday |
| 23:00 | PowerBI Activity | Daily_PowerBI_Trigger |
| 23:45 | EmpLive Files | Daily_Emplive_Trigger |

---

## Data Flow Summary

```
Source Systems (15+)
    ↓  [REST APIs, SFTP, File extracts]
ADF Data Landing (adf-prod-aus-datalanding-01)
    ↓  [JSON, Parquet, CSV → ADLS Gen2]
ADLS Data Lake (stprodaussvcdatalanding01 + stprodaussvcsyn)
    ↓  [External Tables → SQL Views]
ODS Synapse SQL Serverless (21 schemas, 312+ views)
    ↓  [Synapse Integration pipelines (100+)]
Framework DB (ETL config) + Manager DB (audit logging)
    ↓  [SCD Type 2 procedures]
EDW Database (staging → landing → edw schemas)
    ↓  [XMLA Live Connection]
Power BI Service (Production Reports workspace)
    ↓  [Published reports]
End Users
```
