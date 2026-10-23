CREATE EXTERNAL TABLE [RBEAL].[dlDimIncidentCategoryType] (
    [IncidentCategoryTypeID] INT NULL,
    [IncidentCategoryTypeValue] NVARCHAR (200) NULL,
    [IncidentCategoryTypeText] NVARCHAR (200) NULL,
    [IncidentCategoryTypeParentId] INT NULL,
    [IncidentCategoryTypeIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimIncidentCategoryType/main',
    FILE_FORMAT = [parquet]
    );

