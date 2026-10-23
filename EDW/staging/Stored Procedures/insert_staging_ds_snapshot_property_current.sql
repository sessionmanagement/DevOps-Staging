CREATE PROC [staging].[insert_staging_ds_snapshot_property_current]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_ds_snapshot_property_current]
PURPOSE:  

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-03-04    ?				Initial version
1.1		 2025-03-22	   Greg Nuthall		Added property_id, service_id
1.2		 2025-07-23    Greg Nuthall		Added kpi_id
****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[EDWedwkpi_snapshot_property]

-- insert data from landing table into staging table
INSERT INTO [Staging].[EDWedwkpi_snapshot_property] (
	 [dim_kpi_key] 
	,[dim_company_key] 
	,[dim_property_key] 
	,[dim_service_key]
	,[entity_key] 
	,[kpi_id]
	,[property_id]
	,[service_id]
	,[kpi_value] 
	,[user_friendly_score_explanation] 
	,[kpi_status] 
	,[snapshot_date] 

	)
SELECT
	 [dim_kpi_key] 
	,[dim_company_key] 
	,[dim_property_key] 
	,[dim_service_key] 
	,[entity_key]
	,[kpi_id]
	,[property_id]
	,[service_id]
	,[kpi_value] 
	,[user_friendly_score_explanation] 
	,[kpi_status] 
	,[snapshot_date] 

from [Landing].[kpi_ds_snapshot_property_current]