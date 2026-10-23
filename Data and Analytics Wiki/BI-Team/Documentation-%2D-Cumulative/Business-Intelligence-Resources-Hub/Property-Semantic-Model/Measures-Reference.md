# Property Semantic Model - Measures Reference

## Table of Contents

1. [Overview](#overview)
2. [01. Property Portfolio](#01-property-portfolio)
3. [02. Tenancy](#02-tenancy)
4. [03. Tenant](#03-tenant)
5. [04. Financial](#04-financial)
6. [05. Maintenance](#05-maintenance)
7. [06. Inspections](#06-inspections)
8. [07. Healthy Homes](#07-healthy-homes)
9. [08. Void Management](#08-void-management)
10. [09. THVM Dashboard](#09-thvm-dashboard)
11. [10. Tenant Demographics](#10-tenant-demographics)
12. [Other Measures](#other-measures)
13. [Common Patterns](#common-patterns)

---

## Overview

The Property Semantic Model contains **241 DAX measures** organized into 10 display folders (plus subfolders). All measures are defined in the `Measures` table -- a single-row calculated table using `ROW("Placeholder", 0)`.

**Source file:** `Self Service Semantic Models\Property Semantic Model.SemanticModel\definition\tables\Measures.tmdl`

| Folder | Subfolders | Measure Count |
|--------|-----------|---------------|
| 01. Property Portfolio | Current Snapshot, By Program, Date-Aware, Timeline | 26 |
| 02. Tenancy | By Status, Bond, Arrears | 16 |
| 03. Tenant | Income, Demographics | 8 |
| 04. Financial | Rent, Utilities, Damages, Arrears, Write-Offs, Balances, Other Charges, Grants | 27 |
| 05. Maintenance | By Urgency, Completion, Liability | 17 |
| 06. Inspections | By Status, By Category | 10 |
| 07. Healthy Homes | Insulation, Ventilation, Draught Stopping, Moisture & Drainage, Heating | 17 |
| 08. Void Management | By Category, Duration KPIs, Target Performance, Workflow Stage, Milestones, Trends | 30 |
| 09. THVM Dashboard | Service Flows, Occupancy, Exits, Length of Stay, Continuous Length Of Stay | 47 |
| 10. Tenant Demographics | Ethnicity, Gender, Data Quality | 12 |
| (root) | -- | 1 |

---

## Other Measures

| Measure Name | Format | Display Folder | Primary Tables | Description |
|-------------|--------|---------------|---------------|-------------|
| Last Refreshed | dd/MM/yyyy HH:mm:ss | _(root)_ | -- | Date and time when the semantic model was last refreshed (NZ time). Calculates UTC+12 or UTC+13 based on NZ daylight saving rules. |

---

## 01. Property Portfolio

### Root

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Total Properties | #,0 | Total count of all properties in the portfolio. |
| Properties Vacant Tenantable | #,0 | Count of vacant properties that are ready to be let (tenantable condition). |
| Properties Vacant Untenantable | #,0 | Count of vacant properties not ready to be let (require maintenance or other work). |
| Avg Days Vacant | #,0.0 | Average number of days properties have been vacant. |
| Total Days Vacant | #,0 | Sum of all vacancy days across all properties. |
| Avg Days Under Maintenance | #,0.0 | Average number of days properties are under maintenance and unavailable for letting. |
| Avg Current Rent | $#,0.00 | Average weekly rent across all properties. |
| Total Current Rent (Weekly) | $#,0.00 | Total weekly rent across all properties in the current filter context. |
| Total IRRS Subsidy | $#,0.00 | Total Income Related Rent Subsidy amount across properties. |
| Avg Max Occupancy | #,0.0 | Average maximum occupancy allowed across properties. |

### Current Snapshot

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Properties Occupied | #,0 | Count of properties currently occupied by tenants. |
| Total Properties Vacant | #,0 | Total count of all vacant properties (both tenantable and untenantable). |
| Occupancy Rate % | 0.0% | Percentage of properties that are currently occupied. Occupied / Total Properties. |
| Vacancy Rate % | 0.0% | Percentage of properties that are currently vacant. Vacant / Total Properties. |

### By Program

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Properties - Transitional Housing | #,0 | Count of Transitional Housing properties. |
| Properties - IRRS | #,0 | Count of Income Related Rent Subsidy (IRRS) properties. |
| Properties - Commercial Lease | #,0 | Count of Commercial Lease properties. |
| Properties - Affordable Housing | #,0 | Count of Affordable Housing properties (includes Affordable Rental and Affordable Housing Management). |

### Date-Aware

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Active Properties (Period) | #,0 | Count of properties active at any point during the selected date range. A property is active if Acquired Date <= period end and Confirmed Disposal Date (if any) >= period start. |
| Available Property Days (Period) | #,0 | Total days properties were available (active) within the selected period, clamped to Acquired/Disposal dates. |
| Occupied Days (Period) | #,0 | Sum of occupied days across all properties within the selected period. Respects property lifecycle dates and excludes cancelled tenancies. |
| Unoccupied Days (Period) | #,0 | Total unoccupied days within the selected period. Available Property Days minus Occupied Days. |
| Occupancy Rate (Period) % | 0.00% | Percentage of available property days that were occupied. Occupied Days / Available Property Days. |
| Property Status at Date | _(text)_ | Returns status of a single property at the selected date: "Occupied", "Unoccupied", or "Not Active". |

### Timeline

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Timeline Total Void Days | #,0 | Sum of Days Interval for all void intervals across the current filter context. |
| Timeline Total Tenancy Days | #,0 | Sum of Days Interval for all tenancy intervals across the current filter context. |
| Timeline Avg Void Days | #,0.0 | Average void duration across the current filter context. |
| Timeline Avg Gap Days | #,0.0 | Average gap between consecutive intervals regardless of record type. |
| Timeline Void Days (Period) | #,0 | Date-aware void days. Clamps each void interval to the selected Date Table period and sums overlapping days. |
| Timeline Tenancy Days (Period) | #,0 | Date-aware tenancy days. Clamps each tenancy interval to the selected Date Table period and sums overlapping days. |

---

## 02. Tenancy

### Root

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Total Tenancies | #,0 | Total count of all tenancy records (includes historical). |
| Active Tenancies | #,0 | Count of currently active tenancies (includes those in arrears). Statuses: New, Active, Active Arrears. |
| Active Tenancies In Arrears % | 0.0% | Percentage of active tenancies that are in arrears. |
| Total Rent (Tenancy) | $#,0.00 | Total weekly rent from all tenancies in the current filter context. |
| Avg Rent Per Tenancy | $#,0.00 | Average weekly rent per tenancy. |
| Avg Tenancy Signatories | #,0.0 | Average number of signatories (adults) per tenancy. |
| Tenancies With Notice To Vacate | #,0 | Count of tenancies where notice to vacate has been issued. |
| Active Tenancies in Period | #,0 | Count of tenancies active at any point during the selected period from Date Table. Excludes Cancelled. Uses Date Table as disconnected slicer. |

### By Status

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Tenancies - Active (Current) | #,0 | Count of active tenancies with no arrears. |
| Tenancies - Active Arrears | #,0 | Count of active tenancies currently in arrears. |
| Tenancies - Vacated | #,0 | Count of tenancies where tenant has vacated but account not yet closed. |
| Tenancies - Vacated Arrears | #,0 | Count of vacated tenancies with outstanding arrears. |
| Tenancies - Vacated Closed | #,0 | Count of fully closed tenancy accounts. |
| Tenancies - Cancelled | #,0 | Count of cancelled tenancies. |
| Tenancies - New | #,0 | Count of new tenancies being set up. |

### Bond

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Tenancies With Bond Lodged | #,0 | Count of tenancies with bond lodged with Tenancy Services. |

### Arrears

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Tenancies With Arrears Arrangement | #,0 | Count of tenancies with an active arrears repayment arrangement. |

---

## 03. Tenant

### Root

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Total Tenants | #,0 | Total count of all tenant records (includes household members). |
| Primary Tenants | #,0 | Count of primary tenants (main lease signatories). |
| Household Members | #,0 | Count of household members (non-primary occupants). |
| Avg Household Size | #,0.0 | Average number of people per household. |

### Income

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Total Household Income | $#,0.00 | Sum of total household income for all tenants. |
| Avg Household Income | $#,0.00 | Average household income across all tenants. |

### Demographics

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Tenants With Disability | #,0 | Count of tenants with a recorded disability. Excludes "None" and "No". |
| Tenants Employed | #,0 | Count of tenants who are employed. Includes Employed, Full Time, Part Time, Self Employed. |

---

## 04. Financial

### Root

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Total Transactions | #,0 | Total count of all financial transactions. |
| Transaction Amount | $#,0.00 | Sum of all transaction amounts. Charges are negative, payments are positive. |

### Rent

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Rent Charged | $#,0.00 | Total rent charged (negative value represents charges to tenants). |
| Rent Payments | $#,0.00 | Total rent payments received (positive value). |
| Rent Adjustments CR | $#,0.00 | Total rent credit adjustments. |
| Rent Adjustments DR | $#,0.00 | Total rent debit adjustments. |
| Rent Refunds | $#,0.00 | Total rent refunds issued. Includes "Refund of Rent" and "Refund of Rent (Motels)". |
| Net Rent Position | $#,0.00 | Net rent position (charges + payments + adjustments). Positive = overpaid, Negative = arrears. |

### Utilities

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Electricity Charged | $#,0.00 | Total electricity charges. |
| Electricity Payments | $#,0.00 | Total electricity payments received. |
| Water Charged | $#,0.00 | Total water usage charges. |
| Water Payments | $#,0.00 | Total water usage payments received. |
| Internet Charged | $#,0.00 | Total internet access charges. |
| Internet Payments | $#,0.00 | Total internet access payments received. |

### Damages

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Client Damages Charged | $#,0.00 | Total client damage charges (includes meth contamination). |
| Client Damages Payments | $#,0.00 | Total client damage payments received (includes meth). |

### Arrears

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Arrears Payments - Rent | $#,0.00 | Total arrears payments received for rent. |
| Arrears Payments - Utilities | $#,0.00 | Total arrears payments received for utilities. Includes water and cleaning. |
| Arrears Payments - Tenant Liability | $#,0.00 | Total arrears payments for tenant liability charges. |

### Write-Offs

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Bad Debt Write-Off - Rent | $#,0.00 | Total rent written off as bad debt. |
| Bad Debt Write-Off - Utilities | $#,0.00 | Total utilities written off as bad debt. |
| Bad Debt Write-Off - Tenant Liability | $#,0.00 | Total tenant liability written off as bad debt. |
| Total Bad Debt Written Off | $#,0.00 | Total amount written off as bad debt across all categories. |

### Balances

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Current Rent Balance | $#,0.00 | Current rent balance across all tenancies. Negative = arrears, Positive = credit. |
| Current Non-Rent Balance | $#,0.00 | Current non-rent balance (utilities, damages, etc.) across all tenancies. |
| Current Total Balance | $#,0.00 | Current total balance (rent + non-rent) across all tenancies. |
| Tenancies With Current Balance | #,0 | Count of tenancies with a recorded balance. |

### Other Charges

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Lawns & Gardens Charged | $#,0.00 | Total lawns and garden maintenance charges (includes responsive). |
| Lawns & Gardens Payments | $#,0.00 | Total lawns and garden maintenance payments received. |
| Cleaning Charged | $#,0.00 | Total cleaning charges. |

### Grants

| Measure Name | Format | Description |
|-------------|--------|-------------|
| SNG Grants Applied | $#,0.00 | Total Sustaining Tenancies (SNG) grants applied to tenant accounts. Includes rent and non-rent grants. |

---

## 05. Maintenance

### Root

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Total Maintenance Work Orders | #,0 | Total count of all maintenance work orders. |
| Active Maintenance Work Orders | #,0 | Count of currently active maintenance work orders. |
| Inactive Maintenance Work Orders | #,0 | Count of inactive (completed/closed) maintenance work orders. |
| Total Maintenance Tasks | #,0 | Total count of individual maintenance tasks. |
| Total Maintenance Cost | $#,0.00 | Total cost of all maintenance tasks. |
| Avg Maintenance Task Cost | $#,0.00 | Average cost per maintenance task. |
| Maintenance - Cancelled | #,0 | Count of cancelled maintenance work orders. |
| Maintenance - On Hold | #,0 | Count of maintenance work orders currently on hold. |

### By Urgency

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Maintenance - Emergency | #,0 | Count of emergency priority maintenance work orders. |
| Maintenance - Urgent | #,0 | Count of urgent priority maintenance work orders. |
| Maintenance - Standard | #,0 | Count of standard priority maintenance work orders. |
| Maintenance - Cyclical | #,0 | Count of cyclical/planned maintenance work orders. |

### Completion

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Maintenance Completed By Contractor | #,0 | Count of maintenance work orders marked completed by contractor. |
| Maintenance Post Inspection Done | #,0 | Count of maintenance work orders with post-completion inspection done. |
| Maintenance Completed Satisfactorily | #,0 | Count of maintenance work orders completed to satisfactory standard. |
| Maintenance Confirmed For Payment | #,0 | Count of maintenance work orders confirmed for payment. |
| Maintenance Finalised | #,0 | Count of maintenance work orders fully finalised. |

### Liability

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Maintenance - Tenant Damage | #,0 | Count of maintenance work orders due to tenant damage. |
| Maintenance - Tenant Liable | #,0 | Count of maintenance work orders where tenant is liable for costs. |
| Maintenance - Tenants Charged | #,0 | Count of maintenance work orders where tenants have been charged. |

---

## 06. Inspections

### Root

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Total Inspections | #,0 | Total count of all property inspections. |
| Inspection Completion Rate % | 0.0% | Percentage of non-cancelled inspections that are completed. |
| Inspections With Tenant Present | #,0 | Count of inspections where the tenant was present. |

### By Status

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Inspections Completed | #,0 | Count of completed inspections. |
| Inspections New/Pending | #,0 | Count of new/pending inspections. |
| Inspections Cancelled | #,0 | Count of cancelled inspections. |
| Inspections With Work Task Created | #,0 | Count of inspections that resulted in maintenance work tasks (fully or partially created). |

### By Category

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Inspections - Routine | #,0 | Count of routine tenancy inspections. |
| Inspections - Tenancy Report | #,0 | Count of tenancy inspection reports (move-in/move-out). |
| Inspections - Property Condition | #,0 | Count of property condition report inspections. |

---

## 07. Healthy Homes

### Root

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Total Healthy Homes Records | #,0 | Total count of properties with Healthy Homes compliance data. |
| HH - Generally Exempt | #,0 | Count of properties with general exemption from Healthy Homes Standards. |
| HH - With Compliance Date | #,0 | Count of properties with a recorded Healthy Homes compliance date. |
| HH - Compliance Rate % | 0.0% | Percentage of non-exempt properties with Healthy Homes compliance. |

### Insulation

| Measure Name | Format | Description |
|-------------|--------|-------------|
| HH - Has Ceiling Insulation | #,0 | Count of properties with ceiling insulation installed. |
| HH - Ceiling Insulation Exempt | #,0 | Count of properties exempt from ceiling insulation requirements. |
| HH - Ceiling Insulation Meets Standard | #,0 | Count of properties where ceiling insulation meets the Healthy Homes Standard. |
| HH - Has Underfloor Insulation | #,0 | Count of properties with underfloor insulation installed. |
| HH - Has Wall Insulation | #,0 | Count of properties with wall insulation installed. |
| HH - Avg Ceiling R-Value | #,0.00 | Average ceiling insulation R-Value. |
| HH - Avg Underfloor R-Value | #,0.00 | Average underfloor insulation R-Value. |

### Ventilation

| Measure Name | Format | Description |
|-------------|--------|-------------|
| HH - Has Bathroom Extractor | #,0 | Count of properties with bathroom extractor fan. |
| HH - Has Kitchen Extractor | #,0 | Count of properties with kitchen extractor fan. |
| HH - Bathroom Ventilation Compliant | #,0 | Count of properties with compliant bathroom ventilation. |
| HH - Kitchen Ventilation Compliant | #,0 | Count of properties with compliant kitchen ventilation. |

### Draught Stopping

| Measure Name | Format | Description |
|-------------|--------|-------------|
| HH - Is Draught Free | #,0 | Count of properties that are draught-free. |

### Moisture & Drainage

| Measure Name | Format | Description |
|-------------|--------|-------------|
| HH - Has Subfloor Moisture Barrier | #,0 | Count of properties with subfloor moisture barrier. |
| HH - Has Adequate Guttering | #,0 | Count of properties with adequate guttering. |

### Heating

| Measure Name | Format | Description |
|-------------|--------|-------------|
| HH - Avg Main Heat Source (kW) | #,0.0 | Average main heat source capacity in kilowatts. |
| HH - Avg Required Heating (kW) | #,0.0 | Average required heating capacity in kilowatts. |

---

## 08. Void Management

### Root

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Total Voids | _(default)_ | Total count of all void checklist records. Includes NEW*, ROUT/ROTH, and RTLL voids. |
| Active Voids | _(default)_ | Count of voids currently in progress (Void Completed Date is blank). |
| Completed Voids | _(default)_ | Count of voids that have been fully completed. |
| Void Completion Rate % | 0.0% | Percentage of all voids that have been completed. |

### By Category

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Voids - New Property | _(default)_ | Count of new property onboarding voids (NEWC/NEWR/NEWS/NEWT/NEWP). |
| Voids - Turnover | _(default)_ | Count of routine turnover voids (ROUT for standard, ROTH for transitional housing). |
| Voids - Return to Landlord | _(default)_ | Count of Return To Landlord/Lease voids (RTLL). Properties being handed back. |
| Voids - Transitional Housing | _(default)_ | Count of transitional housing related voids (NEWT, ROTH). |

### Duration KPIs

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Avg Void Duration Days | 0.0 | Average days from void creation to completion. Key KPI for turnaround performance. |
| Avg Days Key to Tenantable | 0.0 | Average days from receiving keys from vacating tenant to property being ready. Critical turnaround metric. |
| Total Void Days | #,##0 | Sum of all void duration days across completed voids. Total lost tenancy days. |
| Current Void Age Days | 0.0 | Average age in days of currently active (incomplete) voids. |
| Avg Days Assessment to Repairs | 0.0 | Average days from assessment completion to repairs completion. |
| Avg Days Ready to Offer Accepted | 0.0 | Average days from property ready to tenant offer accepted. |

### Target Performance

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Voids On Target | _(default)_ | Count of completed voids that met their target completion date. |
| Voids Over Target | _(default)_ | Count of completed voids that exceeded their target completion date. |
| Void Target Met % | 0.0% | Percentage of voids completed on or before target date. |
| Avg Days Over Target | 0.0 | Average days by which overdue voids exceeded their target. |
| Voids Overdue | _(default)_ | Count of active voids that have passed their target completion date. |
| Voids At Risk | _(default)_ | Count of active voids with target completion date within the next 7 days. |

### Workflow Stage

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Voids Awaiting Assessment | _(default)_ | Count of active voids where initial assessment and scoping has not yet been completed. |
| Voids Awaiting Repairs | _(default)_ | Count of active voids assessed but repairs not yet complete. |
| Voids Ready for Allocation | _(default)_ | Count of voids where property is ready (Vacant:Tenantable) but no offer accepted yet. |
| Voids Awaiting Move-In | _(default)_ | Count of voids where offer accepted and lease signed, awaiting tenant move-in. |

### Milestones

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Pre-Vacate Inspections Done | _(default)_ | Count of voids where pre-vacate inspection was completed. |
| Final Inspections Done | _(default)_ | Count of voids where final inspection was completed after keys received. |
| Safety Checks Completed | _(default)_ | Count of voids where safety compliance check was completed. |
| Properties Made Tenantable | _(default)_ | Count of voids where property was converted to Vacant:Tenantable. |
| BOS Listings Completed | _(default)_ | Count of voids where property vacancy was listed in BOS. |
| Tenant Offers Accepted | _(default)_ | Count of voids where tenant offer was confirmed and accepted. |
| Bond Recoveries Processed | _(default)_ | Count of voids where bond recovery forms were completed. |
| Compliance Issues Resolved | _(default)_ | Count of voids where all compliance issues were resolved. |
| Leases Signed | _(default)_ | Count of voids where signed lease/tenancy agreement was received. |

### Trends

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Voids Created This Month | _(default)_ | Count of new voids created in the current month. |
| Voids Completed This Month | _(default)_ | Count of voids completed in the current month. |
| Net Void Movement | _(default)_ | Net change in void volume this month. Positive = reducing backlog. Negative = growing. |

---

## 09. THVM Dashboard

The THVM (Transitional Housing Vacancy Management) Dashboard folder contains measures aligned with HUD (Ministry of Housing and Urban Development) reporting requirements.

### Service Flows

| Measure Name | Format | Description |
|-------------|--------|-------------|
| TH Households Entered This Month | #,0 | Count of unique TH households (primary tenants) that genuinely entered during the selected month. Uses chain logic: only counts tenancies where Is New Chain = 1. Internal transfers (gap <=3 days) are NOT counted as new entries. |
| TH Households Serviced (12M) | #,0 | Count of unique TH chains (households) active at any point during the rolling 12-month period. Uses chain-level summary with Chain Start Date and Max Vacated Date. |
| TH Households With Transfer Activity | #,0 | Count of TH tenancies in the selected month where Leaving Reason = "Internal transfer between Emerge services". These are excluded from exit counts. |
| TH Rate MSD Referrals Monthly % | 0.0% | Placeholder -- returns BLANK. Referral source data not yet available. |
| TH Rate MSD Referrals Yearly % | 0.0% | Placeholder -- returns BLANK. Referral source data not yet available. |
| TH Avg Household Turnover (12M) | #,0.00 | Average distinct households per property over rolling 12 months. Counts pre-existing household plus new chain starts. Higher = more movement, lower = longer stays. |

> **Business Logic -- Chain-Based Household Counting:** A "chain" groups consecutive TH tenancies for the same tenant where the gap between vacating one property and starting the next is 3 days or fewer. The `Is New Chain` flag on the Tenancy table identifies the first tenancy in each chain. This prevents internal transfers from being double-counted as new service entries.

### Occupancy

| Measure Name | Format | Description |
|-------------|--------|-------------|
| TH Places Contracted | #,0 | Total count of all TH properties regardless of occupancy status. |
| TH Places Occupied at Month End | #,0 | Count of TH properties with Status = OCCUPIED. |
| TH Monthly Occupancy Rate % | 0.0% | Occupancy rate: (Places Occupied / Places Contracted) x 100. |
| TH Places Unoccupied (Period) | #,0 | Count of TH properties unoccupied at END of selected date range. Builds virtual table of TH properties and checks for active tenancy at reference date. |
| TH Places Unoccupied >20 Days | #,0 | Count of TH properties where total unoccupied days in the selected date range exceeds 20. |
| TH Avg Weekly Contribution (Occupied) | $#,0.00 | Average weekly rent contribution across occupied TH properties. |
| TH Max Weekly Contribution (Occupied) | $#,0.00 | Maximum weekly rent contribution among occupied TH properties. |
| TH Property Unoccupied Days | #,0 | Total days TH properties were unoccupied within the selected Date Table filter context. Sums unoccupied days across all TH properties. |
| Occupied Bed Nights (Period) | #,0 | Total occupied bed nights across all properties during the selected period. Sums overlapping tenancy days per property. |
| TH Avg Time to Fill Days (12M) | #,0 | Average days between a household vacating and the next moving in, over rolling 12 months. |

> **Business Logic -- Unoccupied Calculations:** These measures build virtual property tables filtered to TH, then cross-reference all tenancies (using `ALL('Tenancy')`) to calculate occupied days per property within the period, subtracting from total period days to get unoccupied days.

### Exits

| Measure Name | Format | Description |
|-------------|--------|-------------|
| TH Exits This Month | #,0 | Count of TH tenancies with Vacated Date in the selected month. Excludes internal transfers. |
| TH Exits Last 3 Months | #,0 | Count of TH exits in the 3 calendar months ending at the selected date. Excludes internal transfers. |
| TH Exits Last 12 Months | #,0 | Count of TH exits in the 12 calendar months ending at the selected date. Excludes internal transfers. |
| TH Exits (Period) | #,0 | Total TH exits in the selected date period, excluding internal transfers. |
| TH Monthly Exit Rate % | 0.0% | Monthly exit rate: Exits in month / Households serviced in month. |
| TH Positive Exit Rate % | 0.0% | Percentage of exits that are Positive (long-term sustainable housing). Leaving Reasons: Social Housing, Private Rental. Exit Points: Private Market Rental, Community Housing Provider, Kainga Ora. |
| TH Negative Exit Rate % | 0.0% | Percentage of exits that are Negative. Leaving Reasons: Arrested, Client was asked to leave / evicted, Return to EH Motel, Unknown reason. Exit Points: Unknown, Correctional Facility. |
| TH Neutral Exit Rate % | 0.0% | Percentage of exits that are Neutral. Leaving Reasons: Care Facility, Deceased, Other, Other Accommodation. Exit Points: Family/Whanau Home, Transitional Housing, Other, Mental Health Inpatient, Boarding House, Overseas, Aged Care, Emergency Accommodation. |
| TH Positive Exits (12M) | #,0 | Count of Positive exits in the 12 months ending at the selected date. |
| TH Negative Exits (12M) | #,0 | Count of Negative exits in the 12 months ending at the selected date. |
| TH Positive Exits (Period) | #,0 | Positive TH exits (Social Housing, Private Rental) in the selected date period. |
| TH Negative Exits (Period) | #,0 | Negative TH exits (Arrested, Evicted, Return to EH Motel, Unknown) in the selected date period. |
| TH Neutral Exits (Period) | #,0 | Neutral TH exits (Care Facility, Deceased, Other, Other Accommodation) in the selected date period. |
| TH Positive Exit Rate (Period) % | 0.0% | Percentage of exits that are positive in the selected date period. |
| TH Negative Exit Rate (Period) % | 0.0% | Percentage of exits that are negative in the selected date period. |
| TH Neutral Exit Rate (Period) % | 0.0% | Percentage of exits that are neutral in the selected date period. |
| TH Exited Short Stay (12M) | #,0 | Count of chain exits (12M) where chain duration was 1-84 days (0-12 weeks). |
| TH Exited Medium Stay (12M) | #,0 | Count of chain exits (12M) where chain duration was 85-364 days (12-52 weeks). |
| TH Exited Long Stay (12M) | #,0 | Count of chain exits (12M) where chain duration was 365-728 days (53-104 weeks). |
| TH Exited Ultra-Long Stay (12M) | #,0 | Count of chain exits (12M) where chain duration was 729+ days (>104 weeks). |

> **Business Logic -- Exit Classification:** All exit measures use dual-column logic: first checks `Leaving Reason`, and if blank, falls back to `Exit Point`. Internal transfers are always excluded (Leaving Reason = "Internal transfer between Emerge services" OR Exit Point = "Internal Transfer"). Stay duration measures use chain-level calculation with DATEDIFF from Chain Start Date to final Vacated Date and inclusive day counting.

### Length of Stay

| Measure Name | Format | Description |
|-------------|--------|-------------|
| TH Avg Stay Weeks (Exited 12M) | #,0.0 | Median length of stay in weeks for TH chains that exited in the 12 months ending at selected date. Uses MEDIAN per HUD standards. |
| TH Avg Stay Weeks (In Service) | #,0.0 | Median length of stay in weeks for TH chains IN SERVICE as of the selected date. Uses GROUPBY for chain aggregation. |
| TH Max Stay Weeks (Exited 12M) | #,0.0 | Maximum length of stay in weeks for TH chains that exited in the past 12 months. |
| TH Max Stay Weeks (In Service) | #,0.0 | Maximum length of stay in weeks for TH chains currently in service. |
| TH Households Still in Service | #,0 | Count of unique TH chains in service as of the selected date. |
| TH In Service - Short Stay % | 0.0% | Percentage of in-service chains with 0-12 weeks stay. |
| TH In Service - Medium Stay % | 0.0% | Percentage of in-service chains with 12-52 weeks stay. |
| TH In Service - Long Stay % | 0.0% | Percentage of in-service chains with 52-104 weeks stay. |
| TH In Service - Ultra-Long Stay % | 0.0% | Percentage of in-service chains with >104 weeks stay. |
| TH Avg Exit Time by Stay (Weeks) | #,0.0 | Median exit time in weeks filtered by Stay Category slicer (Short/Medium/Long/Ultra-Long). Uses SELECTEDVALUE on Stay Category table. |
| Stay Chain Gap Check | _(text)_ | Displays gap status: "First Tenancy", "Continuous (X days gap)", or "New Chain (X days gap)". For row-level context with Tenancy table. |
| Total Length of Stay (Days) | #,0 | Total continuous length of stay in days from chain start date to selected month end. Uses pre-calculated Chain Start Date column from SQL. |

> **Business Logic -- GROUPBY vs SUMMARIZE:** In-service measures use GROUPBY with CURRENTGROUP() aggregations for chain-level calculations, which is more memory-efficient. Exited measures use SUMMARIZE + ADDCOLUMNS pattern to look up the last leaving reason for each chain. Both patterns group tenancies by Chain ID + Tangata Whaiora ID.

### Continuous Length Of Stay

| Measure Name | Format | Description |
|-------------|--------|-------------|
| TH Short Stay % (Grand Total) | 0.0% | Grand total Short Stay %, filtered to properties with Occupied Bed Nights > 0. |
| TH Medium Stay % (Grand Total) | 0.0% | Grand total Medium Stay %, filtered to properties with Occupied Bed Nights > 0. |
| TH Long Stay % (Grand Total) | 0.0% | Grand total Long Stay %, filtered to properties with Occupied Bed Nights > 0. |
| TH Ultra-Long Stay % (Grand Total) | 0.0% | Grand total Ultra-Long Stay %, filtered to properties with Occupied Bed Nights > 0. |
| TH Continuous Length Of Stay (12M) | #,0 | Grand total TH Households Serviced (12M), filtered to tenancies with Occupied Bed Nights > 0. |

---

## 10. Tenant Demographics

### Root

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Total Active Tenants (Date Filtered) | _(default)_ | Count of primary tenants whose tenancy overlaps with the selected date range. Falls back to all primary tenants if no date filter applied. |

### Ethnicity

All ethnicity measures follow the same pattern: filter primary tenants active during the selected Date Table range, count those matching ethnicity value sets.

| Measure Name | Format | Ethnicity Values |
|-------------|--------|-----------------|
| Tenants - Maori | _(default)_ | Maori, New Zealand Maori |
| Tenants - Pacific Peoples | _(default)_ | Samoan, Tongan, Cook Island Maori, Niuean, Tokelauan, Fijian, Pacific Peoples, Pacific Islander, Other Pacific Peoples |
| Tenants - European/Pakeha | _(default)_ | NZ European, New Zealand European, European, Pakeha, Other European, British, Australian, Dutch, German, Irish, South African |
| Tenants - Asian | _(default)_ | Chinese, Indian, Filipino, Korean, Japanese, Vietnamese, Thai, Cambodian, Malaysian, Indonesian, Asian, Other Asian, Southeast Asian |
| Tenants - Other Ethnicity | _(default)_ | Any ethnicity not in the above four groups and not blank |
| Tenants - Ethnicity Not Recorded | _(default)_ | NULL/blank ethnicity. Data quality indicator. |

### Gender

All gender measures follow the same pattern as ethnicity measures.

| Measure Name | Format | Gender Values |
|-------------|--------|--------------|
| Tenants - Wahine (Female) | 0 | Wahine/Female |
| Tenants - Tane (Male) | 0 | Tane/Male |
| Tenants - Other Gender | 0 | Any gender not Female, Male, or Unspecified/Unknown and not blank |
| Tenants - Gender Not Recorded | 0 | NULL, blank, or Unspecified/Unknown. Data quality indicator. |

### Data Quality

| Measure Name | Format | Description |
|-------------|--------|-------------|
| Ethnicity Data Completeness % | 0.0% | Percentage of active primary tenants with ethnicity recorded. (Total - Not Recorded) / Total. |
| Gender Data Completeness % | 0.0% | Percentage of active primary tenants with gender recorded. (Total - Not Recorded) / Total. |

---

## Common Patterns

### Date-Aware Measures with ISFILTERED Fallback

Many measures throughout the THVM Dashboard and Demographics folders use this pattern:

```dax
VAR _IsDateFiltered = ISFILTERED('Date Table')
VAR _ReferenceDate =
    IF(
        _IsDateFiltered,
        MAX('Date Table'[Calendar Date]),
        TODAY()
    )
```

When the Date Table slicer is applied, the measure uses the selected date range. When no date filter is applied, it defaults to TODAY(). This allows the same measure to work as both a historical analysis tool and a current-state indicator.

### Chain-Based Household Logic (THVM Dashboard)

A "chain" is a sequence of Transitional Housing tenancies for the same tenant where the gap between vacating one property and starting the next is **3 days or fewer**. Key columns on the Tenancy table:

- `Chain ID` -- unique identifier for the chain
- `Chain Start Date` -- earliest tenancy start date in the chain
- `Is New Chain` -- flag (1/0) indicating whether this tenancy starts a new chain
- `Gap Days` -- days between previous vacate and current start
- `Prev Vacate Date` -- previous tenancy's vacated date

Chain measures use two aggregation patterns:
- **GROUPBY** (for in-service snapshots): Groups by Chain ID with CURRENTGROUP() aggregations
- **SUMMARIZE + ADDCOLUMNS** (for exited chains): Summarizes chains then adds last leaving reason via filtered lookup

### Exit Classification (Positive / Negative / Neutral)

All exit measures use a dual-column approach:
1. First check `Leaving Reason` column
2. If blank, fall back to `Exit Point` column

| Category | Leaving Reasons | Exit Points (fallback) |
|----------|----------------|----------------------|
| **Positive** | Social Housing, Private Rental | Private Market Rental, Community Housing Provider, Kainga Ora |
| **Negative** | Arrested, Client was asked to leave / evicted, Return to EH Motel, Unknown reason | Unknown, Correctional Facility |
| **Neutral** | Care Facility, Deceased, Other, Other Accommodation | Family/Whanau Home, Transitional Housing, Other, Mental Health Inpatient (Hospital), Boarding House, Overseas, Aged Care, Emergency Accommodation (MSD) |

**Always excluded:** "Internal transfer between Emerge services" (Leaving Reason) and "Internal Transfer" (Exit Point).

### Stay Duration Categories

| Category | DATEDIFF Range | Inclusive Days | Weeks |
|----------|---------------|---------------|-------|
| Short | 0-83 | 1-84 days | 0-12 weeks |
| Medium | 84-363 | 85-364 days | 12-52 weeks |
| Long | 364-727 | 365-728 days | 53-104 weeks |
| Ultra-Long | 728+ | 729+ days | >104 weeks |

The `Stay Category` slicer table provides a user-friendly filter used by `TH Avg Exit Time by Stay (Weeks)` via SELECTEDVALUE.

### Financial Transaction Types

Charges are negative amounts, payments are positive amounts. The `Net Rent Position` measure sums all rent-related transaction types (charged + payments + CR adjustments + DR adjustments + refunds).

### Demographic Measures with Date Filtering

All ethnicity and gender measures use this pattern:
1. If no Date Table filter: count all primary tenants matching the criteria
2. If Date Table filtered: count primary tenants whose tenancy overlaps the date range (started before end AND not vacated before start), using `REMOVEFILTERS('Date Table')` to prevent the Date Table filter from affecting the Tenant/Tenancy relationship

---

_Last updated: 2026-02-02_
_Source: Property Semantic Model TMDL definition (3,888 lines, 241 measures)_
