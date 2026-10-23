
create view [Staging].[vw_kpi_definitions]
as 
select
	 src.[id] 	,src.[title] 	,src.[strategic_pillar] 	,src.[rollup_area] 	,src.[outcome] 	,src.[rollup_area_sfs] 
from [Landing].[kpi_definitions] as src;