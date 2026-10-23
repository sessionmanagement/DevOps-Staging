CREATE EXTERNAL TABLE [RBMNB].[dlDimSmokingStatus] (
    [SmokingStatusID] INT NULL,
    [SmokingStatusValue] NVARCHAR (200) NULL,
    [SmokingStatusText] NVARCHAR (200) NULL,
    [SmokingStatusParentId] INT NULL,
    [SmokingStatusIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimSmokingStatus/main',
    FILE_FORMAT = [parquet]
    );

