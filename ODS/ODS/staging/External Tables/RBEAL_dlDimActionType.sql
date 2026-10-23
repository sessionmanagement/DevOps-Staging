CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimActionType] (
    [ActionTypeID] INT NULL,
    [ActionTypeValue] NVARCHAR (200) NULL,
    [ActionTypeText] NVARCHAR (200) NULL,
    [ActionTypeParentId] INT NULL,
    [ActionTypeIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimActionType/staging',
    FILE_FORMAT = [parquet]
    );

