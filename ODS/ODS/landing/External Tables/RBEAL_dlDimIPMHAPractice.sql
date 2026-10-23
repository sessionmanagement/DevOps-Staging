CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimIPMHAPractice] (
    [IPMHAPracticeID] INT NULL,
    [IPMHAPracticeValue] NVARCHAR (200) NULL,
    [IPMHAPracticeText] NVARCHAR (200) NULL,
    [IPMHAPracticeParentId] INT NULL,
    [IPMHAPracticeIsActive] BIT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimIPMHAPractice/landing',
    FILE_FORMAT = [parquet]
    );
GO

