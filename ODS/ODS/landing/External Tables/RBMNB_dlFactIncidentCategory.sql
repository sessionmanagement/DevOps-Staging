CREATE EXTERNAL TABLE [landing].[RBMNB_dlFactIncidentCategory] (
    [IncidentCategoryID] INT NULL,
    [IncidentID] INT NULL,
    [IncidentCategoryTypeID] INT NULL,
    [IncidentCategoryCreatedUserID] INT NULL,
    [IncidentCategoryCreatedDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactIncidentCategory/landing',
    FILE_FORMAT = [parquet]
    );

