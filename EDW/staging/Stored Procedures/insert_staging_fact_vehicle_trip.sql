
CREATE PROC [staging].[insert_staging_fact_vehicle_trip]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_vehicle_trip]
PURPOSE:  vehicle trips from tapu waka

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-05-19    Pankaj Bhatt		Initial version
1.1      2026-06-09    Greg Nuthall		Modified to find more employees
****************************************************************************/

--Ensure no duplicate employee names
   IF OBJECT_ID('tempdb..#employee_name_link') IS NOT NULL DROP TABLE #employee_name_link;
   IF OBJECT_ID('tempdb..#employee_email_link') IS NOT NULL DROP TABLE #employee_email_link;
   
    select
        dim_employee_key,
        employee_id,
        employee_name,
        row_number() over (
            partition by employee_name
            order by DWHEffectiveFrom desc, dim_employee_key desc
        ) as duplicate_row_num
    into #employee_name_link
	
	from edw.dim_employee
    where DWHIsCurrent = 1
	  and isnull(employee_id,-1) <> -1
      and DWHDMLOperation <> 'D'
	  and ltrim(rtrim(isnull(employee_name,''))) <> ''

--Ensure no duplicate employee emails
	 select
        dim_employee_key,
        employee_id,
        employee_primary_email_address,
        row_number() over (
            partition by employee_primary_email_address
            order by DWHEffectiveFrom desc, dim_employee_key desc
        ) as duplicate_row_num
    into #employee_email_link
	
	FROM edw.dim_employee
    WHERE DWHIsCurrent = 1
      and DWHDMLOperation <> 'D'
	  and isnull(employee_id,-1) <> -1
      and ltrim(rtrim(isnull(employee_primary_email_address,''))) <> ''


--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_vehicle_trip]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_vehicle_trip] (
	 [dim_vehicle_key]
	,[dim_employee_key]
	,[vehicle_trip_id] 
	,[vehicle_id] 
	,[employee_id]
	,[is_processed] 
	,[version] 
	,[start_timestamp] 
	,[start_point_latitude] 
	,[start_point_longitude] 
	,[start_address] 
	,[end_timestamp] 
	,[end_point_latitude] 
	,[end_point_longitude] 
	,[end_address] 
	,[is_towed] 
	,[driver_full_name] 
	,[driver_email_address] 
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
	)
SELECT
	 isnull(v.dim_vehicle_key, CASE WHEN l.vehicle_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_vehicle_key
	--,isnull(empl1.dim_employee_key, CASE WHEN (l.driver_email_address IS NOT NULL) THEN -1 ELSE 0 END) as dim_employee_key    
	
	,case when isnull(l.driver_email_address,'') = '' 
			then 0 
		  else 
			isnull(isnull(isnull(e.dim_employee_key, eel.dim_employee_key),enl.dim_employee_key),-1)
	end as dim_employee_key    
	
	,l.[vehicle_trip_id] 
	,l.[vehicle_id] 
	--,empl1.employee_id as employee_id
	,case when isnull(l.driver_email_address,'') = '' 
			then 0 
		  else 
			isnull(isnull(isnull(e.employee_id,eel.employee_id),enl.employee_id),-1)
	end as employee_id   
		
	,l.[is_processed] 
	,l.[version] 
	,l.[start_timestamp] 
	,l.[start_point_latitude] 
	,l.[start_point_longitude] 
	,l.[start_address] 
	,l.[end_timestamp] 
	,l.[end_point_latitude] 
	,l.[end_point_longitude] 
	,l.[end_address] 
	,l.[is_towed] 
	,l.[driver_full_name] 
	,l.[driver_email_address] 
	,l.[distance_meters] 
	,l.[distance_meters_offroad] 
	,l.[average_speed] 
	,l.[max_speed] 
	,l.[num_polls] 
	,l.[on_road_within_speed_limit] 
	,l.[on_road_over_speed_limit_band1] 
	,l.[on_road_over_speed_limit_band2] 
	,l.[on_road_over_speed_limit_band3] 
	,l.[on_road_over_speed_limit_band4] 
	,l.[on_road_over_speed_limit_band5] 
	,l.[offroad_within_speed_limit] 
	,l.[offroad_over_speed_limit_band1] 
	,l.[offroad_over_speed_limit_band2] 
	,l.[offroad_over_speed_limit_band3] 
	,l.[offroad_over_speed_limit_band4] 
	,l.[offroad_over_speed_limit_band5] 
from [Landing].[edw_fact_vehicle_trip] l
left outer join [edw].[dim_vehicle] v on l.vehicle_id = v.vehicle_id and v.DWHIsCurrent = 1
left outer join reference.edw_lookup lk 
	on CAST(lower(TRIM(l.driver_email_address)) AS NVARCHAR(MAX)) = CAST(lower(TRIM(lk.Input_Value)) AS NVARCHAR(MAX)) 
	AND lk.Category = 'dim_employee.employee_name'
left outer join edw.dim_employee e on lk.output_value = e.employee_id and e.DWHIsCurrent = 1

left outer join #employee_email_link eel 
	on lower(trim(replace(replace(l.driver_email_address,'Adm-',''),'@mindandbody.co.nz','@emergeaotearoa.org.nz'))) = lower(trim(eel.employee_primary_email_address)) 
		and eel.duplicate_row_num = 1
left outer join #employee_name_link enl 
	on lower(trim(replace(l.driver_full_name,'Admin - ',''))) = lower(trim(enl.employee_name)) 
	and enl.duplicate_row_num = 1


--outer apply
--(    SELECT TOP 1 empl_inner.*
--    FROM edw.dim_employee empl_inner
--    WHERE 
--        -- Only consider current, non-unknown employee records
--        --l.[start_timestamp] between empl_inner.DWHEffectiveFrom and empl_inner.DWHEffectiveTo
--		empl_inner.DWHIsCurrent = 1
--		AND empl_inner.employee_id <> 0   
--        -- Only include employees who are matches on Email
--        AND (
--            -- Match : By Raw Email
--            UPPER(TRIM(empl_inner.employee_primary_email_address)) = UPPER(TRIM(l.driver_email_address))
--            -- Match : By Email Lookup
--            OR empl_inner.employee_id = TRY_CAST(elk11.Output_Value AS INT)
--        )        
--    ORDER BY
--        -- Priority 1: Raw Email Match
--        CASE WHEN UPPER(TRIM(empl_inner.employee_primary_email_address)) = UPPER(TRIM(l.driver_email_address)) THEN 1 ELSE 0 END DESC,      
--        -- Priority 2: ID from Email lookup
--        CASE WHEN empl_inner.employee_id = TRY_CAST(elk11.Output_Value AS INT) THEN 1 ELSE 0 END DESC,
--        -- Ensures only one row is selected if multiple employees match (e.g., duplicate emails)
--        empl_inner.employee_id ASC 
--) empl1