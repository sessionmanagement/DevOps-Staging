# Tenancy Referral Bridge

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
| **Power BI Table Name** | `Tenancy Referral Bridge` |
| **Source** | DAX Calculated Table |
| **Query Group** | (root) |
| **Row Description** | One row per tenancy-referral pair where client ID matches and dates overlap within a 3-day tolerance |
| **Column Count** | 18 |
| **Overall Classification** | :red_circle: Sensitive |

This bridge table links property tenancies to Transitional Housing (Emergency Housing Service) referrals. It uses a CROSSJOIN filtered by matching Tangata Whaiora ID and date overlap with a 3-day tolerance window:

- **Client match**: `Tenancy.Tangata Whaiora ID = Referral.Tangata Whaiora ID`
- **Date overlap**: `Referral Accepted Date >= Tenancy Start Date - 3 days` AND (`Referral Discharge Date <= Tenancy Vacated Date + 3 days` OR `Tenancy Vacated Date IS NULL`)

The bridge enables analysis of which referrals correspond to specific tenancy periods without creating many-to-many relationships between Tenancy and TH Referrals directly.

---

## Data Classification

| Level | Badge | Description |
|-------|-------|-------------|
| Public | :green_circle: | Non-sensitive operational data |
| Internal | :yellow_circle: | Internal business data |
| Sensitive | :red_circle: | Personal identifiable information |

---

## Column Reference

| # | Column Name | Data Type | Hidden | Classification | Description |
|---|-------------|-----------|--------|----------------|-------------|
| 1 | Property Tenancy ID | string | Yes | :green_circle: Public | Unique tenancy identifier (GUID) |
| 2 | Tenancy Tangata Whaiora ID | int64 | Yes | :red_circle: Sensitive | Client ID extracted from tenancy record |
| 3 | Tenancy Start Date | date | No | :green_circle: Public | Date tenancy commenced |
| 4 | Tenancy Vacated Date | date | No | :green_circle: Public | Date tenant vacated (NULL if current) |
| 5 | Referral Tangata Whaiora ID | int64 | Yes | :red_circle: Sensitive | Client ID from referral record |
| 6 | Referral Accepted Date | date | No | :green_circle: Public | Date referral was accepted |
| 7 | Referral Discharge Date | date | No | :green_circle: Public | Date referral was discharged |
| 8 | Referrer Name | string | No | :red_circle: Sensitive | Name of the referring person/organisation |
| 9 | Referral Status | string | No | :green_circle: Public | Current status of the referral |
| 10 | Referral Accepted Reason | string | No | :green_circle: Public | Reason the referral was accepted |
| 11 | Referral Discharge Reason | string | No | :green_circle: Public | Reason the referral was discharged |
| 12 | Referral Received Date | date | No | :green_circle: Public | Date referral was received |
| 13 | Referral Accepted Reason Code | string | Yes | :green_circle: Public | Code for accepted reason |
| 14 | Referral Discharge Reason Code | string | Yes | :green_circle: Public | Code for discharge reason |
| 15 | Service Name | string | No | :green_circle: Public | Service name (Emergency Housing Service) |
| 16 | Service Type Name | string | No | :green_circle: Public | Service type classification |
| 17 | Finance Funder Name | string | No | :green_circle: Public | Funder of the service |
| 18 | Tangata Whaiora Team Name | string | No | :green_circle: Public | Client team name from referral |

---

## Source SQL

The following SQL is a documentation equivalent of the DAX calculated table logic. In Power BI, this table is computed at refresh time using DAX CROSSJOIN + FILTER.

