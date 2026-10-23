
create view [Staging].[vw_Datapay_components]
as 
select
	 src.[company_id] 	,src.[component_id] 	,src.[code] 	,src.[name] 	,src.[category] 	,src.[subcategory] 	,src.[component_parameter_id] 	,src.[parameter_name] 	,src.[value_type] 	,src.[role] 	,src.[reference_value_id] 	,src.[reference_value_name] 	,src.[reference_value_value] 
from [Landing].[Datapay_components] as src;