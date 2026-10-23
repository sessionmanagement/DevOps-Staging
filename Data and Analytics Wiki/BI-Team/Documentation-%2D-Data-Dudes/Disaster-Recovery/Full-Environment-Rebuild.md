# Full Environment Rebuild

**Applies to:** Complete platform rebuild from absolute zero — resource group deletion, region outage, or greenfield recovery
**RTO Target:** 24 hours per layer (total rebuild may span multiple days)
**RPO Target:** 24 hours (limited by daily load schedule and last successful backup)
**Priority:** Highest — this is the worst-case scenario

---

## When to Use This Page

- Complete resource group deletion (`rg-prod-aus-svc-datareporting` and/or `rg-prod-aus-svc-datalanding`)
- Azure region outage affecting Australia East / Australia Southeast
- Ransomware that requires full environment teardown and rebuild
- Subscription-level disaster

> **Data Sovereignty Reminder:** All resources MUST be deployed within Australia East or Australia Southeast. No data may leave the Australasia region.

---

## Assumptions

- Azure DevOps is accessible (`https://dev.azure.com/EmergeAotearoa`)
- Source code repositories are intact in Azure DevOps
- Microsoft Entra ID is operational (user accounts, groups, app registrations)
- Azure subscription is active and has sufficient quota

---

## Master Recovery Sequence

Follow these phases in order. Each phase depends on the previous being complete.

::: mermaid
flowchart TB
    P0[Phase 0: Incident Assessment<br/>& Communication] --> P1
    P1[Phase 1: Resource Groups<br/>& Key Vault] --> P2
    P2[Phase 2: SQL Servers<br/>& Database Restore] --> P3
    P3[Phase 3: Storage Accounts<br/>& Data Lake] --> P4
    P4[Phase 4: Azure Data Factory<br/>& Data Landing] --> P5
    P5[Phase 5: Synapse Workspaces<br/>& Pipelines] --> P6
    P6[Phase 6: Data Reload<br/>& Validation] --> P7
    P7[Phase 7: Power BI<br/>& Reporting] --> P8
    P8[Phase 8: Final Validation<br/>& Handover]
:::

---

## Phase 0: Incident Assessment & Communication

<details>
<summary><b>Step 0.1 — Assess the scope of the disaster</b></summary>

1. Determine which resources are affected:
   - [ ] `rg-prod-aus-svc-datareporting` — Synapse, EDW, ODS, storage
   - [ ] `rg-prod-aus-svc-datalanding` — ADF, DLA SQL, DLA storage
   - [ ] Key Vault `kv-prod-aus-svc-syn-01`
   - [ ] Microsoft Entra ID (users, service principals)
   - [ ] Azure DevOps (repos, pipelines, variable groups)
2. Document the timeline:
   - When was the incident detected?
   - When was the last known good state?
   - What is the estimated data loss window?

</details>
<br/>

<details>
<summary><b>Step 0.2 — Escalate and communicate</b></summary>

1. Notify **BI Manager** (Chris Negus) — DR activation approval
2. Notify **Data Engineering Lead** (Greg Nuthall) — Lead infrastructure recovery
3. Notify **Analyst Lead** (Mike Gencic) — Coordinate business communication
4. Create an incident ticket in **Pae Awhina**
5. Send initial stakeholder communication:
   - What happened (high level)
   - Estimated time to recovery
   - What services are affected
   - Next update window

</details>
<br/>

<details>
<summary><b>Step 0.3 — Assemble the recovery team</b></summary>

1. Open a dedicated **Microsoft Teams** channel or call for the incident
2. Assign roles:
   - **Infrastructure recovery:** Greg Nuthall (Phase 1–5)
   - **Data validation:** Mike Gencic (Phase 6–7)
   - **Stakeholder updates:** Chris Negus (All phases)
3. Agree on update cadence (e.g., every 2 hours)

</details>
<br/>

---

## Phase 1: Resource Groups & Key Vault

**Estimated time: 1–2 hours**

<details>
<summary><b>Step 1.1 — Create resource groups</b></summary>

1. Azure Portal → **Resource groups** → **Create**
2. Create each resource group:

| Resource Group | Region | Purpose |
|---------------|--------|---------|
| `rg-prod-aus-svc-datareporting` | Australia East | Synapse, EDW, ODS, storage |
| `rg-prod-aus-svc-datalanding` | Australia Southeast | ADF, DLA SQL |

3. Apply tags as per organisational standards

</details>
<br/>

<details>
<summary><b>Step 1.2 — Restore or create Key Vault</b></summary>

