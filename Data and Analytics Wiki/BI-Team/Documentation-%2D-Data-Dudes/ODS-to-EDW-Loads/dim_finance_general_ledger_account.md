# dim_finance_general_ledger_account

[[_TOC_]]

Business Central chart of accounts, enriched with a company-specific hierarchy of up to six levels. This is the principal account dimension for budget and actual reporting.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `466` |
| Target table | `edw.dim_finance_general_ledger_account` |
| Load type | `ODSFLLMRGIRV` — full row-versioned merge |
| Load phase | `101 Dimensions` |
| Highwater | None; full source view read every run |
| Source system | Microsoft Dynamics 365 Business Central |

## Data lineage

```text
Business Central glAccounts
  └─ ODS view: ETL.dim_finance_general_ledger_account
       └─ landing.edw_dim_finance_general_ledger_account
            └─ staging.ODSETLdim_finance_general_ledger_account
                 ├─ recursive hierarchy construction
                 └─ edw.dim_finance_general_ledger_account
```

## Key fields and attributes

| Column | Type | Role |
| --- | --- | --- |
| `dim_finance_general_ledger_account_key` | `int` | Surrogate primary key |
| `finance_general_ledger_account_company_name` | `nvarchar(200)` | Business Central company; part of business key |
| `finance_general_ledger_account_code` | `nvarchar(10)` | G/L account number; part of business key |
| `finance_general_ledger_account_description` | `nvarchar(200)` | Account name |
| `finance_general_ledger_account_type` | `nvarchar(10)` | Business Central account type |
| `finance_general_ledger_account_category` | `nvarchar(10)` | Account category |
| `finance_general_ledger_account_direct_posting_flag` | `nvarchar(10)` | Whether direct posting is permitted |
| `finance_general_ledger_account_parent_code` | `nvarchar(10)` | Parent account number |
| `finance_general_ledger_account_subcategory_entry_no` | `int` | Account-subcategory key from Business Central |
| `finance_general_ledger_account_subcategory_description` | `nvarchar(250)` | Account-subcategory description |

The natural business key is `(finance_general_ledger_account_company_name, finance_general_ledger_account_code)`.

## Hierarchy fields

| Column group | Purpose |
| --- | --- |
| `hierarchy_structure` | Hyphen-separated account path |
| `hierarchy_length_depth` | Number of hierarchy edges |
| `hierarchy_first_level_*` through `sixth_level_*` | Flattened account code and name at each hierarchy level |

Staging builds the path with a recursive CTE, scoped by company, then resolves each level back to the staged account table.

### Hard-coded parent overrides

Before recursion, staging overrides the source parent for these accounts:

| Account | Parent |
| --- | --- |
| `1000` | Root (`-1`) |
| `1001` | `1000` |
| `2000` | `1000` |
| `2999` | Root (`-1`) |
| `3000` | Root (`-1`) |
| `3001` | `3000` |
| `4000` | `3001` |
| `5000` | `3000` |

All other accounts use `Parent_Account_No` from Business Central.

## Relationships

::: mermaid
erDiagram
    dim_finance_general_ledger_account ||--o{ fact_finance_budget : "transaction G/L account"
    dim_finance_general_ledger_account ||--o{ fact_finance_general_ledger : "transaction G/L account"
    dim_finance_general_ledger_account ||--o{ fact_finance_customer_ledger : "balancing account"
    dim_finance_general_ledger_account ||--o{ fact_finance_vendor_ledger : "balancing account"
:::

The key has different semantics by fact: budget/general ledger use the transaction account; customer/vendor ledger use the balancing account.

## SCD and deletion behavior

The update procedure performs a full comparison using company and account code. Changed current rows are closed and replacement rows inserted. Accounts missing from the full source are soft-deleted/versioned out. Keys `0` and `-1` are explicitly seeded as N/A and Unknown.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_finance_general_ledger_account` |
| Landing | `landing.edw_dim_finance_general_ledger_account` |
| Staging | `staging.ODSETLdim_finance_general_ledger_account` |
| Procedures | `staging.insert_staging_dim_finance_general_ledger_account`, `edw.Updateedwdim_finance_general_ledger_account` |
| Target | `edw.dim_finance_general_ledger_account` |

## Notes

### Hierarchy assumes four-character account codes

Hierarchy parsing uses fixed positions (`LEFT(path,4)`, then substrings at offsets 6, 11, 16, 21 and 26). The target account code allows 10 characters, but hierarchy construction assumes each code is exactly four characters. Longer or shorter codes will produce incorrect levels.

### Depth is stored as text

`finance_general_ledger_account_hierarchy_length_depth` is `nvarchar(40)`, although it contains a numeric depth. Consumers should convert it before numeric sorting or comparisons.

### Flags and classifications are strings

Direct-posting flag, account type and category are stored as `nvarchar` rather than typed boolean/reference keys. Semantic models should expose stable labels and avoid relying on undocumented raw codes.

### Source-system value

The procedure records `DWHSourceSystem = 'BusinessCentral.glAccounts'`, which is more specific than the staging object name and useful for lineage.
