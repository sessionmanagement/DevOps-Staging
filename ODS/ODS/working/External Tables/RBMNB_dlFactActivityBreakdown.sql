CREATE EXTERNAL TABLE [working].[RBMNB_dlFactActivityBreakdown] (
    [ActivityBreakdownID] INT NULL,
    [ActivityID] INT NULL,
    [ActivityBreakdownTypeID] INT NULL,
    [ActivityBreakdownDuration] INT NULL,
    [ActivityBreakdownCreatedUserID] INT NULL,
    [ActivityBreakdownCreatedDate] DATETIME NULL,
    [CreatedApplicationId] INT NULL,
    [ActivityBreakdownCreatedApplicationSyncDate] DATETIME NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactActivityBreakdown/working',
    FILE_FORMAT = [parquet]
    );

