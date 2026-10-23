
create view [Staging].[vw_IntelliHR_pay_grades]
as 
select
	 src.[pay_grades_id] 	,src.[code] 	,src.[name] 	,src.[isEnabled] 
from [Landing].[IntelliHR_pay_grades] as src;