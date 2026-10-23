CREATE   PROC [staging].[insert_staging_ds_snapshot_tenancy_current]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_ds_snapshot_tenancy_current]
PURPOSE:  Insert tenancy KPI data from landing to staging for processing

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-08-06    Greg Nuthall		Initial version based on property procedure
						                Substituted property_id with property_tenancy_id
						                Substituted dim_property_key with dim_property_tenancy_key
****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[EDWedwkpi_snapshot_tenancy]

-- insert data from landing table into staging table
INSERT INTO [Staging].[EDWedwkpi_snapshot_tenancy] (
	 [kpi_snapshot_tenancy_id]
	,[dim_kpi_key] 
	,[dim_company_key] 
	,[dim_property_tenancy_key] 
	,[dim_service_key]
	,[entity_key] 
	,[kpi_id]
	,[property_tenancy_id]
	,[service_id]
	,[kpi_value] 
	,[user_friendly_score_explanation] 
	,[kpi_status] 
	,[snapshot_date] 

	)
SELECT
	 ROW_NUMBER() OVER (ORDER BY [dim_kpi_key]) AS [kpi_snapshot_tenancy_id]
	,[dim_kpi_key] 
	,[dim_company_key] 
	,[dim_property_tenancy_key] 
	,[dim_service_key] 
	,[entity_key]
	,[kpi_id]
	,[property_tenancy_id]
	,[service_id]
	,[kpi_value] 
	,[user_friendly_score_explanation] 
	,[kpi_status] 
	,[snapshot_date] 

from [Landing].[kpi_ds_snapshot_tenancy_current]