CREATE TABLE [landing].[edw_dim_client_interaction_type] (
    [company_key]                         INT            NULL,
    [client_interaction_type_id]          INT            NULL,
    [client_interaction_type_code]        NVARCHAR (20) NULL,
    [client_interaction_type_name]        NVARCHAR (50) NULL,
    [client_parent_interaction_type_code] NVARCHAR (20) NULL,
    [client_parent_interaction_type_name] NVARCHAR (20) NULL
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [dim_client_interaction_type]
    ON [landing].[edw_dim_client_interaction_type]([company_key] ASC, [client_interaction_type_id] ASC);
GO

