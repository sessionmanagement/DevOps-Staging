# DR Testing and Validation

**Purpose:** Procedures for regularly testing the Disaster Recovery plan to ensure it works when needed. Also includes data validation queries and checklists used during actual DR events.
**Review Frequency:** Quarterly (minimum)

---

## DR Test Schedule

| Test Type | Frequency | Scope | Duration | Participants |
|-----------|-----------|-------|----------|-------------|
| **Tabletop Exercise** | Quarterly | Walk through DR scenarios verbally | 1–2 hours | Full BI team |
| **Component Test** | Bi-annually | Restore single database or pipeline | 2–4 hours | Data Engineering |
| **Partial Recovery Test** | Annually | Rebuild one tier (e.g., ADF + extraction) | 1 day | Data Engineering + Analysts |
| **Full DR Test** | Annually | Complete environment rebuild to TEST | 2 days | Full BI team |

---

## Test 1: Tabletop Exercise

A tabletop exercise walks through DR scenarios without performing actual recovery actions. It validates that the team understands the procedures.

<details>
<summary><b>How to run a tabletop exercise</b></summary>

1. **Facilitator:** BI Manager or designated senior engineer
2. **Participants:** All BI team members (Data Engineers + Analysts)
3. **Duration:** 1–2 hours
4. **Format:**
   - Present a disaster scenario (e.g., "The EDW database has been corrupted by a failed deployment")
   - Walk through the DR procedures step-by-step
   - Each participant describes what they would do at each step
   - Identify gaps, unclear procedures, or missing information
   - Document findings and update DR documentation

**Scenario bank for tabletop exercises:**
- Scenario A: EDW database corrupted during deployment
- Scenario B: ADF Data Landing pipelines all failing — Key Vault secret expired
- Scenario C: Storage account `stprodaussvcsyn` accidentally deleted
- Scenario D: Synapse workspace is inaccessible — Azure outage
- Scenario E: Ransomware detected — all production databases encrypted
- Scenario F: Service principal compromised — unauthorised pipeline executions detected
- Scenario G: Power BI workspace deleted by mistake
- Scenario H: Framework database HWM data lost — all loads running as full

</details>
<br/>

---

## Test 2: Component Recovery Test

Test the recovery of a single component to the TEST environment.

<details>
<summary><b>Step 1 — Select the component to test</b></summary>

Rotate through these components each test cycle:

| Cycle | Component | Recovery Page |
|-------|-----------|---------------|
| 1 | EDW Database restore | [Database-Recovery-Procedures](Database-Recovery-Procedures) |
| 2 | ODS Schema rebuild | [Storage-and-ODS-Recovery](Storage-and-ODS-Recovery) |
| 3 | ADF Pipeline restore from Git | [ADF-Data-Landing-Recovery](ADF-Data-Landing-Recovery) |
| 4 | Synapse Pipeline restore from Git | [Synapse-and-Pipeline-Recovery](Synapse-and-Pipeline-Recovery) |
| 5 | Key Vault secret rotation | [Key-Vault-and-Security-Recovery](Key-Vault-and-Security-Recovery) |
| 6 | Power BI report republish | [Power-BI-Recovery](Power-BI-Recovery) |

</details>
<br/>

<details>
<summary><b>Step 2 — Execute in TEST environment</b></summary>

1. Perform the recovery procedure against the TEST environment only
2. Use test resource group: `rg-test-aus-svc-datareporting`
3. Document:
   - Start time
   - Each step performed
   - Any deviations from the documented procedure
   - Any errors encountered
   - End time

</details>
<br/>

<details>
<summary><b>Step 3 — Validate the recovery</b></summary>

Run the appropriate validation queries (see Validation Queries section below).

</details>
<br/>

<details>
<summary><b>Step 4 — Document results</b></summary>

Create a test report:
- Date of test
- Component tested
- Actual RTO achieved
- Issues found
- DR documentation updates needed
- Action items

