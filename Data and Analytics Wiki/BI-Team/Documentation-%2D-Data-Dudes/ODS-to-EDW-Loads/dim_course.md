# dim_course

[[_TOC_]]

Training and development course catalog sourced from the **Akoranga** learning management system (Totara / MySQL).

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `619` |
| Target table | `edw.dim_course` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | Akoranga (Totara / MySQL) |

## Data lineage

```text
Akoranga (Totara LMS / MySQL)
  ├─ mdl_course
  ├─ mdl_course_categories
  └─ mdl_course_info_data
       └─ ODS view: ETL.dim_course
            └─ landing.edw_dim_course             (TRUNCATE + full Copy)
                 └─ staging.ODSETLdim_course      (staging.insert_staging_dim_course)
                      └─ edw.dim_course           (edw.Updateedwdim_course)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_course_key` | `int` | Surrogate primary key (identity 1, 1) | — |
| `course_id` | `int` | Business key (Totara course ID) | Akoranga |
| `course_full_name` | `nvarchar(400)` | Full course title | — |
| `course_short_name` | `nvarchar(400)` | Short course code / title | — |
| `course_id_number` | `nvarchar(100)` | Course reference identifier | — |
| `course_category_id` | `int` | Category identifier | Category hierarchy |
| `course_category_name` | `nvarchar(200)` | Course category name | — |
| `course_category_path` | `nvarchar(1000)` | Full category hierarchy path | — |
| `course_linked_to_certification` | `nvarchar(500)` | Certification linkage text | `edw.dim_certification` |
| `is_enable_completion` | `int` | Completion tracking enabled flag | — |
| `is_course_visible` | `int` | Visibility flag | — |

::: mermaid
erDiagram
    dim_course ||--o{ fact_employee_course_progress : "employee_course_id / dim_course_key"
:::

## Direct business key join pattern

To join using `course_id`, match directly and filter `DWHIsCurrent = 1`:

```sql
FROM edw.fact_employee_course_progress AS fact
INNER JOIN edw.dim_course AS c
    ON fact.employee_course_id = c.course_id
    AND c.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_course` |
| Landing | `landing.edw_dim_course` |
| Staging | `staging.ODSETLdim_course` |
| Stored procedures | `staging.insert_staging_dim_course`, `edw.Updateedwdim_course` |
| Target | `edw.dim_course` |
