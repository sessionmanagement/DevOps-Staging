CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimArea] (
    [AreaID] INT NULL,
    [AreaParentID] INT NULL,
    [AreaName] NVARCHAR (50) NULL,
    [AreaDescription] NVARCHAR (MAX) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimArea/landing',
    FILE_FORMAT = [parquet]
    );

