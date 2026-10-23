CREATE EXTERNAL TABLE [landing].[RBEAL_dlFactIncidentCategory] (
    [IncidentCategoryID] INT NULL,
    [IncidentID] INT NULL,
    [IncidentCategoryTypeID] INT NULL,
    [IncidentCategoryCreatedUserID] INT NULL,
    [IncidentCategoryCreatedDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactIncidentCategory/landing',
    FILE_FORMAT = [parquet]
    );

