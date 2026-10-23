# Synapse and Pipeline Recovery

**Applies to:** Synapse Integration workspace (100+ pipelines), linked services, triggers, data flows
**RTO Target:** 24 hours | **RPO Target:** 24 hours
**Priority:** P4 (after Key Vault, databases, and storage)

---

## Pre-Requisites

Before starting Synapse recovery:
- [ ] Azure Key Vault is accessible (see [Key-Vault-and-Security-Recovery](Key-Vault-and-Security-Recovery))
- [ ] SQL databases are restored — EDW, ODS, Framework, Manager (see [Database-Recovery-Procedures](Database-Recovery-Procedures))
- [ ] Storage accounts are operational (see [Storage-and-ODS-Recovery](Storage-and-ODS-Recovery))
- [ ] Azure DevOps access confirmed
- [ ] You have **Synapse Contributor** or **Owner** access to the workspace

---

## Decision Tree

Use this flow to determine the appropriate recovery path:

::: mermaid
graph TD
    A[Assess Synapse Environment] -->|Can you access Synapse Prod?| B{Yes / No}
    B -->|No| C{Why not?}
    B -->|Yes| D{How are the pipelines?}
    C -->|Security failure| E[Password reset / user restore<br/>from Entra ID global admin]
    C -->|Azure service error| K[Send urgent Azure<br/>support request]
    C -->|Workspace deleted| F[Rebuild workspace<br/>from scratch — Scenario 3]
    D -->|Pipelines missing| G[Restore from Git<br/>Scenario 2]
    D -->|Pipelines exist but<br/>cannot open| I[Remove and restore<br/>from Git — Scenario 2]
    D -->|Can trigger but<br/>pipelines fail| J{What error?}
    J -->|System error| K
    J -->|Pipeline failure<br/>data/config issue| L[Fix config and re-run<br/>See Troubleshooting guides]
    J -->|Linked service failure| M[Restore linked services<br/>from Git — Scenario 2]
:::

---

## Synapse Integration Inventory

### Pipelines (100+)

| Category | Count | Examples |
|----------|-------|---------|
| **Metadata Discovery** | 10 | Framework, EDW, ODS metadata discovery |
| **ODS Dimension Loads** | 15 | dim_client, dim_employee, dim_service (Full Merge/Incremental) |
| **ODS Fact Loads** | 5 | fact_client_referral, fact_finance_vendor_ledger |
| **Business System Loads** | 40+ | Akoranga, Business Central, DataPay, EmpLive, IntelliHR loads |
| **EDW Loads** | 10+ | EDW Master, Phase 1, Phase 2 orchestration |
| **KPI Processing** | 5+ | KPI Monthly History, KPI Dimension & Fact loads |
| **Maintenance** | 5+ | Index Rebuild, Archive Population, Row Level Security |

### Linked Services (23)

| Linked Service | Target | Purpose |
|---------------|--------|---------|
| `ls_ODS` | ODS Database | Read source data |
| `ls_datawarehouse` | EDW Database | Write warehouse data |
| `ls_Framework` | Framework DB | ETL configuration |
| `ls_Manager` | Manager DB | Audit logging |
| `ls_BCCR` | Business Central | ERP data |
| `ls_ADLS_datalanding` | ADLS Gen2 | Data landing storage |
| `ls_ADLS_personaverse` | ADLS Gen2 | Personaverse data |
| `ls_ADLS_waharoa` | ADLS Gen2 | Waharoa/Zavanti data |
| `ls_AzureStorage` | Azure Storage | General storage |
| `ls_REST_Business_Central` | REST API | BC API calls |
| `ls_EcoPortal` | REST API | EcoPortal data |
| `ls_IntelliHR` | REST API | HR data |
| `ls_RecordBaseEAL` | REST API | RecordBase EAL |
| `ls_RecordBaseMNB` | REST API | RecordBase M&B |
| `ls_powerBI` | REST API | PowerBI metadata |
| `ls_AKV` | Key Vault | Secret retrieval |
| `ls_AKV_SixDegrees` | Key Vault | 6 Degrees credentials |
| `CloudReplicatorTableStorage` | Table Storage | Replication state |

### Triggers (20+)