Follow [Key-Vault-and-Security-Recovery](Key-Vault-and-Security-Recovery):
1. Check for soft-deleted vault first (may be recoverable within 90 days)
2. If not recoverable, create new Key Vault
3. Recreate ALL secrets (this is the most time-consuming step in Phase 1)
4. Set access policies for all managed identities and service principals

</details>
<br/>

<details>
<summary><b>Step 1.3 — Verify service principals</b></summary>

1. Microsoft Entra ID → **App registrations**
2. Verify the Azure DevOps service principal exists and has valid secrets
3. Verify any other app registrations used by the platform
4. If secrets expired, rotate and update in Key Vault

</details>
<br/>

**Checkpoint:** Key Vault operational, all secrets populated, service principals valid.

---

## Phase 2: SQL Servers & Database Restore

**Estimated time: 2–4 hours**

<details>
<summary><b>Step 2.1 — Create SQL Servers</b></summary>

If SQL servers are lost, create them in order:

| Server | Resource Group | Region | Auth |
|--------|---------------|--------|------|
| `sql-prod-aus-svc-datawarehouse-01` | `rg-prod-aus-svc-datareporting` | Australia East | Entra-only |
| `sql-prod-aus-svc-fk-01` | `rg-prod-aus-svc-datareporting` | Australia East | Entra-only |
| `sql-prod-aue-svc-datalanding` | `rg-prod-aus-svc-datalanding` | Australia Southeast | Entra-only |

Configure firewall rules:
- Allow Azure services
- Allow required team member IPs

</details>
<br/>

<details>
<summary><b>Step 2.2 — Restore databases from PITR</b></summary>

Follow [Database-Recovery-Procedures](Database-Recovery-Procedures):

**Restore in this order (dependencies):**

| Order | Database | Server | Why First |
|-------|----------|--------|-----------|
| 1 | `Framework` | `sql-prod-aus-svc-fk-01` | ETL metadata needed by all pipelines |
| 2 | `sqldb-prod-manager` | `sql-prod-aus-svc-datawarehouse-01` | Monitoring/audit infra |
| 3 | `sqldb-prod-entprod-01` | `sql-prod-aue-svc-datalanding` | Data landing SQL |
| 4 | `sqldb-prod-datawarehouse-01` | `sql-prod-aus-svc-datawarehouse-01` | EDW |
| 5 | `Recordbase_EmergeAotearoa_Elite` | `eal-sql01` | RecordBase EAL |
| 6 | `Recordbase_MindAndBody_Elite` | `eal-sql01` | RecordBase M&B |

If PITR is not available, deploy from DACPAC (Scenario 2 in Database Recovery).

</details>
<br/>

<details>
<summary><b>Step 2.3 — Restore database security</b></summary>

For each database:
1. Create database users for managed identities (ADF, Synapse)
2. Create database roles (`eal_etl_role`, `eal_report_reader_role` for EDW)
3. Grant permissions per the SSDT security scripts in each repo
4. Verify service principal access for CI/CD pipelines

</details>
<br/>

<details>
<summary><b>Step 2.4 — Configure EDW auto-scaling</b></summary>

1. Restore the automation that handles EDW scaling:
   - 04:30 AM → S6
   - 08:45 AM → S3
   - 17:00 PM → S0
2. This may be Azure Automation, Logic App, or Azure DevOps scheduled pipeline — identify and restore the mechanism

</details>
<br/>

**Checkpoint:** All databases accessible, populated with data (or schema if PITR unavailable), security configured.

---

## Phase 3: Storage Accounts & Data Lake

**Estimated time: 1–2 hours (creation) + 2–8 hours (data reload)**

<details>
<summary><b>Step 3.1 — Create storage accounts</b></summary>

Follow [Storage-and-ODS-Recovery](Storage-and-ODS-Recovery):

| Account | Resource Group | Region | Key Settings |
|---------|---------------|--------|-------------|
| `stprodaussvcsyn` | `rg-prod-aus-svc-datareporting` | Australia East | ADLS Gen2, LRS, soft delete |
| `stprodaussvcdatalanding01` | `rg-prod-aus-svc-datalanding` | Australia Southeast | ADLS Gen2, LRS |
| `stprodaussvcwaharoa01` | `rg-prod-aus-svc-datareporting` | Australia East | ADLS Gen2, LRS |

</details>
<br/>

<details>
<summary><b>Step 3.2 — Create containers</b></summary>

1. For `stprodaussvcsyn`: Create `ods`, `staging`, `reference` containers
2. For `stprodaussvcdatalanding01`: Create per-source containers + `configuration`
3. For `stprodaussvcwaharoa01`: Create Zavanti/property containers

