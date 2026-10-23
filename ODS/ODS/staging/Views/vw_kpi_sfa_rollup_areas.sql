
create view [Staging].[vw_kpi_sfa_rollup_areas]
as 
select
	 src.[id] 	,src.[title] 	,src.[roll_up_id] 	,src.[strategic_focus_area] 
from [Landing].[kpi_sfa_rollup_areas] as src;