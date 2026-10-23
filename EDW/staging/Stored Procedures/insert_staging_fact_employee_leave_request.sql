

CREATE PROC [staging].[insert_staging_fact_employee_leave_request]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_employee_leave_request]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-03-03    Pankaj Bhatt		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_employee_leave_request]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_employee_leave_request] (
	 [dim_employee_key]
	,[dim_employee_leave_request_type_key]
	,[dim_leave_request_start_date_key]
	,[dim_leave_request_end_date_key]
	,[leave_request_id] 
	,[employee_id] 
	,[leave_request_type_id] 
	,[leave_request_start_date_time] 
	,[leave_request_end_date_time] 
	,[leave_request_status] 
	)
SELECT
	 isnull(e.dim_employee_key, CASE WHEN l.employee_id IS NOT NULL THEN -1 ELSE 0 END) as dim_employee_key
	,isnull(lrt.dim_employee_leave_request_type_key, CASE WHEN l.leave_request_type_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_employee_leave_request_type_key 
	,FORMAT(cast(l.[leave_request_start_date_time] AS DATE), 'yyyyMMdd') as dim_leave_request_start_date_key
	,FORMAT(cast(l.[leave_request_end_date_time] AS DATE), 'yyyyMMdd') as dim_leave_request_end_date_key
	,l.[leave_request_id] 
	,ISNULL(elk1.Output_Value, TRY_CAST(l.employee_id AS INT)) as [employee_id]	
	,l.[leave_request_type_id] 
	,l.[leave_request_start_date_time] 
	,l.[leave_request_end_date_time] 
	,l.[leave_request_status] 
from [Landing].[edw_fact_employee_leave_request] l
left outer join edw.dim_employee_leave_request_type lrt on l.leave_request_type_id = lrt.leave_request_type_id and lrt.DWHIsCurrent = 1
left outer join reference.edw_lookup elk1 on cast(l.employee_id as nvarchar) = Cast(elk1.Input_Value as nvarchar) and elk1.Category = 'dim_employee.employee_id'
-- DEV has employees with multiple current record. PROD is fine. Add logic to handle this scenario
OUTER APPLY (
    SELECT max(dim_employee_key) dim_employee_key
    FROM edw.dim_employee d
	-- Only consider current, non-unknown employee records
	-- Match By ID (Looked-up or Original)
    WHERE (
	d.employee_id = ISNULL(elk1.Output_Value, TRY_CAST(l.employee_id AS INT))
	)  
	AND l.[leave_request_end_date_time] between d.DWHEffectiveFrom and d.DWHEffectiveTo
) e