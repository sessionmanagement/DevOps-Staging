

CREATE   VIEW [edw].[vw_dim_vehicle]
AS
SELECT 
	[dim_vehicle_key],
	[vehicle_id],
	[vehicle_name],
	[vehicle_description],
	[vehicle_number_plate],
	[vehicle_type],
	[vehicle_class],
	[vehicle_make],
	[vehicle_model],
	[vehicle_year],
	[vehicle_nzta_subject_to_ruc],
	[vehicle_nzta_subject_to_ruc_hubo],
	[vehicle_nzta_wof_expiry_date],
	[vehicle_nzta_wof_type],
	[vehicle_nzta_license_expiry_date],
	[vehicle_nzta_fuel_type],
	[vehicle_nzta_ruc_expiry],
	[vehicle_nzta_ruc_expiry_date],
	[vehicle_service_code],
	[DWHBatchId],
	[DWHEffectiveFrom],
	[DWHEffectiveTo],
	[DWHDMLOperation],
	[DWHIsCurrent],
	[DWHSourceSystem]
FROM [edw].[dim_vehicle]