# Row Level Security Procedures Summary

## Purpose
These three procedures build and refresh the email-driven Row Level Security (RLS) access matrix used by Power BI reports.

All three procedures generate access rows and load them into [edw].[row_level_security_general].  
The `RLS_Type` value on each row defines the final security category the row belongs to.

The five final `RLS_Type` categories are:

- `Employee`
- `Property`
- `Recordbase`
- `Service`
- `Tenancy`

These categories are used by Power BI reports to apply the correct row-level security rules for each reporting area.

The procedures map each user, by email address, to the records they are allowed to see based on organizational hierarchy, service ownership, property and tenancy ownership, and Record Base team mappings.

## Procedures and what they do

### 1. [edw].[update_row_level_security_kaimahi]
Builds the workforce and hierarchy side of RLS access.

- Uses employee hierarchy and current employee data to determine each person’s position in the reporting structure.
- Identifies people with no direct reports and adjusts access-level logic accordingly.
- Derives leadership and access tiers such as CEO, Exec, National, Regional, District, Service Manager/Team Leader, and non-charge staff.
- Produces employee-level visibility rules used to control what kaimahi-related data a user can view.
- Loads rows into [edw].[row_level_security_general] for the `Employee` RLS category.

### 2. [edw].[update_row_level_security_services]
Builds service, property, and tenancy access for non-Record Base reporting.

- Standardizes service metadata such as service, district, department, region, and company, and applies business fixes where needed.
- Joins employee hierarchy to service and allocation logic to determine who can see which services.
- Builds access sets for service-based reporting, including property and tenancy where relevant.
- Preserves Record Base rows and refreshes the non-Record Base rows in the general RLS table.
- Populates company, service, property, and property-tenancy keys and assigns employee hierarchy exclusion level.
- Loads rows into [edw].[row_level_security_general] for the `Service`, `Property`, and `Tenancy` RLS categories.

### 3. [edw].[update_row_level_security_recordbase]
Builds Record Base-specific access at client-team level.

- Starts from the same hierarchy and service foundation, then joins to client-team mappings.
- Applies district-manager-specific ranking and deduplication so district-level assignment behaves correctly.
- Produces Record Base rows at client-team granularity, with service and company context.
- Refreshes only Record Base rows in the general RLS table, leaving non-Record Base rows untouched.
- Populates client-team keys and employee hierarchy exclusion level for Record Base report filtering.
- Loads rows into [edw].[row_level_security_general] for the `Recordbase` RLS category.

## Final RLS categories
The final output in [edw].[row_level_security_general] is grouped into five business-facing security categories:

- `Employee`  
  Controls access to employee and workforce-related reporting.

- `Property`  
  Controls access to property-related reporting.

- `Recordbase`  
  Controls access to Record Base reporting, generally at client-team level.

- `Service`  
  Controls access to service-level reporting.

- `Tenancy`  
  Controls access to tenancy-related reporting.

## Timing in the daily load process
This RLS data is generated in the early morning as part of the EDW daily processing sequence.

- It runs after the main EDW/data warehouse table loads are completed.
- It runs before KPI data generation begins.
- It also runs before Power BI dataset refresh activity.

This ensures the row-level security data is fully prepared and available before KPI outputs and Power BI reports are refreshed, so all Power BI reports can use the latest access rules for that day.

## Combined outcome
When run together, these procedures create a complete RLS access dataset in [edw].[row_level_security_general], keyed by user email, with consistent hierarchy-based access control across:

- Employee and workforce views
- Service views
- Property views
- Tenancy views
- Record Base and client-team views

This allows Power BI to apply the correct row-level security automatically for each signed-in user across all reporting domains.

## Operational notes
- Source foundations include current employee hierarchy, active service structures, and row-level cost/allocation mappings.
- `RLS_Type` values are intentionally separated so Record Base can be refreshed independently from the other RLS domains when needed.
- Recommended run sequence is kaimahi, then services, then recordbase, or equivalent orchestration that preserves the intended split between Record Base and non-Record Base loads.