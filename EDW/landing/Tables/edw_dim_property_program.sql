CREATE TABLE [landing].[edw_dim_property_program] (
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
    [synapse_link_sink_modified_on]                  DATETIME2 (7)   NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_dim_property_program]
    ON [landing].[edw_dim_property_program]([property_subprogram_id] ASC);

