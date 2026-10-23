# ADF Data Landing Recovery

**Applies to:** Azure Data Factory `adf-prod-aus-datalanding-01`, all source system extraction pipelines, triggers, linked services
**RTO Target:** 24 hours | **RPO Target:** 24 hours
**Priority:** P3 (after Key Vault, databases, and storage)

---

## Pre-Requisites

Before starting ADF recovery:
- [ ] Azure Key Vault is accessible (see [Key-Vault-and-Security-Recovery](Key-Vault-and-Security-Recovery))
- [ ] Storage accounts are operational — `stprodaussvcdatalanding01` exists (see [Storage-and-ODS-Recovery](Storage-and-ODS-Recovery))
- [ ] Framework database is accessible (see [Database-Recovery-Procedures](Database-Recovery-Procedures))
- [ ] Azure Portal access is confirmed
- [ ] You have **Data Factory Contributor** access to the resource group

---

## ADF Data Landing Inventory

**Factory:** `adf-prod-aus-datalanding-01`
**Resource Group:** `rg-prod-aus-svc-datalanding`
**Source Control:** Azure DevOps repo `ADF Data Landing`, publish branch `adf_publish`

### Pipelines (20+)

| Category | Pipelines | Source Systems |
|----------|-----------|----------------|
| **Master Extractors** | Extract_Master_Akoranga, Extract_Master_BusinessCentral, Extract_Master_Tapui_Waka + 5 more | Akoranga, BC, Tapui Waka, EmpLive, EcoPortal, IntelliHR, DataPay, PowerBI |
| **Single Table** | Extract_Akoranga_Table, Extract_BC_Table, etc. | Called via ForEach in master pipelines |
| **DataPay Special** | Datapay PayRuns, DataPay Payslips_Bulk_Load, DataPay PRR Report | Payroll processing |
| **API Extractions** | Extract BusinessCentral API, EcoPortal GraphQL, Emplive API, IntelliHr API | REST/GraphQL APIs |
| **File Extractions** | Extract EmpLive files, SnapHire Master Load | SFTP/File |
| **Other** | Extract PowerBI ActivityEvents, Extract MS Graph, Web Expenses, Fetch Job Timeline | Metadata + HR |

### Linked Services (20)

| Linked Service | Type | Target |
|---------------|------|--------|
| `ls_SSQL_ODS` | SQL | Serverless SQL ODS |
| `ls_AZSQL_datalanding` | SQL | Azure SQL DLA |
| `ls_AZSQL_DLA_IntelliHR` | SQL | IntelliHR-specific DLA |
| `ls_Framework` | SQL | Framework config DB |
| `ls_ADLS_datalanding` | ADLS Gen2 | Parametrised storage |
| `ls_REST_Business_Central` | REST | BC API |
| `ls_REST_DataPay` | REST | DataPay API |
| `ls_REST_Ecoportal` | REST | EcoPortal API |
| `ls_REST_intellihr` | REST | IntelliHR API |
| `ls_REST_PowerBI` | REST | Power BI API |
| `ls_REST_tapui_waka` | REST | Tapui Waka API |
| `ls_REST` | REST | Generic REST |
| `ls_EcoPortal_GraphQL` | HTTP | EcoPortal GraphQL |
| `ls_EcoPortal_OAuth` | HTTP | EcoPortal auth |
| `ls_HTTP` | HTTP | Generic HTTP |
| `ls_SFTP` | SFTP | File transfers |
| `ls_MySQL` | MySQL | MySQL source |
| `ls_kv_datalnd01` | Key Vault | Parametrised KV |
| `ls_AKV_syn` | Key Vault | Synapse Key Vault |

### Triggers (13 Active)

| Time (NZST) | Trigger | Pipeline |
|-------------|---------|----------|
| 00:00 | Daily_Midnight_Trigger | Extract MS Graph Master, EcoPortal GraphQL |
| 00:05 | Emplive API | Extract Emplive API Master |
| 00:30 | Daily_Tapui_Waka_Trigger | Extract Tapui Waka |
| 01:00 | Daily_BusinessCentral_Trigger | Extract BusinessCentral |
| 01:00 | Daily_Intellihr_Trigger | Extract IntelliHR API Master |
| 01:00 (Fri) | Weekly Friday | DataPay Payslips Bulk Load |
| 01:15 | Daily_DataPay_Trigger | Extract DataPay, Cost Allocation |
| 03:15 | Daily_Akoranga_Trigger | Extract Akoranga Master (Mon–Sat) |
| 09:00 (Sat) | Weekly Saturday | Fetch Job Timeline |
| 09:00 (Bi-weekly Sat) | Pay Run Cycle | DataPay PRR Processing |
| 23:00 | Daily_PowerBI_Trigger | Extract PowerBI Activity Events |
| 23:45 | Daily_Emplive_Trigger | Extract EmpLive files |

