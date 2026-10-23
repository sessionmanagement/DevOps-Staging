CREATE EXTERNAL TABLE [working].[RBEAL_dlDimIncidentCategoryType] (
    [IncidentCategoryTypeID] INT NULL,
    [IncidentCategoryTypeValue] NVARCHAR (200) NULL,
    [IncidentCategoryTypeText] NVARCHAR (200) NULL,
    [IncidentCategoryTypeParentId] INT NULL,
    [IncidentCategoryTypeIsActive] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimIncidentCategoryType/working',
    FILE_FORMAT = [parquet]
    );

