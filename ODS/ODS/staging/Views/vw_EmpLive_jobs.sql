
create view [Staging].[vw_EmpLive_jobs]
as 
select
	 src.[id] 	,src.[reference_number] 	,src.[name] 	,src.[start_date] 	,src.[end_date] 	,src.[cost_code] 	,src.[comments] 	,src.[contact_name] 	,src.[contact_phone] 	,src.[address_1] 	,src.[address_2] 	,src.[suburb] 	,src.[state] 	,src.[post_code] 	,src.[country] 
from [Landing].[EmpLive_jobs] as src;