</details>
<br/>

---

## Test 3: Full DR Test (Annual)

<details>
<summary><b>Pre-Test Planning</b></summary>

1. Schedule 2 days for the test (ideally over a low-activity period)
2. Notify stakeholders that TEST environment will be rebuilt
3. Prepare the test environment:
   - Delete test resource group resources (or use a separate DR-test resource group)
   - Ensure Azure DevOps pipelines are accessible
4. Assign recovery roles:
   - Infrastructure recovery: Data Engineering Lead
   - Data validation: Analyst Lead
   - Documentation: Designated scribe

</details>
<br/>

<details>
<summary><b>Test Execution</b></summary>

Follow the [Full-Environment-Rebuild](Full-Environment-Rebuild) procedure from Phase 0 to Phase 8, targeting the TEST environment:

- Use test resource groups
- Use test database servers
- Use test storage accounts
- Deploy to test Synapse workspace
- Publish to a test Power BI workspace

Record actual times for each phase.

</details>
<br/>

<details>
<summary><b>Post-Test Review</b></summary>

1. Compare actual vs estimated times for each phase
2. Identify bottlenecks
3. Update estimated times in the DR documentation
4. Document all issues and create remediation tasks
5. Update RTO/RPO targets if needed

</details>
<br/>

---

## Validation Queries

Use these queries during or after any DR event to verify data integrity.

### EDW Row Count Validation

```sql
-- Core dimension counts (compare against known baselines)
SELECT 'edw.dim_client' AS Entity, COUNT(*) AS TotalRows, COUNT(CASE WHEN DWHIsCurrent = 1 THEN 1 END) AS CurrentRows FROM edw.dim_client
UNION ALL
SELECT 'edw.dim_service', COUNT(*), COUNT(CASE WHEN DWHIsCurrent = 1 THEN 1 END) FROM edw.dim_service
UNION ALL
SELECT 'edw.dim_employee_hierarchy', COUNT(*), COUNT(CASE WHEN DWHIsCurrent = 1 THEN 1 END) FROM edw.dim_employee_hierarchy
UNION ALL
SELECT 'edw.dim_region', COUNT(*), COUNT(CASE WHEN DWHIsCurrent = 1 THEN 1 END) FROM edw.dim_region
UNION ALL
SELECT 'edw.dim_finance_contract', COUNT(*), COUNT(CASE WHEN DWHIsCurrent = 1 THEN 1 END) FROM edw.dim_finance_contract
ORDER BY Entity;

-- Core fact counts
SELECT 'edw.fact_client_referral' AS Entity, COUNT(*) AS RowCount FROM edw.fact_client_referral
UNION ALL
SELECT 'edw.fact_finance_vendor_ledger', COUNT(*) FROM edw.fact_finance_vendor_ledger
UNION ALL
SELECT 'edw.fact_finance_general_ledger', COUNT(*) FROM edw.fact_finance_general_ledger
UNION ALL
SELECT 'edw.fact_client_address_history', COUNT(*) FROM edw.fact_client_address_history
ORDER BY Entity;

-- Most recent modification dates (should be within RPO window)
SELECT 'dim_client' AS Entity, MAX(DWHModifiedDateTime) AS LastModified FROM edw.dim_client
UNION ALL
SELECT 'dim_service', MAX(DWHModifiedDateTime) FROM edw.dim_service
UNION ALL
SELECT 'fact_client_referral', MAX(DWHModifiedDateTime) FROM edw.fact_client_referral
ORDER BY Entity;
```

### Framework Validation

```sql
-- Metadata completeness
SELECT 'DataSource' AS Entity, COUNT(*) AS Count FROM Metadata.DataSource
UNION ALL
SELECT 'DataObject', COUNT(*) FROM Metadata.DataObject
UNION ALL
SELECT 'DataObjectField', COUNT(*) FROM Metadata.DataObjectField;

-- Config migration state
SELECT * FROM Metadata.SystemInformation;

-- High water marks (critical for incremental loads)
SELECT COUNT(*) AS HWM_Count FROM Deploy.DataLoadMigration_HWM;

-- Check for any in-flight batches
SELECT BatchID, CreatedAt, ClosedAt, Status
FROM ETL.Batch
WHERE ClosedAt IS NULL;
```

