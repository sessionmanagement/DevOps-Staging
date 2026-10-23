CREATE TABLE [edw].[dim_client_activity_breakdown_type] (
    [dim_client_activity_breakdown_type_key]        INT            IDENTITY (100000, 1) NOT NULL,
    [client_activity_breakdown_type_id]             INT            NOT NULL,
    [dim_client_activity_breakdown_type_unique_key] NVARCHAR (50)  NOT NULL,
    [company_id]                                    INT            NOT NULL,
    [team_configuration_name]                       NVARCHAR (50)  NULL,
    [client_activity_breakdown_type_code]           NVARCHAR (50)  NULL,
    [client_activity_breakdown_type_name]           NVARCHAR (200) NULL,
    [client_parent_activity_breakdown_type]         INT            NULL,
    [client_parent_activity_breakdown_type_name]    NVARCHAR (200) NULL,
    [DWHSourceSystem]                               NVARCHAR (500) NOT NULL,
    [DWHBatchId]                                    INT            NOT NULL,
    [DWHDMLOperation]                               CHAR (1)       NOT NULL,
    [DWHModifiedOn]                                 DATETIME       NOT NULL,
    [DWHCreatedAt]                                  DATETIME       NOT NULL,
    CONSTRAINT [PK_EDW_dim_client_activity_breakdown_type] PRIMARY KEY NONCLUSTERED ([dim_client_activity_breakdown_type_key] ASC)
);





