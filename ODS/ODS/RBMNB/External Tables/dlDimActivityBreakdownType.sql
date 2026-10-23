CREATE EXTERNAL TABLE [RBMNB].[dlDimActivityBreakdownType] (
    [ActivityBreakdownTypeID] INT NULL,
    [TeamConfigurationID] INT NULL,
    [ActivityBreakdownTypeCode] NVARCHAR (50) NULL,
    [ActivityBreakdownTypeName] NVARCHAR (200) NULL,
    [ActivityBreakdownTypeParentID] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimActivityBreakdownType/main',
    FILE_FORMAT = [parquet]
    );