</details>
<br/>

<details>
<summary><b>Step 3.3 — Configure access</b></summary>

1. Grant Storage Blob Data Contributor to:
   - ADF managed identity
   - Synapse managed identity
   - Service principal(s)
2. Generate SAS tokens if needed (Waharoa) and store in Key Vault

</details>
<br/>

**Checkpoint:** Storage accounts created with correct containers and RBAC.

---

## Phase 4: Azure Data Factory & Data Landing

**Estimated time: 1–2 hours**

<details>
<summary><b>Step 4.1 — Create ADF instance</b></summary>

Follow [ADF-Data-Landing-Recovery](ADF-Data-Landing-Recovery) Scenario 3:

1. Create `adf-prod-aus-datalanding-01` in `rg-prod-aus-svc-datalanding`
2. Connect to Git: `ADF Data Landing` repo
3. Grant managed identity access to Key Vault and storage

</details>
<br/>

<details>
<summary><b>Step 4.2 — Deploy and configure pipelines</b></summary>

1. Publish from Git to deploy all pipelines
2. Upload configuration JSON files to ADLS `configuration` container (if not present)
3. Test each linked service connection
4. Start all 13 triggers

</details>
<br/>

<details>
<summary><b>Step 4.3 — Run initial data extraction</b></summary>

1. Manually trigger all master extract pipelines
2. Monitor for completion (2–4 hours for parallel execution)
3. Verify data lands in ADLS containers

</details>
<br/>

**Checkpoint:** ADF operational, all source data extracted to ADLS.

---

## Phase 5: Synapse Workspaces & Pipelines

**Estimated time: 1–2 hours**

<details>
<summary><b>Step 5.1 — Create Synapse workspace</b></summary>

Follow [Synapse-and-Pipeline-Recovery](Synapse-and-Pipeline-Recovery) Scenario 3:

1. Create `synapseausprod` in `rg-prod-aus-svc-datareporting`
2. Associate with `stprodaussvcsyn` storage
3. Connect to Git: `Synapse Integration` repo
4. Create integration runtimes

</details>
<br/>

<details>
<summary><b>Step 5.2 — Deploy ODS schema</b></summary>

Follow [Storage-and-ODS-Recovery](Storage-and-ODS-Recovery) Scenario 3:

1. Run ODS DACPAC deploy pipeline from Azure DevOps
2. Verify external data sources point to correct storage
3. Test ODS views return data

</details>
<br/>

<details>
<summary><b>Step 5.3 — Deploy Synapse Data Landing workspace</b></summary>

1. Create the secondary Synapse workspace for Zavanti/SFTP
2. Connect to Git: `Synapse Data Landing` repo
3. Configure linked services and credentials

</details>
<br/>

<details>
<summary><b>Step 5.4 — Configure and publish Synapse Integration</b></summary>

1. Publish all pipelines from Git
2. Test linked services
3. Start all triggers
4. Run a test ODS dimension load

</details>
<br/>

**Checkpoint:** Synapse workspaces operational, ODS views accessible, pipelines deployable.

---

## Phase 6: Data Reload & Validation

**Estimated time: 4–12 hours**

<details>
<summary><b>Step 6.1 — Run full ETL cycle</b></summary>

If databases were rebuilt from DACPAC (no PITR data), run the full ETL cycle:

1. **Framework:** Verify metadata is populated via config migration
2. **ADF Data Landing:** All source extractions complete (Phase 4)
3. **ODS:** Data visible via Synapse SQL Serverless views
4. **Synapse Integration:** Run the full ODS → EDW load sequence:
   - ODS dimension loads (Full Merge pattern)
   - ODS fact loads
   - EDW Phase 1 loads
   - EDW Phase 2 loads
   - KPI loads
5. **Manager:** Verify load execution records are being created

</details>
<br/>

<details>
<summary><b>Step 6.2 — Validate data integrity</b></summary>

1. Query Manager DB for load execution results:
```sql
SELECT source_system_name, table_name, insert_count, update_count, error_count, status
FROM load_check.load_execution
WHERE start_time >= DATEADD(HOUR, -24, GETDATE())
ORDER BY start_time DESC;
```

2. Run data quality checks:
```sql
SELECT * FROM dq.dq_results
WHERE run_date_time >= DATEADD(HOUR, -24, GETDATE())
ORDER BY run_date_time DESC;
```

