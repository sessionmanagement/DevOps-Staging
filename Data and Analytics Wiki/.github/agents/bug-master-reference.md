# Bug Master Reference Material

This file contains detailed reference material for the Bug Master agent. Load sections as needed — you do not need to read the entire file for every interaction.

**Sections:**
1. [Organization Context](#1-organization-context)
2. [Technical Architecture](#2-technical-architecture)
3. [Team Structure and Roles](#3-team-structure-and-roles)
4. [Azure DevOps Structure](#4-azure-devops-structure)
5. [Investigation Procedures](#5-investigation-procedures)
6. [Enhancement Request Management](#6-enhancement-request-management)
7. [Communication Templates](#7-communication-templates)
8. [Quality Assurance and Testing](#8-quality-assurance-and-testing)
9. [Monitoring and Metrics](#9-monitoring-and-metrics)
10. [Emergency Procedures](#10-emergency-procedures)

---

## 1. Organization Context

### About Emerge Aotearoa

Emerge Aotearoa is a New Zealand organization providing essential services across four key areas:

- **Health Services**: Mental health and addiction support
- **Disability Services**: Support for people with disabilities
- **Housing Services**: Social housing and tenancy management
- **Employment Services**: Vocational and employment support

### Key Māori Terminology

| Term | Meaning |
|------|---------|
| **Kaimahi** | Staff/employees |
| **Tangata Whaiora** | People accessing services (clients) |
| **Te Pātaka** | Production Power BI platform/app |
| **Pae Awhina** | Service desk ticketing system |
| **Waharoa** | Housing/property management system |

### Business Domains and Systems

**Primary Business Systems:**
- **Waharoa/Zavanti**: Property management, tenancies, maintenance
- **Personaverse**: Client services and case management
- **Business Central**: Financial management and general ledger
- **Akoranga**: Learning management system
- **Emplive**: Employee time and attendance
- **IntelliHR**: Human resources management
- **DataPay**: Payroll system

**Key Business Data Areas:**
- Financial transactions and budgets
- Employee demographics, remuneration, and leave
- Client referrals and service outcomes
- Property management and maintenance
- Training and certification progress
- KPI monitoring and organizational performance

---

## 2. Technical Architecture

### Core Data Platform

**Azure Cloud Infrastructure:**
- **EDW (Enterprise Data Warehouse)**: Azure SQL Database for dimensional modeling
- **ODS (Operational Data Store)**: Staging and operational data storage
- **Azure Data Factory**: ETL pipelines for data integration
- **Power BI Service**: Semantic models and reports
- **Azure Synapse**: Advanced analytics and data processing

**Environment Structure:**
- **Production**: `sql-prod-aus-svc-datawarehouse-01.database.windows.net`
- **Development**: `sql-dev-aue-svc-datawarehouse-01.database.windows.net`
- **Databases**: `sqldb-prod-datawarehouse-01` (prod), `sqldb-dev-datawarehouse-01` (dev)

### Database Architecture

**Schema Organization:**
- `edw.*`: Enterprise data warehouse views (final consumption layer)
- `dwh.*`: Dimensional model (facts and dimensions)
- `kpi.*`: Pre-calculated KPI metrics
- `staging.*`: Staging tables for ETL processes
- `landing.*`: Raw data landing tables

**Naming Conventions:**
- Fact tables: `fact_[business_process]` (e.g., `fact_client_referral`)
- Dimension tables: `dim_[entity]` (e.g., `dim_employee`, `dim_client`)
- Keys: `dim_[name]_key` for surrogate keys, `[name]_id` for business keys
- SCD tracking: `DWHEffectiveFrom`, `DWHEffectiveTo`, `DWHIsCurrent`

### Power BI Architecture

**Report Structure:**
- 60+ Power BI semantic models using modern PBIP format
- 40+ Power BI reports for operational and analytical reporting
- 4 Paginated reports (.rdl) for formal documentation
- Row-Level Security integrated with SharePoint

**Key Semantic Models:**
- Financial Dataset, Kaimahi Demographics Dataset, Kaimahi Dataset
- Tangata Whaiora Dataset, Property Dataset, KPI Dataset
- Incident Reporting Dataset, Quality Feedback Dataset

**Development Standards:**
- Git-based version control using PBIP format
- Star schema design with Kimball methodology
- Parameters for environment switching (Server, Database, Top N Rows)
- Measures organized in dedicated tables
- DAX naming conventions and Time Intelligence functions

---

## 3. Team Structure and Roles

### Scrum Framework

**Sprint Structure:**
- 3-week sprints with defined ceremonies
- Daily stand-ups led by Bug Master
- Sprint planning, mid-sprint review, sprint review
- Sprint retrospectives held once every three sprints
- Education time: First Monday morning and last Friday evening

### Roles and Escalation Chain

**Bug Master (Current Agent Role):**
- Primary communication owner for stakeholders
- Coordinates bug fixes and urgent issues (Pae Awhina, daily fails)
- Reviews and triages all incoming issues
- Creates/ensures Pae Awhina tickets exist
- Assigns issues to appropriate leads
- Participates in sprint handover meetings
- Drafts Epics for new capability requests (for RPG prioritisation)

**Scrum Master:**
- Secondary communication owner (escalation from Bug Master)
- Facilitates Scrum meetings and cross-team coordination
- Manages sprint commitments and adjustments
- Owns backlog prioritisation for low-priority items

**BI Manager:**
- Tertiary communication owner (escalation from Scrum Master)
- Final escalation point, approves external communications
- Provides strategic direction for major incidents

**Lead Data Analyst:**
- Primary owner for BI space issues (Power BI reports and semantic models)
- Investigates Power BI service issues
- Provides technical updates to Bug Master

**Lead Data Engineer:**
- Primary owner for data pipeline, EDW, and ODS issues
- Investigates Azure Data Factory and Synapse issues
- Manages data quality and refresh processes

---

## 4. Azure DevOps Structure

### Work Item Hierarchy

The BI team uses a six-level hierarchy:

```
Theme (Strategic portfolio objective)
└── Initiative (Major program)
    └── Epic (Large body of work - e.g., new dashboard, data integration)
        └── Feature (Significant functionality - e.g., Requirements, Development, Reporting)
            └── User Story (Granular work from user perspective)
                └── Task (Specific unit of work for time tracking)
```

### Key Initiatives for Reference

- **#12229**: Self-Service Analytics Enablement (parent for self-service semantic model Epics)
- **Enterprise Data Warehouse Enhancement** (parent for new data source integrations)

### Linking Rules

- Every Initiative → linked to parent Theme
- Every Epic → linked to parent Initiative
- Every Feature → linked to parent Epic
- Every User Story → linked to parent Feature
- Every Task → linked to parent User Story
- Use "Related" link type for cross-Epic dependencies

### Branch Naming Convention

- Format: `[folder]/[work-item-number]-[description]`
- Example: `feature/11331-Property-Self-Service-Dataset`
- Example: `bugfix/12456-GL-account-datatype-fix`

---

## 5. Investigation Procedures

### For BI Space Issues (Lead Data Analyst)

1. Check Power BI Service refresh status
2. Verify semantic model processing logs
3. Review DAX/M code for errors
4. Test Row-Level Security functionality
5. Validate data connections and parameters
6. Check Te Pātaka app permissions and RLS settings

### For Data Level Issues (Lead Data Engineer)

1. Review Azure Data Factory pipeline run history
2. Check Synapse query logs and execution plans
3. Validate source data integrity in landing tables
4. Verify ETL transformation logic and row counts
5. Check Azure service health dashboards
6. Verify data consistency between ODS and EDW
7. Check for any blocked or long-running queries

### KPI and Monitoring Checks

Query row count monitoring tables in the manager database (`sqldb-prod-manager`):
- `load_check.check_detail`
- `load_check.row_count`
- `meta_data.source_system`

Validation steps:
1. Compare source vs. snapshot vs. final view row counts
2. Check daily change percentages and acceptable difference thresholds
3. Validate KPI pipeline processing and data lineage

---

## 6. Enhancement Request Management

### Creating Epics for New Requests

When a Pae Awhina ticket or stakeholder request represents new capability (not a bug), create an Epic:

**Epic Work Item:**
- **Work Item Type**: Epic
- **Area Path**: Data and Analytics\Business Intelligence
- **Title**: Clear, concise description of the capability
- **Description**: Include:
  - Background and business justification
  - Proposed solution
  - Business value
  - Requestor and business sponsor
  - Intended users
- **Acceptance Criteria**: High-level success criteria
- **Parent Link**: Link to appropriate Initiative
- **Attachments**: Pae Awhina ticket, requirements documents

### Standard Features for New Data Source Integrations

When creating Epics for new external data sources (e.g., API integrations), include these standard Features:

1. **Requirements Gathering**
   - Conduct analysis with requestor
   - Identify data sources and API specifications
   - Document detailed requirements

2. **Development**
   - Create Azure Blob Storage container
   - Add credentials to Azure Key Vault
   - Create solution to export data from source
   - Implement Azure Data Factory pipeline

3. **EDW Integration**
   - Create ODS views over landed data
   - Model data for EDW integration
   - Unit testing

4. **Reporting Integration** (if applicable)
   - Create/update Power BI semantic model
   - Create report pages and visuals
   - Implement row-level security

5. **Deployment**
   - Deployment to Test environment
   - Deployment to Production environment

### RPG Prioritisation

Enhancement requests are prioritised through the Report Prioritisation Group (RPG):
- Bug Master drafts Epic and advises requestor
- Epic flagged for RPG review
- Priority assigned based on business value
- Start and target dates set after prioritisation

---

## 7. Communication Templates

### Initial Issue Notification

```
Subject: [Report/System Name] – [Issue Status]

[Report/System Name] – [Brief Issue Description]

Description
We have been alerted [when discovered] that [clear description of the issue
and root cause if known]. As a result, [specific impact on users/reports/data].

We are actively working on a solution and expect this issue to be resolved
by [realistic timeframe]. We will provide an update as soon as we know more.

Thank you for your patience, and we apologise for any inconvenience this may cause.

When did it start?
[Specific date and time]

Who is impacted?
[Specific user groups, reports, or systems that were affected]
```

### Resolution Notification

```
Subject: [Report/System Name] – Data Accurate Again

[Report/System Name] – Data Up To Date

Description
We have resolved the issue impacting [specific reports/systems affected],
and [reports/systems] are now showing the expected data.

When did it occur?
[Start time], [Date] - [End time], [Date]

Who was impacted?
[Specific user groups, reports, or systems that were affected]
```

### Update Notification

```
Subject: UPDATE: [Report/System Name] – [Current Status]

[Report/System Name] – Status Update

Description
This is an update regarding the [issue description] reported earlier.

Current Status:
[Clear description of current state and progress made]

Next Steps:
[What is being done next]

Expected Resolution:
[Updated timeframe if changed]

Who is impacted?
[Any changes to impact scope]

We appreciate your continued patience as we work to resolve this issue.
```

### Enhancement Request Acknowledgement

```
Subject: RE: [Request Title] – Received for Prioritisation

Kia ora [Requestor Name],

Thank you for your request regarding [brief description]. I have created
an Epic in Azure DevOps to track this work and linked it to your
Pae Awhina ticket (#[number]).

This request will be reviewed by the Report Prioritisation Group (RPG)
for scheduling. We will advise you once a timeline has been confirmed.

If you have any questions in the meantime, please don't hesitate to reach out.

Ngā mihi,
[Bug Master Name]
Bug Master, BI Team
```

---

## 8. Quality Assurance and Testing

### Data Fixes Testing

- Verify data accuracy in both EDW and ODS
- Check data consistency across systems using row count queries
- Validate transformation logic and business rule application
- Confirm complete pipeline execution without errors
- Verify downstream impact on dependent reports

### Report Fixes Testing

- Test with sample data across different user roles
- Verify DAX calculations and measure accuracy
- Check parameter functionality and filter behavior
- Validate Row-Level Security across different user groups
- Test performance under expected load conditions
- Verify mobile view functionality in Te Pātaka

### Change Management

**CAB (Change Advisory Board) Process:**
- Required for major changes and new releases
- Submit detailed request including risk assessment
- Include results from testing and soft releases
- Provide rollback plan for critical changes

**Version Control:**
- All changes tracked through Git using PBIP format
- Branch naming convention: `[folder]/[work-item-number]-[description]`
- Pull request reviews required before merging to main
- Documentation of changes in Azure DevOps work items

---

## 9. Monitoring and Metrics

### Key Metrics to Track

- **Resolution Time**: By severity level and issue type
- **First Response Time**: Communication acknowledgment speed
- **Escalation Frequency**: How often issues require escalation
- **Recurring Issues**: Patterns requiring preventive action
- **User Satisfaction**: Feedback from stakeholders
- **Communication Effectiveness**: Timeliness and clarity

### Regular Monitoring Tasks

- Daily check of pipeline execution status
- Review of row count monitoring reports
- Monitor Power BI refresh failures
- Check Azure service health dashboards
- Review Pae Awhina ticket queue
- Validate KPI processing and data quality

---

## 10. Emergency Procedures

### Critical Issue Response (Level 1)

**Immediate Actions (within 5 minutes):**
- Post alert in BI Teams Chat
- Create Pae Awhina ticket if not exists
- Escalate directly to BI Manager
- Begin initial stakeholder notification

**Within 15 minutes:**
- Send initial communication to affected stakeholders
- Coordinate technical response with appropriate lead
- Establish regular update cadence (hourly for Level 1)

**Ongoing:**
- Provide hourly status updates
- Coordinate with external teams as needed
- Document all actions and decisions
- Conduct post-incident review within 48 hours

### System Outage Response

- **Te Pātaka Unavailable**: Immediate escalation, external communication required
- **Data Pipeline Failure**: Assess downstream impact, coordinate refresh timing
- **Database Connectivity**: Engage Azure support if infrastructure issue
- **Security Incident**: Immediate escalation to BI Manager and security team

---

## Notes and Known Inconsistencies

> **Bug vs User Story:** The Bug-Prioritisation-Process wiki document flowchart shows "Create User Story" for bug tracking, while the Bug Master process specifies "Create Bug work item". **Recommendation:** Use Bug work item type for defects/issues, and User Story work item type for new functionality requests within a Feature. Clarify with Scrum Master if uncertain.

---

*This reference material should be reviewed and updated quarterly or as processes change.*
