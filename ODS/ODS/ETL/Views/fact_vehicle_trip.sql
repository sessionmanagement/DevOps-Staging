
CREATE     view [ETL].[fact_vehicle_trip]

as

/**********************************************************************************************************
 View		[ETL].[fact_vehicle_trip]
 Author		Pankaj Bhatt
 Created	2026-05-13
 Purpose	Used to build the edw.fact_vehicle_trip table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2026-05-13		Pankaj Bhatt	Initial version

**************************************************************************************************************/

SELECT cast(asset_trip_id as varchar(100)) AS [vehicle_trip_id]
      ,RTRIM(LTRIM([asset_id])) AS [vehicle_id]
      ,[is_processed]
      ,[version]
      ,CONVERT(
				datetime, SWITCHOFFSET(CONVERT(datetimeoffset, [start_timestamp]),
				DATEPART(TZOFFSET,[start_timestamp] AT TIME ZONE 'New Zealand Standard Time')))	
	   AS [start_timestamp]
      ,[start_point_latitude]
      ,[start_point_longitude]
      ,[start_address]
      ,CONVERT(
				datetime, SWITCHOFFSET(CONVERT(datetimeoffset, [end_timestamp]),
				DATEPART(TZOFFSET,[end_timestamp] AT TIME ZONE 'New Zealand Standard Time')))	
	   AS [end_timestamp]
      ,[end_point_latitude]
      ,[end_point_longitude]   
      ,[end_address]
      ,[is_towed]
      --,RTRIM(LTRIM([operator_id])) AS [operator_id]
      ,a.[operator] as [driver_full_name]
      --,c.first_name
      --,c.last_name
      ,c.email_address as [driver_email_address]
      ,[distance_meters]
      ,[distance_meters_offroad]
      ,[average_speed]
      ,[max_speed]
      ,[num_polls]
      ,[on_road_within_speed_limit]
      ,[on_road_over_speed_limit_band1]
      ,[on_road_over_speed_limit_band2]
      ,[on_road_over_speed_limit_band3]
      ,[on_road_over_speed_limit_band4]
      ,[on_road_over_speed_limit_band5]
      ,[offroad_within_speed_limit]
      ,[offroad_over_speed_limit_band1]
      ,[offroad_over_speed_limit_band2]
      ,[offroad_over_speed_limit_band3]
      ,[offroad_over_speed_limit_band4]
      ,[offroad_over_speed_limit_band5]
  FROM TapuiWaka.[asset_trip] a
  left outer join TapuiWaka.contact c
  on a.operator_id = c.contact_id
  and c.ODSIsCurrent = 1
WHERE a.ODSIsCurrent=1