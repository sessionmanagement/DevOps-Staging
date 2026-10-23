


CREATE PROC [staging].[insert_staging_dim_employee_pay_run]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_employee_pay_run]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-02-12    Pankaj Bhatt		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_employee_pay_run]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_employee_pay_run] (
	 [dim_company_key_pay_run_id_key]
	,[dim_company_key]
	,[pay_run_id] 
	,[pay_run_type] 
	,[pay_run_status] 
	,[pay_run_date] 
	,[pay_period_start_date] 
	,[pay_period_end_date] 
	,[company_code] 
	)
SELECT
	 IIf(pay_run_id > 0, Cast(dim_company_key As bigint) * 1000000000 + pay_run_id, pay_run_id)
	,isnull(c.dim_company_key, CASE WHEN pr.company_code IS NOT NULL THEN -1 ELSE 0 END) AS dim_company_key
	,[pay_run_id] 
	,[pay_run_type] 
	,[pay_run_status] 
	,[pay_run_date] 
	,[pay_period_start_date] 
	,[pay_period_end_date] 
	,[company_code] 
from [Landing].[edw_dim_employee_pay_run] pr
left outer join [edw].[dim_company] c
on pr.company_code = c.company_datapay_code