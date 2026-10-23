CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimAccountActivityType] (
    [AccountActivityTypeID] INT NULL,
    [AccountActivityTypeValue] NVARCHAR (200) NULL,
    [AccountActivityTypeText] NVARCHAR (200) NULL,
    [AccountActivityTypeParentId] INT NULL,
    [AccountActivityTypeIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimAccountActivityType/staging',
    FILE_FORMAT = [parquet]
    );

