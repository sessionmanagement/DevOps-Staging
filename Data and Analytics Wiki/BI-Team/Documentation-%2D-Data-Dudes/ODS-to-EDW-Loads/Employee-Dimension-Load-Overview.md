# Employee Dimension Load Overview

[[_TOC_]]

The employee subject area integrates data from multiple HR, payroll, health & safety, and operational systems — including **IntelliHR**, **Datapay**, **Emplive** / **Emplive API**, **EcoPortal**, **Recordbase**, and **On Call**.

This page covers all **11 employee dimension loads**.

## Execution order

`10_Load_Master` runs load phases sequentially in `DataLoadPhaseNo` order. Within a phase, `20_Load_Phase` runs loads **in parallel**, up to 5 concurrently.

| Phase | Employee dimension loads |
| --- | --- |
| `101 Dimensions` | `dim_employee`, `dim_employee_incident`, `dim_employee_incident_classification`, `dim_employee_leave_request_type`, `dim_employee_on_call_log`, `dim_employee_pay_component`, `dim_employee_pay_run`, `dim_employee_pay_slip`, `dim_employee_qualification_library`, `dim_employee_qualification_type` |
| `102 Dimensions` | `dim_employee_hierarchy` |

> **Note.** `dim_employee_hierarchy` runs in phase `102` so that `dim_employee` (phase `101`) completes first.

## Load inventory

| DataLoadId | Target table | Source system(s) | Load type | Phase |
| --- | --- | --- | --- | --- |
| 470 | [dim_employee](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_employee) | IntelliHR, Datapay, Emplive, Recordbase, ETL | `ODSFLLMRGIRV` | 101 |
| 478 | [dim_employee_hierarchy](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_employee_hierarchy) | IntelliHR | `ODSFLLMRGIRV` | 102 |
| 721 | [dim_employee_qualification_library](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_employee_qualification_library) | IntelliHR | `ODSFLLMRGIRV` | 101 |
| 722 | [dim_employee_qualification_type](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_employee_qualification_type) | IntelliHR | `ODSFLLMRGIRV` | 101 |
| 749 | [dim_employee_incident](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_employee_incident) | EcoPortal | `ODSFLLMRGIRV` | 101 |
| 750 | [dim_employee_incident_classification](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_employee_incident_classification) | EcoPortal | `ODSFLLMRG` | 101 |
| 755 | [dim_employee_pay_slip](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_employee_pay_slip) | Datapay | `ODSFLLMRGIRV` | 101 |
| 756 | [dim_employee_pay_run](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_employee_pay_run) | Datapay | `ODSFLLMRGIRV` | 101 |
| 757 | [dim_employee_pay_component](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_employee_pay_component) | Datapay | `ODSFLLMRGIRV` | 101 |
| 762 | [dim_employee_leave_request_type](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_employee_leave_request_type) | Emplive API | `ODSFLLMRGIRV` | 101 |
| 813 | [dim_employee_on_call_log](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_employee_on_call_log) | On Call | `ODSFLLMRG` | 101 |

## Conformed relationships to facts

`edw.dim_employee` is the primary conformed dimension for employee reporting. Analytical joins using `employee_id` filter on `DWHIsCurrent = 1`:

```sql
FROM edw.fact_employee_hours_worked AS fact
INNER JOIN edw.dim_employee AS e
    ON fact.employee_id = e.employee_id
    AND e.DWHIsCurrent = 1
```

::: mermaid
erDiagram
    dim_employee ||--o{ fact_employee_hours_worked : "employee_id"
    dim_employee ||--o{ fact_employee_leave : "employee_id"
    dim_employee ||--o{ fact_employee_pay_slip : "employee_id"
    dim_employee ||--o{ fact_employee_qualification : "employee_id"
    dim_employee ||--o{ fact_employee_remuneration : "employee_id"
    dim_employee ||--o{ fact_client_activity_breakdown : "dim_employee_key / user_id"
    dim_employee ||--o{ fact_webexpenses : "user_id / employee_id"
    dim_employee ||--o{ dim_employee_hierarchy : "dim_employee_key"
:::

## Multi-source integration for core dim_employee

`edw.dim_employee` consolidates employee identity from five upstream sources:

- **IntelliHR**: Core HR profile, job, title, address, emergency contact, ethnicity, qualifications.
- **Datapay**: Payroll entity, pay group, rate and package info.
- **Emplive**: Time & attendance roster profile and pay level.
- **Recordbase (EAL & MNB)**: Operational user mapping (`dlDimUser`).
- **ETL mappings**: Standardised ethnicity lookups (`reference_intelliHR_person_ethnicity`).

## Security and Sensitive Data

- **Dynamic Data Masking**: `employee_salary_sacrifice` and `employee_bank_details` are masked using SQL Server Data Masking functions (`default()` and `partial()`).
- **Sensitivity Classifications**: PII fields (Name, Date of Birth, Email, Phone, Address, Ethnicity, Expiry Dates) carry `ADD SENSITIVITY CLASSIFICATION` metadata for GDPR and Confidential compliance.

## Verification basis

Checked against EDW table DDL, stored procedures, and Framework metadata.
