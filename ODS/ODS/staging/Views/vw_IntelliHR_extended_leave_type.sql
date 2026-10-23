
create view [Staging].[vw_IntelliHR_extended_leave_type]
as 
select
	 src.[extended_leave_type_id] 	,src.[name] 
from [Landing].[IntelliHR_extended_leave_type] as src;