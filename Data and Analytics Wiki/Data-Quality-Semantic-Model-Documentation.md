# Data Quality Semantic Model Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [Data Quality Framework Architecture](#data-quality-framework-architecture)
3. [Semantic Model Design](#semantic-model-design)
4. [Tables Reference](#tables-reference)
5. [Relationships](#relationships)
6. [DAX Measures](#dax-measures)
7. [Parameters](#parameters)
8. [Design Decisions & Rationale](#design-decisions--rationale)
9. [Testing & Validation](#testing--validation)
10. [Deployment Guide](#deployment-guide)
11. [Future Enhancements](#future-enhancements)
12. [Troubleshooting](#troubleshooting)

---

## Project Overview

### Purpose
This Power BI semantic model provides comprehensive reporting and monitoring capabilities for the **Data Quality (DQ) framework** implemented in the Manager database (`sqldb-prod-manager`). It enables the BI team to monitor 400+ automated data quality checks that run daily across the Enterprise Data Warehouse (EDW).

### Key Capabilities
- **Check Execution Monitoring**: Track pass/fail rates, identify failing checks, monitor issue counts
- **KPI Health Scoring**: View quality scores by KPI, track trends, identify problematic views
- **Time-Based Analysis**: Daily/weekly/monthly quality trends, historical comparisons
- **Column Lineage**: Understand which source columns are used by each KPI view
- **Drill-Through Analysis**: Navigate from summary to detailed check results

### Data Sources
- **Primary**: Manager Database (`sqldb-prod-manager` on `sql-prod-aus-svc-datawarehouse-01.database.windows.net`)
- **Secondary**: EDW Database (`sqldb-prod-datawarehouse-01` on same server) - for Dim Date only

### Project Location
- **Folder**: `C:\DevOps\Data_Quality_Report\Semantic Model\`
- **Format**: `.pbip` (Power BI Project format for version control)

---

## Data Quality Framework Architecture

### Overview
The Data Quality framework is a dictionary-driven system that executes automated SQL checks against EDW tables and stores results in the Manager database. The framework is orchestrated by Azure Synapse pipelines.

### Framework Components

```
┌─────────────────────────────────────────────────────────────────┐
│ DATA QUALITY FRAMEWORK FLOW                                     │
│ (Manager Database: sqldb-prod-manager)                          │
└─────────────────────────────────────────────────────────────────┘

1. CHECK DEFINITIONS (dq.dq_dictionary)
   ├─ dictionary_id: Unique check identifier (PRIMARY KEY)
   ├─ table_name: Target EDW table/view (e.g., 'edw.fact_property_inspection')
   ├─ column_name: Specific column to check (NULL for table-level checks)
   ├─ check_name: Human-readable description
   ├─ check_SQL: Executable T-SQL returning CheckType + IssueCount
   └─ expected_result: Expected threshold (e.g., '0', '<=5')

2. CHECK EXECUTION (via Synapse Pipeline "Data quality run data dictionary")
   ├─ Pipeline copies dq_dictionary to EDW
   ├─ EDW procedure: meta_data.populate_dq_from_dictionary executes all checks
   ├─ Returns: check_id, table_name, column_name, record_count, status
   └─ Synapse inserts results into Manager.dq.dq_results

3. RESULTS STORAGE (dq.dq_results)
   ├─ results_id: Auto-increment unique ID
   ├─ check_id: Links to dq_dictionary.dictionary_id
   ├─ record_count: Number of failing records (0 = pass, >0 = fail)
   ├─ run_date_time: NZ timezone execution timestamp
   └─ Growth: 400+ rows per run (one per check)

4. COLUMN LINEAGE (dq.view_column_flags)
   ├─ Tracks which columns each KPI view uses
   ├─ 15 usage flags (is_in_select, is_in_where, is_in_join, etc.)
   ├─ Refreshed by: EDW.meta_data.usp_refresh_view_column_flags
   └─ Enables view-level health scoring

5. KPI HEALTH SCORING (dq.vw_kpi_data_quality_score)
   ├─ Aggregates column health per KPI view
   ├─ Formula: (HealthyMonitoredColumns / MonitoredColumns) × 100
   ├─ One row per KPI view (latest calendar day only)
   └─ Includes: TotalColumns, MonitoredColumns, HealthyMonitoredColumns, etc.

6. DETAILED RESULTS (dq.vw_kpi_data_quality_detail)
   ├─ Row-level check results for all KPI columns
   ├─ Shows passing AND failing checks
   ├─ IsHealthy flag: -1 (not monitored), 0 (failed), 1 (passed)
   └─ Used for drill-through analysis
```

### Key Framework Facts
- **Total Checks**: 400+ checks defined in dictionary
- **Check Frequency**: Daily execution (currently Mon-Fri 8:30 AM NZ time)
- **Scope**: All KPI views (`edw.kpi_%` pattern, excluding `kpi_snapshot_%`)
- **Time Zone**: All timestamps in New Zealand Standard Time (DST-aware)
- **Cross-Database**: EDW executes checks, Manager stores results (orchestrated by Synapse)

---

## Semantic Model Design

### Data Model Type
**Star Schema** with two fact tables sharing a conformed date dimension.

### Model Diagram

```
                    Dim Date
                       │
         ┌─────────────┴─────────────┐
         │                           │
         │ (Run Date)                │ (Score Date)
         │                           │
    Fact DQ Results         Fact KPI Quality Score
         │                           │
         │ (Check ID)                │ (View Name)
         │                           │
   Dim Check Dictionary      Dim Column Lineage


         DQ Detail
    (Isolated - No Relationships)
    (Used for drill-through only)
```

### Design Principles
1. **Star Schema**: Simple, performant, follows Kimball methodology
2. **Conformed Dimensions**: Single Dim Date serves both fact tables
3. **Grain Clarity**: Each fact table has a clearly defined grain
4. **Reference Tables**: DQ Detail isolated for flexible drill-through
5. **Correct Keys**: Relationships use surrogate keys (Check ID, Dictionary ID)

---

## Tables Reference

### Fact Tables

#### **Fact DQ Results**
- **Source**: `dq.dq_results` from Manager database
- **Grain**: One row per check execution
- **Update Frequency**: Daily (400+ new rows per day)
- **Key Columns**:
  - `Results ID` (int64, hidden) - Surrogate key
  - `Check ID` (int64, hidden) - Foreign key to Dim Check Dictionary
  - `Table Name` (string) - EDW table being checked
  - `Column Name` (string) - Column being checked (NULL for table-level)
  - `Check Name` (string) - Human-readable check description
  - `Status Message` (string) - Error message or "PASS"
  - `Record Count` (int64) - Number of failed records (0 = pass)
  - `Run Date` (date) - Converted from run_date_time for relationships

#### **Fact KPI Quality Score**
- **Source**: `dq.vw_kpi_data_quality_score` from Manager database
- **Grain**: One row per KPI view per score date
- **Update Frequency**: Daily (one row per KPI view per day)
- **Key Columns**:
  - `View Name` (string) - KPI view name (e.g., 'kpi_property_pipeline')
  - `Total Columns` (int64) - Total columns used by view
  - `Monitored Columns` (int64) - Columns with DQ checks defined
  - `Unmonitored Columns` (int64) - Columns without DQ checks
  - `Healthy Monitored Columns` (int64) - Columns passing all checks
  - `Compromised Monitored Columns` (int64) - Columns failing checks
  - `Total Checks` (int64) - Number of checks defined for this view
  - `Data Quality Score Pct` (double, **average**) - Health percentage
  - `Score Date` (date) - Date of score calculation

### Dimension Tables

#### **Dim Date**
- **Source**: `edw.dim_date` from EDW database (via Database EDW parameter)
- **Grain**: One row per calendar date
- **Date Range**: 2020-01-01 onwards (filtered in SQL)
- **Key Columns**:
  - `Dim Date KEY` (int64, hidden) - Surrogate key
  - `Calendar Date` (datetime, **isKey**) - Natural key for relationships
  - `Calendar Day Name Short` (string) - Mon, Tue, etc.
  - `Calendar Week Num` (int64)
  - `Calendar Month Num` (int64)
  - `Calendar Month Name Long` (string) - January, February, etc.
  - `Calendar Year Month` (string) - 2024-01, 2024-02, etc.
  - `Calendar Quarter Full` (string) - 2024-Q1, 2024-Q2, etc.
  - `Calendar Year` (int64)
  - `Current Date Flag` (int64) - 1 for today
  - `Current Month Flag` (int64) - 1 for current month dates
  - `Current Calendar Year Flag` (int64) - 1 for current year dates

#### **Dim Check Dictionary**
- **Source**: `dq.dq_dictionary` from Manager database
- **Grain**: One row per check definition
- **Row Count**: 400+ checks
- **Key Columns**:
  - `Dictionary ID` (int64, hidden) - Surrogate key, **relationship key**
  - `Table Name` (string) - EDW table/view being checked
  - `Column Name` (string) - Column being checked
  - `Check Name` (string) - Human-readable check description
  - `Filter Clause` (string) - SQL WHERE clause used in check
  - `Check Sql` (string) - Full SQL query definition
  - `Expected Result` (string) - Expected threshold (e.g., "0")

#### **Dim Column Lineage**
- **Source**: `dq.view_column_flags` from Manager database
- **Grain**: One row per KPI view per source column
- **Key Columns**:
  - `View Name` (string) - KPI view name
  - `Source Table` (string) - Source table referenced
  - `Source Column` (string) - Source column referenced
  - `Is In Select` (int64) - 1 if column in SELECT clause
  - `Is Distinct Select` (int64)
  - `Is In Where` (int64)
  - `Is In Join` (int64)
  - `Is In Group By` (int64)
  - `Is In Having` (int64)
  - `Is In Order By` (int64)
  - `Is Aggregated` (int64)
  - `Is In Outer Apply` (int64)
  - `Is In Cross Apply` (int64)
  - `Is In Window` (int64)
  - `Is In Case` (int64)
  - `Is In Function` (int64)
  - `Is In Expression` (int64)
  - `Has Select Star` (int64)
  - `Load Dtm` (datetime) - Last refresh timestamp

### Reference Tables

#### **DQ Detail**
- **Source**: `dq.vw_kpi_data_quality_detail` from Manager database
- **Grain**: One row per KPI view per column per check
- **Purpose**: Drill-through analysis (NOT part of star schema)
- **Relationships**: NONE (intentionally isolated)
- **Key Columns**:
  - `View Name` (string)
  - `Table Name` (string)
  - `Column Name` (string)
  - `Check Name` (string)
  - `Record Count` (int64)
  - `Status Message` (string)
  - `Rundate` (date)
  - `Ishealthy` (int64) - -1 (not monitored), 0 (failed), 1 (passed)

### Support Tables

#### **Measures Table**
- **Purpose**: Container for DAX measures
- **Type**: Calculated table (empty structure)
- **Contents**: 10 measures for DQ analysis

#### **Changelog**
- **Purpose**: Track dataset version history
- **Type**: M-generated table from embedded data
- **Columns**: Version, Description, Change Date, Changed By, User Story ID

#### **LastRefreshed**
- **Purpose**: Display refresh timestamp to users
- **Type**: Single-row calculated table

---

## Relationships

### Active Relationships

All relationships are **Many-to-One** with **Single direction** filter propagation:

```tmdl
relationship 1: Fact DQ Results → Dim Date
    fromColumn: 'Fact DQ Results'.'Run Date'
    toColumn: 'Dim Date'.'Calendar Date'
    fromCardinality: many
    toCardinality: one

relationship 2: Fact DQ Results → Dim Check Dictionary
    fromColumn: 'Fact DQ Results'.'Check ID'
    toColumn: 'Dim Check Dictionary'.'Dictionary ID'
    fromCardinality: many
    toCardinality: one

relationship 3: Fact KPI Quality Score → Dim Date
    fromColumn: 'Fact KPI Quality Score'.'Score Date'
    toColumn: 'Dim Date'.'Calendar Date'
    fromCardinality: many
    toCardinality: one
```

### Optional Relationship (Not Currently Implemented)

```tmdl
relationship 4 (OPTIONAL): Dim Column Lineage → Fact KPI Quality Score
    fromColumn: 'Dim Column Lineage'.'View Name'
    toColumn: 'Fact KPI Quality Score'.'View Name'
    fromCardinality: many
    toCardinality: one

Purpose: Enable column-level lineage filtering on quality scores
Impact: Allows answering "Which specific columns contribute to poor health scores?"
```

### Relationship Design Notes

1. **Correct Keys**: Uses `Check ID` ↔ `Dictionary ID` (NOT `Check Name` which is non-unique)
2. **Two Date Relationships**: Both fact tables connect to Dim Date (conformed dimension)
3. **No Diamond Pattern**: DQ Detail is isolated to prevent ambiguous filter propagation
4. **Filter Direction**: All relationships filter from dimension → fact (standard star schema)

---

## DAX Measures

All measures are stored in the **Measures Table**.

### Basic Check Metrics

```dax
Total Checks Run = COUNTROWS('Fact DQ Results')

Failed Checks =
    CALCULATE(
        COUNTROWS('Fact DQ Results'),
        'Fact DQ Results'[Record Count] > 0
    )

Passed Checks =
    CALCULATE(
        COUNTROWS('Fact DQ Results'),
        'Fact DQ Results'[Record Count] = 0
    )

Pass Rate % =
    DIVIDE([Passed Checks], [Total Checks Run], 0) * 100

Total Issues Found = SUM('Fact DQ Results'[Record Count])
```

### KPI Health Metrics

```dax
Average DQ Score % =
    AVERAGE('Fact KPI Quality Score'[Data Quality Score Pct])

Views at 100% Health =
    CALCULATE(
        DISTINCTCOUNT('Fact KPI Quality Score'[View Name]),
        'Fact KPI Quality Score'[Data Quality Score Pct] = 100
    )

Views Below 80% =
    CALCULATE(
        DISTINCTCOUNT('Fact KPI Quality Score'[View Name]),
        'Fact KPI Quality Score'[Data Quality Score Pct] < 80
    )
```

### Time Intelligence

```dax
Latest Check Run Date = MAX('Fact DQ Results'[Run Date])

Days Since Last Check =
    DATEDIFF(
        [Latest Check Run Date],
        TODAY(),
        DAY
    )
```

### Additional Measure (Data Masking - Not DQ-related)

```dax
Is Executive User =
    IF(
        USERPRINCIPALNAME() IN VALUES('Executinve Masking'[User Principal Name]),
        1,
        0
    )
```

---

## Parameters

### Server
- **Type**: Text parameter
- **Default**: `sql-prod-aus-svc-datawarehouse-01.database.windows.net`
- **Options**: Dev (`sql-dev-aue-svc-datawarehouse-01.database.windows.net`), Prod
- **Usage**: All database connections

### Database EDW
- **Type**: Text parameter
- **Default**: `sqldb-prod-datawarehouse-01`
- **Options**: Dev (`sqldb-dev-datawarehouse-01`), Prod
- **Usage**: Dim Date query only

### Database DQ
- **Type**: Text parameter
- **Default**: `sqldb-prod-manager`
- **Options**: Currently only Prod listed
- **Usage**: All DQ tables (Fact DQ Results, Fact KPI Quality Score, Dim Check Dictionary, DQ Detail, Dim Column Lineage)
- **Note**: Can add Dev option `sqldb-dev-manager` if needed

### Dataset Name
- **Type**: Text parameter
- **Default**: `Data Quality`
- **Usage**: Changelog and documentation

---

## Design Decisions & Rationale

### 1. Why Two Separate Databases?
**Decision**: Use two parameters (Database EDW and Database DQ)
**Rationale**:
- Dim Date lives in EDW (edw.dim_date)
- All DQ tables live in Manager database (dq schema)
- Clear separation matches the actual data architecture
- Allows independent environment switching if needed

### 2. Why Convert run_date_time to date?
**Decision**: Transform datetime to date in M query
**Rationale**:
- Relationships require matching data types
- Dim Date uses date type for Calendar Date
- DQ checks run once per day, time component not needed for analysis
- Simplifies time intelligence and filtering

### 3. Why Average (not Sum) for Data Quality Score Pct?
**Decision**: Set `summarizeBy: average` for Data Quality Score Pct
**Rationale**:
- Summing percentages is mathematically incorrect (can exceed 100%)
- Averaging gives meaningful aggregate score across multiple views
- Example: Views with 90% and 80% scores → Average = 85% ✓ (Sum = 170% ✗)

### 4. Why Use Check ID instead of Check Name?
**Decision**: Relationship uses Check ID ↔ Dictionary ID
**Rationale**:
- Check Name is NOT unique in dq_dictionary
- Multiple checks can have similar/duplicate names
- Check ID and Dictionary ID are the true surrogate keys
- Using Check Name creates ambiguous many-to-many relationship

### 5. Why Is DQ Detail Isolated (No Relationships)?
**Decision**: DQ Detail has no relationships to model
**Rationale**:
- Prevents diamond relationship pattern
- Avoids ambiguous filter propagation
- Designed specifically for drill-through scenarios
- Users can drill from Fact tables to DQ Detail for row-level analysis
- Relationships would create many-to-many complexity

### 6. Why Minimal Dim Date?
**Decision**: Only 12 columns from full dim_date table
**Rationale**:
- DQ reporting needs basic time intelligence only
- Reduces model size and complexity
- Includes essential: day, week, month, quarter, year, current flags
- Can add more columns later if needed

### 7. Why Hide Most Columns?
**Decision**: Initially hide technical/surrogate key columns
**Rationale**:
- Keeps field list clean for report authors
- Hides surrogate keys (Results ID, Check ID, Dictionary ID)
- Users should use measures, not raw columns
- Can unhide specific columns as needed for ad-hoc analysis

---

## Testing & Validation

### Pre-Deployment Checklist

- [ ] **Data Refresh Test**
  - Refresh model successfully from both databases
  - Verify row counts match source tables
  - Check for refresh errors in Query Dependencies

- [ ] **Relationship Validation**
  - Verify Check ID → Dictionary ID relationship shows correct check definitions
  - Test that date slicers filter both fact tables
  - Confirm no circular dependencies or ambiguous relationships

- [ ] **Measure Validation**
  - Verify Total Checks Run = count of dq_results rows
  - Check that Failed Checks + Passed Checks = Total Checks Run
  - Validate Pass Rate % = (Passed / Total) × 100
  - Confirm Average DQ Score % is between 0-100
  - Test Views at 100% Health returns correct count

- [ ] **Filter Propagation**
  - Select a date → verify both facts filter
  - Select a check name → verify results filter
  - Select a KPI view → verify scores filter
  - Test DQ Detail drill-through from Fact tables

- [ ] **Performance**
  - Measure refresh time (should be under 2 minutes for 400+ checks)
  - Test report responsiveness with all data loaded
  - Check visual load times with filters applied

- [ ] **Data Quality Validation**
  - Compare measure totals to source query results
  - Verify latest check dates match actual Synapse runs
  - Cross-check quality scores with source view calculations

### Validation Queries

Run these queries against Manager database to validate model data:

```sql
-- Verify total check count
SELECT COUNT(*) AS TotalChecks
FROM dq.dq_results
WHERE CAST(run_date_time AS date) = (SELECT MAX(CAST(run_date_time AS date)) FROM dq.dq_results);

-- Verify failed check count
SELECT COUNT(*) AS FailedChecks
FROM dq.dq_results
WHERE record_count > 0
  AND CAST(run_date_time AS date) = (SELECT MAX(CAST(run_date_time AS date)) FROM dq.dq_results);

-- Verify KPI score count
SELECT COUNT(*) AS KPICount
FROM dq.vw_kpi_data_quality_score;

-- Verify average DQ score
SELECT AVG(DataQualityScorePct) AS AvgScore
FROM dq.vw_kpi_data_quality_score;
```

---

## Deployment Guide

### Initial Setup (New Workspace)

1. **Create Power BI Workspace**
   - Name: `Data Quality Monitoring` (or per organizational standards)
   - License: Premium or Premium Per User (for large dataset support)
   - Access: Grant BI team Read/Write

2. **Repository Setup**
   - Create new branch: `feature/<ID>_data_quality_semantic_model`
   - Copy entire `Data_Quality_Report/Semantic Model/` folder
   - Commit with message: "Initial commit: Data Quality semantic model"

3. **Open in Power BI Desktop**
   - Open `Data Quality Dataset.pbip` file
   - Verify parameters point to correct environment
   - Test data refresh

4. **Publish to Workspace**
   - File → Publish → Select target workspace
   - Configure scheduled refresh (daily at 9:00 AM NZ time)
   - Set refresh to run after Synapse DQ pipeline completes

5. **Configure Dataset Settings**
   - Set refresh schedule
   - Configure gateway connection (if required)
   - Set parameter values for Production
   - Test scheduled refresh

### Environment Strategy

| Environment | Server | Database DQ | Workspace |
|-------------|--------|-------------|-----------|
| Development | sql-dev-aue-svc-datawarehouse-01 | sqldb-dev-manager | Data Quality - Dev |
| Production | sql-prod-aus-svc-datawarehouse-01 | sqldb-prod-manager | Data Quality Monitoring |

### Refresh Schedule Recommendation

**Synapse Pipeline**: "Data quality run data dictionary"
**Current**: Mon-Fri 8:30 AM NZ time

**Power BI Refresh**:
**Recommended**: Daily at 9:00 AM NZ time (30 min after pipeline)
**Frequency**: Once per day
**Retry**: Yes (2 retries, 10 min apart)

### Access Control

**Workspace Roles**:
- **Admin**: BI team leads
- **Member**: BI analysts/developers
- **Contributor**: Report authors who need to modify
- **Viewer**: Business users consuming reports

**Row-Level Security**: Not currently implemented (DQ is internal BI tool)

---

## Future Enhancements

### High Priority

1. **Add Dim Column Lineage Relationship**
   - Connect to Fact KPI Quality Score via View Name
   - Enable column-level analysis of quality scores
   - Answer: "Which specific columns cause poor health scores?"

2. **Create Drill-Through Pages**
   - Configure DQ Detail table for drill-through
   - Allow users to navigate from summary → detail
   - Show row-level check failures

3. **Add Time Intelligence Calculation Group**
   - YTD, MTD, Prior Period comparisons
   - Rolling 7/30/90 day averages
   - Month-over-month trends

### Medium Priority

4. **Add More Granular Measures**
   - Checks by Table
   - Checks by Check Type (completeness, referential integrity, etc.)
   - Issues by Severity (if severity added to dictionary)
   - Top 10 Failing Checks

5. **Create Alerting Mechanisms**
   - DAX measure: Views with Declining Scores
   - Flag: Checks Not Run in Last 7 Days
   - Threshold breaches

6. **Performance Optimization**
   - Consider aggregation tables for historical trends
   - Implement incremental refresh if data grows large
   - Review and optimize complex measures

### Low Priority

7. **Remove Unused Tables**
   - Evaluate if Dim Company, Dim Service needed
   - Remove RLS tables if not used for DQ
   - Clean up Executive Masking if not applicable

8. **Add Check Type Dimension**
   - Categorize checks: Completeness, Referential Integrity, Domain Validation, etc.
   - Would require adding check_type column to dq_dictionary

9. **Create Role-Playing Date Dimensions**
   - Check Execution Date (separate from Score Date)
   - Only if independent date slicing needed

---

## Troubleshooting

### Common Issues

#### Issue: Refresh Fails with "Could not find stored procedure"
**Cause**: Using wrong database parameter
**Solution**:
- Verify Database DQ = `sqldb-prod-manager` (not sqldb-prod-datawarehouse-01)
- Check Server parameter matches environment

#### Issue: Relationships Show as Inactive/Broken
**Cause**: Data type mismatch or missing data
**Solution**:
- Verify Run Date and Score Date are date type (not datetime)
- Check Dim Date Calendar Date is date type
- Refresh both tables and test

#### Issue: Measures Return Blank or Incorrect Values
**Cause**: Filter context or relationship issues
**Solution**:
- Verify relationships are active (not inactive)
- Check that measure refers to correct table/column names
- Test measure in table visual with dimensions

#### Issue: Average DQ Score % Shows Over 100%
**Cause**: Column set to Sum instead of Average
**Solution**:
- Right-click Data Quality Score Pct column
- Change Summarization to Average (not Sum)

#### Issue: DQ Detail Shows No Data in Drill-Through
**Cause**: DQ Detail is not configured for drill-through
**Solution**:
- DQ Detail should have NO relationships (this is correct)
- Configure drill-through in report page settings
- Add DQ Detail fields to drill-through page

#### Issue: Slow Refresh Performance
**Cause**: Loading too much historical data
**Solution**:
- Verify Dim Date filtered to >= 2020-01-01
- Consider filtering Fact DQ Results to last 12 months
- Review query folding in Query Dependencies

---

## Metadata

**Document Version**: 1.0
**Last Updated**: 2025-10-28
**Created By**: BI Team
**Model Version**: 0.1.0
**Power BI Format**: .pbip (Project Format)
**Compatibility**: Power BI Desktop v2.0+, Power BI Service Premium

---

## Related Documentation

- **CLAUDE.md** (Main Repo): Complete DevOps repository architecture and DQ framework details
- **Codex-Data-Quality-Dictionary-Guide.md**: Guide for authoring new DQ checks
- **DQ Wiki**: `Data and Analytics Wiki/BI-Team/.../Data‑Quality-Platform-–-KPI-Solution.md`
- **Manager Database CLAUDE.md**: Detailed Manager database schema documentation

---

## Contact & Support

**Primary Contacts**:
- BI Team Lead: [Contact Info]
- Data Quality Framework Owner: [Contact Info]

**Questions?**
- DQ Framework: Review Manager/CLAUDE.md in main repo
- Semantic Model: This document
- Report Building: Power BI best practices wiki

---

## Appendix: Quick Reference

### Key Files
```
Data_Quality_Report/Semantic Model/
├── Data Quality Dataset.pbip                  # Main project file
├── Data Quality Dataset.Report/               # Report definitions
├── Data Quality Dataset.SemanticModel/        # Model definitions
│   ├── definition.pbism
│   ├── definition/
│   │   ├── model.tmdl                        # Model metadata
│   │   ├── relationships.tmdl                # Relationship definitions
│   │   ├── expressions.tmdl                  # Parameters and queries
│   │   ├── tables/*.tmdl                     # Table definitions
│   │   └── roles/*.tmdl                      # Security roles
│   └── diagramLayout.json                    # Model view layout
└── DATA_QUALITY_SEMANTIC_MODEL.md            # This document
```

### Key Measures Summary
| Measure | Purpose | Formula Type |
|---------|---------|--------------|
| Total Checks Run | Count all checks | COUNTROWS |
| Failed Checks | Count checks with issues | CALCULATE + FILTER |
| Pass Rate % | Success percentage | DIVIDE |
| Average DQ Score % | Mean quality score | AVERAGE |
| Views at 100% Health | Perfect score count | CALCULATE + DISTINCTCOUNT |
| Latest Check Run Date | Most recent run | MAX |

### Relationship Quick Reference
| From | To | Key |
|------|----|----|
| Fact DQ Results | Dim Date | Run Date → Calendar Date |
| Fact DQ Results | Dim Check Dictionary | Check ID → Dictionary ID |
| Fact KPI Quality Score | Dim Date | Score Date → Calendar Date |

---

**END OF DOCUMENTATION**
