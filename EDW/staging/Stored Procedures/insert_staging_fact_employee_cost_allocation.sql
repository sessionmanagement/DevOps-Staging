
CREATE PROC [staging].[insert_staging_fact_employee_cost_allocation]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_employee_cost_allocation]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-03-04    Pankaj Bhatt 	Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_employee_cost_allocation]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_employee_cost_allocation] (
	 [dim_employee_key]
	,[dim_company_key]
	,[dim_service_key]
	,[dim_business_unit_hierarchy_key]
	,[employee_id] 
	,[intellihr_business_unit_id] 
	,[intellihr_business_unit_code] 
	,[intellihr_business_unit_name] 
	,[datapay_cost_center_code] 
	,[datapay_cost_center_name] 
	,[cost_allocation_percentage] 
	,[job_title] 
	,[company_id] 
	)
SELECT
	 isnull(e.dim_employee_key, CASE WHEN l.employee_id IS NOT NULL THEN -1 ELSE 0 END) as dim_employee_key
	,isnull(c.dim_company_key, CASE WHEN l.company_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_company_key
	,isnull(s.dim_service_key, CASE WHEN l.intellihr_business_unit_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_service_key
	,isnull(buh.dim_business_unit_hierarchy_key, CASE WHEN l.intellihr_business_unit_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_business_unit_hierarchy_key
	,ISNULL(elk1.Output_Value, TRY_CAST(l.employee_id AS INT)) as [employee_id] 
	,l.[intellihr_business_unit_id] 
	,l.[intellihr_business_unit_code] 
	,l.[intellihr_business_unit_name] 
	,l.[datapay_cost_center_code] 
	,l.[datapay_cost_center_name] 
	,l.[cost_allocation_percentage] 
	,l.[job_title] 
	,l.[company_id] 
from [Landing].[edw_fact_employee_cost_allocation] l
left outer join reference.edw_lookup elk1 on cast(l.employee_id as nvarchar) = Cast(elk1.Input_Value as nvarchar) and elk1.Category = 'dim_employee.employee_id'

--left outer join edw.dim_employee e on l.employee_id = e.employee_id and e.DWHIsCurrent = 1
-- DEV has employees with multiple current record. PROD is fine. Add logic to handle this scenario
OUTER APPLY (
    SELECT max(d.dim_employee_key) dim_employee_key
    FROM edw.dim_employee d
	-- Only consider current, non-unknown employee records
	-- Match By ID (Looked-up or Original)
    WHERE d.employee_id <> 0 AND d.DWHIsCurrent = 1
	AND (
	d.employee_id = ISNULL(elk1.Output_Value, TRY_CAST(l.employee_id AS INT))
	)       
) e
left outer join [edw].[dim_company] c on l.company_id = c.dim_company_intellihr_key
left outer join [edw].[dim_service] s on l.intellihr_business_unit_id = s.intellihr_service_id and c.dim_company_key = s.dim_company_key and s.DWHIsCurrent = 1
left outer join [edw].[dim_business_unit_hierarchy] buh on l.intellihr_business_unit_id = buh.business_unit_id