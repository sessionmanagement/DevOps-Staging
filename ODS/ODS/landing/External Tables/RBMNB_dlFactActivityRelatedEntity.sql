CREATE EXTERNAL TABLE [landing].[RBMNB_dlFactActivityRelatedEntity] (
    [ActivityRelatedEntityID] INT NULL,
    [ActivityID] INT NULL,
    [ActivityRelatedEntityRelatedEntityType] NVARCHAR (50) NULL,
    [RelatedEntityID] INT NULL,
    [ActivityRelatedEntityCreatedUserID] INT NULL,
    [ActivityRelatedEntityCreatedDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactActivityRelatedEntity/landing',
    FILE_FORMAT = [parquet]
    );