### Pipeline Architecture Pattern

Most master pipelines follow this pattern:

```
1. Lookup → Read config JSON from ADLS/configuration/{source}/config.json
2. Web Activities → Get credentials from Key Vault (username, server, database)
3. ForEach → For each table in config:
   └─ ExecutePipeline → Extract_{Source}_Table
      └─ Copy Activity → REST/API → ADLS Gen2 (Parquet/JSON/CSV)
```

---

## Scenario 1: Individual Pipeline Failure

<details>
<summary><b>Step 1 — Identify the failure</b></summary>

1. Navigate to Azure Portal → **Data factories** → `adf-prod-aus-datalanding-01`
2. Click **Open Azure Data Factory Studio** (or go to `https://adf.azure.com`)
3. Go to **Monitor** → **Pipeline runs**
4. Filter by **Status: Failed** and the relevant date range
5. Click the failed run to see activity-level details

</details>
<br/>

<details>
<summary><b>Step 2 — Diagnose the error</b></summary>

Common ADF Data Landing errors:

| Error | Cause | Resolution |
|-------|-------|------------|
| `REST API 401 Unauthorized` | API credential expired | Update Key Vault secret with new credentials |
| `REST API 429 Too Many Requests` | Rate limited by source system | Wait and re-run; consider adding retry policy |
| `Storage write error` | ADLS permission issue | Verify managed identity RBAC on storage |
| `Key Vault access denied` | Managed identity lost access to KV | Add ADF identity to Key Vault access policies |
| `SAS token expired` | Waharoa/Zavanti SAS expired | Generate new SAS and update Key Vault |
| `Connection timeout` | Source system unavailable | Contact vendor; wait and retry |
| `Invalid JSON` | Source API returned unexpected format | Check source API documentation; adjust pipeline |

See also: [Datalanding data factory loads](/BI-Team/Documentation-%2D-Data-Dudes/Troubleshooting-guides/Datalanding-data-factory-loads)

</details>
<br/>

<details>
<summary><b>Step 3 — Re-run the failed pipeline</b></summary>

1. In ADF Monitor → Pipeline runs, click the ellipsis (...) on the failed run
2. Select **Rerun** to retry
3. Or go to **Author** hub → find the pipeline → **Trigger** → **Trigger now**
4. Use the **Debug** option for test runs with modified parameters

</details>
<br/>

---

## Scenario 2: Restore ADF from Source Control

Use this for: pipeline corruption, accidental deletion, linked service misconfiguration.

<details>
<summary><b>Step 1 — Verify ADF Git integration</b></summary>

1. Open ADF Studio → **Manage** → **Git configuration**
2. Verify connection to Azure DevOps:
   - **Repository:** `ADF Data Landing`
   - **Collaboration branch:** `main`
   - **Publish branch:** `adf_publish`
3. If disconnected, reconnect:
   - Organisation: `https://dev.azure.com/EmergeAotearoa`
   - Project: `Data and Analytics`
   - Repository: `ADF Data Landing`

</details>
<br/>

<details>
<summary><b>Step 2 — Restore from the publish branch</b></summary>

**Option A — Republish from Git:**
1. In ADF Studio, switch to the `main` branch
2. All pipeline definitions will load from Git
3. Review and click **Publish** to deploy to the live factory

**Option B — Restore from adf_publish branch:**
1. The `adf_publish` branch contains ARM templates generated during the last publish
2. These ARM templates can be deployed to the factory directly
3. Navigate to Azure DevOps → `ADF Data Landing` repo → `adf_publish` branch
4. Download the ARM template files
5. Deploy using Azure Portal → **Deploy a custom template** → Upload the ARM template

</details>
<br/>

<details>
<summary><b>Step 3 — Restore configuration files</b></summary>

ADF master pipelines read configuration from ADLS Gen2. Verify config files exist:

1. Navigate to storage account `stprodaussvcdatalanding01`
2. Check the `configuration` container
3. Verify config JSON files exist for each source system:
   - `akoranga/config.json`
   - `businesscentral/config.json`
   - `datapay/config.json`
   - `emplive/config.json`
   - `intellihr/config.json`
   - `ecoPortal/config.json`
   - (etc.)

If config files are missing:
- They are typically generated from the Framework database metadata
- Re-run the metadata discovery pipeline to regenerate them

</details>
<br/>

<details>
<summary><b>Step 4 — Verify and restart triggers</b></summary>

1. In ADF Studio → **Manage** → **Triggers**
2. Verify all 13 triggers exist and are in **Started** state
3. For any stopped triggers:
   - Click the trigger → **Start**
   - Validate the schedule is correct (see trigger table above)

