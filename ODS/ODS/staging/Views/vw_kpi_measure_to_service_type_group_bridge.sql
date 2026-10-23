
create view [Staging].[vw_kpi_measure_to_service_type_group_bridge]
as 
select
	 src.[measure_id] 	,src.[service_type_grouping_id] 
from [Landing].[kpi_measure_to_service_type_group_bridge] as src;