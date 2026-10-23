
CREATE PROC [staging].[insert_staging_fact_employee_pay_slip]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_employee_pay_slip]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-02-12    Pankaj Bhatt		Initial version
1.1		 2026-03-24    Pankaj Bhatt		Added join for lookup to get employee_id

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_employee_pay_slip]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_employee_pay_slip] (
	 [dim_employee_pay_slip_key]
    ,[dim_company_key_pay_packet_id_key]
    ,[dim_employee_key]
    ,[dim_company_key]
    ,[dim_pay_run_date_key]
    ,[dim_pay_period_start_date_key]
    ,[dim_pay_period_end_date_key]

	,[pay_packet_id] 
	,[employee_id] 
	,[gross_total_amount] 
	,[deduction_total_amount] 
	,[net_total_amount] 
	,[pay_run_date] 
	,[pay_period_start_date] 
	,[pay_period_end_date] 
	,[company_code] 
	)
SELECT
	 isnull(ps.dim_employee_pay_slip_key, CASE WHEN l.pay_packet_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_employee_pay_slip_key 
	,isnull(ps.dim_company_key_pay_packet_id_key, CASE WHEN l.pay_packet_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_company_key_pay_packet_id_key
	,isnull(e.dim_employee_key, CASE WHEN l.employee_id IS NOT NULL THEN -1 ELSE 0 END) as dim_employee_key
	,isnull(c.dim_company_key, CASE WHEN l.company_code IS NOT NULL THEN -1 ELSE 0 END) AS dim_company_key
	,FORMAT(cast(l.[pay_run_date] AS DATE), 'yyyyMMdd') as [dim_pay_run_date_key]
	,FORMAT(cast(l.[pay_period_start_date] AS DATE), 'yyyyMMdd') as [dim_pay_period_start_date_key]
	,FORMAT(cast(l.[pay_period_end_date] AS DATE), 'yyyyMMdd') as [dim_pay_period_end_date_key]

	,l.[pay_packet_id] 
	,ISNULL(elk1.Output_Value, TRY_CAST(l.employee_id AS INT)) as [employee_id]
	,l.[gross_total_amount] 
	,l.[deduction_total_amount] 
	,l.[net_total_amount] 
	,l.[pay_run_date] 
	,l.[pay_period_start_date] 
	,l.[pay_period_end_date] 
	,l.[company_code] 
from [Landing].[edw_fact_employee_pay_slip] l
left outer join [edw].[dim_employee_pay_slip] ps on l.pay_packet_id = ps.pay_packet_id and l.company_code = ps.company_code and ps.DWHIsCurrent = 1
left outer join reference.edw_lookup elk1 on cast(l.employee_id as nvarchar) = Cast(elk1.Input_Value as nvarchar) and elk1.Category = 'dim_employee.employee_id'
-- DEV has employees with multiple current record. PROD is fine. Add logic to handle this scenario
OUTER APPLY (
    SELECT max(d.dim_employee_key) dim_employee_key
    FROM edw.dim_employee d
	-- Only consider current, non-unknown employee records
	-- Match By ID (Looked-up or Original)
    WHERE l.[pay_period_end_date] between d.DWHEffectiveFrom and d.DWHEffectiveTo
	AND (
	d.employee_id = ISNULL(elk1.Output_Value, TRY_CAST(l.employee_id AS INT))
	)       
) e
left outer join [edw].[dim_company] c on l.company_code = c.company_datapay_code