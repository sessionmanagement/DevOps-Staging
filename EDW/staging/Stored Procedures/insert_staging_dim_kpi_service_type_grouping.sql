CREATE PROC [staging].[insert_staging_dim_kpi_service_type_grouping]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_kpi_service_type_grouping]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-04-14    ?				Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_kpi_service_type_grouping]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_kpi_service_type_grouping] (
	 [service_type_grouping_id] 	,[service_type_group_name] 	,[service_type_grouping] 	,[notes] 
	)
SELECT
	 [service_type_grouping_id] 	,[service_type_group_name] 	,[service_type_grouping] 	,[notes] 
from [Landing].[edw_dim_kpi_service_type_grouping]