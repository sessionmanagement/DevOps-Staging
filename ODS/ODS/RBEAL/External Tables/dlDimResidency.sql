CREATE EXTERNAL TABLE [RBEAL].[dlDimResidency] (
    [ResidencyID] INT NULL,
    [ResidencyValue] NVARCHAR (200) NULL,
    [ResidencyText] NVARCHAR (200) NULL,
    [ResidencyParentId] INT NULL,
    [ResidencyIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimResidency/main',
    FILE_FORMAT = [parquet]
    );

