

CREATE VIEW [edw].[vw_dim_property_maintenace_type]
AS
SELECT dim_property_maintenace_type_id
	,property_maintenance_type_id
	,property_maintenance_type_account_code
	,property_maintenance_type
	,property_maintenance_type_code
	,property_maintenance_service_agreement_priority
	,property_maintenance_priority
	,property_maintenance_owner_recovery_flag
	,property_maintenance_service_agreement_flag
	,property_maintenance_tenant_liable_flag
	,property_maintenance_account_type
	,property_maintenance_deleted_flag
	,synapse_link_sink_modified_on
      ,[DWHBatchId]
      ,[DWHEffectiveFrom]
      ,[DWHEffectiveTo]
      ,[DWHDMLOperation]
      ,[DWHIsCurrent]
      ,[DWHSourceSystem]
FROM [edw].[dim_property_maintenace_type]