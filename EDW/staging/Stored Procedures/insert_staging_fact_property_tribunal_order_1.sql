CREATE PROC [staging].[insert_staging_fact_property_tribunal_order]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_property_tribunal_order]
PURPOSE:  

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-07-15    Greg Nuthall		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_property_tribunal_order]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_property_tribunal_order] (
	 [property_tribunal_order_id] 
	,[property_tenancy_breach_id]
	,[property_id]
	,[property_tenancy_id] 
	,[dim_property_tenancy_key]
	,[dim_property_key]
	,[tribunal_order] 
	,[notes] 
	,[tribunal_outcome] 
	,[tribunal_outcome_reason] 
	,[tribunal_order_start_date] 
	,[tribunal_order_owner] 
	,[modified_by] 
	,[modified_date] 
	,[created_date] 
	,[tribunal_order_state] 
	,[tribunal_order_status] 
	)
SELECT
	 [property_tribunal_order_id] 
	,[property_tenancy_breach_id]
	,pt.property_id
	,t.[property_tenancy_id] 
	,pt.dim_property_tenancy_key
	,pt.dim_property_key
	,[tribunal_order] 
	,[notes] 
	,[tribunal_outcome] 
	,[tribunal_outcome_reason] 
	,[tribunal_order_start_date] 
	,[tribunal_order_owner] 
	,[modified_by] 
	,[modified_date] 
	,[created_date] 
	,[tribunal_order_state] 
	,[tribunal_order_status] 
from [Landing].[edw_fact_property_tribunal_order] t
left outer join [edw].dim_property_tenancy pt 
	on t.property_tenancy_id = pt.property_tenancy_id 
	and pt.DWHIsCurrent = 1