# Client

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
| **Power BI Table Name** | Client |
| **Source** | `edw.vw_dim_client` |
| **Query Group** | Dim Tables |
| **Row Description** | Each row represents a unique client (tangata whaiora) with demographic information |
| **Column Count** | 13 |
| **Overall Classification** | Sensitive |

The Client table is a demographic dimension containing core identity and demographic attributes for tenants. It is linked to the Tenancy table via the Tangata Whaiora ID (extracted from the Primary Tenant Record Base ID in the Tenancy table). It also links to Transitional Housing Referrals. The `client_` prefix is transformed to `Tangata_Whaiora_` by the fnApplyNamingConventions function, reflecting the organisation's te reo Maori naming conventions.

---

## Data Classification

Per the **Emerge Aotearoa Data Classification & Handling Policy**, columns are classified:

| Level | Description | Examples in this table |
|-------|-------------|----------------------|
| :green_circle: **Public** | Non-sensitive business data | Tangata Whaiora ID (hidden, used as key only) |
| :yellow_circle: **In-Confidence** | Business-sensitive data requiring controlled access | Maori Flag, Pasifika Flag |
| :red_circle: **Sensitive** | Personally identifiable information requiring strict controls | Display Name, First/Last/Preferred Name, DOB, Age, Gender, Ethnicity |

---

## Column Reference

| # | Column Name | Data Type | Visibility | Classification | Description |
|---|------------|-----------|------------|----------------|-------------|
| 1 | Tangata Whaiora ID | int64 | Hidden | :green_circle: Public | Business key (client_id) |
| 2 | Tangata Whaiora Display Name | string | Visible | :red_circle: Sensitive | Client display name (PII) |
| 3 | Tangata Whaiora First Name | string | Visible | :red_circle: Sensitive | Client first name (PII) |
| 4 | Tangata Whaiora Last Name | string | Visible | :red_circle: Sensitive | Client last name (PII) |
| 5 | Tangata Whaiora Preferred Name | string | Visible | :red_circle: Sensitive | Client preferred name (PII) |
| 6 | Tangata Whaiora Date Of Birth | date | Visible | :red_circle: Sensitive | Date of birth (PII) |
| 7 | Tangata Whaiora Age Years | double | Visible | :red_circle: Sensitive | Age in years (PII) |
| 8 | Tangata Whaiora Gender | string | Visible | :red_circle: Sensitive | Gender (PII) |
| 9 | Tangata Whaiora Primary Ethnicity | string | Visible | :red_circle: Sensitive | Primary ethnicity (PII) |
| 10 | Tangata Whaiora Secondary Ethnicity | string | Visible | :red_circle: Sensitive | Secondary ethnicity (PII) |
| 11 | Tangata Whaiora Tertiary Ethnicity | string | Visible | :red_circle: Sensitive | Tertiary ethnicity (PII) |
| 12 | Tangata Whaiora Maori Flag | int64 | Visible | :yellow_circle: In-Confidence | 1 = identifies as Maori |
| 13 | Tangata Whaiora Pasifika Flag | int64 | Visible | :yellow_circle: In-Confidence | 1 = identifies as Pasifika |

---

## Source SQL

```sql
SELECT
    [client_id]                         AS [Tangata Whaiora ID],
    [client_display_name]               AS [Tangata Whaiora Display Name],
    [client_first_name]                 AS [Tangata Whaiora First Name],
    [client_last_name]                  AS [Tangata Whaiora Last Name],
    [client_preferred_name]             AS [Tangata Whaiora Preferred Name],
    CAST([client_date_of_birth] AS DATE) AS [Tangata Whaiora Date Of Birth],
    [client_age_years]                  AS [Tangata Whaiora Age Years],
    [client_gender]                     AS [Tangata Whaiora Gender],
    [client_primary_ethnicity]          AS [Tangata Whaiora Primary Ethnicity],
    [client_secondary_ethnicity]        AS [Tangata Whaiora Secondary Ethnicity],
    [client_tertiary_ethnicity]         AS [Tangata Whaiora Tertiary Ethnicity],
    [client_maori_flag]                 AS [Tangata Whaiora Maori Flag],
    [client_pasifika_flag]              AS [Tangata Whaiora Pasifika Flag]
FROM [edw].[vw_dim_client]
WHERE [DWHIsCurrent] = 1
    AND [DWHDMLOperation] <> 'D'
    AND [company_id] = 1;
```

---

## Transformation Notes

- **fnApplyNamingConventions**: Replaces `client_` prefix with `Tangata_Whaiora_`. Replaces underscores with spaces, applies proper case. Capitalises ID.
- **Filters**:
  - `DWHIsCurrent = 1` (current SCD Type 2 record only)
  - `DWHDMLOperation <> 'D'` (exclude deleted records)
  - `company_id = 1` (filters to primary company)
- **Type conversions**: `client_date_of_birth` CAST to DATE

---

## Relationships

| From Table | From Column | To Table | To Column | Cardinality | Cross Filter |
|-----------|-------------|----------|-----------|-------------|-------------|
| Tenancy | Tangata Whaiora ID | Client | Tangata Whaiora ID | Many-to-One | Single |
| Transitional Housing Referrals | Tangata Whaiora ID | Client | Tangata Whaiora ID | Many-to-One | Single |

---

## Related Measures

| Measure | Folder | Description |
|---------|--------|-------------|
| Total Clients | 03. Tenant | Count of distinct clients |
| Maori Clients | 10. Tenant Demographics | Count of clients with Maori Flag = 1 |
| Pasifika Clients | 10. Tenant Demographics | Count of clients with Pasifika Flag = 1 |
| Average Client Age | 10. Tenant Demographics | Average age of clients in years |
