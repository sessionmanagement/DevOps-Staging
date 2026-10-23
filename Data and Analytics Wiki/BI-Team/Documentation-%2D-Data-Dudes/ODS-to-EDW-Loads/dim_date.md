# dim_date

[[_TOC_]]

The conformed enterprise calendar and financial date dimension. Populated via framework stored procedures and reference holiday tables with date keys in `YYYYMMDD` integer format.

## Table identity

| Property | Value |
| --- | --- |
| Target table | `edw.dim_date` |
| Key format | `YYYYMMDD` integer (e.g. `20260923`) |
| Range | Comprehensive historical and future calendar dates |
| Source systems | Calendar generation logic & NZ Public Holidays (`reference.EDW_Holiday_Date_Driven`, `reference.EDW_Holiday_Variable`) |

## Key fields and attributes

### Calendar attributes

- `dim_date_key`: Primary date key in `YYYYMMDD` format (`int`).
- `calendar_date`: Standard SQL `DATE`.
- `calendar_day_num`, `calendar_day_name_full`, `calendar_day_name_short`.
- **Te Reo Māori days & months**: `calendar_day_name_TeReo` (e.g. Rāhina, Rātū), `calendar_month_name_TeReo` (e.g. Kohitātea, Huitanguru).
- `calendar_month_num`, `calendar_month_name_long`, `calendar_month_name_short`, `calendar_year_month`.
- `calendar_quarter_num`, `calendar_quarter_full`.
- `calendar_year`, `calendar_first_day_of_year_date`, `calendar_last_day_of_year_date`.

### Financial calendar attributes

- `financial_year_num`, `financial_year_desc` (e.g. `FY2026/2027`).
- `financial_month_num`, `financial_year_month`.
- `financial_quarter_num`, `financial_quarter_full`.
- `financial_week_num`, `financial_first_day_of_week_date`.
- `financial_first_day_of_year_date`, `financial_last_day_of_year_date`.

### New Zealand holiday flags & descriptions

- `national_holiday_flag`, `national_holiday_description` (e.g. Waitangi Day, Matariki, ANZAC Day, Labour Day, Christmas Day).
- `regional_holiday_flag`, `regional_holiday_description` (e.g. Auckland Anniversary, Wellington Anniversary).
- `is_holiday_flag`, `weekend_flag`, `weekday_flag`, `calendar_trading_day_flag`.
- Supports New Zealand Mondayisation holiday rules and variable weekday occurrences (e.g. Labour Day on the 4th Monday of October).

### Dynamic rolling offsets & flags

- Flags: `current_date_flag`, `current_month_flag`, `current_calendar_year_flag`, `current_financial_year_flag`, `previous_year_date_flag`, `previous_year_month_flag`.
- Rolling offset integers (0 = current, -1 = previous, +1 = next):
  - `current_date_rolling_day_offset`
  - `current_date_rolling_month_offset`
  - `current_date_rolling_year_offset`
  - `current_date_rolling_financial_month_offset`
  - `current_date_rolling_financial_year_offset`

::: mermaid
erDiagram
    dim_date ||--o{ fact_finance_general_ledger : "posting_date_key"
    dim_date ||--o{ fact_employee_hours_worked : "shift_date_key"
    dim_date ||--o{ fact_client_referral : "referral_created_date_key"
    dim_date ||--o{ fact_property_inspection : "inspection_date_key"
:::

## Direct join pattern

All fact tables throughout the EDW reference `edw.dim_date` via integer date keys in `YYYYMMDD` format:

```sql
FROM edw.fact_finance_general_ledger AS fact
INNER JOIN edw.dim_date AS d
    ON fact.finance_posting_date_key = d.dim_date_key
```

## Objects touched

| Layer | Object |
| --- | --- |
| Staging | `staging.ODSETLdim_date` |
| Reference | `reference.EDW_Holiday_Date_Driven`, `reference.EDW_Holiday_Variable` |
| Stored procedures | `staging.insert_staging_dim_date`, `edw.Updateedwdim_date` |
| Target | `edw.dim_date` |
