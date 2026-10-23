
create view [Staging].[vw_Datapay_pay_groups]
as 
select
	 src.[company_id] 	,src.[paygroup_id] 	,src.[code] 	,src.[name] 
from [Landing].[Datapay_pay_groups] as src;