# Storage and ODS Recovery

**Applies to:** ADLS Gen2 storage accounts, ODS Data Lake, External tables, Synapse SQL Serverless views
**RTO Target:** 24 hours | **RPO Target:** 24 hours
**Priority:** P2 (after Key Vault and databases)

---

## Pre-Requisites

Before starting storage/ODS recovery:
- [ ] Azure Key Vault is accessible (see [Key-Vault-and-Security-Recovery](Key-Vault-and-Security-Recovery))
- [ ] SQL databases are restored (see [Database-Recovery-Procedures](Database-Recovery-Procedures))
- [ ] You have **Storage Blob Data Contributor** access to the storage accounts
- [ ] Azure Portal access is confirmed

---

## Storage Account Inventory

| Account | Purpose | Soft Delete | Key Containers |
|---------|---------|-------------|----------------|
| `stprodaussvcsyn` | Production ODS data lake | **Enabled** | ods, staging, reference, datalake |
| `stprodaussvcdatalanding01` | Raw source data landing | _Verify_ | Per source system (akoranga, businesscentral, datapay, etc.) |
| `stprodaussvcwaharoa01` | Zavanti / Waharoa property data | _Verify_ | Property tables, Dataverse exports |
| `stdevaussvcsyn` | Dev data lake | _Verify_ | Dev datasets |
| `sttestaussvcsyn` | Test data lake | _Verify_ | Test replication |

---

## Scenario 1: Recover Deleted Files (Soft Delete)

Use this for: accidental file deletion, individual folder/file corruption.

<details>
<summary><b>Step 1 — Log in to the Azure Portal</b></summary>

