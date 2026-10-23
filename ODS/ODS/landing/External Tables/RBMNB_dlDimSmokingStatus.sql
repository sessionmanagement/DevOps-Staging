CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimSmokingStatus] (
    [SmokingStatusID] INT NULL,
    [SmokingStatusValue] NVARCHAR (200) NULL,
    [SmokingStatusText] NVARCHAR (200) NULL,
    [SmokingStatusParentId] INT NULL,
    [SmokingStatusIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimSmokingStatus/landing',
    FILE_FORMAT = [parquet]
    );

