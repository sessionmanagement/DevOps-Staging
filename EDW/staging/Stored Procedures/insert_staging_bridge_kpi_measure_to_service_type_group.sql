


CREATE PROC [staging].[insert_staging_bridge_kpi_measure_to_service_type_group]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_bridge_kpi_measure_to_service_type_group]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-04-15    Manish Singh		Initial version
2.0      2025-05-25    Manish Singh		Adding DWHiscurrent=1 condition
2.1      2025-05-28    Greg Nuthall		Moved dim_kpi_service_type_grouping DWHIScurrent to inside the table to make sure it gets all records 
2.2      2025-05-23    Manish Singh     Adding DWHiscurrent=1 condition

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLbridge_kpi_measure_to_service_type_group]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLbridge_kpi_measure_to_service_type_group] (
     dim_kpi_key,
dim_kpi_service_type_grouping_key,
	 [measure_id] 
	,[service_type_grouping_id] 
	)
SELECT
	isnull(DKST.dim_kpi_key,CASE WHEN isnull(LDKST.[measure_id],'') <> '' THEN -1 ELSE 0 END) as dim_kpi_key,
	isnull(DKSTG.dim_kpi_service_type_grouping_key,CASE WHEN isnull(LDKST.[service_type_grouping_id],'') <> '' THEN -1 ELSE 0 END) as dim_kpi_service_type_grouping_key,
	 [measure_id] 
	,LDKST.[service_type_grouping_id] 
from [Landing].[edw_bridge_kpi_measure_to_service_type_group] LDKST
LEFT OUTER JOIN [edw].[dim_kpi] DKST ON LDKST.measure_id=DKST.kpi_id
LEFT OUTER JOIN (select * from [EDW].[dim_kpi_service_type_grouping] where DWHIsCurrent=1) DKSTG 
	ON LDKST.[service_type_grouping_id]=DKSTG.[service_type_grouping_id]
where DKST.DWHIsCurrent=1  AND DKST.DWHIsCurrent=1