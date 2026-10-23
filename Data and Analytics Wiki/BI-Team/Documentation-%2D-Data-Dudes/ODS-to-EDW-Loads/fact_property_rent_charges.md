# fact_property_rent_charges

[[_TOC_]]

Rent charges configured against a property — the rent amounts set for a property, with the employee who set them.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `734` |
| Target table | `edw.fact_property_rent_charges` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` |
| Highwater / Incremental / Merged | No / No / Yes |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.fact_property_rent_charges
       └─ landing.edw_fact_property_rent_charges             (TRUNCATE + full Copy)
            └─ staging.ODSETLfact_property_rent_charges      (staging.insert_staging_fact_property_rent_charges)
                 └─ edw.fact_property_rent_charges           (edw.Updateedwfact_property_rent_charges)
```

### Distinguishing source views

`vw_zav_propertyrentcharges`, `vw_systemuser`

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_property_rent_charges_key` | `int` | Surrogate primary key | — |
| `rent_charge_id` | `uniqueidentifier` | Business key (grain) | Zavanti `vw_zav_propertyrentcharges` |
| `dim_property_key` | `int` | Dimension foreign key | `edw.dim_property` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company` |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee` |
| `property_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `employee_id` | `int` | Business key (lookup) | `edw.dim_employee` |

::: mermaid
erDiagram
    dim_property ||--o{ fact_property_rent_charges : "dim_property_key"
    dim_company  ||--o{ fact_property_rent_charges : "dim_company_key"
    dim_employee ||--o{ fact_property_rent_charges : "dim_employee_key"
:::

## Load behaviour

`IsHighwater = 0`, `IsIncremental = 0`. The full ODS view is read on every run, then merged with row versioning.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_property_rent_charges` |
| Landing | `landing.edw_fact_property_rent_charges` |
| Staging | `staging.ODSETLfact_property_rent_charges` |
| Stored procedures | `staging.insert_staging_fact_property_rent_charges`, `edw.Updateedwfact_property_rent_charges` |
| Target | `edw.fact_property_rent_charges` |

## Notes

### The only property fact reaching outside the property subject area

This is the sole property fact carrying `dim_employee_key` and `dim_company_key`. Every other property fact stays within the property dimensions. That makes it the one place where property data joins the HR conformed dimensions.

### Cross-source employee resolution

`employee_id` is an `int` resolving against `edw.dim_employee`, which is sourced from IntelliHR and Datapay — not Zavanti. The ODS view must therefore map a Zavanti `systemuser` to an Emerge employee. Confirm how that mapping is done and how unmatched users are handled, since a failed match will resolve to the Unknown member (`-1`).

### No date keys

Rent charges have no conformed date. Effective-dated rent analysis is not possible from this fact without additional columns from the ODS view.

### No tenancy key

Rent is charged against the property, not the tenancy. To relate rent charges to what a tenant was actually charged, use [fact_property_tenancy_transaction](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_property_tenancy_transaction).
