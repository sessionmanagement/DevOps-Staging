# Transitional Housing Referrals

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
| **Power BI Table Name** | Transitional Housing Referrals |
| **Source** | Multi-table JOIN: `edw.vw_fact_client_referral` INNER JOIN `edw.vw_dim_client_referral`, `edw.vw_dim_client`, `edw.vw_dim_client_team`, `edw.vw_dim_service` |
| **Query Group** | (root) |
| **Row Description** | One distinct inbound referral to an Emergency Housing Service, excluding declined, pending, and follow-up team referrals |
| **Column Count** | 14 |
| **Overall Classification** | Sensitive |

Transitional housing referral data sourced from the client referral system. This table joins the fact_client_referral with supporting dimensions to produce a flattened referral view filtered specifically to Emergency Housing Services. The query uses SELECT DISTINCT and excludes declined referrals, pending referrals, and follow-up team records. It is used indirectly by the 09. THVM Dashboard measures via the Tenancy Referral Bridge table.

---

## Data Classification

Per the **Emerge Aotearoa Data Classification & Handling Policy**, columns are classified:

| Level | Description | Examples in this table |
|-------|-------------|----------------------|
| :green_circle: **Public** | Non-sensitive operational data | Referral Status, Service Name, Service Type Name, Finance Funder Name, Tangata Whaiora Team Name, Referral Received Date, Referral Accepted Date, Referral Discharge Date |
| :yellow_circle: **In-Confidence** | Business-sensitive referral details | Tangata Whaiora Referrer Name, Referral Accepted Reason, Referral Accepted Reason Code, Referral Discharge Reason, Referral Discharge Reason Code |
| :red_circle: **Sensitive** | Personally identifiable information | Tangata Whaiora ID |

---

## Column Reference

| # | Column Name | Data Type | Visibility | Classification | Description |
|---|------------|-----------|------------|----------------|-------------|
| 1 | Tangata Whaiora ID | int64 | Visible | :red_circle: Sensitive | Client identifier (PII - links to individual) |
| 2 | Tangata Whaiora Referrer Name | string | Visible | :yellow_circle: In-Confidence | Name of the person/organisation that made the referral |
| 3 | Tangata Whaiora Referral Accepted Reason | string | Visible | :yellow_circle: In-Confidence | Reason the referral was accepted |
| 4 | Tangata Whaiora Referral Accepted Reason Code | string | Visible | :yellow_circle: In-Confidence | Code for acceptance reason |
| 5 | Tangata Whaiora Referral Discharge Reason | string | Visible | :yellow_circle: In-Confidence | Reason the referral was discharged |
| 6 | Tangata Whaiora Referral Discharge Reason Code | string | Visible | :yellow_circle: In-Confidence | Code for discharge reason |
| 7 | Tangata Whaiora Referral Status | string | Visible | :green_circle: Public | Current referral status (excludes Declined and Pending) |
| 8 | Service Name | string | Visible | :green_circle: Public | Name of the service receiving the referral |
| 9 | Service Type Name | string | Visible | :green_circle: Public | Always "Emergency Housing Service" (filter applied) |
| 10 | Finance Funder Name | string | Visible | :green_circle: Public | Funding organisation name |
| 11 | Tangata Whaiora Team Name | string | Visible | :green_circle: Public | Client team name (excludes follow-up teams) |
| 12 | Tangata Whaiora Referral Received Date | date | Visible | :green_circle: Public | Date the referral was received |
| 13 | Tangata Whaiora Referral Accepted Date | date | Visible | :green_circle: Public | Date the referral was accepted |
| 14 | Tangata Whaiora Referral Discharge Date | date | Visible | :green_circle: Public | Date the referral was discharged |

---

## Source SQL

