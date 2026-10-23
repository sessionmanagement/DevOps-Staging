# fact_client_assessment_outcome

[[_TOC_]]

Client outcome assessment responses (Outcome Tool templates Q1 through Q25), scores, and completion dates, sourced from Recordbase (`rbeal` and `rbmnb`).

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `660` |
| Target table | `edw.fact_client_assessment_outcome` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  ├─ otFactOutcomeToolResponse
  ├─ otFactOutcomeToolResponseAnswer
  ├─ otDimOutcomeToolTemplate
  ├─ dlFactReferral
  ├─ dlDimUser
  └─ dlDimTeam
       └─ ODS view: ETL.fact_client_assessment_outcome
            └─ landing.edw_fact_client_assessment_outcome             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_client_assessment_outcome      (staging.insert_staging_fact_client_assessment_outcome)
                      └─ edw.fact_client_assessment_outcome           (edw.Updateedwfact_client_assessment_outcome)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_client_assessment_outcome_key` | `int` | Surrogate primary key | — |
| `fact_client_assessment_outcome_unique_key` | `nvarchar(100)` | Compound natural key | — |
| `assessment_id` | `int` | Business key | Recordbase |
| `client_id` | `int` | Business key | `edw.dim_client.client_id` |
| `client_referral_id` | `int` | Business key | `edw.dim_client_referral.client_referral_id` |
| `client_team_id` | `int` | Business key | `edw.dim_client_team.client_team_id` |
| `dim_client_key` | `int` | Dimension foreign key | `edw.dim_client.dim_client_key` |
| `dim_client_referral_key` | `int` | Dimension foreign key | `edw.dim_client_referral.dim_client_referral_key` |
| `dim_client_team_key` | `int` | Dimension foreign key | `edw.dim_client_team.dim_client_team_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `assessment_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `assessment_created_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |

::: mermaid
erDiagram
    dim_client          ||--o{ fact_client_assessment_outcome : "client_id / dim_client_key"
    dim_client_referral ||--o{ fact_client_assessment_outcome : "client_referral_id / dim_client_referral_key"
    dim_client_team     ||--o{ fact_client_assessment_outcome : "client_team_id / dim_client_team_key"
    dim_company         ||--o{ fact_client_assessment_outcome : "dim_company_key"
    dim_date            ||--o{ fact_client_assessment_outcome : "assessment / created date keys"
:::

## Direct business key join pattern

```sql
FROM edw.fact_client_assessment_outcome AS fact
INNER JOIN edw.dim_client AS c
    ON fact.client_id = c.client_id
    AND c.DWHIsCurrent = 1
INNER JOIN edw.dim_client_referral AS r
    ON fact.client_referral_id = r.client_referral_id
    AND r.DWHIsCurrent = 1
```

## Response measures & Question columns

- Question response columns: `outcome_tool_question_q1` through `outcome_tool_question_q25` (`nvarchar(100)`).
- Assessment score totals / completion indicators.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_client_assessment_outcome` |
| Landing | `landing.edw_fact_client_assessment_outcome` |
| Staging | `staging.ODSETLfact_client_assessment_outcome` |
| Stored procedures | `staging.insert_staging_fact_client_assessment_outcome`, `edw.Updateedwfact_client_assessment_outcome` |
| Target | `edw.fact_client_assessment_outcome` |
