
create view [Staging].[vw_kpi_service_type_grouping]
as 
select
	 src.[id] 	,src.[service_type_group_name] 	,src.[service_type_grouping] 	,src.[notes] 
from [Landing].[kpi_service_type_grouping] as src;