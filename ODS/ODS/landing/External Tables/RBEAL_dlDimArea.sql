CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimArea] (
    [AreaID] INT NULL,
    [AreaParentID] INT NULL,
    [AreaName] NVARCHAR (50) NULL,
    [AreaDescription] NVARCHAR (MAX) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimArea/landing',
    FILE_FORMAT = [parquet]
    );

