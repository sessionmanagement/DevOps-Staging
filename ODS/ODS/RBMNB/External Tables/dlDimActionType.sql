CREATE EXTERNAL TABLE [RBMNB].[dlDimActionType] (
    [ActionTypeID] INT NULL,
    [ActionTypeValue] NVARCHAR (200) NULL,
    [ActionTypeText] NVARCHAR (200) NULL,
    [ActionTypeParentId] INT NULL,
    [ActionTypeIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimActionType/main',
    FILE_FORMAT = [parquet]
    );

