CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimAccountActivityClassification] (
    [AccountActivityClassificationID] INT NULL,
    [AccountActivityClassificationValue] NVARCHAR (200) NULL,
    [AccountActivityClassificationText] NVARCHAR (200) NULL,
    [AccountActivityClassificationParentId] INT NULL,
    [AccountActivityClassificationIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimAccountActivityClassification/staging',
    FILE_FORMAT = [parquet]
    );

