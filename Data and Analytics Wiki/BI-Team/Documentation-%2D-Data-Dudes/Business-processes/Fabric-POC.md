# Microsoft Fabric POC Summary — Emerge Aotearoa

  

**Date:** May 2026  

**Team:** Stefen Hasselberg, Mike Gencic, Greg Nuthall, Malhar Badheka  

**Workspace:** EAL-POC-DataEngineer  

  

---

  

## 1. Objective

  

The purpose of this Proof of Concept was to evaluate Microsoft Fabric as a potential future platform for Emerge Aotearoa's data and analytics workloads, currently hosted on Azure Synapse Analytics, Azure Data Factory, and a SQL Server–based Enterprise Data Warehouse (EDW). The POC assessed Fabric's capabilities across data ingestion, transformation, warehousing, security, governance, data science, and reporting — with a focus on determining migration feasibility, identifying gaps, and understanding what a future-state architecture could look like.

  

---

  

## 2. Architecture Implemented

  

The POC workspace implemented a **Medallion Architecture** (Bronze → Silver → Gold) consistent with Fabric best practices:

  

| Layer | Fabric Item | Owner | Purpose |

|-------|-------------|-------|---------|

| **Bronze** | Lakehouse | Stefen Hasselberg | Raw data landing zone — CSV files, API responses (IntelliHR), and shortcut-linked storage |

| **Silver** | Lakehouse | Stefen Hasselberg | Cleansed and conformed data — Delta tables with incremental update logic |

| **Gold** | Warehouse | Stefen Hasselberg | Dimensional model (star schema) — final presentation layer for reporting and analytics |

| **Framework** | SQL Database (eal-framework) | Stefen Hasselberg | ETL framework and metadata management |

  

The **Gold Warehouse** contained two schemas mirroring the EDW structure:

  

- **dbo**: `dim_employee`, `fact_employee_hours_worked`, staging tables (`stg_dim_employee`, `stg_fact_employee_hours_worked`), and stored procedures (`usp_load_fact_employee_hours_worked`, `usp_merge_dim_employee`)

- **edw**: `dim_business_unit_hierarchy`, `dim_employee`, `dim_leave_type`, `dim_payroll_category`, `dim_service`

  

---

  

## 3. Key Workstreams & Findings

  

### 3.1 Data Ingestion & Pipelines

  

- **IntelliHR API ingestion** was tested using Spark notebooks (Malhar Badheka) — JSON responses were converted to Parquet/Delta format and loaded through Bronze into Silver (`InteliHR.jobs Json to parquet`, `intellihr_businessunit_delta`, `load Intelihr people`).

- **ADF pipeline migration** was assessed. Fabric Data Factory supports many existing ADF patterns and a direct lift-and-shift path exists for current pipelines. A Fabric Migration Assessment tool is already available within ADF.

- **Timesheet data** (EmpLive audit trail CSVs) was used as an end-to-end test case — ingested via email → Logic App → Storage Account → Fabric shortcut → Bronze → Silver → Gold, with plans for Fabric Activator alerts to managers for outstanding timesheet approvals.

- Pipeline folders (`Ingestion`, `Loading`, `Pipelines`, `Transformation`, `masterpipeline_malhar`) and two pipelines (`SQL`, `Test_template_in_fabric`) were created to test orchestration patterns.

  

### 3.2 T-SQL & Stored Procedure Compatibility

  

- **Critical finding:** The `MERGE` statement is not supported in Fabric Warehouse. This means existing EDW stored procedures cannot be migrated directly and would require rewriting as `INSERT`/`UPDATE`/`DELETE` patterns or notebook-based alternatives.

- Stored procedures were successfully created and executed in the Gold warehouse (`usp_merge_dim_employee`, `usp_load_fact_employee_hours_worked`), confirming that T-SQL development remains viable despite some syntax limitations.

  

### 3.3 Security

  

- **Row-Level Security (RLS)** was successfully implemented and tested on `dim_employee` using a security function (`Security.tvf_dim_employee_filter`) and security policy, controlling visibility by user email with admin bypass and sentinel row handling.

- **Dynamic Data Masking** is available in Fabric Lakehouse and Warehouse, with Purview integration.

- **Audit Logs** can monitor unauthorised access and can be queried via agents or notebooks.

- **Private Endpoints** were noted to impact performance — enabling them disables the standard starter pool, requiring a different execution pool with slower start-up times.

  