| Trigger | Schedule | Pipelines |
|---------|----------|-----------|
| Daily Akoranga | 05:00 NZST | Akoranga ODS loads |
| Daily Business Central | 05:00 NZST | BC ODS loads |
| Daily DataPay | 05:00 NZST | DataPay ODS loads |
| Daily EcoPortal | 05:00 NZST | EcoPortal ODS loads |
| Daily EmpLive | 05:00 NZST | EmpLive ODS loads |
| Daily IntelliHR | 05:00 NZST | IntelliHR ODS loads |
| Daily KPI | Daily | KPI dimension & fact loads |
| Daily PowerBI | Daily | PowerBI activity processing |
| Daily RecordBase EAL/MNB | Daily | RecordBase loads |
| Daily SnapHire | Daily | SnapHire loads |
| Daily Tapui Waka | Daily | Tapui Waka loads |
| Weekly Sunday | Sunday | Weekly maintenance |
| Monthly KPI History | Monthly | KPI history rebuild |
| Pay Run Cycle | Bi-weekly | Payroll-specific processing |
| EDW dim_date | As needed | Date dimension reload |

---

## Scenario 1: Pipeline Failure (Configuration/Data Issue)

Use this for: individual pipeline failures, timeout errors, data issues.

<details>
<summary><b>Step 1 — Identify the failed pipeline</b></summary>

1. Navigate to the Synapse workspace:
   - **Production:** `https://web.azuresynapse.net` → select `synapseausprod`
   - **Dev:** `https://web.azuresynapse.net` → select `synapseausdev`
2. Go to **Monitor** → **Pipeline runs**
3. Filter by **Status: Failed** and the relevant date range
4. Click the failed pipeline to see error details

</details>
<br/>

<details>
<summary><b>Step 2 — Diagnose the error</b></summary>

Common errors and resolutions:

| Error | Cause | Resolution |
|-------|-------|------------|
| `SqlErrorNumber 40613` | Database temporarily unavailable | Wait and re-run; check scaling schedule |
| `ErrorCode: 2200` | Storage access denied | Verify managed identity RBAC on storage |
| `UserErrorInvalidColumnMapping` | Schema change in source | Check ODS views and redeploy DACPAC |
| `OperationTimedOut` | Pipeline activity exceeded timeout | Increase timeout or check data volume |
| `InvalidTemplate` | Pipeline JSON corruption | Restore pipeline from Git |
| `LinkedServiceConnectionFailed` | Linked service credential expired | Check Key Vault secrets |

</details>
<br/>

<details>
<summary><b>Step 3 — Re-run the failed pipeline</b></summary>

1. In Monitor → Pipeline runs, click the ellipsis (...) on the failed run
2. Select **Rerun** to retry with the same parameters
3. Or navigate to **Integrate** → find the pipeline → click **Trigger** → **Trigger now**
4. Monitor the new run until completion

</details>
<br/>

See also: [Pipeline failures (EDW)](/BI-Team/Documentation-%2D-Data-Dudes/Troubleshooting-guides/Pipeline-failures-(EDW)) and [Pipeline failures ODS](/BI-Team/Documentation-%2D-Data-Dudes/Troubleshooting-guides/Pipleline-failures-ODS)

---

## Scenario 2: Restore Pipelines from Git

Use this for: pipeline corruption, accidental deletion of pipelines, linked service misconfiguration.

<details>
<summary><b>Step 1 — Verify Git integration is active</b></summary>

1. Open Synapse workspace → **Manage** → **Git configuration**
2. Verify the workspace is connected to Azure DevOps:
   - **Repository:** `Synapse Integration`
   - **Collaboration branch:** `main`
   - **Publish branch:** `workspace_publish`
3. If Git integration is disconnected, reconnect:
   - Organisation: `https://dev.azure.com/EmergeAotearoa`
   - Project: `Data and Analytics`
   - Repository: `Synapse Integration`

</details>
<br/>

<details>
<summary><b>Step 2 — Restore pipeline definitions from Git</b></summary>

**Option A — Sync from the collaboration branch:**
1. In Synapse Studio, switch to the `main` branch
2. The workspace will load all pipeline definitions from Git
3. Verify pipelines appear in the **Integrate** hub
4. Click **Publish all** to deploy changes to the live workspace

**Option B — Redeploy via CI/CD pipeline:**
1. Navigate to Azure DevOps → Pipelines
2. Find the Synapse deploy pipeline (`synapse_deploy.yml`)
3. Run on the `Production` branch
4. The pipeline will:
   - Generate ARM templates from the workspace_publish branch
   - Deploy all pipelines, linked services, triggers, and datasets to the target workspace

</details>
<br/>

<details>
<summary><b>Step 3 — Verify linked services after restoration</b></summary>

1. In Synapse Studio → **Manage** → **Linked services**
2. Click **Test connection** on each linked service:
   - `ls_ODS` → should connect to ODS database
   - `ls_datawarehouse` → should connect to EDW
   - `ls_Framework` → should connect to Framework DB
   - `ls_ADLS_datalanding` → should connect to ADLS Gen2
   - `ls_AKV` → should connect to Key Vault