```sql
-- Tenancy CTE: core tenancy data with extracted Tangata Whaiora ID
WITH Tenancy AS (
    SELECT
        [property_tenancy_id]                                              AS [Property Tenancy ID],
        TRY_CAST(
            (SELECT STRING_AGG(v.c, '') WITHIN GROUP (ORDER BY v.n)
             FROM (
                 SELECT SUBSTRING(t.[property_tenancy_primary_tenant_recordbaseid], n.n, 1) AS c, n.n
                 FROM (SELECT TOP 100 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
                       FROM sys.objects) n
                 WHERE n.n <= LEN(t.[property_tenancy_primary_tenant_recordbaseid])
                   AND SUBSTRING(t.[property_tenancy_primary_tenant_recordbaseid], n.n, 1) LIKE '[0-9]'
             ) v)
        AS BIGINT)                                                         AS [Tenancy Tangata Whaiora ID],
        CAST([property_tenancy_tenancy_start_date] AS DATE)                AS [Tenancy Start Date],
        CAST([property_tenancy_vacated_date] AS DATE)                      AS [Tenancy Vacated Date]
    FROM [edw].[dim_property_tenancy] t
    WHERE [DWHIsCurrent] = 1
        AND [DWHDMLOperation] <> 'D'
        AND [property_tenancy_id] IS NOT NULL
        AND [property_tenant_opportunity_status] <> 'Cancelled'
),

-- Referral CTE: Transitional Housing Referrals
Referral AS (
    SELECT DISTINCT
        c.[client_id]                                                      AS [Referral Tangata Whaiora ID],
        cr.[client_referrer_name]                                          AS [Referrer Name],
        cr.[client_referral_accepted_reason]                               AS [Referral Accepted Reason],
        cr.[client_referral_accepted_reason_code]                          AS [Referral Accepted Reason Code],
        cr.[client_referral_discharge_reason]                              AS [Referral Discharge Reason],
        cr.[client_referral_discharge_reason_code]                         AS [Referral Discharge Reason Code],
        cr.[client_referral_status]                                        AS [Referral Status],
        s.[service_name]                                                   AS [Service Name],
        s.[service_type_name]                                              AS [Service Type Name],
        s.[finance_funder_name]                                            AS [Finance Funder Name],
        ct.[client_team_name]                                              AS [Tangata Whaiora Team Name],
        CASE
            WHEN fcr.[client_referral_received_date_key] IS NULL
                OR fcr.[client_referral_received_date_key] = 0
            THEN NULL
            ELSE DATEFROMPARTS(
                fcr.[client_referral_received_date_key] / 10000,
                (fcr.[client_referral_received_date_key] / 100) % 100,
                fcr.[client_referral_received_date_key] % 100
            )
        END                                                                AS [Referral Received Date],
        CASE
            WHEN fcr.[client_referral_accepted_date_key] IS NULL
                OR fcr.[client_referral_accepted_date_key] = 0
            THEN NULL
            ELSE DATEFROMPARTS(
                fcr.[client_referral_accepted_date_key] / 10000,
                (fcr.[client_referral_accepted_date_key] / 100) % 100,
                fcr.[client_referral_accepted_date_key] % 100
            )
        END                                                                AS [Referral Accepted Date],
        CASE
            WHEN fcr.[client_referral_discharge_date_key] IS NULL
                OR fcr.[client_referral_discharge_date_key] = 0
            THEN NULL
            ELSE DATEFROMPARTS(
                fcr.[client_referral_discharge_date_key] / 10000,
                (fcr.[client_referral_discharge_date_key] / 100) % 100,
                fcr.[client_referral_discharge_date_key] % 100
            )
        END                                                                AS [Referral Discharge Date]
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
        AND ct.[client_team_name] NOT LIKE '%f/up%'
)

-- Bridge join: match on client ID + date overlap with 3-day tolerance
SELECT
    t.[Property Tenancy ID],
    t.[Tenancy Tangata Whaiora ID],
    t.[Tenancy Start Date],
    t.[Tenancy Vacated Date],
    r.[Referral Tangata Whaiora ID],
    r.[Referral Accepted Date],
    r.[Referral Discharge Date],
    r.[Referrer Name],
    r.[Referral Status],
    r.[Referral Accepted Reason],
    r.[Referral Discharge Reason],
    r.[Referral Received Date],
    r.[Referral Accepted Reason Code],
    r.[Referral Discharge Reason Code],
    r.[Service Name],
    r.[Service Type Name],
    r.[Finance Funder Name],
    r.[Tangata Whaiora Team Name]
FROM Tenancy t
    INNER JOIN Referral r
        ON t.[Tenancy Tangata Whaiora ID] = r.[Referral Tangata Whaiora ID]
WHERE t.[Tenancy Tangata Whaiora ID] IS NOT NULL
    AND r.[Referral Accepted Date] >= DATEADD(DAY, -3, t.[Tenancy Start Date])
    AND (
        r.[Referral Discharge Date] <= DATEADD(DAY, 3, t.[Tenancy Vacated Date])
        OR t.[Tenancy Vacated Date] IS NULL
    );
```

---

## Transformation Notes

1. **Tangata Whaiora ID extraction**: The numeric client ID is extracted from the `property_tenancy_primary_tenant_recordbaseid` field by stripping non-digit characters and casting to BIGINT.

2. **Date key conversion**: EDW date keys stored as integers (YYYYMMDD) are converted to proper DATE types using `DATEFROMPARTS`.

3. **Referral filtering**: Only inbound referrals for Emergency Housing Service are included. Declined, Pending, and follow-up team referrals are excluded.

4. **3-day tolerance**: The date overlap window includes a 3-day buffer on both sides to accommodate minor discrepancies between tenancy and referral dates.

5. **NULL vacated dates**: Tenancies with no vacated date (current tenancies) match any referral that started on or after the tenancy start date minus 3 days.

---

## Relationships

| Direction | Related Table | Key Column | Cardinality | Active |
|-----------|--------------|------------|-------------|--------|
| From (Many) | Tenancy | Property Tenancy ID | Many-to-One | Yes |

The bridge table has a many-to-one relationship to the Tenancy table via Property Tenancy ID. This enables Tenancy DAX calculated columns to count and flag matched referrals.

---

## Related Measures

This table is primarily consumed by **DAX calculated columns on the Tenancy table**, including:

- **Referral Count**: Count of matching referrals per tenancy from this bridge
- **Has Matching Referrals**: Boolean flag indicating whether the tenancy has at least one matching referral

The bridge pattern avoids a direct many-to-many relationship between Tenancy and TH Referrals, providing a clean path for referral-related calculations at the tenancy grain.
