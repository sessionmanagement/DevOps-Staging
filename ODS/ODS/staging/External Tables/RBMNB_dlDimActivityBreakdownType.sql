CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimActivityBreakdownType] (
    [ActivityBreakdownTypeID] INT NULL,
    [TeamConfigurationID] INT NULL,
    [ActivityBreakdownTypeCode] NVARCHAR (50) NULL,
    [ActivityBreakdownTypeName] NVARCHAR (200) NULL,
    [ActivityBreakdownTypeParentID] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimActivityBreakdownType/staging',
    FILE_FORMAT = [parquet]
    );

