CREATE EXTERNAL TABLE [RBMNB].[dlFactPersonInteraction] (
    [PersonInteractionId] INT NULL,
    [PersonId] INT NULL,
    [PersonInteractionTypeId] INT NULL,
    [PersonInteractionOccurred] DATETIME2 (7) NULL,
    [PersonInteractionComments] NVARCHAR (MAX) NULL,
    [PersonInteractionCommentsHtml] NVARCHAR (MAX) NULL,
    [PersonInteractionCreatedDate] DATETIME NULL,
    [PersonInteractionCreatedUserID] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPersonInteraction/main',
    FILE_FORMAT = [parquet]
    );
