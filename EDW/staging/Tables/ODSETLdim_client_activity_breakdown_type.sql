CREATE TABLE [staging].[ODSETLdim_client_activity_breakdown_type] (
    [client_activity_breakdown_type_id]             INT            NOT NULL,
    [dim_client_activity_breakdown_type_unique_key] NVARCHAR (50)  NOT NULL,
    [company_id]                                    INT            NOT NULL,
    [team_configuration_name]                       NVARCHAR (50)  NULL,
    [client_activity_breakdown_type_code]           NVARCHAR (50)  NULL,
    [client_activity_breakdown_type_name]           NVARCHAR (200) NULL,
    [client_parent_activity_breakdown_type]         INT            NULL,
    [client_parent_activity_breakdown_type_name]    NVARCHAR (200) NULL
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_dim_activity_breakdown_type]
    ON [staging].[ODSETLdim_client_activity_breakdown_type]([dim_client_activity_breakdown_type_unique_key] ASC);

