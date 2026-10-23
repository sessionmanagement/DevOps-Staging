CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimActivityType] (
    [ActivityTypeID] INT NULL,
    [TeamConfigurationID] INT NULL,
    [ActivityTypeCode] NVARCHAR (20) NULL,
    [ActivityTypeName] NVARCHAR (50) NULL,
    [ActivityTypeDescription] NVARCHAR (MAX) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimActivityType/landing',
    FILE_FORMAT = [parquet]
    );

