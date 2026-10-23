
create view [Staging].[vw_Datapay_employee_groups]
as 
select
	 src.[company_id] 	,src.[employee_group_id] 	,src.[name] 	,src.[employee_group_type] 	,src.[inactive] 
from [Landing].[Datapay_employee_groups] as src;