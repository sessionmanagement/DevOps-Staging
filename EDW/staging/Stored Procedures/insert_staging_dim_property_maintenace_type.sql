CREATE PROC [staging].[insert_staging_dim_property_maintenace_type]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_property_maintenace_type]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-12-12    ?				Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_property_maintenace_type]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_property_maintenace_type] (
	 [property_maintenance_type_id] 	,[property_maintenance_type_account_code] 	,[property_maintenance_type] 	,[property_maintenance_type_code] 	,[property_maintenance_service_agreement_priority] 	,[property_maintenance_priority] 	,[property_maintenance_owner_recovery_flag] 	,[property_maintenance_service_agreement_flag] 	,[property_maintenance_tenant_liable_flag] 	,[property_maintenance_account_type] 	,[property_maintenance_deleted_flag] 	,[synapse_link_sink_modified_on] 
	)
SELECT
	 [property_maintenance_type_id] 	,[property_maintenance_type_account_code] 	,[property_maintenance_type] 	,[property_maintenance_type_code] 	,[property_maintenance_service_agreement_priority] 	,[property_maintenance_priority] 	,[property_maintenance_owner_recovery_flag] 	,[property_maintenance_service_agreement_flag] 	,[property_maintenance_tenant_liable_flag] 	,[property_maintenance_account_type] 	,[property_maintenance_deleted_flag] 	,[synapse_link_sink_modified_on] 
from [Landing].[edw_dim_property_maintenace_type]