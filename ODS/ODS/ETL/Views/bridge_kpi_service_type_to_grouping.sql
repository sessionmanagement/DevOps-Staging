/**********************************************************************************************************
 View		[ETL].[bridge_kpi_service_type_to_grouping]
 Author		Manish Singh
 Created	2025/04/11	
 Purpose	Resolves many-to-many relationship 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2025/04/11			Manish Singh		Initial version


**************************************************************************************************************/
CREATE VIEW [ETL].[bridge_kpi_service_type_to_grouping] as 
SELECT  [service_type_grouping_id]
      ,[service_type_id]
  FROM [kpi].[service_type_grouping_to_service_type_bridge]