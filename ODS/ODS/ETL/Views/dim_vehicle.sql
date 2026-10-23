CREATE     view [ETL].[dim_vehicle]

as

/**********************************************************************************************************
 View		[ETL].[dim_vehicle]
 Author		Pankaj Bhatt
 Created	2026-05-13
 Purpose	Used to build the edw.dim_vehicle table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2026-05-13		Pankaj Bhatt	Initial version
--1.1		 2026-10-21		Malhar Badheka	added vehicle service code 
**************************************************************************************************************/

SELECT 
	DISTINCT
	RTRIM(LTRIM([asset_id])) AS [vehicle_id]
	,[name] AS [vehicle_name]
	,[description] AS [vehicle_description]
	,[identifier] AS [vehicle_number_plate]
	,[type] AS [vehicle_type]
	,[class] AS [vehicle_class]
	,[make] AS [vehicle_make]
	,[model] AS [vehicle_model]
	,[year] AS [vehicle_year]
	,[asset_service_code] AS [vehicle_service_code]

	,[asset_nzta_subject_to_ruc] as [vehicle_nzta_subject_to_ruc]
	,[asset_nzta_subject_to_ruc_hubo] as [vehicle_nzta_subject_to_ruc_hubo]

	,[asset_nzta_wof_expiry_date] as [vehicle_nzta_wof_expiry_date]
	,[asset_nzta_wof_type] as [vehicle_nzta_wof_type]
	,[asset_nzta_license_expiry_date] as [vehicle_nzta_license_expiry_date]
	,[asset_nzta_fuel_type] as [vehicle_nzta_fuel_type]
	,[asset_nzta_ruc_expiry] as [vehicle_nzta_ruc_expiry]
	,[asset_nzta_ruc_expiry_date] as [vehicle_nzta_ruc_expiry_date]

FROM TapuiWaka.[asset]
WHERE ODSIsCurrent=1