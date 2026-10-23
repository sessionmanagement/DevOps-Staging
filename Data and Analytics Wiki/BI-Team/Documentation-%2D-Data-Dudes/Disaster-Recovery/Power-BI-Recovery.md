# Power BI Recovery

**Applies to:** Power BI semantic models, reports, datasets, paginated reports, workspace configuration
**RTO Target:** 24 hours | **RPO Target:** N/A — reports reload from connections (no data backup needed)
**Priority:** P5 (after all upstream infrastructure is operational)

---

## Pre-Requisites

Before starting Power BI recovery:
- [ ] EDW database is operational and contains data (see [Database-Recovery-Procedures](Database-Recovery-Procedures))
- [ ] Network connectivity from Power BI Service to Azure SQL is established
- [ ] Entra ID authentication is working
- [ ] Azure DevOps access to the `Reports and Datasets` repository is confirmed

---

## Power BI Asset Inventory

### Repository
**Location:** Azure DevOps `Reports and Datasets` repo

| Category | Count | Format | Notes |
|----------|-------|--------|-------|
| **Reports** | ~50 | PBIP (Power BI Project) | `.pbir` report definitions, reference datasets via XMLA connection |
| **Datasets / Semantic Models** | ~80 | PBIP with TMDL | `.tmdl` model definitions, Power Query M expressions |
| **Paginated Reports** | 5 | RDL | AHM Statements, ClientsNotSeen variants, Income & Expense |
| **Shared Semantic Models** | 2 | PBIP with TMDL | Property Semantic Model, Template Semantic Model |
| **Total** | ~137 projects | | All version-controlled in Git |

### Power BI Workspaces

| Workspace | Purpose | Key Content |
|-----------|---------|-------------|
| **Production Reports** | Primary production workspace | Published reports and semantic models |
| **Mike R Datasets** | Secondary / development | Development and testing |

### Connection Pattern

Reports connect to semantic models via XMLA Live Connection:
```
powerbi://api.powerbi.com/v1.0/myorg/Production Reports;Initial Catalog="{DatasetName}"
```

Semantic models connect to source databases via Power Query M with parameters:
- Server parameter → Production SQL server
- Database parameter → Production database name

---

## Scenario 1: Individual Report or Semantic Model Corrupted

<details>
<summary><b>Step 1 — Identify the affected asset</b></summary>

