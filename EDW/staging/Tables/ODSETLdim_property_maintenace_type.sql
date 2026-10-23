CREATE TABLE [staging].[ODSETLdim_property_maintenace_type] (
    [ODSdim_property_maintenace_typeID]               INT            IDENTITY (1, 1) NOT NULL,
    [property_maintenance_type_id]                    NVARCHAR (40)  NULL,
    [property_maintenance_type_account_code]          NVARCHAR (80)  NULL,
    [property_maintenance_type]                       NVARCHAR (80)  NULL,
    [property_maintenance_type_code]                  NVARCHAR (80)  NULL,
    [property_maintenance_service_agreement_priority] NVARCHAR (50)  NULL,
    [property_maintenance_priority]                   NVARCHAR (200) NULL,
    [property_maintenance_owner_recovery_flag]        INT            NULL,
    [property_maintenance_service_agreement_flag]     INT            NULL,
    [property_maintenance_tenant_liable_flag]         INT            NULL,
    [property_maintenance_account_type]               NVARCHAR (80)  NULL,
    [property_maintenance_deleted_flag]               INT            NULL,
    [synapse_link_sink_modified_on]                   DATETIME2 (7)  NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_property_maintenace_type] PRIMARY KEY NONCLUSTERED ([ODSdim_property_maintenace_typeID] ASC)
);

