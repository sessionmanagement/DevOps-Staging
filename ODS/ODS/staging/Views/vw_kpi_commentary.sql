
create view [Staging].[vw_kpi_commentary]
as 
select
	 src.[response_id] 	,src.[measure_selected] 	,src.[commentary] 	,src.[company_id] 	,src.[service_id] 	,src.[kpi_id] 	,src.[responder] 	,src.[submitted_date] 
from [Landing].[kpi_commentary] as src;