```sql
SELECT DISTINCT
    c.[client_id]                                                          AS [Tangata Whaiora ID],
    cr.[client_referrer_name]                                              AS [Tangata Whaiora Referrer Name],
    cr.[client_referral_accepted_reason]                                   AS [Tangata Whaiora Referral Accepted Reason],
    cr.[client_referral_accepted_reason_code]                              AS [Tangata Whaiora Referral Accepted Reason Code],
    cr.[client_referral_discharge_reason]                                  AS [Tangata Whaiora Referral Discharge Reason],
    cr.[client_referral_discharge_reason_code]                             AS [Tangata Whaiora Referral Discharge Reason Code],
    cr.[client_referral_status]                                            AS [Tangata Whaiora Referral Status],
    s.[service_name]                                                       AS [Service Name],
    s.[service_type_name]                                                  AS [Service Type Name],
    s.[finance_funder_name]                                                AS [Finance Funder Name],
    ct.[client_team_name]                                                  AS [Tangata Whaiora Team Name],
    CASE
        WHEN fcr.[client_referral_received_date_key] IS NULL
            OR fcr.[client_referral_received_date_key] = 0
        THEN NULL
        ELSE DATEFROMPARTS(
            fcr.[client_referral_received_date_key] / 10000,
            (fcr.[client_referral_received_date_key] / 100) % 100,
            fcr.[client_referral_received_date_key] % 100
        )
    END                                                                    AS [Tangata Whaiora Referral Received Date],
    CASE
        WHEN fcr.[client_referral_accepted_date_key] IS NULL
            OR fcr.[client_referral_accepted_date_key] = 0
        THEN NULL
        ELSE DATEFROMPARTS(
            fcr.[client_referral_accepted_date_key] / 10000,
            (fcr.[client_referral_accepted_date_key] / 100) % 100,
            fcr.[client_referral_accepted_date_key] % 100
        )
    END                                                                    AS [Tangata Whaiora Referral Accepted Date],
    CASE
        WHEN fcr.[client_referral_discharge_date_key] IS NULL
            OR fcr.[client_referral_discharge_date_key] = 0
        THEN NULL
        ELSE DATEFROMPARTS(
            fcr.[client_referral_discharge_date_key] / 10000,
            (fcr.[client_referral_discharge_date_key] / 100) % 100,
            fcr.[client_referral_discharge_date_key] % 100
        )
    END                                                                    AS [Tangata Whaiora Referral Discharge Date]
FROM [edw].[vw_fact_client_referral] AS fcr
    INNER JOIN [edw].[vw_dim_client_referral] AS cr
        ON fcr.[dim_client_referral_key] = cr.[dim_client_referral_key]
    INNER JOIN [edw].[vw_dim_client] AS c
        ON fcr.[dim_client_key] = c.[dim_client_key]
    INNER JOIN [edw].[vw_dim_client_team] AS ct
        ON fcr.[dim_client_team_key] = ct.[dim_client_team_key]
    INNER JOIN [edw].[vw_dim_service] AS s
        ON ct.[dim_service_key] = s.[dim_service_key]
WHERE
    fcr.[DWHDMLOperation] <> 'D'
    AND cr.[client_referral_status] <> 'Declined'
    AND cr.[client_referral_status] <> 'Pending'
    AND cr.[client_referral_type] = 'InboundReferral'
    AND s.[service_type_name] = 'Emergency Housing Service'
    AND ct.[client_team_name] NOT LIKE '%f/up%';
```

---

## Transformation Notes

- **fnApplyNamingConventions**: Replaces underscores with spaces, capitalises ID/KEY. The `client_` prefix is replaced with `Tangata_Whaiora_` per standard naming conventions.
- **Filters**:
  - `fcr.DWHDMLOperation <> 'D'` -- Excludes soft-deleted EDW rows
  - `cr.client_referral_status <> 'Declined'` -- Excludes declined referrals
  - `cr.client_referral_status <> 'Pending'` -- Excludes pending referrals
  - `cr.client_referral_type = 'InboundReferral'` -- Only inbound referrals (not outbound)
  - `s.service_type_name = 'Emergency Housing Service'` -- Only Emergency Housing Services
  - `ct.client_team_name NOT LIKE '%f/up%'` -- Excludes follow-up teams
