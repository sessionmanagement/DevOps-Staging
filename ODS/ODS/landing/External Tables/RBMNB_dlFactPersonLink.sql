CREATE EXTERNAL TABLE [landing].[RBMNB_dlFactPersonLink] (
    [PersonLinkId] INT NULL,
    [PrimaryPersonId] INT NULL,
    [LinkedPersonId] INT NULL,
    [PersonLinkCreatedUserId] INT NULL,
    [PersonLinkCreatedDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPersonLink/landing',
    FILE_FORMAT = [parquet]
    );

