
CREATE PROC [staging].[insert_staging_dim_kpi_service_type]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_kpi_service_type]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-04-14    Manish Singh				Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_kpi_service_type]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_kpi_service_type] (
	 [service_type_id] 
	,[service_type] 
	,[service_type_grouping_lookup_id] 
	,[service_type_grouping] 
	)
SELECT
	 [service_type_id] 
	,[service_type] 
	,[service_type_grouping_lookup_id] 
	,[service_type_grouping] 
from [Landing].[edw_dim_kpi_service_type]