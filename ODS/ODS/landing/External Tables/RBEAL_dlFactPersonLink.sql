CREATE EXTERNAL TABLE [landing].[RBEAL_dlFactPersonLink] (
    [PersonLinkId] INT NULL,
    [PrimaryPersonId] INT NULL,
    [LinkedPersonId] INT NULL,
    [PersonLinkCreatedUserId] INT NULL,
    [PersonLinkCreatedDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonLink/landing',
    FILE_FORMAT = [parquet]
    );

