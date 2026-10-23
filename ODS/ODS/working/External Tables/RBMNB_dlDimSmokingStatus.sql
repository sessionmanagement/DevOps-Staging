CREATE EXTERNAL TABLE [working].[RBMNB_dlDimSmokingStatus] (
    [SmokingStatusID] INT NULL,
    [SmokingStatusValue] NVARCHAR (200) NULL,
    [SmokingStatusText] NVARCHAR (200) NULL,
    [SmokingStatusParentId] INT NULL,
    [SmokingStatusIsActive] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimSmokingStatus/working',
    FILE_FORMAT = [parquet]
    );

