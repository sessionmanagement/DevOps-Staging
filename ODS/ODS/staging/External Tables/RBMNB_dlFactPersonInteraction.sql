CREATE EXTERNAL TABLE [staging].[RBMNB_dlFactPersonInteraction] (
    [PersonInteractionId] INT NULL,
    [PersonId] INT NULL,
    [PersonInteractionTypeId] INT NULL,
    [PersonInteractionOccurred] DATETIME2 (7) NULL,
    [PersonInteractionComments] NVARCHAR (MAX) NULL,
    [PersonInteractionCommentsHtml] NVARCHAR (MAX) NULL,
    [PersonInteractionCreatedDate] DATETIME NULL,
    [PersonInteractionCreatedUserID] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPersonInteraction/staging',
    FILE_FORMAT = [parquet]
    );
