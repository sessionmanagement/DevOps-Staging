CREATE EXTERNAL TABLE [staging].[RBMNB_dlFactPersonLink] (
    [PersonLinkId] INT NULL,
    [PrimaryPersonId] INT NULL,
    [LinkedPersonId] INT NULL,
    [PersonLinkCreatedUserId] INT NULL,
    [PersonLinkCreatedDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPersonLink/staging',
    FILE_FORMAT = [parquet]
    );

