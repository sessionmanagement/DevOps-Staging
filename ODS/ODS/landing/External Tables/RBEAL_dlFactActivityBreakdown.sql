CREATE EXTERNAL TABLE [landing].[RBEAL_dlFactActivityBreakdown] (
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
    LOCATION = N'RBEAL/dlFactActivityBreakdown/landing',
    FILE_FORMAT = [parquet]
    );

