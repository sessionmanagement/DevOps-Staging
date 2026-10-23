/**********************************************************************************************************
 View		[ETL].[dim_kpi_service_type_grouping]
 Author		Manish Singh
 Created	2025/04/11	
 Purpose	Service Type grouping table from the Organisational Performance Sharepoint
 site added to the EDW so that analyst can filter each KPI to apply to the correct services as defined by the business. 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2025/04/11			Manish Singh		Initial version


**************************************************************************************************************/
Create view [ETL].[dim_kpi_service_type_grouping] AS
SELECT  [id] service_type_grouping_id
      ,[service_type_group_name]
      ,[service_type_grouping]
      ,[notes]
   FROM [kpi].[service_type_grouping]