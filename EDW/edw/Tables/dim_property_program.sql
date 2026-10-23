CREATE TABLE [edw].[dim_property_program] (
    [dim_property_program_id]                        INT             IDENTITY (1, 1) NOT NULL,
    [property_program_id]                            NVARCHAR (40)   NULL,
    [property_subprogram_id]                         NVARCHAR (40)   NULL,
    [property_program_name]                          NVARCHAR (100)  NULL,
    [property_program_owner_name]                    NVARCHAR (100)  NULL,
    [property_subprogram_name]                       NVARCHAR (100)  NULL,
    [property_subprogram_property_transaction_types] NVARCHAR (1000) NULL,
    [property_subprogram_state]                      NVARCHAR (20)   NULL,
    [property_subprogram_status]                     NVARCHAR (20)   NULL,
    [property_market_rent_ignore_flag]               INT             NULL,
    [property_subprogram_owning_business_unit_name]  NVARCHAR (100)  NULL,
    [property_subprogram_owning_team_name]           NVARCHAR (100)  NULL,
    [property_subprogram_owning_user_name]           NVARCHAR (100)  NULL,
    [property_subprogram_owner_name]                 NVARCHAR (100)  NULL,
    [property_subprogram_created_by_user_name]       NVARCHAR (100)  NULL,
    [property_subprogram_modified_by_user_name]      NVARCHAR (100)  NULL,
    [property_subprogram_modified_on_date]           DATETIME2 (7)   NULL,
    [property_subprogram_version_number]             BIGINT          NULL,
    [property_subprogram_code]                       NVARCHAR (20)   NULL,
    [property_subprogram_deleted_flag]               INT             NULL,
    [synapse_link_sink_modified_on]                  DATETIME2 (7)   NULL,
    [DWHBatchId]                                     INT             NOT NULL,
    [DWHEffectiveFrom]                               DATETIME        NOT NULL,
    [DWHEffectiveTo]                                 DATETIME        NOT NULL,
    [DWHDMLOperation]                                CHAR (1)        NOT NULL,
    [DWHIsCurrent]                                   BIT             NOT NULL,
    [DWHSourceSystem]                                NVARCHAR (500)  NOT NULL,
    CONSTRAINT [PK__edw_dim_property_program] PRIMARY KEY NONCLUSTERED ([dim_property_program_id] ASC)
);



