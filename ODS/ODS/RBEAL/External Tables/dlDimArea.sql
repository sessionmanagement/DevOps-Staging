CREATE EXTERNAL TABLE [RBEAL].[dlDimArea] (
    [AreaID] INT NULL,
    [AreaParentID] INT NULL,
    [AreaName] NVARCHAR (50) NULL,
    [AreaDescription] NVARCHAR (MAX) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimArea/main',
    FILE_FORMAT = [parquet]
    );

