CREATE EXTERNAL TABLE [RBMNB].[dlDimIPMHAPractice] (
    [IPMHAPracticeID] INT NULL,
    [IPMHAPracticeValue] NVARCHAR (200) NULL,
    [IPMHAPracticeText] NVARCHAR (200) NULL,
    [IPMHAPracticeParentId] INT NULL,
    [IPMHAPracticeIsActive] BIT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimIPMHAPractice/main',
    FILE_FORMAT = [parquet]
    );
GO

