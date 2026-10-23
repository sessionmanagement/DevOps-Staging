
create view [Staging].[vw_WebExpenses_category]
as 
select
	 src.[category_id] 	,src.[category_name] 	,src.[gl_code] 	,src.[spend_limit] 	,src.[company_id] 	,src.[receipts_required] 	,src.[vat_id] 	,src.[vat_rate] 
from [Landing].[WebExpenses_category] as src;