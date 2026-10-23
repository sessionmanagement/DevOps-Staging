

CREATE PROC [staging].[insert_staging_dim_employee_pay_slip]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_employee_pay_slip]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-02-10    Pankaj Bhatt		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_employee_pay_slip]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_employee_pay_slip] (
	 [dim_company_key_pay_packet_id_key]
	,[dim_company_key]
	,[pay_packet_id] 
	,[pay_packet_type] 
	,[pay_run_date] 
	,[pay_period_start_date] 
	,[pay_period_end_date]
	,[company_code]
	)
SELECT
	 IIf(pay_packet_id > 0, Cast(dim_company_key As bigint) * 1000000000 + pay_packet_id, pay_packet_id)
	,isnull(c.dim_company_key, CASE WHEN ps.company_code IS NOT NULL THEN -1 ELSE 0 END) AS dim_company_key
	,[pay_packet_id] 
	,[pay_packet_type] 
	,[pay_run_date] 
	,[pay_period_start_date] 
	,[pay_period_end_date]
	,[company_code]
from [Landing].[edw_dim_employee_pay_slip] ps
left outer join [edw].[dim_company] c
on ps.company_code = c.company_datapay_code