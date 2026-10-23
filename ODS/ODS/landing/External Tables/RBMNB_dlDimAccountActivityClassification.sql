CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimAccountActivityClassification] (
    [AccountActivityClassificationID] INT NULL,
    [AccountActivityClassificationValue] NVARCHAR (200) NULL,
    [AccountActivityClassificationText] NVARCHAR (200) NULL,
    [AccountActivityClassificationParentId] INT NULL,
    [AccountActivityClassificationIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimAccountActivityClassification/landing',
    FILE_FORMAT = [parquet]
    );

