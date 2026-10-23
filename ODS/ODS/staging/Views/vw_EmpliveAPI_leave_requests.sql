
create view [Staging].[vw_EmpliveAPI_leave_requests]
as 
select
	 src.[leave_request_id] 	,src.[employee_id] 	,src.[start_date_time] 	,src.[end_date_time] 	,src.[default_leave_type] 	,src.[status] 
from [Landing].[EmpliveAPI_leave_requests] as src;