



CREATE PROC [staging].[insert_staging_fact_employee_pay_slip_item]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_employee_pay_slip_item]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-02-13    Pankaj Bhatt		Initial version
1.1		 2026-03-24    Pankaj Bhatt		Added join for lookup to get employee_id

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_employee_pay_slip_item]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_employee_pay_slip_item] (
	 [dim_employee_pay_slip_key]
    ,[dim_company_key_pay_packet_id_key]
    ,[dim_employee_key]
    ,[dim_company_key]
	,[pay_packet_id] 
	,[pay_packet_row_id] 
	,[employee_id] 
	,[item_type] 
	,[item_amount] 
	,[item_type_detail] 
	,[item_summary] 
	,[company_code] 
	)
SELECT
	 isnull(ps.dim_employee_pay_slip_key, CASE WHEN l.pay_packet_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_employee_pay_slip_key 
	,isnull(ps.dim_company_key_pay_packet_id_key, CASE WHEN l.pay_packet_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_company_key_pay_packet_id_key
	,isnull(e.dim_employee_key, CASE WHEN l.employee_id IS NOT NULL THEN -1 ELSE 0 END) as dim_employee_key
	,isnull(c.dim_company_key, CASE WHEN l.company_code IS NOT NULL THEN -1 ELSE 0 END) AS dim_company_key

	,l.[pay_packet_id] 
	,l.[pay_packet_row_id] 
	,ISNULL(elk1.Output_Value, TRY_CAST(l.employee_id AS INT)) as [employee_id] 
	,l.[item_type] 
	,l.[item_amount] 
	,l.[item_type_detail] 
	,l.[item_summary] 
	,l.[company_code] 
from [Landing].[edw_fact_employee_pay_slip_item] l
left outer join [edw].[dim_employee_pay_slip] ps on l.pay_packet_id = ps.pay_packet_id and l.company_code = ps.company_code and ps.DWHIsCurrent = 1
left outer join reference.edw_lookup elk1 on cast(l.employee_id as nvarchar) = Cast(elk1.Input_Value as nvarchar) and elk1.Category = 'dim_employee.employee_id'
-- DEV has employees with multiple current record. PROD is fine. Add logic to handle this scenario
OUTER APPLY (
    SELECT max(dim_employee_key) dim_employee_key
    FROM edw.dim_employee d
	-- Only consider current, non-unknown employee records
	-- Match By ID (Looked-up or Original)  
    WHERE ps.[pay_period_end_date] between d.DWHEffectiveFrom and d.DWHEffectiveTo
	  AND (
	d.employee_id = ISNULL(elk1.Output_Value, TRY_CAST(l.employee_id AS INT))
	) 
      --AND d.DWHIsCurrent = 1
) e
left outer join [edw].[dim_company] c on l.company_code = c.company_datapay_code