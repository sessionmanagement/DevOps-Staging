CREATE EXTERNAL TABLE [working].[RBEAL_dlFactActivityRelatedEntity] (
    [ActivityRelatedEntityID] INT NULL,
    [ActivityID] INT NULL,
    [ActivityRelatedEntityRelatedEntityType] NVARCHAR (50) NULL,
    [RelatedEntityID] INT NULL,
    [ActivityRelatedEntityCreatedUserID] INT NULL,
    [ActivityRelatedEntityCreatedDate] DATETIME NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactActivityRelatedEntity/working',
    FILE_FORMAT = [parquet]
    );

