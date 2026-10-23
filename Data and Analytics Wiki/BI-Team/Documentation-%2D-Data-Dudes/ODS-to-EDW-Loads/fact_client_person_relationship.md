# fact_client_person_relationship

[[_TOC_]]

Relationships between clients and assigned personnel (caseworkers, key workers, support workers) sourced from Recordbase and IntelliHR.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `588` |
| Target table | `edw.fact_client_person_relationship` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` |
| Source systems | Recordbase (rbeal, rbmnb), IntelliHR |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb) / IntelliHR
  ├─ dlFactPersonRelationship
  ├─ dlDimRelationshipType
  ├─ dlFactReferral
  ├─ dlDimUser
  ├─ dlDimTeam
  └─ people (IntelliHR)
       └─ ODS view: ETL.fact_client_person_relationship
            └─ landing.edw_fact_client_person_relationship             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_client_person_relationship      (staging.insert_staging_fact_client_person_relationship)
                      └─ edw.fact_client_person_relationship           (edw.Updateedwfact_client_person_relationship)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_client_person_relationship_key` | `int` | Surrogate primary key (identity 100000, 1) | — |
| `fact_client_person_relationship_id` | `int` | Business key | Recordbase |
| `dim_client_key` | `int` | Dimension foreign key | `edw.dim_client.dim_client_key` |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_client_referral_key` | `int` | Dimension foreign key | `edw.dim_client_referral.dim_client_referral_key` |
| `dim_client_team_key` | `int` | Dimension foreign key | `edw.dim_client_team.dim_client_team_key` |
| `dim_service_key` | `int` | Dimension foreign key | `edw.dim_service.dim_service_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `client_id` | `int` | Business key | `edw.dim_client.client_id` |
| `client_referral_id` | `int` | Business key | `edw.dim_client_referral.client_referral_id` |
| `client_team_id` | `int` | Business key | `edw.dim_client_team.client_team_id` |
| `client_responsible_user_id` | `int` | Business key | Recordbase user / employee |

::: mermaid
erDiagram
    dim_client          ||--o{ fact_client_person_relationship : "client_id / dim_client_key"
    dim_employee        ||--o{ fact_client_person_relationship : "dim_employee_key"
    dim_client_referral ||--o{ fact_client_person_relationship : "client_referral_id / dim_client_referral_key"
    dim_client_team     ||--o{ fact_client_person_relationship : "client_team_id / dim_client_team_key"
    dim_service         ||--o{ fact_client_person_relationship : "dim_service_key"
    dim_company         ||--o{ fact_client_person_relationship : "dim_company_key"
:::

## Direct business key join pattern

```sql
FROM edw.fact_client_person_relationship AS fact
INNER JOIN edw.dim_client AS c
    ON fact.client_id = c.client_id
    AND c.DWHIsCurrent = 1
INNER JOIN edw.dim_employee AS e
    ON fact.client_responsible_user_id = e.employee_id
    AND e.DWHIsCurrent = 1
```

## Attributes

- `client_relationship_is_primary_caseworker`: Primary caseworker flag (`int`).
- `client_relationship_type`, `client_relationship_type_id`: Relationship type description and ID.
- Start, end, and created dates (`int` integer date keys / `date`).

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_client_person_relationship` |
| Landing | `landing.edw_fact_client_person_relationship` |
| Staging | `staging.ODSETLfact_client_person_relationship` |
| Stored procedures | `staging.insert_staging_fact_client_person_relationship`, `edw.Updateedwfact_client_person_relationship` |
| Target | `edw.fact_client_person_relationship` |

## Notes

- See also [dim_client_person_relationship](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_client_person_relationship) (DataLoadId 628) which has the same target table schema and is configured in phase `200 Facts`.