1. Log in to [Power BI Service](https://app.powerbi.com)
2. Navigate to the **Production Reports** workspace
3. Identify the corrupted report or semantic model
4. Note its name for matching in the Git repository

</details>
<br/>

<details>
<summary><b>Step 2 — Locate the asset in the Git repository</b></summary>

1. Open the `Reports and Datasets` repository
2. Reports are in the `Reports/` folder
3. Datasets/semantic models are in the `Datasets/` folder
4. Each project has:
   - `.SemanticModel/` folder → TMDL definitions (tables, measures, relationships)
   - `.Report/` folder → Report layout and page definitions
   - `definition.pbir` → Dataset connection reference

</details>
<br/>

<details>
<summary><b>Step 3 — Republish from Git</b></summary>

**Option A — Open in Power BI Desktop and publish:**
1. Clone/pull the latest version of the `Reports and Datasets` repo
2. Open the `.pbip` file for the affected project in Power BI Desktop
3. Verify the data source parameters point to the correct production server
4. Click **Publish** → select the **Production Reports** workspace
5. Choose to replace the existing asset

**Option B — Use Power BI deployment pipeline (if configured):**
1. Navigate to the deployment pipeline in Power BI Service
2. Deploy from the development/test stage to production

</details>
<br/>

<details>
<summary><b>Step 4 — Refresh the semantic model</b></summary>

1. In Power BI Service → workspace → find the semantic model
2. Click the ellipsis (...) → **Refresh now**
3. Monitor the refresh — it will reload all data from the EDW database
4. Refresh time varies by dataset size (typically 5–30 minutes)

</details>
<br/>

<details>
<summary><b>Step 5 — Verify the report</b></summary>

1. Open the report in Power BI Service
2. Verify data is displayed correctly
3. Check that filters, slicers, and drill-throughs work
4. Verify Row Level Security (RLS) is applied correctly (if applicable)

</details>
<br/>

---

## Scenario 2: Complete Workspace Lost

Use this for: workspace deletion, tenant-level issue, workspace corruption.

<details>
<summary><b>Step 1 — Recreate the Power BI workspace</b></summary>

1. Log in to [Power BI Service](https://app.powerbi.com)
2. Click **Workspaces** → **Create a workspace**
3. Name: **Production Reports** (match original)
4. Configure workspace settings:
   - **License mode:** Premium Per User or Premium capacity (as previously configured)
   - **Advanced** → Enable XMLA read/write endpoint

</details>
<br/>

<details>
<summary><b>Step 2 — Configure workspace access</b></summary>

1. In workspace settings → **Access**
2. Add members:
   - BI team members → **Contributor** or **Member** role
   - Service accounts → **Admin** role (if used for automated refresh)
   - Report consumers → **Viewer** role
3. Add any Entra ID security groups that had access

</details>
<br/>

<details>
<summary><b>Step 3 — Publish semantic models first</b></summary>

Semantic models must be published before reports (reports reference them).

1. Clone the `Reports and Datasets` repository
2. For each project in the `Datasets/` folder:
   - Open the `.pbip` file in Power BI Desktop
   - Update data source parameters if needed:
     - Server: `sql-prod-aus-svc-datawarehouse-01.database.windows.net`
     - Database: `sqldb-prod-datawarehouse-01`
   - Click **Publish** → select **Production Reports** workspace
3. After publishing, configure refresh schedules for each semantic model

**Publish order matters.** Publish shared/foundation semantic models first, then dependent models.

</details>
<br/>

<details>
<summary><b>Step 4 — Refresh all semantic models</b></summary>

1. In Power BI Service → workspace
2. For each semantic model:
   - Click ellipsis (...) → **Settings**
   - Under **Data source credentials**, configure authentication:
     - Authentication method: **OAuth2**
     - Privacy level: **Organizational**
   - Under **Scheduled refresh**, configure the refresh schedule
   - Click **Refresh now** to perform initial data load
3. Wait for all refreshes to complete

> **Note:** Initial refresh of all ~80 semantic models will take several hours. Prioritise the most business-critical datasets first.

</details>
<br/>

<details>
<summary><b>Step 5 — Publish reports</b></summary>

1. For each project in the `Reports/` folder:
   - Open the `.pbip` file in Power BI Desktop
   - The report should connect to its semantic model (already published in Step 3)
   - If connection is broken, update the `definition.pbir` file to point to the correct workspace/dataset
   - Click **Publish** → select **Production Reports** workspace

</details>
<br/>

<details>
<summary><b>Step 6 — Publish paginated reports</b></summary>

1. For the 5 paginated reports in `Paginated Reports/`:
   - Open each `.rdl` file in Power BI Report Builder (or SSRS-compatible tool)
   - Update data source connections to point to production
   - Publish to the Power BI Service workspace

</details>
<br/>

<details>
<summary><b>Step 7 — Configure Row Level Security</b></summary>

1. For semantic models with RLS:
   - Open the semantic model in Power BI Service → **Security**
   - Verify roles exist (they should be republished from the TMDL `roles/` definitions)
   - Add members to each role (Entra ID users/groups)
2. RLS roles are defined in the `roles/` subfolder of each `.SemanticModel/definition/` directory

</details>
<br/>

<details>
<summary><b>Step 8 — Restore app and sharing settings</b></summary>

1. If a Power BI App was published from this workspace:
   - Reconfigure the App → select reports to include
   - Configure audience → add Entra ID groups
   - Publish the App
2. Restore any direct sharing:
   - Share individual reports with required users/groups
3. Restore embedded report configurations (if any)

</details>
<br/>

---

## Scenario 3: Semantic Model Refresh Failure After DR

After restoring upstream databases, semantic models may fail to refresh due to changed server names, credentials, or schemas.

<details>
<summary><b>Step 1 — Check the refresh error</b></summary>

1. Power BI Service → workspace → semantic model → **Refresh history**
2. Check the error message:
   - `DM_GWPipeline_Gateway_SpooledOperationMissing` → Gateway/credential issue
   - `Expression.Error: The import ... matches no exports` → M Query parameter mismatch
   - `OLE DB or ODBC error` → Connection string or server name changed

</details>
<br/>

<details>
<summary><b>Step 2 — Update data source credentials</b></summary>

1. In Power BI Service → semantic model → **Settings**
2. Under **Data source credentials**:
   - Click **Edit credentials**
   - Re-enter/re-authenticate with OAuth2 (Entra ID)
3. Click **Apply**

</details>
<br/>

<details>
<summary><b>Step 3 — Update parameters if server/database changed</b></summary>

If the database was restored to a different server or with a different name:

1. In Power BI Service → semantic model → **Settings** → **Parameters**
2. Update:
   - `Server` parameter → new server name
   - `Database` parameter → new database name
3. Click **Apply**
4. Re-run **Refresh now**

Alternatively, update `expressions.tmdl` in the repository with the new values and republish.

</details>
<br/>

---

## Priority Order for Report Recovery

Not all reports carry equal business impact. Prioritise in this order:

| Priority | Reports | Reason |
|----------|---------|--------|
| **P1** | KPI reports, Finance reports | Executive/board visibility |
| **P2** | Kaimahi (HR) reports | Operational staffing |
| **P3** | Client/referral reports | Service delivery |
| **P4** | Training/Akoranga reports | Compliance |
| **P5** | Administrative/activity reports | Operational efficiency |

> **Decision required:** Confirm the prioritisation with the BI Manager during DR activation.

---

## Post-Recovery Checklist

After Power BI recovery:

- [ ] Power BI workspace exists with correct name and license mode
- [ ] Workspace access configured (team members, service accounts, viewers)
- [ ] XMLA endpoint enabled (if previously configured)
- [ ] All ~80 semantic models published
- [ ] Data source credentials configured for each semantic model
- [ ] All semantic model refreshes complete successfully
- [ ] Scheduled refresh configured for each semantic model
- [ ] All ~50 reports published and displaying data
- [ ] All 5 paginated reports published
- [ ] Row Level Security configured with correct role memberships
- [ ] Power BI App republished (if applicable)
- [ ] Report sharing/permissions restored
- [ ] End users can access reports through standard URLs
