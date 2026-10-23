
CREATE PROC [staging].[insert_staging_dim_vehicle]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_vehicle]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-05-18    Pankaj Bhatt		Initial version
1.1		 2026-10-21    GitHub Copilot	Add vehicle_service_code (#15036)

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_vehicle]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_vehicle] (
	 [vehicle_id] 
	,[vehicle_name] 
	,[vehicle_description] 
	,[vehicle_number_plate] 
	,[vehicle_type] 
	,[vehicle_class] 
	,[vehicle_make] 
	,[vehicle_model] 
	,[vehicle_year] 
	,[vehicle_nzta_subject_to_ruc] 
	,[vehicle_nzta_subject_to_ruc_hubo] 
	,[vehicle_nzta_wof_expiry_date] 
	,[vehicle_nzta_wof_type] 
	,[vehicle_nzta_license_expiry_date] 
	,[vehicle_nzta_fuel_type] 
	,[vehicle_nzta_ruc_expiry] 
	,[vehicle_nzta_ruc_expiry_date] 
	,[vehicle_service_code]
	)
SELECT
	 [vehicle_id] 
	,[vehicle_name] 
	,[vehicle_description] 
	,[vehicle_number_plate] 
	,[vehicle_type] 
	,[vehicle_class] 
	,[vehicle_make] 
	,[vehicle_model] 
	,[vehicle_year] 
	,[vehicle_nzta_subject_to_ruc] 
	,[vehicle_nzta_subject_to_ruc_hubo] 
	,[vehicle_nzta_wof_expiry_date] 
	,[vehicle_nzta_wof_type] 
	,[vehicle_nzta_license_expiry_date] 
	,[vehicle_nzta_fuel_type] 
	,[vehicle_nzta_ruc_expiry] 
	,[vehicle_nzta_ruc_expiry_date] 
	,[vehicle_service_code]
from [Landing].[edw_dim_vehicle]