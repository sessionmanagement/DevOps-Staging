CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimActionType] (
    [ActionTypeID] INT NULL,
    [ActionTypeValue] NVARCHAR (200) NULL,
    [ActionTypeText] NVARCHAR (200) NULL,
    [ActionTypeParentId] INT NULL,
    [ActionTypeIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimActionType/landing',
    FILE_FORMAT = [parquet]
    );