### Manager Validation

```sql
-- Configuration completeness
SELECT COUNT(*) AS ConfigCount FROM config.configuration;

-- Recent load executions
SELECT TOP 20
    source_system_name, table_name, 
    start_time, end_time,
    insert_count, update_count, delete_count,
    status
FROM load_check.load_execution
ORDER BY start_time DESC;

-- Data quality results
SELECT TOP 20
    check_name, run_date_time, result, threshold, actual_value
FROM dq.dq_results
ORDER BY run_date_time DESC;
```

### ODS View Validation

```sql
-- Check schemas and view counts
SELECT s.name AS SchemaName, COUNT(*) AS ViewCount
FROM sys.views v
JOIN sys.schemas s ON v.schema_id = s.schema_id
GROUP BY s.name
ORDER BY s.name;

-- Test data access from key schemas
SELECT TOP 1 * FROM BusinessCentral.Items;
SELECT TOP 1 * FROM EmpLive.employees;
SELECT TOP 1 * FROM Akoranga.mdl_user;
SELECT TOP 1 * FROM IntelliHR.people;
SELECT TOP 1 * FROM Datapay.employees;
```

### Storage Account Validation

```sql
-- Check external data sources (run in Synapse SQL Serverless)
SELECT name, location, type FROM sys.external_data_sources;
```

---

## Baseline Snapshot Process

To enable meaningful validation during DR, maintain a baseline snapshot.

<details>
<summary><b>How to take a baseline snapshot</b></summary>

Run this monthly (or after significant data changes) and store results:

```sql
-- Run against EDW
SELECT 
    SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    SUM(p.rows) AS RowCount,
    GETDATE() AS SnapshotDate
FROM sys.tables t
JOIN sys.partitions p ON t.object_id = p.object_id AND p.index_id IN (0, 1)
WHERE SCHEMA_NAME(t.schema_id) IN ('edw', 'staging', 'landing', 'kpi', 'reference')
GROUP BY SCHEMA_NAME(t.schema_id), t.name
ORDER BY SchemaName, TableName;
```

Store baseline snapshots in:
- Manager database (automated via pipeline)
- Or as a CSV in a secure SharePoint location (manual)

</details>
<br/>

---

## DR Test Results Log

Record all DR test results here for audit and improvement tracking.

| Date | Test Type | Component | Actual RTO | Issues Found | Actions Taken |
|------|-----------|-----------|------------|-------------|--------------|
| _YYYY-MM-DD_ | _Tabletop / Component / Full_ | _Component name_ | _Duration_ | _Issues_ | _Actions_ |

> **Template:** Copy a row and fill in after each DR test.

---

## Preventive Measures Checklist

Review these items quarterly to prevent disasters:

- [ ] Azure SQL backup retention set to maximum (35 days) for all production databases
- [ ] Storage account soft delete enabled and retention verified
- [ ] Key Vault purge protection enabled (90 days) and verified
- [ ] All service principal secrets reviewed — none expiring within 30 days
- [ ] All API credentials reviewed — none expiring within 30 days
- [ ] Azure DevOps variable groups documented externally (in case DevOps is unavailable)
- [ ] All CI/CD pipelines tested recently (within last sprint)
- [ ] Git repositories have recent commits on Production branches
- [ ] Framework BCP export run recently (within last month)
- [ ] Manager load_execution shows successful loads for all source systems
- [ ] Data quality checks show no critical failures
- [ ] On-call roster is current and accurate
- [ ] Vendor DR contact information is up to date
- [ ] This DR documentation has been reviewed and is current
