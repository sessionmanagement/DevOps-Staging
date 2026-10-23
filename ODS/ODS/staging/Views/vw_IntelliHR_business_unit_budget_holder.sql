
create view [Staging].[vw_IntelliHR_business_unit_budget_holder]
as 
select
	 src.[business_unit_id] 	,src.[budget_holders_person_id] 	,src.[budget_holders_displayname] 	,src.[budget_holders_employee_id] 
from [Landing].[IntelliHR_business_unit_budget_holder] as src;