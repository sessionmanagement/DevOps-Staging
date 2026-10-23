
CREATE PROC [staging].[insert_staging_bridge_kpi_service_type_to_grouping]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_bridge_kpi_service_type_to_grouping]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-04-14    Manish Singh				Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLbridge_kpi_service_type_to_grouping]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLbridge_kpi_service_type_to_grouping] (

dim_kpi_service_type_key,
dim_kpi_service_type_grouping_key,
	 [service_type_grouping_id] 
	,[service_type_id] 
	)
SELECT
 		isnull(DKST.dim_kpi_service_type_key,CASE WHEN isnull(LDKST.[service_type_id],'') <> '' THEN -1 ELSE 0 END) as dim_kpi_service_type_key,
	isnull(DKSTG.dim_kpi_service_type_grouping_key,CASE WHEN isnull(LDKST.[service_type_grouping_id],'') <> '' THEN -1 ELSE 0 END) as dim_kpi_service_type_grouping_key,
	 LDKST.[service_type_grouping_id] 
	,LDKST.[service_type_id] 
from [Landing].[edw_bridge_kpi_service_type_to_grouping] LDKST
LEFT OUTER JOIN [edw].[dim_kpi_service_type] DKST ON LDKST.[service_type_id]=DKST.[service_type_id]
LEFT OUTER JOIN [EDW].[dim_kpi_service_type_grouping] DKSTG ON LDKST.[service_type_grouping_id]=DKSTG.[service_type_grouping_id]