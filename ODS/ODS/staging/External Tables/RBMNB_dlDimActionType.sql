CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimActionType] (
    [ActionTypeID] INT NULL,
    [ActionTypeValue] NVARCHAR (200) NULL,
    [ActionTypeText] NVARCHAR (200) NULL,
    [ActionTypeParentId] INT NULL,
    [ActionTypeIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimActionType/staging',
    FILE_FORMAT = [parquet]
    );