1. Navigate to [https://portal.azure.com](https://portal.azure.com)
2. Sign in with your Emerge Aotearoa Entra ID credentials

</details>
<br/>

<details>
<summary><b>Step 2 — Navigate to the Storage Account</b></summary>

1. Search for **Storage accounts** in the top search bar
2. Select the relevant storage account:
   - For ODS files: `stprodaussvcsyn`
   - For raw landing data: `stprodaussvcdatalanding01`
   - For Waharoa data: `stprodaussvcwaharoa01`

</details>
<br/>

<details>
<summary><b>Step 3 — Navigate to the Affected Container</b></summary>

1. In the storage account, click **Containers** under Data storage
2. Select the container (e.g., `ods` for the ODS data lake)
3. Navigate into the folder structure to find the affected files

</details>
<br/>

<details>
<summary><b>Step 4 — Show and Restore Deleted Objects</b></summary>

1. At the top of the container browser, click **Show deleted blobs** toggle
2. Deleted files appear with a strikethrough or "Deleted" indicator
3. Select the files or folders to restore
4. Click **Undelete**
5. Verify the files are accessible after restoration

> **Note:** Soft delete has a configured retention window. Files older than the retention period cannot be recovered via this method.

</details>
<br/>

---

## Scenario 2: Storage Account Completely Lost

Use this for: storage account deletion, region-level failure affecting storage.

<details>
<summary><b>Step 1 — Recreate the Storage Account</b></summary>

1. In Azure Portal → **Storage accounts** → **Create**
2. Configure:
   - **Subscription:** `3ad070fe-7936-4060-a09c-338ac9352378`
   - **Resource Group:** `rg-prod-aus-svc-datareporting` (for ODS) or `rg-prod-aus-svc-datalanding` (for DLA)
   - **Storage account name:** Match original name exactly (e.g., `stprodaussvcsyn`)
   - **Region:** Australia East (mandatory — data sovereignty)
   - **Performance:** Standard
   - **Redundancy:** Locally-redundant storage (LRS) — Australasia requirement
3. Under **Advanced**:
   - Enable **Hierarchical namespace** (required for ADLS Gen2)
   - Enable **Blob soft delete** — set retention to maximum available
   - Enable **Container soft delete**
4. Click **Review + Create** → **Create**

</details>
<br/>

<details>
<summary><b>Step 2 — Recreate Containers</b></summary>

1. Navigate into the new storage account
2. Create the required containers:

**For `stprodaussvcsyn` (ODS Data Lake):**
- `ods`
- `staging`
- `reference`
- Additional containers as per source systems

**For `stprodaussvcdatalanding01` (Raw Landing):**
- Create a container for each source system (akoranga, businesscentral, datapay, emplive, intellihr, ecoPortal, snapHire, tapuiWaka, msGraph, powerBI, webExpenses)
- Create `configuration` container (holds pipeline config JSON files)

</details>
<br/>

<details>
<summary><b>Step 3 — Restore Access Permissions</b></summary>

1. Navigate to **Access Control (IAM)** on the storage account
2. Add role assignments for:
   - **Synapse workspace managed identity** → Storage Blob Data Contributor
   - **ADF managed identity** → Storage Blob Data Contributor
   - **Service principal** used by CI/CD → Storage Blob Data Contributor
3. Verify the Synapse/ADF linked services can access the storage

</details>
<br/>

<details>
<summary><b>Step 4 — Reload Data from Source Systems</b></summary>

Since storage data is a landing zone, it can be reloaded by re-running the extraction pipelines:

1. Re-run **ADF Data Landing pipelines** (see [ADF-Data-Landing-Recovery](ADF-Data-Landing-Recovery))
   - This will re-extract data from all 15+ source systems
   - Extraction time: 2–8 hours depending on data volume and API rate limits
2. Re-run **Synapse Data Landing notebooks** (for Zavanti/SFTP data)
3. Verify data exists in all expected folders

> **Note:** Historical data beyond what source system APIs provide may not be recoverable. The RPO for source data depends on API capabilities (e.g., some APIs only return current-state data, not historical).

</details>
<br/>

---

## Scenario 3: ODS Schema Recovery (Synapse SQL Serverless)

The ODS is a virtualisation layer — views on top of ADLS Gen2 files. If the ODS schema is corrupted or lost, it can be rebuilt from source control.

<details>
<summary><b>Step 1 — Verify the underlying storage data exists</b></summary>

1. Navigate to `stprodaussvcsyn` in Azure Portal
2. Confirm the `ods` container has data files (Parquet, CSV, JSON)
3. If storage is empty, complete Scenario 2 first

</details>
<br/>

<details>
<summary><b>Step 2 — Deploy ODS schema from DACPAC</b></summary>

1. Navigate to Azure DevOps: `https://dev.azure.com/EmergeAotearoa/Data%20and%20Analytics`
2. Go to **Pipelines** → find the ODS deploy pipeline
3. Run on the `Production` branch
4. The pipeline will:
   - Build the two SSDT projects: `ODS.sqlproj` and `ODS_Zavanti.sqlproj`
   - Generate DACPAC files
   - Deploy to the Synapse SQL Serverless endpoint
   - **Key setting:** `/p:DropObjectsNotInSource=false` — preserves objects not in source control

</details>
<br/>

<details>
<summary><b>Step 3 — Verify External Data Sources</b></summary>

After deploying the schema, verify the external data sources are correctly configured:

```sql
-- Check external data sources exist
SELECT name, location FROM sys.external_data_sources;

-- Expected:
-- [data] → abfss://ods@stprodaussvcsyn.dfs.core.windows.net
-- [ref_data_source] → https://stdevaussvcsyn.dfs.core.windows.net/latlong-by-service-location
```

If external data sources are missing, they must be recreated manually (they are excluded from DACPAC deployment).

</details>
<br/>

<details>
<summary><b>Step 4 — Verify ODS Schemas and Views</b></summary>

Check that all 21 schemas have their expected views:

```sql
SELECT s.name AS SchemaName, COUNT(*) AS ViewCount
FROM sys.views v
JOIN sys.schemas s ON v.schema_id = s.schema_id
GROUP BY s.name
ORDER BY s.name;
```

Expected schemas: `Akoranga`, `BusinessCentral`, `Datapay`, `EcoPortal`, `EmpLive`, `EmpliveAPI`, `IntelliHR`, `RBEAL`, `RBMNB`, `SnapHire`, `TapuiWaka`, `webexpenses`, `six_degrees`, `staging`, `landing`, `working`, `reference`, `kpi`, `PowerBI`, `dbo`

Total views expected: 312+

</details>
<br/>

<details>
<summary><b>Step 5 — Run a sample query to verify data access</b></summary>

```sql
-- Test a view from each major schema
SELECT TOP 10 * FROM BusinessCentral.Items;
SELECT TOP 10 * FROM EmpLive.employees;
SELECT TOP 10 * FROM Akoranga.mdl_user;
```

If queries fail with access errors → verify storage account permissions (Step 3 of Scenario 2)
If queries fail with "file not found" → storage data needs to be reloaded

</details>
<br/>

---

## Scenario 4: Restore ODS from Production to Test

Use the existing automated pipeline to copy ODS data from production to test environment:

<details>
<summary><b>Steps</b></summary>

1. Navigate to the copy-production-to-test ADF instance in `rg-test-aus-svc-datareporting`
2. Run the **Run Data Copy Pipelines** master orchestrator
3. This will:
   - Query Framework for enabled data sources
   - Enumerate production ADLS folders
   - Binary-copy files from `stprodaussvcsyn` → `sttestaussvcsyn`
   - Copy the EDW database from production to test
   - Scale test database to S1
   - Recreate users and roles

See [Copy-Production-Data-to-Test](/BI-Team/Documentation-%2D-Data-Dudes/Copy-Production-Data-to-Test) for detailed steps.

</details>
<br/>

---

## Post-Recovery Checklist

After any storage/ODS recovery:

- [ ] Storage account accessible from Azure Portal
- [ ] ADLS Gen2 hierarchical namespace enabled
- [ ] Soft delete enabled and configured
- [ ] All expected containers exist
- [ ] Managed identities have correct RBAC assignments
- [ ] Synapse linked service `ls_ADLS_datalanding` connects successfully
- [ ] External data sources in Synapse SQL are correctly configured
- [ ] ODS views return data (test at least one per schema)
- [ ] Staging views query data correctly
- [ ] ADF Data Landing pipelines can write to storage
- [ ] Synapse Integration pipelines can read from storage
