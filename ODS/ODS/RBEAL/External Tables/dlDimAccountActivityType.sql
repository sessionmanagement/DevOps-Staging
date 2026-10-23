CREATE EXTERNAL TABLE [RBEAL].[dlDimAccountActivityType] (
    [AccountActivityTypeID] INT NULL,
    [AccountActivityTypeValue] NVARCHAR (200) NULL,
    [AccountActivityTypeText] NVARCHAR (200) NULL,
    [AccountActivityTypeParentId] INT NULL,
    [AccountActivityTypeIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimAccountActivityType/main',
    FILE_FORMAT = [parquet]
    );

