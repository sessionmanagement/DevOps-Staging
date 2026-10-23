CREATE EXTERNAL TABLE [working].[RBEAL_dlDimActivityType] (
    [ActivityTypeID] INT NULL,
    [TeamConfigurationID] INT NULL,
    [ActivityTypeCode] NVARCHAR (20) NULL,
    [ActivityTypeName] NVARCHAR (50) NULL,
    [ActivityTypeDescription] NVARCHAR (MAX) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimActivityType/working',
    FILE_FORMAT = [parquet]
    );

