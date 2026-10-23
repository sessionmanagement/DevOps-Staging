CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimAccountActivityType] (
    [AccountActivityTypeID] INT NULL,
    [AccountActivityTypeValue] NVARCHAR (200) NULL,
    [AccountActivityTypeText] NVARCHAR (200) NULL,
    [AccountActivityTypeParentId] INT NULL,
    [AccountActivityTypeIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimAccountActivityType/landing',
    FILE_FORMAT = [parquet]
    );

