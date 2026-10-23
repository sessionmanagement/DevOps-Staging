CREATE EXTERNAL TABLE [staging].[RBMNB_dlFactActivityBreakdown] (
    [ActivityBreakdownID] INT NULL,
    [ActivityID] INT NULL,
    [ActivityBreakdownTypeID] INT NULL,
    [ActivityBreakdownDuration] INT NULL,
    [ActivityBreakdownCreatedUserID] INT NULL,
    [ActivityBreakdownCreatedDate] DATETIME NULL,
    [CreatedApplicationId] INT NULL,
    [ActivityBreakdownCreatedApplicationSyncDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactActivityBreakdown/staging',
    FILE_FORMAT = [parquet]
    );

