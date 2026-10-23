CREATE EXTERNAL TABLE [working].[RBEAL_dlDimIPMHARole] (
    [IPMHARoleID] INT NULL,
    [IPMHARoleValue] NVARCHAR (200) NULL,
    [IPMHARoleText] NVARCHAR (200) NULL,
    [IPMHARoleParentId] INT NULL,
    [IPMHARoleIsActive] BIT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimIPMHARole/working',
    FILE_FORMAT = [parquet]
    );
GO