3. If any linked service fails:
   - Check that the underlying resource exists
   - Check Key Vault secrets are valid
   - Check managed identity permissions

</details>
<br/>

<details>
<summary><b>Step 4 — Re-enable triggers</b></summary>

1. In Synapse Studio → **Manage** → **Triggers**
2. Verify all triggers are in **Started** state
3. If triggers are stopped, start them one by one
4. Verify the trigger schedule matches the expected schedule (see [Infrastructure-Inventory](Infrastructure-Inventory))

> **Warning:** When restoring from Git, triggers may be deployed in a stopped state. Always verify trigger status after deployment.

</details>
<br/>

---

## Scenario 3: Complete Synapse Workspace Rebuild

Use this for: workspace deletion, workspace corruption, region failover.

<details>
<summary><b>Step 1 — Create new Synapse workspace</b></summary>

1. Azure Portal → **Azure Synapse Analytics** → **Create**
2. Configure:
   - **Subscription:** `3ad070fe-7936-4060-a09c-338ac9352378`
   - **Resource Group:** `rg-prod-aus-svc-datareporting`
   - **Workspace name:** `synapseausprod` (match original)
   - **Region:** Australia East (mandatory — data sovereignty)
   - **Data Lake Storage Gen2:** Select `stprodaussvcsyn`
   - **File system:** Select the default container
3. Under **Security**:
   - **SQL admin:** Set appropriate admin credentials
   - **Managed identity:** Enable system-assigned
4. Click **Review + Create** → **Create**
5. Wait for deployment to complete (10–20 minutes)

</details>
<br/>

<details>
<summary><b>Step 2 — Connect workspace to Git</b></summary>

1. Open the new Synapse workspace in Synapse Studio
2. Go to **Manage** → **Git configuration** → **Configure**
3. Set:
   - **Repository type:** Azure DevOps Git
   - **Organisation:** `https://dev.azure.com/EmergeAotearoa`
   - **Project:** `Data and Analytics`
   - **Repository:** `Synapse Integration`
   - **Collaboration branch:** `main`
   - **Publish branch:** `workspace_publish`
   - **Root folder:** `/`
4. Import existing resources from the repository
5. Synapse Studio will load all pipeline definitions

</details>
<br/>

<details>
<summary><b>Step 3 — Configure integration runtimes</b></summary>

1. In **Manage** → **Integration runtimes**
2. Create `IntegrationRuntimeAUSE`:
   - Type: Azure
   - Region: Australia East
   - Compute type: General Purpose
3. The `AutoResolveIntegrationRuntime` should exist by default

</details>
<br/>

<details>
<summary><b>Step 4 — Restore linked services</b></summary>

1. Linked services should be loaded from Git (Step 2)
2. For each linked service, verify the connection:
   - Update any Key Vault references if the vault name changed
   - Update any hardcoded connection strings
   - Grant the new workspace's managed identity access to:
     - SQL databases (EDW, ODS, Framework, Manager)
     - Storage accounts (ADLS Gen2)
     - Key Vault (Get, List secrets policy)
3. Test each linked service connection

</details>
<br/>

<details>
<summary><b>Step 5 — Publish and enable triggers</b></summary>

1. In Synapse Studio, verify all pipelines are visible in the **Integrate** hub
2. Click **Publish all** to deploy to the live workspace
3. Go to **Manage** → **Triggers** → Start all triggers
4. Verify trigger schedules match expected schedule

</details>
<br/>

<details>
<summary><b>Step 6 — Run a test pipeline</b></summary>

1. Select a low-risk pipeline (e.g., a single ODS dimension load)
2. Click **Trigger** → **Trigger now**
3. Monitor in **Monitor** → **Pipeline runs**
4. Verify successful completion
5. Check the target database for expected data

</details>
<br/>

---

## Post-Recovery Checklist

After any Synapse recovery:

- [ ] Synapse workspace accessible via Synapse Studio
- [ ] Git integration connected and synced with `Synapse Integration` repo
- [ ] All 100+ pipelines visible in the Integrate hub
- [ ] All 23 linked services show successful test connections
- [ ] Integration runtimes created and operational (`IntegrationRuntimeAUSE`)
- [ ] All 20+ triggers in Started state with correct schedules
- [ ] Test pipeline runs successfully end-to-end
- [ ] Managed identity has correct RBAC on all dependent resources
- [ ] Framework DB batch creation works (CreateBatch SP)
- [ ] EDW load pipeline completes and writes data
- [ ] Manager DB receives load execution records
- [ ] Pipeline monitoring shows runs in Monitor hub
