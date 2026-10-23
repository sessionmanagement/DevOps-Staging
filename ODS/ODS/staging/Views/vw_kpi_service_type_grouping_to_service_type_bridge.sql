
create view [Staging].[vw_kpi_service_type_grouping_to_service_type_bridge]
as 
select
	 src.[service_type_grouping_id] 	,src.[service_type_id] 
from [Landing].[kpi_service_type_grouping_to_service_type_bridge] as src;