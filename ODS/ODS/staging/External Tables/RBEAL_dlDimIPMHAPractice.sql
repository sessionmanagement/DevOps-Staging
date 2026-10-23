CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimIPMHAPractice] (
    [IPMHAPracticeID] INT NULL,
    [IPMHAPracticeValue] NVARCHAR (200) NULL,
    [IPMHAPracticeText] NVARCHAR (200) NULL,
    [IPMHAPracticeParentId] INT NULL,
    [IPMHAPracticeIsActive] BIT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimIPMHAPractice/staging',
    FILE_FORMAT = [parquet]
    );
GO

