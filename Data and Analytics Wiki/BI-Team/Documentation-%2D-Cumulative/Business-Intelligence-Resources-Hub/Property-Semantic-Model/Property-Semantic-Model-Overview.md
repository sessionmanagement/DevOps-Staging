# Property Semantic Model Overview

## Table of Contents
1. [Model Purpose](#model-purpose)
2. [Architecture](#architecture)
3. [Star Schema Diagram](#star-schema-diagram)
4. [Table Inventory](#table-inventory)
5. [Measure Folders](#measure-folders)
6. [Data Classification Summary](#data-classification-summary)
7. [Table Documentation Links](#table-documentation-links)

---

## Model Purpose

The Property Semantic Model provides property portfolio management analytics for Emerge Aotearoa's social and transitional housing operations. It supports analysis of:

- Property portfolio composition, acquisition, and disposal
- Tenancy lifecycle management (start, occupancy, vacating)
- Void period tracking and turnaround times
- Property maintenance and inspection workflows
- Healthy Homes compliance status
- Transitional Housing referral-to-tenancy linkage and audit
- Financial transactions at the tenancy level
- Property timeline analysis (void vs tenancy intervals over time)

---

## Architecture

| Property | Value |
|----------|-------|
| **EDW Server** | `sql-prod-aus-svc-datawarehouse-01.database.windows.net` |
| **EDW Database** | `sqldb-prod-datawarehouse-01` |
| **Refresh Schedule** | Daily, 6:30 - 7:30 AM NZT |
| **Table Count** | 18 tables (8 dimensions, 5 facts, 4 calculated, 1 slicer) |
| **Measure Count** | ~240 measures across 10+ display folders |
| **Model Format** | Power BI Project (.pbip) with TMDL definition |
| **Failure Alerts** | `bItasks@emergeaotearoa.org.nz` |

---

## Star Schema Diagram

:::mermaid
erDiagram
    Property ||--o{ Tenancy : "Property ID"
    Property ||--|| "Healthy Homes" : "Property ID"
    Property ||--o{ "Void Checklist" : "Property ID"
    Property ||--o{ "Property Maintenance Task" : "Property ID"
    Property ||--o{ "Property Timeline" : "Property ID"
    Tenancy ||--o{ Tenant : "Property Tenancy ID"
    Tenancy ||--o{ "Tenancy Transaction" : "Property Tenancy ID"
    Tenancy ||--o{ "Property Inspection" : "Property Tenancy ID"
    Tenancy ||--o{ "Tenancy Referral Bridge" : "Property Tenancy ID"
    Tenancy }o--|| Client : "Tangata Whaiora ID"
    Client ||--o{ "TH Referrals" : "Tangata Whaiora ID"
    "Property Maintenance" ||--o{ "Property Maintenance Task" : "Property Maintenance ID"
    "Property Maintenance Type" ||--o{ "Property Maintenance Task" : "Property Maintenance Type ID"
:::

---

## Table Inventory

### Dimension Tables (8)

| Table | Source | Description |
|-------|--------|-------------|
| Property | `edw.vw_dim_property` | Core property dimension with location, program, status |
| Tenancy | `edw.vw_dim_property_tenancy` | Tenancy lifecycle records |
| Tenant | `edw.vw_dim_property_tenant` | Individual tenant details |
| Client | `edw.vw_dim_client` | Tangata Whaiora (client) dimension |
| Healthy Homes | `edw.vw_dim_property_healthy_homes` | Healthy Homes compliance status per property |
| Property Maintenance | `edw.vw_dim_property_maintenance` | Maintenance work order headers |
| Property Maintenance Type | `edw.vw_dim_property_maintenance_type` | Maintenance type classification |
| Date | `edw.vw_dim_date` | Standard date dimension |

### Fact Tables (5)

| Table | Source | Description |
|-------|--------|-------------|
| Void Checklist | `edw.vw_fact_property_void_checklist` | Void period tracking and checklist items |
| Property Maintenance Task | `edw.vw_fact_property_maintenance_task` | Individual maintenance tasks |
| Property Inspection | `edw.vw_fact_property_inspection` | Property inspection records |
| Tenancy Transaction | `edw.vw_fact_property_tenancy_transaction` | Financial transactions per tenancy |
| TH Referrals | `edw.vw_fact_client_referral` | Transitional Housing referral records |

### Calculated Tables (4)

| Table | Source | Description |
|-------|--------|-------------|
| Tenancy Referral Bridge | DAX Calculated | Bridge linking tenancies to referrals via date overlap |
| Tenancy Referral Audit V2 | DAX Calculated | Audit table with match quality classification (improved) |
| Tenancy Referral Audit | DAX Calculated | Original audit table with simple client ID matching |
| Property Timeline | DAX Calculated | Chronological void/tenancy intervals per property |

### Slicer Tables (1)

| Table | Source | Description |
|-------|--------|-------------|
| Stay Category | DAX DATATABLE | Disconnected slicer for length-of-stay bands |

---

## Measure Folders

| Display Folder | Approx. Count | Description |
|----------------|---------------|-------------|
| 01. Property Portfolio | ~40 | Core portfolio metrics: counts, occupancy rates, acquisition/disposal |
| 01. Property Portfolio\Timeline | ~6 | Timeline-based void and tenancy day calculations |
| 02. Tenancy | ~30 | Tenancy lifecycle metrics: starts, exits, duration, turnover |
| 03. Voids | ~25 | Void period metrics: counts, duration, turnaround time |
| 04. Maintenance | ~20 | Maintenance task metrics: counts, completion rates, costs |
| 05. Inspections | ~15 | Inspection metrics: compliance rates, overdue counts |
| 06. Healthy Homes | ~15 | Healthy Homes compliance: pass/fail rates, statement status |
| 07. Financials | ~20 | Tenancy transaction metrics: rent, arrears, bonds |
| 08. TH Referrals | ~30 | Transitional Housing referral metrics: counts, match rates |
| 09. Audit | ~15 | Audit and data quality measures |
| 10. Helper | ~20 | Supporting measures: selected values, formatting, conditional logic |

---

## Data Classification Summary

| Badge | Level | Description |
|-------|-------|-------------|
| :green_circle: | Public | Non-sensitive operational data |
| :yellow_circle: | Internal | Internal business data |
| :red_circle: | Sensitive | Personal identifiable information |

| Table | Highest Classification | Key Sensitive Fields |
|-------|----------------------|---------------------|
| Property | :green_circle: Public | -- |
| Tenancy | :red_circle: Sensitive | Tangata Whaiora ID, Tenancy Name |
| Tenant | :red_circle: Sensitive | Tenant names, contact details |
| Client | :red_circle: Sensitive | Client ID, names |
| Healthy Homes | :green_circle: Public | -- |
| Property Maintenance | :green_circle: Public | -- |
| Property Maintenance Type | :green_circle: Public | -- |
| Date | :green_circle: Public | -- |
| Void Checklist | :green_circle: Public | -- |
| Property Maintenance Task | :green_circle: Public | -- |
| Property Inspection | :green_circle: Public | -- |
| Tenancy Transaction | :yellow_circle: Internal | Financial amounts |
| TH Referrals | :red_circle: Sensitive | Tangata Whaiora ID, Referrer Name |
| Tenancy Referral Bridge | :red_circle: Sensitive | Tangata Whaiora IDs, Referrer Name |
| Tenancy Referral Audit V2 | :red_circle: Sensitive | Tangata Whaiora IDs, names |
| Tenancy Referral Audit | :red_circle: Sensitive | Tangata Whaiora IDs, names |
| Property Timeline | :green_circle: Public | -- |
| Stay Category | :green_circle: Public | -- |

---

## Table Documentation Links

### Dimensions
- [Property](dim-Property)
- [Tenancy](dim-Tenancy)
- [Tenant](dim-Tenant)
- [Client](dim-Client)
- [Healthy Homes](dim-Healthy-Homes)
- [Property Maintenance](dim-Property-Maintenance)
- [Property Maintenance Type](dim-Property-Maintenance-Type)
- [Date](dim-Date)

### Facts
- [Void Checklist](fact-Void-Checklist)
- [Property Maintenance Task](fact-Property-Maintenance-Task)
- [Property Inspection](fact-Property-Inspection)
- [Tenancy Transaction](fact-Tenancy-Transaction)
- [TH Referrals](fact-TH-Referrals)

### Calculated Tables
- [Tenancy Referral Bridge](calc-Tenancy-Referral-Bridge)
- [Tenancy Referral Audit V2](calc-Tenancy-Referral-Audit-V2)
- [Tenancy Referral Audit](calc-Tenancy-Referral-Audit)
- [Property Timeline](calc-Property-Timeline)

### Slicer Tables
- [Stay Category](slicer-Stay-Category)
