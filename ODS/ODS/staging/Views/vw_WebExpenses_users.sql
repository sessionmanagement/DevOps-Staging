
create view [Staging].[vw_WebExpenses_users]
as 
select
	 src.[user_id] 	,src.[first_name] 	,src.[last_name] 	,src.[login] 	,src.[claimant_role_flag] 	,src.[approver_role_flag] 	,src.[accounts_role_flag] 	,src.[division_admin_flag] 	,src.[cost_centre_id] 	,src.[cost_centre_code] 	,src.[cost_centre_name] 	,src.[approver_id] 	,src.[approver_first_name] 	,src.[approver_last_name] 	,src.[approver_login] 	,src.[created_date] 
from [Landing].[WebExpenses_users] as src;