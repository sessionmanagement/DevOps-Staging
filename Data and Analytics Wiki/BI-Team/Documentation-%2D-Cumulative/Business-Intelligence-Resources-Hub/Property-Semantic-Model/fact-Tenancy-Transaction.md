# Tenancy Transaction

## Table of Contents
1. [Overview](#overview)
2. [Data Classification](#data-classification)
3. [Column Reference](#column-reference)
4. [Source SQL](#source-sql)
5. [Transformation Notes](#transformation-notes)
6. [Relationships](#relationships)
7. [Related Measures](#related-measures)

---

## Overview

| Property | Value |
|----------|-------|
| **Power BI Table Name** | Tenancy Transaction |
| **Source** | `edw.fact_property_tenancy_transaction` |
| **Query Group** | Fact Tables |
| **Row Description** | One financial transaction against a tenancy (rent charge, payment, adjustment, refund, write-off, etc.) |
| **Column Count** | 37 |
| **Overall Classification** | In-Confidence |

Financial transactions against tenancies including rent charges, payments, arrears, and adjustments. Includes running balance columns (rent, non-rent, total) and a window function to flag the latest balance record per tenancy. Charges are represented as negative amounts; payments as positive amounts.

---

## Data Classification

Per the **Emerge Aotearoa Data Classification & Handling Policy**, columns are classified:

| Level | Description | Examples in this table |
|-------|-------------|----------------------|
| :green_circle: **Public** | Non-sensitive operational data | Transaction Date, Rent From Date, Rent To Date, Transaction Type, Transaction Status, Transaction State, Payment Type, Rent Or Non-Rent, Credit Or Debit |
| :yellow_circle: **In-Confidence** | Business-sensitive financial data | Amount, Balance Rent, Balance Non Rent, Balance Total, G/L Code, Comments, Arrears Arrangement, Bc Entry No |
| :red_circle: **Sensitive** | N/A | No columns at this level |

---

## Column Reference

| # | Column Name | Data Type | Visibility | Classification | Description |
|---|------------|-----------|------------|----------------|-------------|
| 1 | Fact Property Tenancy Transaction ID | int64 | Hidden | :green_circle: Public | Surrogate key |
| 2 | Property Tenancy Transaction ID | string | Hidden | :green_circle: Public | Business key from source system |
| 3 | Dim Property KEY | int64 | Hidden | :green_circle: Public | FK to Dim Property |
| 4 | Dim Property Detail KEY | int64 | Hidden | :green_circle: Public | FK to Dim Property Detail |
| 5 | Dim Property Healthy Homes KEY | int64 | Hidden | :green_circle: Public | FK to Dim Property Healthy Homes |
| 6 | Dim Property Tenancy KEY | int64 | Hidden | :green_circle: Public | FK to Dim Property Tenancy |
| 7 | Dim Property Program KEY | int64 | Hidden | :green_circle: Public | FK to Dim Property Program |
| 8 | Property ID | string | Hidden | :green_circle: Public | Property business key |
| 9 | Property Tenancy ID | string | Hidden | :green_circle: Public | Tenancy business key (join to Tenancy table) |
| 10 | Property Program ID | string | Hidden | :green_circle: Public | Program identifier |
| 11 | Property Subprogram ID | string | Hidden | :green_circle: Public | Subprogram identifier |
| 12 | Transaction Date | date | Visible | :green_circle: Public | Date the transaction was recorded |
| 13 | Rent From Date | date | Visible | :green_circle: Public | Start date of the rent period |
| 14 | Rent To Date | date | Visible | :green_circle: Public | End date of the rent period |
| 15 | Rent Paid To | date | Visible | :green_circle: Public | Date rent is paid up to |
| 16 | Tenancy As At Date | date | Visible | :green_circle: Public | Snapshot date for balance calculation |
| 17 | Transaction Name | string | Visible | :green_circle: Public | Human-readable transaction description |
| 18 | G/L Code | string | Hidden | :yellow_circle: In-Confidence | General ledger transaction type code |
| 19 | Transaction Type | string | Visible | :green_circle: Public | Category of transaction (Rent Charge, Rent Payment, etc.) |
| 20 | Account Type | string | Visible | :green_circle: Public | Account type classification |
| 21 | Sub Transaction Name | string | Visible | :green_circle: Public | Sub-classification of the transaction |
| 22 | Comments | string | Visible | :yellow_circle: In-Confidence | Free-text comments on the transaction |
| 23 | Transaction State | string | Visible | :green_circle: Public | Active/Inactive state |
| 24 | Transaction Status | string | Visible | :green_circle: Public | Processing status |
| 25 | Payment Type ID | int64 | Hidden | :green_circle: Public | Payment type identifier |
| 26 | Payment Type | string | Visible | :green_circle: Public | Method of payment |
| 27 | Rent Or Non-Rent | string | Visible | :green_circle: Public | Whether transaction is rent or non-rent |
| 28 | Credit Or Debit | string | Visible | :green_circle: Public | Credit or debit indicator |
| 29 | Arrears Arrangement | string | Visible | :yellow_circle: In-Confidence | Details of arrears arrangement if applicable |
| 30 | Import Payment | string | Hidden | :yellow_circle: In-Confidence | Imported payment reference |
| 31 | Bc Entry No | string | Hidden | :yellow_circle: In-Confidence | Business Central entry number |
| 32 | Amount | double | Visible | :yellow_circle: In-Confidence | Transaction amount (negative=charge, positive=payment) |
| 33 | Balance Non Rent | double | Visible | :yellow_circle: In-Confidence | Running non-rent balance for the tenancy |
| 34 | Balance Rent | double | Visible | :yellow_circle: In-Confidence | Running rent balance for the tenancy |
| 35 | Balance Total | double | Visible | :yellow_circle: In-Confidence | Running total balance (rent + non-rent) |
| 36 | Receipt Number (Number) | int64 | Hidden | :yellow_circle: In-Confidence | Payment receipt number |
| 37 | Is Latest Balance | boolean | Visible | :green_circle: Public | TRUE if this row has the latest as_at_date_key for its tenancy |

---

## Source SQL

```sql
SELECT
    [fact_property_tenancy_transaction_id]                                          AS [Fact Property Tenancy Transaction ID],
    [property_tenancy_transaction_id]                                               AS [Property Tenancy Transaction ID],
    [dim_property_key]                                                              AS [Dim Property KEY],
    [dim_property_detail_key]                                                       AS [Dim Property Detail KEY],
    [dim_property_healthy_homes_key]                                                AS [Dim Property Healthy Homes KEY],
    [dim_property_tenancy_key]                                                      AS [Dim Property Tenancy KEY],
    [dim_property_program_key]                                                      AS [Dim Property Program KEY],
    [property_id]                                                                   AS [Property ID],
    [property_tenancy_id]                                                           AS [Property Tenancy ID],
    [property_program_id]                                                           AS [Property Program ID],
    [property_subprogram_id]                                                        AS [Property Subprogram ID],
    TRY_CONVERT(DATE, CAST([property_tenancy_transaction_date_key] AS CHAR(8)), 112) AS [Transaction Date],
    TRY_CONVERT(DATE, CAST([rent_from_date_key] AS CHAR(8)), 112)                  AS [Rent From Date],
    TRY_CONVERT(DATE, CAST([rent_to_date_key] AS CHAR(8)), 112)                    AS [Rent To Date],
    TRY_CONVERT(DATE, CAST([rent_paid_to_date_key] AS CHAR(8)), 112)               AS [Rent Paid To],
    TRY_CONVERT(DATE, CAST([as_at_date_key] AS CHAR(8)), 112)                      AS [Tenancy As At Date],
    [property_tenancy_transaction_name]                                             AS [Transaction Name],
    [property_tenancy_transaction_type_code]                                        AS [G/L Code],
    [property_tenancy_transaction_type]                                             AS [Transaction Type],
    [property_tenancy_transaction_account_type]                                     AS [Account Type],
    [property_tenancy_transaction_subtransaction_name]                              AS [Sub Transaction Name],
    [property_tenancy_transaction_comments]                                         AS [Comments],
    [property_tenancy_transaction_state]                                            AS [Transaction State],
    [property_tenancy_transaction_status]                                           AS [Transaction Status],
    [property_tenancy_transaction_payment_type_id]                                  AS [Payment Type ID],
    [property_tenancy_transaction_payment_type]                                     AS [Payment Type],
    [property_tenancy_transaction_rent_nonrent]                                     AS [Rent Or Non-Rent],
    [property_tenancy_transaction_credit_debit]                                     AS [Credit Or Debit],
    [property_tenancy_transaction_arrears_arrangement]                              AS [Arrears Arrangement],
    [property_tenancy_transaction_import_payment_name]                              AS [Import Payment],
    [property_tenancy_transaction_bc_entry_number]                                  AS [Bc Entry No],
    [property_tenancy_transaction_amount]                                           AS [Amount],
    [property_tenancy_transaction_balance_non_rent]                                 AS [Balance Non Rent],
    [property_tenancy_transaction_balance_rent]                                     AS [Balance Rent],
    [property_tenancy_transaction_balance_total]                                    AS [Balance Total],
    [property_tenancy_transaction_receipt_number]                                   AS [Receipt Number (Number)],
    CAST(
        CASE
            WHEN [as_at_date_key] = MAX([as_at_date_key]) OVER (
                PARTITION BY [property_tenancy_id]
            )
            THEN 1
            ELSE 0
        END
    AS BIT)                                                                        AS [Is Latest Balance]
FROM [edw].[fact_property_tenancy_transaction]
WHERE [DWHDMLOperation] <> 'D'
    AND [property_id] IS NOT NULL
    AND [property_tenancy_id] IS NOT NULL;
```

---

## Transformation Notes

- **fnApplyNamingConventions**: Replaces underscores with spaces, capitalises ID/KEY suffixes. Applied to all column names after SQL aliasing.
- **Filters**:
  - `DWHDMLOperation <> 'D'` -- Excludes soft-deleted EDW rows
  - `property_id IS NOT NULL` -- Excludes orphan transactions with no property
  - `property_tenancy_id IS NOT NULL` -- Excludes orphan transactions with no tenancy
- **Type conversions**:
  - 5 date key columns (int YYYYMMDD) converted to DATE via `TRY_CONVERT(DATE, CAST(... AS CHAR(8)), 112)`
  - `Is Latest Balance` computed as BIT via window function `MAX(as_at_date_key) OVER (PARTITION BY property_tenancy_id)`, then converted to boolean in M ("Changed Type" step)

---

## Relationships

| From Table | From Column | To Table | To Column | Cardinality | Cross Filter |
|-----------|-------------|----------|-----------|-------------|-------------|
| Tenancy Transaction | Property Tenancy ID | Tenancy | Property Tenancy ID | Many-to-One | Single |

---

## Related Measures

| Measure | Folder | Description |
|---------|--------|-------------|
| Total Transactions | 04. Financial | Count of all financial transaction rows |
| Transaction Amount | 04. Financial | Sum of all transaction amounts |
| Rent Charged | 04. Financial\Rent | Sum of Rent Charge transactions (negative) |
| Rent Payments | 04. Financial\Rent | Sum of Rent Payment transactions (positive) |
| Rent Adjustments CR | 04. Financial\Rent | Sum of Rent CR Adjustment transactions |
| Rent Adjustments DR | 04. Financial\Rent | Sum of Rent DR Adjustment transactions |
| Rent Refunds | 04. Financial\Rent | Sum of Refund of Rent transactions |
| Net Rent Position | 04. Financial\Rent | Charges + Payments + Adjustments + Refunds |
| Electricity Charged | 04. Financial\Utilities | Sum of Electricity Charge transactions |
| Electricity Payments | 04. Financial\Utilities | Sum of Electricity Payment transactions |
| Water Charged | 04. Financial\Utilities | Sum of Water Usage Charge transactions |
| Water Payments | 04. Financial\Utilities | Sum of Water Usage Payment transactions |
| Internet Charged | 04. Financial\Utilities | Sum of Internet Access Charge transactions |
| Internet Payments | 04. Financial\Utilities | Sum of Internet Access Payment transactions |
| Client Damages Charged | 04. Financial\Damages | Sum of Client Damages Charge transactions |
| Client Damages Payments | 04. Financial\Damages | Sum of Client Damages Payment transactions |
| Arrears Payments - Rent | 04. Financial\Arrears | Sum of Arrears Payment Rent transactions |
| Arrears Payments - Utilities | 04. Financial\Arrears | Sum of utility arrears payment transactions |
| Arrears Payments - Tenant Liability | 04. Financial\Arrears | Sum of Arrears Payment Tenant Liability transactions |
| Bad Debt Write-Off - Rent | 04. Financial\Write-Offs | Sum of Write Off Bad Debt - Rent transactions |
| Bad Debt Write-Off - Utilities | 04. Financial\Write-Offs | Sum of Write Off Bad Debt - Utilities transactions |
| Bad Debt Write-Off - Tenant Liability | 04. Financial\Write-Offs | Sum of Write Off Bad Debt - Tenant Liability transactions |
| Total Bad Debt Written Off | 04. Financial\Write-Offs | Combined rent + utilities + tenant liability write-offs |
| Current Rent Balance | 04. Financial\Balances | Rent balance for latest balance rows only |
| Current Non-Rent Balance | 04. Financial\Balances | Non-rent balance for latest balance rows only |
| Current Total Balance | 04. Financial\Balances | Total balance for latest balance rows only |
| Tenancies With Current Balance | 04. Financial\Balances | Distinct tenancies that have a latest balance row |
| Lawns & Gardens Charged | 04. Financial\Other Charges | Sum of Lawns & Garden Maintenance charges |
| Lawns & Gardens Payments | 04. Financial\Other Charges | Sum of Lawns & Garden Maintenance payments |
| Cleaning Charged | 04. Financial\Other Charges | Sum of Cleaning Charge transactions |
| SNG Grants Applied | 04. Financial\Grants | Sum of SNG grant transactions applied to rent/non-rent |
