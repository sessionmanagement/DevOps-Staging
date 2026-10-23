CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimIPMHARole] (
    [IPMHARoleID] INT NULL,
    [IPMHARoleValue] NVARCHAR (200) NULL,
    [IPMHARoleText] NVARCHAR (200) NULL,
    [IPMHARoleParentId] INT NULL,
    [IPMHARoleIsActive] BIT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimIPMHARole/staging',
    FILE_FORMAT = [parquet]
    );
GO

