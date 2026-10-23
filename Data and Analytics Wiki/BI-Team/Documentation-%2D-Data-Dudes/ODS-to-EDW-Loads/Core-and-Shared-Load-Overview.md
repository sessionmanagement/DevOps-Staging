# Core and Shared Load Overview

[[_TOC_]]

This section documents the foundational conformed dimensions and shared operational tables that span across all business domains at Emerge Aotearoa (Services, Locations, Companies, Calendar Date, Gender, Leave Types, Training Courses, and Fleet Vehicles & Trips).

## Load inventory

| DataLoadId | Target table | Source system(s) | Load type | Phase | Primary role |
| --- | --- | --- | --- | --- | --- |
| 480 | [dim_service](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_service) | Business Central, IntelliHR, Datapay, Reference | `ODSFLLMRGIRV` | 102 Dimensions | Core service / cost center / organizational hierarchy |
| 774 | [dim_location_new](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_location_new) | Business Central, IntelliHR | `ODSFLLMRGIRV` | 101 Dimensions | Physical workplace & accounting locations (supersedes legacy `dim_location`) |
| 462 | [dim_company](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_company) | Business Central, Datapay, IntelliHR, Recordbase | `ODSFLLMRGIRV` | 101 Dimensions | Legal entity mapping across systems |
| — | [dim_date](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_date) | Calendar generator & NZ Public Holiday tables | Framework / Static | Reference | Enterprise calendar, financial periods, Te Reo Māori, NZ holidays |
| 526 | [dim_gender](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_gender) | Datapay, Emplive, IntelliHR, Recordbase, Zavanti | `ODSFLLMRG` | 101 Dimensions | Standardized gender lookup across all systems |
| 541 | [dim_leave_type](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_leave_type) | Datapay, Emplive, Reference | `ODSFLLMRG` | 101 Dimensions | Payroll leave type mapping |
| 619 | [dim_course](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_course) | Akoranga (Totara / MySQL) | `ODSFLLMRGIRV` | 101 Dimensions | LMS training course catalog |
| 786 | [dim_vehicle](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_vehicle) | Tapu Waka (REST API) | `ODSFLLMRGIRV` | 101 Dimensions | Fleet vehicle assets & NZTA compliance (WoF/CoF/RUC) |
| 787 | [fact_vehicle_trip](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_vehicle_trip) | Tapu Waka (REST API) | `ODSFLLMRG` | 200 Facts | GPS telematics trip logs, distance, speeding compliance |

## Conformed relationships

These shared dimensions sit at the hub of the EDW star schema:

::: mermaid
erDiagram
    dim_service      ||--o{ fact_finance_general_ledger : "service_id"
    dim_service      ||--o{ fact_client_referral : "dim_service_key"
    dim_service      ||--o{ fact_employee_cost_allocation : "dim_service_key"
    dim_location_new ||--o{ fact_finance_general_ledger : "location_id"
    dim_company      ||--o{ fact_finance_general_ledger : "dim_company_key"
    dim_company      ||--o{ dim_employee : "company_id"
    dim_date         ||--o{ fact_finance_general_ledger : "posting_date_key"
    dim_date         ||--o{ fact_employee_hours_worked : "shift_date_key"
    dim_vehicle      ||--o{ fact_vehicle_trip : "vehicle_id"
:::

## Direct business key join patterns

To join facts or staging queries to SCD Type 2 dimensions in this group using business `_id` fields, match directly and filter `DWHIsCurrent = 1`:

```sql
-- Joining to dim_service
FROM edw.fact_finance_general_ledger AS gl
INNER JOIN edw.dim_service AS s
    ON gl.service_id = s.service_id
    AND s.DWHIsCurrent = 1
```

```sql
-- Joining to dim_location_new
FROM edw.fact_finance_general_ledger AS gl
INNER JOIN edw.dim_location_new AS loc
    ON CAST(gl.location_id AS NVARCHAR(MAX)) = loc.business_central_location_id
    AND loc.DWHIsCurrent = 1
```

```sql
-- Joining to dim_vehicle
FROM edw.fact_vehicle_trip AS trip
INNER JOIN edw.dim_vehicle AS v
    ON trip.vehicle_id = v.vehicle_id
    AND v.DWHIsCurrent = 1
```

## Key architectural observations

1. **`dim_service` phase ordering (102 Dimensions)**: Because `dim_service` integrates company and service hierarchies, it loads in phase `102`, after `dim_company` (phase `101`) is current.
2. **`dim_location_new` vs `dim_location`**: `dim_location_new` (DataLoadId 774) supersedes the legacy `dim_location` (DataLoadId 477), unifying IntelliHR physical site locations with Business Central accounting locations.
3. **Multi-system cross-references**: `dim_company` and `dim_gender` provide explicit cross-reference keys across Business Central, Datapay, IntelliHR, Recordbase, and Zavanti to ensure consistent entity resolution across all source boundaries.