- **Type conversions**:
  - 3 date key columns (int YYYYMMDD) converted to DATE via `DATEFROMPARTS()` with NULL/0 handling
  - In M, the KEY suffix is removed after date conversion: "Tangata Whaiora Referral Received Date KEY" becomes "Tangata Whaiora Referral Received Date"
- **SELECT DISTINCT**: Applied to the entire result set to eliminate duplicate referral rows from the multi-table join
- **M transforms**: Date KEY columns are converted from int to Date type using `Date.FromText`, then renamed to remove the " KEY" suffix

---

## Relationships

| From Table | From Column | To Table | To Column | Cardinality | Cross Filter |
|-----------|-------------|----------|-----------|-------------|-------------|
| Transitional Housing Referrals | Tangata Whaiora ID | Client | Tangata Whaiora ID | Many-to-One | Single |

---

## Related Measures

| Measure | Folder | Description |
|---------|--------|-------------|
| TH MSD Referrals Received - Monthly | 09. THVM Dashboard\Service Flows | Count of MSD referrals received in the current month |
| TH MSD Referrals Received - Yearly | 09. THVM Dashboard\Service Flows | Count of MSD referrals received in the current year |
| TH MSD Referrals Accepted - Monthly | 09. THVM Dashboard\Service Flows | Count of MSD referrals accepted in the current month |
| TH Rate MSD Referrals Monthly % | 09. THVM Dashboard\Service Flows | Monthly referral acceptance rate (placeholder) |
| TH Rate MSD Referrals Yearly % | 09. THVM Dashboard\Service Flows | Yearly referral acceptance rate (placeholder) |
| TH Occupied Units | 09. THVM Dashboard\Occupancy | Count of currently occupied transitional housing units |
| TH Total Units | 09. THVM Dashboard\Occupancy | Total transitional housing units |
| TH Unoccupied Units | 09. THVM Dashboard\Occupancy | Count of unoccupied transitional housing units |
| TH Occupancy Rate % | 09. THVM Dashboard\Occupancy | Occupied / Total as percentage |
| TH Unoccupied > 20 Days | 09. THVM Dashboard\Occupancy | Units unoccupied for more than 20 days |
| TH Revenue This Month | 09. THVM Dashboard\Occupancy | Revenue for transitional housing this month |
| TH Revenue Last Month | 09. THVM Dashboard\Occupancy | Revenue for transitional housing last month |
| TH Positive Exit Rate Monthly % | 09. THVM Dashboard\Exits | Positive exit rate for current month |
| TH Positive Exit Rate Yearly % | 09. THVM Dashboard\Exits | Positive exit rate for current year |
| TH Positive Exit Rate All Time % | 09. THVM Dashboard\Exits | Positive exit rate since inception |
| TH Exits This Month | 09. THVM Dashboard\Exits | Count of exits in current month |
| TH Exits This Year | 09. THVM Dashboard\Exits | Count of exits in current year |
| TH Exits All Time | 09. THVM Dashboard\Exits | Count of all exits |
| TH Positive Exits All Time | 09. THVM Dashboard\Exits | Count of positive exits |
| TH Negative Exits All Time | 09. THVM Dashboard\Exits | Count of negative exits |
| TH Active Exits All Time | 09. THVM Dashboard\Exits | Count of still-active exits |
| TH Avg Length of Stay - Monthly | 09. THVM Dashboard\Length of Stay | Average length of stay for exits this month (days) |
| TH Avg Length of Stay - Yearly | 09. THVM Dashboard\Length of Stay | Average length of stay for exits this year (days) |
| TH Avg Length of Stay - All Time | 09. THVM Dashboard\Length of Stay | Average length of stay for all exits (days) |
| TH Median Length of Stay - All Time | 09. THVM Dashboard\Length of Stay | Median length of stay for all exits (days) |
| TH Total Length of Stay Days | 09. THVM Dashboard\Length of Stay | Sum of all length of stay days |
