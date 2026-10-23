
create view [Staging].[vw_Datapay_companies]
as 
select
	 src.[company_id] 	,src.[name] 	,src.[code] 
from [Landing].[Datapay_companies] as src;