

CREATE PROC [staging].[insert_staging_fact_employee_pay_run_item]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_employee_pay_run_item]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-02-16    Pankaj Bhatt		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_employee_pay_run_item]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_employee_pay_run_item] (
	 [dim_employee_pay_run_key]
	,[dim_company_key_pay_run_id_key]

	,[dim_employee_key]
	,[dim_company_key]

	,[dim_employee_pay_component_key]
	,[dim_company_key_pay_component_key]

	,[dim_pay_period_start_date_key]
	,[dim_pay_period_end_date_key]

	,[pay_run_id] 
	,[employee_id] 
	,[pay_component_code] 
	,[pay_component_name] 
	,[pay_component_category] 
	,[pay_period_start_date] 
	,[pay_period_end_date] 
	,[hours_amount] 
	,[total_amount] 
	,[division_code] 
	,[cost_centre_code] 
	,[department_code] 
	,[sub_department_code] 
	,[department] 
	,[sub_department] 
	,[remuneration_type] 
	,[work_class] 
	,[work_type] 
	,[company_code] 
	)
SELECT
	 isnull(pr.dim_employee_pay_run_key, CASE WHEN l.pay_run_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_employee_pay_run_key 
	,isnull(pr.dim_company_key_pay_run_id_key, CASE WHEN l.pay_run_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_company_key_pay_run_id_key
	
	,isnull(e.dim_employee_key, CASE WHEN l.employee_id IS NOT NULL THEN -1 ELSE 0 END) as dim_employee_key
	,isnull(c.dim_company_key, CASE WHEN l.company_code IS NOT NULL THEN -1 ELSE 0 END) AS dim_company_key

	,isnull(pc.dim_employee_pay_component_key, CASE WHEN l.pay_component_code IS NOT NULL THEN -1 ELSE 0 END) AS dim_employee_pay_component_key 
	,isnull(pc.dim_company_key_pay_component_key, CASE WHEN l.pay_component_code IS NOT NULL THEN -1 ELSE 0 END) AS dim_company_key_pay_component_key

	,FORMAT(cast(l.[pay_period_start_date] AS DATE), 'yyyyMMdd') as [dim_pay_period_start_date_key]
	,FORMAT(cast(l.[pay_period_end_date] AS DATE), 'yyyyMMdd') as [dim_pay_period_end_date_key]

	,l.[pay_run_id] 
	,l.[employee_id] 
	,l.[pay_component_code] 
	,l.[pay_component_name] 
	,l.[pay_component_category] 
	,l.[pay_period_start_date] 
	,l.[pay_period_end_date] 
	,l.[hours_amount] 
	,l.[total_amount] 
	,l.[division_code] 
	,l.[cost_centre_code] 
	,l.[department_code] 
	,l.[sub_department_code] 
	,l.[department] 
	,l.[sub_department] 
	,l.[remuneration_type] 
	,l.[work_class] 
	,l.[work_type] 
	,l.[company_code] 
from [Landing].[edw_fact_employee_pay_run_item] l
left outer join [edw].[dim_employee_pay_run] pr on l.pay_run_id = pr.pay_run_id and l.company_code = pr.company_code and pr.DWHIsCurrent = 1
-- DEV has employees with multiple current record. PROD is fine. Add logic to handle this scenario
OUTER APPLY (
    SELECT max(dim_employee_key) dim_employee_key
    FROM edw.dim_employee d
    WHERE d.employee_id = l.employee_id 
      AND l.[pay_period_end_date] between d.DWHEffectiveFrom and d.DWHEffectiveTo
      --AND d.DWHIsCurrent = 1
) e
left outer join [edw].[dim_company] c on l.company_code = c.company_datapay_code
left outer join [edw].[dim_employee_pay_component] pc on l.pay_component_code = pc.pay_component_code and l.company_code = pc.company_code and pc.DWHIsCurrent = 1