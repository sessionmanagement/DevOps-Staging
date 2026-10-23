CREATE EXTERNAL TABLE [working].[RBEAL_dlFactPersonLink] (
    [PersonLinkId] INT NULL,
    [PrimaryPersonId] INT NULL,
    [LinkedPersonId] INT NULL,
    [PersonLinkCreatedUserId] INT NULL,
    [PersonLinkCreatedDate] DATETIME NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonLink/working',
    FILE_FORMAT = [parquet]
    );

