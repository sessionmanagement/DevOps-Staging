
create view [Staging].[vw_EmpLive_roster_shifts]
as 
select
	 src.[id] 	,src.[service_name_id] 	,src.[job_id] 	,src.[role_id] 	,src.[static_shift_id] 	,src.[start_date] 	,src.[start_time] 	,src.[end_date] 	,src.[end_time] 	,src.[employees_required] 
from [Landing].[EmpLive_roster_shifts] as src;