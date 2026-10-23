CREATE TABLE [landing].[edw_dim_client_activity_breakdown_type] (
    [company_key]                                INT            NULL,
    [client_activity_breakdown_type_id]          INT            NULL,
    [team_configuration_name]                    NVARCHAR (50)  NULL,
    [client_activity_breakdown_type_code]        NVARCHAR (50)  NULL,
    [client_activity_breakdown_type_name]        NVARCHAR (200) NULL,
    [client_parent_activity_breakdown_type]      INT            NULL,
    [client_parent_activity_breakdown_type_name] NVARCHAR (200) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_dim_client_activity_breakdown_type]
    ON [landing].[edw_dim_client_activity_breakdown_type]([client_activity_breakdown_type_id] ASC, [company_key] ASC);

