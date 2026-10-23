
create view [Staging].[vw_WebExpenses_costcentre]
as 
select
	 src.[cost_centre_id] 	,src.[cost_centre_name] 	,src.[approver_id] 	,src.[approver_first_name] 	,src.[approver_last_name] 	,src.[approver_login] 
from [Landing].[WebExpenses_costcentre] as src;