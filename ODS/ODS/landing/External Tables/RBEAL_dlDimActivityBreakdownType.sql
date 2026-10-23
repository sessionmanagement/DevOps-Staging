CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimActivityBreakdownType] (
    [ActivityBreakdownTypeID] INT NULL,
    [TeamConfigurationID] INT NULL,
    [ActivityBreakdownTypeCode] NVARCHAR (50) NULL,
    [ActivityBreakdownTypeName] NVARCHAR (200) NULL,
    [ActivityBreakdownTypeParentID] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimActivityBreakdownType/landing',
    FILE_FORMAT = [parquet]
    );

