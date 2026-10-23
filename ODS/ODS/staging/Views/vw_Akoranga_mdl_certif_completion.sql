
create view [Staging].[vw_Akoranga_mdl_certif_completion]
as 
select
	 src.[id] 	,src.[certif_id] 	,src.[user_id] 	,src.[certif_path] 	,src.[status] 	,src.[renewal_status] 	,src.[time_window_opens] 	,src.[time_expires] 	,src.[baseline_time_expires] 	,src.[time_completed] 	,src.[time_modified] 
from [Landing].[Akoranga_mdl_certif_completion] as src;