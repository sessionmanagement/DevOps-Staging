CREATE EXTERNAL TABLE [RBEAL].[dlDimIPMHARole] (
    [IPMHARoleID] INT NULL,
    [IPMHARoleValue] NVARCHAR (200) NULL,
    [IPMHARoleText] NVARCHAR (200) NULL,
    [IPMHARoleParentId] INT NULL,
    [IPMHARoleIsActive] BIT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimIPMHARole/main',
    FILE_FORMAT = [parquet]
    );
GO

