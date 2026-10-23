# Employee Fact Load Overview

[[_TOC_]]

The employee fact tables integrate transactional and analytical data across HR, payroll, time & attendance, health & safety, training, and operational duties.

This page covers all **15 employee fact loads**.

## Execution order

`10_Load_Master` runs load phases sequentially in `DataLoadPhaseNo` order. Within a phase, `20_Load_Phase` runs loads **in parallel**, up to 5 concurrently.

| Phase | Employee fact loads |
| --- | --- |
| `200 Facts` | `fact_employee_cost_allocation`, `fact_employee_hours_worked`, `fact_employee_incident`, `fact_employee_leave`, `fact_employee_leave_request`, `fact_employee_pay_run_item`, `fact_employee_pay_slip`, `fact_employee_pay_slip_item`, `fact_employee_qualification` |
| `201 Facts` | `fact_employee_certification_progress`, `fact_employee_course_progress`, `fact_employee_kpi_commentary`, `fact_employee_on_call_log`, `fact_employee_program_progress`, `fact_employee_remuneration` |

## Load inventory

| DataLoadId | Target table | Source system(s) | Load type | Phase | Primary dimensions |
| --- | --- | --- | --- | --- | --- |
| 561 | [fact_employee_remuneration](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_employee_remuneration) | IntelliHR, ETL | `ODSFLLMRGIRV` | 201 | Employee, Company, Location, Service, Ethnicity, Payroll Category, Hierarchy |
| 566 | [fact_employee_leave](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_employee_leave) | Datapay, IntelliHR | `ODSFLLMRGIRV` | 200 | Employee, Company, Business Unit, Leave Type, Ethnicity, Payroll Category |
| 574 | [fact_employee_hours_worked](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_employee_hours_worked) | Emplive | `ODSFLLMRGIRV` | 200 | Employee, Company, Ethnicity, Payroll Category, Leave Type, Date, Time |
| 625 | [fact_employee_program_progress](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_employee_program_progress) | Akoranga (Totara) | `ODSFLLMRGIRV` | 201 | Employee, Program, Service, Business Unit |
| 645 | [fact_employee_course_progress](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_employee_course_progress) | Akoranga (Totara) | `ODSFLLMRGIRV` | 201 | Employee, Course, Service, Business Unit |
| 646 | [fact_employee_certification_progress](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_employee_certification_progress) | Akoranga (Totara) | `ODSFLLMRGIRV` | 201 | Employee, Certification, Service, Business Unit |
| 710 | [fact_employee_kpi_commentary](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_employee_kpi_commentary) | SharePoint (KPI) | `ODSFLLINS` | 201 | KPI, Company, Employee, Service |
| 723 | [fact_employee_qualification](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_employee_qualification) | IntelliHR | `ODSFLLMRGIRV` | 200 | Employee, Qualification Library, Qualification Type, Service, Company |
| 752 | [fact_employee_incident](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_employee_incident) | EcoPortal | `ODSFLLMRG` | 200 | Employee Incident, Client Incident, Date |
| 758 | [fact_employee_pay_slip](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_employee_pay_slip) | Datapay | `ODSFLLMRG` | 200 | Employee Pay Slip, Employee, Company, Date |
| 759 | [fact_employee_pay_slip_item](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_employee_pay_slip_item) | Datapay | `ODSFLLMRG` | 200 | Employee Pay Slip, Employee, Company |
| 760 | [fact_employee_pay_run_item](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_employee_pay_run_item) | Datapay | `ODSFLLINS` | 200 | Employee Pay Run, Employee Pay Component, Employee, Company, Date |
| 763 | [fact_employee_leave_request](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_employee_leave_request) | Emplive API | `ODSFLLMRG` | 200 | Employee, Leave Request Type, Date |
| 764 | [fact_employee_cost_allocation](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_employee_cost_allocation) | Datapay, IntelliHR | `ODSFLLMRG` | 200 | Employee, Company, Service, Business Unit |
| 814 | [fact_employee_on_call_log](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_employee_on_call_log) | On Call | `ODSFLLMRG` | 201 | Employee, Region, Service, Employee (Escalated To), Employee (On Call) |

## Direct business key join pattern

To join an employee fact to an SCD Type 2 dimension (such as `dim_employee`, `dim_course`, `dim_program`, `dim_certification`, or `dim_employee_pay_slip`) using business `_id` fields, match the ID directly and filter `DWHIsCurrent = 1`:

```sql
FROM edw.fact_employee_hours_worked AS fact
INNER JOIN edw.dim_employee AS e
    ON fact.employee_id = e.employee_id
    AND e.DWHIsCurrent = 1
```

```sql
FROM edw.fact_employee_course_progress AS fact
INNER JOIN edw.dim_course AS c
    ON fact.employee_course_id = c.course_id
    AND c.DWHIsCurrent = 1
```

## Load types used in this group

| Code | Description | Behaviour |
| --- | --- | --- |
| `ODSFLLMRGIRV` | ODS: Full row-versioned merged | Full extract from ODS; MERGE updates target with SCD Type 2 row versioning |
| `ODSFLLMRG` | ODS: Full non-versioned merged | Full extract from ODS; MERGE updates target in-place (Type 1) |
| `ODSFLLINS` | ODS: Truncated reload | Truncates target or batch range, then inserts fresh rows |

## Verification basis

Checked against EDW table DDL, stored procedures, and Framework metadata.
