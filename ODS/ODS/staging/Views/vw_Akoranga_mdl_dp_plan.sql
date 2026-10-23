
create view [Staging].[vw_Akoranga_mdl_dp_plan]
as 
select
	 src.[id] 	,src.[template_id] 	,src.[user_id] 	,src.[name] 	,src.[description] 	,src.[start_date] 	,src.[end_date] 	,src.[time_completed] 	,src.[certif_status] 	,src.[created_by] 
from [Landing].[Akoranga_mdl_dp_plan] as src;