### 3.4 Governance & Lineage

  

- **Microsoft Purview** is the recommended tool for lineage tracking, though it cannot natively drill into Silver/Bronze layers. A workaround exists: a notebook-driven approach using table metadata to push manual lineage items into Purview.

- **Ontology** in Fabric provides a business entity model visible down to the Gold layer (via semantic models) but is not a full lineage model.

- **PII/Sensitive Data** can be labelled as confidential in Purview and automatically flow through to Fabric artefacts.

  

### 3.5 Semantic Models & Reporting

  

- Two semantic models were created (`test_malhar`, `test_malhar_1`) demonstrating direct linkage to warehouse data without requiring scheduled refreshes.

- Best practice recommendation: use **separate workspaces** for semantic models and enterprise reports.

- Power BI usage analysis was explored via the `analyze_pbi_usage` notebook.

  

### 3.6 Data Science & Machine Learning

  

- **ML experiments** were conducted (Greg Nuthall) using diabetes datasets as a learning exercise:

  - Classification model (`DB_class`) and Regression model (`DB_Reg`)

  - Tracked via Fabric Experiments (`diabetes-classification`, `diabetes-regression`)

- **Real-time analytics** were explored with an Eventhouse (`Gold_EventhouseEndpoint`) and KQL Database for streaming/event-based scenarios.

  

### 3.7 Data Agents

  

- Fabric **Data Agents** provide AI-powered natural language querying of warehouse data.

- Recommended to deploy agents in a separate workspace, primarily for data discovery.

- Agents support custom instructions, API access, and Power Automate integration.

- Copilot functionality can be restricted to specific geographical locations.

  

### 3.8 CI/CD

  

- Fabric has deployment integration with Azure DevOps covering most artefacts **except Bronze and Silver layer data structures** — this is a significant gap.

- Fabric's built-in deployment pipelines do not have feature parity with Azure DevOps pipelines.

- A solution for Bronze/Silver CI/CD is reportedly in development by Microsoft, but no ETA was provided.

  

### 3.9 Disaster Recovery

  

- Workspace backups can be stored in alternate Azure regions for disaster recovery purposes.

  

---

  

## 4. Summary of Achievements

  

| Area | Status | Notes |

|------|--------|-------|

| Medallion Architecture (Bronze/Silver/Gold) | **Completed** | Lakehouse + Warehouse deployed and populated |

| IntelliHR API Ingestion | **Completed** | JSON → Parquet → Delta via notebooks |

| Timesheet Data Pipeline (end-to-end) | **Completed** | CSV → Bronze → Silver → Gold with change tracking |

| Dimensional Model in Gold Warehouse | **Completed** | 7 dimension/fact tables, 2 stored procedures |

| Row-Level Security | **Completed** | Tested and validated on `dim_employee` |

| Semantic Model & Direct Query | **Completed** | Two models created, no-refresh linking confirmed |

| ML Experiments | **Completed** | Classification and regression models trained |

| Real-time Analytics (Eventhouse) | **Explored** | KQL Database provisioned |

| Data Agents | **Assessed** | Capability confirmed, deployment approach defined |

| CI/CD Integration | **Assessed** | Gap identified for Bronze/Silver layer |

| ADF Migration Path | **Assessed** | Lift-and-shift feasible for most pipelines |

  

---

  

## 5. Risks & Considerations

  

1. **MERGE statement gap** — Requires rewriting all existing EDW merge-based stored procedures.

2. **CI/CD immaturity** — No current solution for Bronze/Silver layer source control; Microsoft solution pending.

3. **Private endpoint performance** — Security trade-off with pool start-up latency.

4. **Notebook expertise** — Team is primarily T-SQL focused; notebook-based ETL would require upskilling (mitigated by AI/Copilot tooling).

5. **Purview lineage depth** — Cannot natively trace below Gold layer without custom notebook solution.

  

---

  

## 6. Recommendation

  

The POC successfully demonstrated that Microsoft Fabric can support Emerge Aotearoa's core data platform needs — from ingestion through to dimensional modelling, security, and reporting. The Medallion Architecture aligns well with the existing Bronze/Silver/Gold (Landing/Staging/EDW) patterns. Key risks around T-SQL compatibility and CI/CD maturity should be monitored as Microsoft continues to evolve the platform. A phased migration approach — starting with new workloads (e.g., the timesheet alerting pipeline) while maintaining the existing EDW — is the recommended path forward.