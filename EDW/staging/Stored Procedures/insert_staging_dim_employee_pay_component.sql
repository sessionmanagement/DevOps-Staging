

CREATE PROC [staging].[insert_staging_dim_employee_pay_component]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_employee_pay_component]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-02-12    Pankaj Bhatt		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_employee_pay_component]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_employee_pay_component] (
	 [dim_company_key_pay_component_key]
    ,[dim_company_key]
	,[pay_component_code] 
	,[pay_component_name] 
	,[pay_component_category] 
	,[company_code] 
	)
SELECT
	 IIf(pay_component_code is not null, pay_component_code + '_' + Cast(dim_company_key As nvarchar), pay_component_code)
	,isnull(c.dim_company_key, CASE WHEN pc.company_code IS NOT NULL THEN -1 ELSE 0 END) AS dim_company_key
	,[pay_component_code] 
	,[pay_component_name] 
	,[pay_component_category] 
	,[company_code] 
from [Landing].[edw_dim_employee_pay_component] pc
left outer join [edw].[dim_company] c
on pc.company_code = c.company_datapay_code