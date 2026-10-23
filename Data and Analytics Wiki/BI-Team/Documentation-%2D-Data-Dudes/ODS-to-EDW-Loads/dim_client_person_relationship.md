# dim_client_person_relationship

[[_TOC_]]

Relationship between a client and an employee (caseworker/support worker) — despite the `dim_` name, this table is configured to run in the **Facts** load phase because it depends on dimensions from every earlier phase, including phase `103`.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `628` |
| Target table | `edw.dim_client_person_relationship` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` _(see [Known issues](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Client-Dimension-Load-Overview#known-issues))_ |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source systems | Recordbase (rbeal, rbmnb), IntelliHR |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb) / IntelliHR
  └─ ODS view: ETL.dim_client_person_relationship
       └─ landing.edw_dim_client_person_relationship             (TRUNCATE + full Copy)
            └─ staging.ODSETLdim_client_person_relationship      (staging.insert_staging_dim_client_person_relationship)
                 └─ edw.dim_client_person_relationship           (edw.Updateedwdim_client_person_relationship)
```

### Source objects behind the ODS view

| Source | Contributing objects |
| --- | --- |
| `intellihr` | `people` |
| `rbeal` | `dlDimRelationshipType`, `dlFactReferralStatus`, `dlDimUser`, `dlFactReferral`, `dlDimReferralStatusType`, `dlFactPersonRelationship`, `dlDimTeam` |
| `rbmnb` | Same object set as `rbeal` |

## Key fields and relationships

This is the most heavily conformed table in the client group — six dimension foreign keys.

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_client_person_relationship_key` | `int` | Surrogate primary key (identity 100000, 1) | — |
| `dim_client_person_relationship_id` | `int` | Business key | Recordbase |
| `dim_client_person_relationship_unique_key` | `nvarchar(100)` | Combined natural key | — |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_client_key` | `int` | Dimension foreign key | `edw.dim_client.dim_client_key` |
| `dim_client_referral_key` | `int` | Dimension foreign key | `edw.dim_client_referral.dim_client_referral_key` |
| `dim_client_team_key` | `int` | Dimension foreign key | `edw.dim_client_team.dim_client_team_key` (phase 103) |
| `dim_service_key` | `int` | Dimension foreign key | `edw.dim_service.dim_service_key` |
| `client_id` | `int` | Business key (lookup) | Recordbase |
| `client_referral_id` | `int` | Business key (lookup) | Recordbase |
| `client_team_id` | `int` | Business key (lookup) | Recordbase |
| `client_responsible_user_id` | `int` | Business key (lookup) | Recordbase employee/user |

::: mermaid
erDiagram
    dim_company         ||--o{ dim_client_person_relationship : "dim_company_key"
    dim_employee         ||--o{ dim_client_person_relationship : "dim_employee_key"
    dim_client           ||--o{ dim_client_person_relationship : "dim_client_key"
    dim_client_referral  ||--o{ dim_client_person_relationship : "dim_client_referral_key"
    dim_client_team      ||--o{ dim_client_person_relationship : "dim_client_team_key"
    dim_service          ||--o{ dim_client_person_relationship : "dim_service_key"
:::

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_client_person_relationship` |
| Landing | `landing.edw_dim_client_person_relationship` |
| Staging | `staging.ODSETLdim_client_person_relationship` |
| Stored procedures | `staging.insert_staging_dim_client_person_relationship`, `edw.Updateedwdim_client_person_relationship` |
| Target | `edw.dim_client_person_relationship` |

## Notes

### Why this "dimension" runs in the Facts phase

Because it references `dim_client_team_key`, which only becomes current after phase `103`, this table cannot safely load in phase `101` or `102`. Rather than introduce a phase `104`, the Framework configuration defers it to phase `200 Facts` — after every dimension, including `103`, has loaded. It behaves like a dimension (SCD Type 2, no measures) but is scheduled like a fact.

### Denormalised descriptive columns

Several columns duplicate information already available via the foreign keys — e.g. `client_team_name`, `client_referral_type`, `client_relationship_type_text` — likely for report convenience without an additional join.
