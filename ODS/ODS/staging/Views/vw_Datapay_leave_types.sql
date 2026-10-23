
create view [Staging].[vw_Datapay_leave_types]
as 
select
	 src.[leave_type_id] 	,src.[name] 	,src.[type] 	,src.[paygroup_id] 	,src.[company_id] 
from [Landing].[Datapay_leave_types] as src;