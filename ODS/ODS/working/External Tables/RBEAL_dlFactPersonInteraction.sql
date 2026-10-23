CREATE EXTERNAL TABLE [working].[RBEAL_dlFactPersonInteraction] (
    [PersonInteractionId] INT NULL,
    [PersonId] INT NULL,
    [PersonInteractionTypeId] INT NULL,
    [PersonInteractionOccurred] DATETIME2 (7) NULL,
    [PersonInteractionComments] NVARCHAR (MAX) NULL,
    [PersonInteractionCommentsHtml] NVARCHAR (MAX) NULL,
    [PersonInteractionCreatedDate] DATETIME NULL,
    [PersonInteractionCreatedUserID] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonInteraction/working',
    FILE_FORMAT = [parquet]
    );
