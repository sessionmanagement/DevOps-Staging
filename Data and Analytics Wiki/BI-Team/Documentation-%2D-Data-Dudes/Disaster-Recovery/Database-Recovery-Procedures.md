# Database Recovery Procedures

**Applies to:** EDW, Framework, Manager, Data Landing SQL, RecordBase databases
**RTO Target:** 24 hours | **RPO Target:** 24 hours
**Priority:** P1 (after Key Vault / Security)

---

## Pre-Requisites

Before starting database recovery:
- [ ] Azure Key Vault is accessible (see [Key-Vault-and-Security-Recovery](Key-Vault-and-Security-Recovery))
- [ ] You have **Contributor** or **SQL Server Contributor** access to the relevant resource group
- [ ] Azure Portal access is confirmed: [https://portal.azure.com](https://portal.azure.com)

---

## Scenario 1: Single Database Restore (Point-in-Time)

Use this for: database corruption, accidental data deletion, failed deployment rollback.

<details>
<summary><b>Step 1 — Log in to the Azure Portal</b></summary>

1. Navigate to [https://portal.azure.com](https://portal.azure.com)
2. Sign in with your Emerge Aotearoa Entra ID credentials
3. Verify you are in the correct subscription: `3ad070fe-7936-4060-a09c-338ac9352378`

</details>
<br/>

<details>
<summary><b>Step 2 — Navigate to the SQL Database</b></summary>

1. In the Azure Portal, search for **SQL databases** in the top search bar
2. Select the database to restore from the list:

| Database | Server | Purpose |
|----------|--------|---------|
| `sqldb-prod-datawarehouse-01` | `sql-prod-aus-svc-datawarehouse-01` | EDW |
| `sqldb-prod-manager` | `sql-prod-aus-svc-datawarehouse-01` | Manager |
| `Framework` | `sql-prod-aus-svc-fk-01` | Framework metadata |
| `sqldb-prod-entprod-01` | `sql-prod-aue-svc-datalanding` | Data Landing |
| `Recordbase_EmergeAotearoa_Elite` | `eal-sql01` | RecordBase EAL |
| `Recordbase_MindAndBody_Elite` | `eal-sql01` | RecordBase M&B |

</details>
<br/>

<details>
<summary><b>Step 3 — Initiate Point-in-Time Restore</b></summary>

1. On the database overview page, click **Restore** in the top toolbar
2. In the **Restore point** section:
   - Select **Point in time**
   - Choose the date and time to restore to (the last known good state before the incident)
   - Azure shows the earliest available restore point — this is typically within the last 35 days for production
3. In the **Database name** field:
   - Enter a **new name** for the restored database (e.g., `sqldb-prod-datawarehouse-01-restored-20260323`)
   - Do NOT overwrite the existing database at this stage
4. Under **Compute + storage**:
   - Match the original database tier (or use the minimum needed for validation)
   - For EDW: Use S3 or higher for validation, S6 for production
   - For Manager/Framework: Use S0 or S1

</details>
<br/>

<details>
<summary><b>Step 4 — Review and Create</b></summary>

1. Click **Review + Create**
2. Verify:
   - Region is **Australia East** or **Australia Southeast** (must stay in Australasia)
   - Database name is correct
   - Server is correct
3. Click **Create**
4. Wait for the restore to complete — this can take 15 minutes to several hours depending on database size

</details>
<br/>

<details>
<summary><b>Step 5 — Validate the Restored Database</b></summary>

1. Connect to the restored database using SSMS or Azure Data Studio
2. Run validation queries appropriate to the database:

**For EDW:**
```sql
-- Check key table row counts
SELECT 'edw.dim_client' AS TableName, COUNT(*) AS RowCount FROM edw.dim_client WHERE DWHIsCurrent = 1
UNION ALL
SELECT 'edw.dim_service', COUNT(*) FROM edw.dim_service WHERE DWHIsCurrent = 1
UNION ALL
SELECT 'edw.fact_client_referral', COUNT(*) FROM edw.fact_client_referral
UNION ALL
SELECT 'edw.dim_employee_hierarchy', COUNT(*) FROM edw.dim_employee_hierarchy WHERE DWHIsCurrent = 1;

-- Check most recent data
SELECT MAX(DWHModifiedDateTime) AS LastModified FROM edw.dim_client;
```

**For Framework:**
```sql
-- Verify critical metadata tables
SELECT COUNT(*) AS DataSourceCount FROM Metadata.DataSource;
SELECT COUNT(*) AS DataObjectCount FROM Metadata.DataObject;
SELECT * FROM Metadata.SystemInformation; -- Check ConfigsLastMergedDateTime
SELECT COUNT(*) AS HWMCount FROM Deploy.DataLoadMigration_HWM;
```

**For Manager:**
```sql
-- Verify configuration and audit trail
SELECT COUNT(*) AS ConfigCount FROM config.configuration;
SELECT COUNT(*) AS LoadExecutionCount FROM load_check.load_execution;
SELECT MAX(start_time) AS LastLoad FROM load_check.load_execution;
SELECT COUNT(*) AS DQResultCount FROM dq.dq_results;
```

</details>
<br/>

<details>
<summary><b>Step 6 — Swap the Restored Database into Production</b></summary>

Once validation is confirmed:

1. In Azure Portal, navigate to the **original** database
2. Click **Rename** — change to `sqldb-prod-datawarehouse-01-OLD-YYYYMMDD`
3. Navigate to the **restored** database
4. Click **Rename** — change to the original production name (e.g., `sqldb-prod-datawarehouse-01`)
5. Verify all downstream connections can reach the renamed database:
   - Synapse linked services
   - Power BI connections
   - ADF linked services
   - Framework BCP migration scripts

> **Note:** If rename is not possible via Portal, use Azure CLI:
> ```
> az sql db rename --resource-group rg-prod-aus-svc-datareporting --server sql-prod-aus-svc-datawarehouse-01 --name sqldb-prod-datawarehouse-01-restored-20260323 --new-name sqldb-prod-datawarehouse-01
> ```

</details>
<br/>

<details>
<summary><b>Step 7 — Clean Up</b></summary>

1. Keep the old database (`*-OLD-YYYYMMDD`) for at least 7 days as a safety net
2. After confirmed stable operation, delete the old database to stop incurring costs
3. Document the restore event in the incident ticket

</details>
<br/>

---

## Scenario 2: Full Database Rebuild from Source Control

Use this when: point-in-time restore is not available, database is completely lost, or deploying to a new server.

<details>
<summary><b>Step 1 — Ensure the target SQL Server exists</b></summary>

If the SQL Server itself is lost:

1. In Azure Portal → **SQL servers** → **Create**
2. Configure:
   - **Server name:** Match original (e.g., `sql-prod-aus-svc-datawarehouse-01`)
   - **Region:** Australia East (mandatory — data sovereignty)
   - **Authentication:** Microsoft Entra-only authentication
   - **Admin:** Set appropriate Entra admin
3. Configure firewall rules to allow Azure services and required IPs

</details>
<br/>

<details>
<summary><b>Step 2 — Create an empty database</b></summary>

1. On the SQL Server, click **Create database**
2. Configure:
   - **Database name:** Match original name
   - **Compute tier:** Start with S3 (can scale later)
   - **Backup storage redundancy:** Locally-redundant (Australasia region)
3. Click **Create**

</details>
<br/>

<details>
<summary><b>Step 3 — Deploy schema from DACPAC via Azure DevOps</b></summary>

1. Navigate to Azure DevOps: `https://dev.azure.com/EmergeAotearoa/Data%20and%20Analytics`
2. Go to **Pipelines**
3. Run the appropriate deploy pipeline:

| Database | Pipeline | Branch |
|----------|----------|--------|
| EDW | `edw_deploy.yml` | `Production` |
| ODS | `ods_deploy.yml` | `Production` |
| Datalanding | `datalanding_deploy.yml` | `Production` |
| Framework | Manual DACPAC from `Data Framework` repo | `Production` |
| Manager | `manager_deploy.yml` | `Production` |

4. The pipeline will:
   - Build the SSDT project → generate DACPAC
   - Execute pre-deployment scripts (if any)
   - Publish DACPAC to the target database
   - Excluded objects: Users, Logins, RoleMembership, Permissions, Credentials

</details>
<br/>

<details>
<summary><b>Step 4 — Restore reference data and configuration</b></summary>

**For EDW:**
- Post-deployment script (`Script.PostDeployment.sql`) automatically loads reference data:
  - `reference.EDW_Mapping`
  - `reference.EDW_Lookup`
  - `reference.EDW_Holiday_Date_Driven`
  - `reference.EDW_Holiday_Variable`

**For Framework:**
- Restore config migration exports from the last BCP backup:
  - `DataLoadMigration_Master`
  - `DataLoadMigration_DataSource`
  - `DataLoadMigration_DataLoad`
  - `DataLoadMigration_DataLoadField`
  - `DataLoadMigration_DataLoadPhase`
  - `DataLoadMigration_DataLoadQuery`
  - `DataLoadMigration_DataLoadFieldDetail`
  - `DataLoadMigration_DataObject`
- Run the config migration pipeline from Azure DevOps (`framework_migrate_configs.yml`)

**For Manager:**
- Restore `config.configuration` key-value pairs from last backup
- Restore `meta_data.source_system` reference data

</details>
<br/>

<details>
<summary><b>Step 5 — Re-create users, roles, and permissions</b></summary>

1. The DACPAC deployment excludes security objects
2. Re-create database roles:

**For EDW:**
```sql
-- Roles are defined in source control (Security/ folder)
-- But role membership must be manually restored
-- ETL role
CREATE ROLE [eal_etl_role] AUTHORIZATION [dbo];
-- Report reader role
CREATE ROLE [eal_report_reader_role] AUTHORIZATION [dbo];
```

3. Add Synapse/ADF managed identities to the database
4. Add service principal accounts used by CI/CD
5. Add Power BI service account or Entra group for report access

</details>
<br/>

<details>
<summary><b>Step 6 — Reload data</b></summary>

After schema and configuration are in place:

1. **Framework DB first** — Re-run config migration to populate metadata
2. **DLA/ODS** — Re-run ADF Data Landing pipelines to extract source data
3. **EDW** — Re-run Synapse Integration pipelines to populate warehouse tables
4. **Manager** — Load execution data will be generated as pipelines run

> **Warning:** A full data reload from all source systems may take 8–24 hours depending on data volume and API rate limits.

</details>
<br/>

---

## Scenario 3: Framework Database Recovery (Critical Path)

The Framework database is the highest-priority database for recovery because all ETL pipelines depend on its metadata.

<details>
<summary><b>Priority Recovery Steps for Framework</b></summary>

1. **First:** Attempt Point-in-Time Restore (Scenario 1 above)
2. **If PITR unavailable:** Deploy schema from DACPAC
3. **Then:** Restore BCP export files containing configuration data:
   - Source: Last successful `framework_migrate_configs.yml` pipeline run
   - Check Azure DevOps pipeline artifacts for the exported CSV files
   - Files are pipe-delimited with header rows
4. **Import BCP files** into the Deploy schema tables
5. **Run** `MergeFrameworkConfigs` stored procedure to apply configuration
6. **Verify** `Metadata.SystemInformation` shows correct `ConfigsLastMergedDateTime`
7. **Verify** `Deploy.DataLoadMigration_HWM` has highwater marks — these are critical for incremental loads
   - If HWM data is lost, all loads will run as FULL loads (significantly longer processing time)

</details>
<br/>

---

## Scenario 4: RecordBase Database Recovery

RecordBase databases (`Recordbase_EmergeAotearoa_Elite`, `Recordbase_MindAndBody_Elite`) reside on `eal-sql01`.

<details>
<summary><b>Recovery Steps</b></summary>

1. These databases are hosted by Emerge Aotearoa but data originates from the external RecordBase vendor
2. **First:** Attempt Azure PITR restore (same as Scenario 1)
3. If the data needs to be reloaded from vendor:
   - Contact RecordBase vendor (contact details to be documented)
   - Request data re-export for the required date range
   - Coordinate data reload with vendor
4. After restore, verify downstream ODS views that reference these databases are functional

</details>
<br/>

---

## Post-Recovery Checklist

After any database recovery:

- [ ] Database is accessible from Synapse linked services
- [ ] Database is accessible from ADF linked services
- [ ] Database is accessible from Power BI
- [ ] All schemas exist and contain expected objects
- [ ] Security roles and users are correctly configured
- [ ] Row counts match expected baseline (see Manager `load_check.load_execution` for reference)
- [ ] Auto-scaling schedule is operational (EDW only)
- [ ] CI/CD deploy pipeline runs successfully against the restored database
- [ ] Framework config migration pipeline runs successfully (Framework only)
- [ ] Data quality checks pass (see Manager `dq.dq_results`)