> **Important:** After ARM template deployment, triggers are typically deployed in a stopped state. You must manually start each trigger.

</details>
<br/>

<details>
<summary><b>Step 5 — Test a pipeline end-to-end</b></summary>

1. Select a small-volume pipeline (e.g., `Extract_Master_Tapui_Waka`)
2. Trigger manually
3. Verify:
   - Pipeline runs successfully
   - Data appears in the ADLS storage target container
   - No Key Vault access errors
   - No API authentication errors

</details>
<br/>

---

## Scenario 3: Complete ADF Rebuild

Use this for: factory deletion, resource group deletion.

<details>
<summary><b>Step 1 — Create new Data Factory</b></summary>

1. Azure Portal → **Data factories** → **Create**
2. Configure:
   - **Subscription:** `3ad070fe-7936-4060-a09c-338ac9352378`
   - **Resource Group:** `rg-prod-aus-svc-datalanding`
   - **Name:** `adf-prod-aus-datalanding-01` (match original)
   - **Region:** Australia Southeast (match original)
   - **Version:** V2
3. Under **Git configuration**:
   - Select **Azure DevOps Git**
   - Organisation: `https://dev.azure.com/EmergeAotearoa`
   - Project: `Data and Analytics`
   - Repository: `ADF Data Landing`
   - Collaboration branch: `main`
   - Publish branch: `adf_publish`
4. Click **Review + Create** → **Create**

</details>
<br/>

<details>
<summary><b>Step 2 — Grant managed identity permissions</b></summary>

The new ADF instance will have a new managed identity. Grant it access to:

1. **Key Vault** (`kv-prod-aus-svc-syn-01`):
   - Azure Portal → Key Vault → **Access policies** → Add
   - Select the new ADF managed identity
   - Grant: Get, List on Secrets
2. **Storage Account** (`stprodaussvcdatalanding01`):
   - Azure Portal → Storage account → **Access Control (IAM)** → Add role assignment
   - Role: **Storage Blob Data Contributor**
   - Assign to: the new ADF managed identity
3. **SQL Database** (Framework):
   - Connect to Framework database
   - Add the ADF managed identity as a user

</details>
<br/>

<details>
<summary><b>Step 3 — Publish and configure</b></summary>

1. Open ADF Studio
2. Switch to `main` branch — all pipeline definitions load from Git
3. Click **Publish** to deploy to the live factory
4. Configure **Global parameters** for environment-specific values
5. Start all triggers (see Scenario 2, Step 4)

</details>
<br/>

<details>
<summary><b>Step 4 — Test complete extraction cycle</b></summary>

1. Manually trigger each master extraction pipeline
2. Monitor for completion
3. Verify data appears in ADLS Gen2 containers
4. Verify downstream ODS views can read the landed data

</details>
<br/>

---

## Full Data Re-Extraction Timeline

If all source data needs to be re-extracted from scratch:

| Source System | Estimated Time | Notes |
|--------------|----------------|-------|
| Business Central | 1–2 hours | REST API with pagination |
| Akoranga | 30 min–1 hour | Direct data copy |
| DataPay | 1–2 hours | REST API + payslip bulk |
| EmpLive | 1–2 hours | API + file extraction |
| IntelliHR | 30 min–1 hour | REST API |
| EcoPortal | 1–2 hours | GraphQL with pagination |
| RecordBase EAL/MNB | 1 hour | SQL extraction |
| SnapHire | 30 min | File-based |
| Tapui Waka | 15–30 min | REST API |
| MS Graph | 30 min | REST API |
| PowerBI Activity | 15–30 min | REST API |
| Web Expenses | 15–30 min | REST API |
| **Total (sequential)** | **8–12 hours** | Run in parallel where possible |
| **Total (parallel)** | **2–4 hours** | Limited by longest-running extraction |

> **Note:** Historical data availability depends on source system API capabilities. Some APIs only return current-state data. Check with each vendor for historical data limits.

---

## Post-Recovery Checklist

After any ADF Data Landing recovery:

- [ ] Data Factory accessible in Azure Portal and ADF Studio
- [ ] Git integration connected to `ADF Data Landing` repo
- [ ] All 20+ pipelines visible in Author hub
- [ ] All 20 linked services show successful test connections
- [ ] All 13 triggers in Started state with correct schedules
- [ ] Key Vault access confirmed (ls_kv_datalnd01 connected)
- [ ] ADLS storage write access confirmed
- [ ] Configuration JSON files exist in ADLS `configuration` container
- [ ] At least one master pipeline runs successfully end-to-end
- [ ] Extracted data appears in ADLS containers in correct format
- [ ] Downstream ODS views can read the landed data
