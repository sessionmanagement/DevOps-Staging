
CREATE PROC [staging].[insert_staging_dim_property_inspection_detail]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_property_inspection_detail]
PURPOSE:  

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-08-03    Greg Nuthall		Initial version
****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_property_inspection_detail]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_property_inspection_detail] (
    dim_property_key
	,[property_id] 
	,[property_inspection_detail_id] 
	,[asset_condition_id] 
	,[asset_condition] 
	,[property_is_clean] 
	,[inspection_comments] 
	,[property_inspection_id] 
	,[property_undamaged] 
	,[property_working] 
	,[asset_name] 
	,[inspection_area] 
	,[property_asset_name] 
	)
SELECT
	case when idt.[property_id] is null then 0 else isnull(p.dim_property_key,-1) end as dim_property_key
	,idt.[property_id] 
	,idt.[property_inspection_detail_id] 
	,idt.[asset_condition_id] 
	,idt.[asset_condition] 
	,idt.[property_is_clean] 
	,idt.[inspection_comments] 
	,idt.[property_inspection_id] 
	,idt.[property_undamaged] 
	,idt.[property_working] 
	,idt.[asset_name] 
	,idt.[inspection_area] 
	,idt.[property_asset_name] 
from [Landing].[edw_dim_property_inspection_detail] idt
left outer join edw.dim_property p on idt.property_id = p.property_id and p.DWHIsCurrent = 1