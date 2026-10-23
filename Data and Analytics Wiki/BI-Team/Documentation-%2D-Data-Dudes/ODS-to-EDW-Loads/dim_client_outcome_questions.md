# dim_client_outcome_questions

[[_TOC_]]

> **Repository gap.** This load is configured in the Framework database and its target table exists in the live EDW database (confirmed via an `INFORMATION_SCHEMA` column extract), but **no corresponding object exists anywhere in the EDW repository** — no `edw/Tables/dim_client_outcome_questions.sql`, no `landing`/`staging` table definitions, and no `staging.insert_staging_dim_client_outcome_questions` or `edw.Updateedwdim_client_outcome_questions` stored procedure. Everything on this page beyond the load identity and key fields is inferred from naming convention, not verified against source.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `804` |
| Target table | `edw.dim_client_outcome_questions` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned), assumed from load type |
| Source system | Unconfirmed |

## Key fields (from live database schema only)

| Column | Type | Role |
| --- | --- | --- |
| `dim_client_outcome_questions_key` | `int` | Surrogate primary key (inferred) |
| `company_key` | `int` | Business key or surrogate FK — ambiguous, same naming issue as `dim_client_interaction_type` |
| `outcome_tool_template_id` | `int` | Business key — likely links to an outcome tool/assessment template |
| `outcome_tool_question_id` | `nvarchar(50)` | Business key — likely identifies an individual question within a template |

No standard `DWH*` audit columns, source-view lineage, or ETL objects could be confirmed for this table.

## Recommended next step

Before relying on this table, confirm with the team whether:

- it was deployed directly to the database outside the normal `Predacpac_deployment_scripts` / `.sqlproj` process, or
- the corresponding files exist in the repo under a different name than expected, or
- the EDW repo clone used for this documentation pass is missing a recent commit.

## Related

- [Client Dimension Load Overview](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Client-Dimension-Load-Overview) — see Known issues for the same naming ambiguity on `company_key`.
