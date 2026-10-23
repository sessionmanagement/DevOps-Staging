
create view [Staging].[vw_kpi_service_type]
as 
select
	 src.[id] 	,src.[service_type] 	,src.[service_type_grouping_lookup_id] 	,src.[service_type_grouping] 
from [Landing].[kpi_service_type] as src;