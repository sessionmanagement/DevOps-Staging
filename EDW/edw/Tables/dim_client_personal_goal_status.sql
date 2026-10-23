CREATE TABLE [edw].[dim_client_personal_goal_status] (
    [dim_client_personal_goal_status_key]        INT            IDENTITY (100000, 1) NOT NULL,
    [company_id]                                 INT            NOT NULL,
    [dim_client_personal_goal_status_unique_key] NVARCHAR (100) NOT NULL,
    [personal_goal_status_type_id]               INT            NULL,
    [personal_goal_status_type_value]            NVARCHAR (200) NULL,
    [personal_goal_status_type_text]             NVARCHAR (200) NULL,
    [DWHSourceSystem]                            NVARCHAR (500) NOT NULL,
    [DWHBatchId]                                 INT            NOT NULL,
    [DWHDMLOperation]                            CHAR (1)       NOT NULL,
    [DWHModifiedOn]                              DATETIME       NOT NULL,
    [DWHCreatedAt]                               DATETIME       NOT NULL,
    CONSTRAINT [PK_EDW_dim_client_personal_goal_status] PRIMARY KEY NONCLUSTERED ([dim_client_personal_goal_status_key] ASC)
);