3. Spot-check key dimension counts against known baselines:
```sql
-- Compare counts against last known values
SELECT 'dim_client' AS Entity, COUNT(*) AS CurrentCount FROM edw.dim_client WHERE DWHIsCurrent = 1
UNION ALL
SELECT 'dim_service', COUNT(*) FROM edw.dim_service WHERE DWHIsCurrent = 1
UNION ALL
SELECT 'dim_employee_hierarchy', COUNT(*) FROM edw.dim_employee_hierarchy WHERE DWHIsCurrent = 1;
```

</details>
<br/>

<details>
<summary><b>Step 6.3 — Verify trigger schedules are active</b></summary>

1. ADF: Verify all 13 triggers are in Started state
2. Synapse: Verify all 20+ triggers are in Started state
3. Confirm next scheduled run times align with expected schedule

</details>
<br/>

**Checkpoint:** Full data pipeline operational, data loaded and validated, triggers active.

---

## Phase 7: Power BI & Reporting

**Estimated time: 4–8 hours**

<details>
<summary><b>Step 7.1 — Restore Power BI workspace and reports</b></summary>

Follow [Power-BI-Recovery](Power-BI-Recovery) Scenario 2:

1. Create workspace if deleted
2. Publish semantic models from Git (datasets first)
3. Configure data source credentials
4. Refresh all semantic models
5. Publish reports
6. Configure RLS
7. Restore sharing and App settings

</details>
<br/>

<details>
<summary><b>Step 7.2 — Verify business-critical reports</b></summary>

1. Open each P1 report (KPI, Finance) and verify data displays
2. Check filter/slicer functionality
3. Verify RLS restricts data correctly
4. Have a business user confirm data accuracy

</details>
<br/>

**Checkpoint:** Power BI reports accessible to end users with correct data.

---

## Phase 8: Final Validation & Handover

<details>
<summary><b>Step 8.1 — End-to-end validation</b></summary>

Run through the complete validation checklist:

**Infrastructure:**
- [ ] All resource groups exist with correct resources
- [ ] Key Vault operational with all secrets
- [ ] All SQL databases accessible and containing data
- [ ] All storage accounts accessible with correct containers and data
- [ ] ADF operational with all triggers running
- [ ] Synapse workspaces operational with all triggers running

**Data Pipeline:**
- [ ] ADF extracts data from all source systems
- [ ] ODS views return data for all schemas
- [ ] Synapse pipelines load ODS → EDW successfully
- [ ] Framework metadata is complete and correct
- [ ] Manager logs load executions
- [ ] Data quality checks pass

**Reporting:**
- [ ] Power BI workspace accessible
- [ ] All semantic models refresh successfully
- [ ] All reports display correct data
- [ ] RLS is correctly applied
- [ ] End users can access reports

**Security:**
- [ ] All managed identities have correct RBAC
- [ ] All linked services connect successfully
- [ ] CI/CD pipelines can deploy
- [ ] Auto-scaling schedule is operational

</details>
<br/>

<details>
<summary><b>Step 8.2 — Send recovery complete notification</b></summary>

1. Notify all stakeholders that the platform is operational
2. Include:
   - Summary of what was recovered
   - Any known limitations or data gaps
   - Date range of any data loss
   - Contact for issues
3. Close the incident ticket in Pae Awhina

</details>
<br/>

<details>
<summary><b>Step 8.3 — Post-incident review</b></summary>

Within 1 week of recovery:

1. Conduct a post-incident review with the recovery team
2. Document:
   - Root cause of the disaster
   - Timeline of events
   - What worked well in the recovery
   - What could be improved
   - Actual RTO/RPO achieved vs targets
3. Update this DR documentation with lessons learned
4. Create action items for any identified gaps

</details>
<br/>

---

## Quick Reference: Full Rebuild Timeline

| Phase | Components | Estimated Duration | Cumulative |
|-------|-----------|-------------------|------------|
| 0 | Assessment & Communication | 30 min | 30 min |
| 1 | Resource Groups & Key Vault | 1–2 hours | 2.5 hours |
| 2 | SQL Servers & Databases | 2–4 hours | 6.5 hours |
| 3 | Storage Accounts | 1–2 hours | 8.5 hours |
| 4 | ADF & Data Extraction | 3–6 hours | 14.5 hours |
| 5 | Synapse Workspaces & Pipelines | 1–2 hours | 16.5 hours |
| 6 | Data Reload & Validation | 4–12 hours | 28.5 hours |
| 7 | Power BI & Reporting | 4–8 hours | 36.5 hours |
| 8 | Final Validation | 1–2 hours | 38.5 hours |

> **Note:** Phases 4–5 can be partially parallelised (ADF and Synapse setup). Phases 6–7 must be sequential (data must exist before reports can refresh). A full rebuild from absolute zero is estimated at 24–40 hours with a 2-person team working continuously.
