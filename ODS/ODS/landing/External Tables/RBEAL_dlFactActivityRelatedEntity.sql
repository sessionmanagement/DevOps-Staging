CREATE EXTERNAL TABLE [landing].[RBEAL_dlFactActivityRelatedEntity] (
    [ActivityRelatedEntityID] INT NULL,
    [ActivityID] INT NULL,
    [ActivityRelatedEntityRelatedEntityType] NVARCHAR (50) NULL,
    [RelatedEntityID] INT NULL,
    [ActivityRelatedEntityCreatedUserID] INT NULL,
    [ActivityRelatedEntityCreatedDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactActivityRelatedEntity/landing',
    FILE_FORMAT = [parquet]
    );

