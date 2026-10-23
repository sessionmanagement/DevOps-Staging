
create view [Staging].[vw_Datapay_leave_balances]
as 
select
	 src.[employee_id] 	,src.[leave_type_id] 	,src.[effective_date] 	,src.[unit] 	,src.[entitlement] 	,src.[accrual] 	,src.[taken] 	,src.[balance] 	,src.[anniversary] 	,src.[next_entitlement] 
from [Landing].[Datapay_leave_balances] as src;