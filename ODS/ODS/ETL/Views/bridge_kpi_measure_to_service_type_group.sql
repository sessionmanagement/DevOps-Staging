CREATE VIEW [ETL].[bridge_kpi_measure_to_service_type_group] as
SELECT  [measure_id]
      ,[service_type_grouping_id]

  FROM [kpi].[measure_to_service_type_group_bridge]