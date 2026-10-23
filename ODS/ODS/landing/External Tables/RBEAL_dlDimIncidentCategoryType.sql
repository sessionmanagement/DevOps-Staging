CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimIncidentCategoryType] (
    [IncidentCategoryTypeID] INT NULL,
    [IncidentCategoryTypeValue] NVARCHAR (200) NULL,
    [IncidentCategoryTypeText] NVARCHAR (200) NULL,
    [IncidentCategoryTypeParentId] INT NULL,
    [IncidentCategoryTypeIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimIncidentCategoryType/landing',
    FILE_FORMAT = [parquet]
    );

