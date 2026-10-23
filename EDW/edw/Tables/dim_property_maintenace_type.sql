CREATE TABLE [edw].[dim_property_maintenace_type] (
    [dim_property_maintenace_type_id]                 INT            IDENTITY (1, 1) NOT NULL,
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
    [DWHBatchId]                                      INT            NOT NULL,
    [DWHEffectiveFrom]                                DATETIME       NOT NULL,
    [DWHEffectiveTo]                                  DATETIME       NOT NULL,
    [DWHDMLOperation]                                 CHAR (1)       NOT NULL,
    [DWHIsCurrent]                                    BIT            NOT NULL,
    [DWHSourceSystem]                                 NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK__edw_dim_property_maintenace_type] PRIMARY KEY NONCLUSTERED ([dim_property_maintenace_type_id] ASC)
);



