CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimActivityClassification] (
    [ActivityClassificationID] INT NULL,
    [TeamConfigurationID] INT NULL,
    [ActivityClassificationCode] NVARCHAR (20) NULL,
    [ActivityClassificationName] NVARCHAR (50) NULL,
    [ActivityClassificationDescription] NVARCHAR (MAX) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimActivityClassification/staging',
    FILE_FORMAT = [parquet]
    );

