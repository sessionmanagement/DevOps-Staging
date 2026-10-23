CREATE EXTERNAL TABLE [working].[RBMNB_dlDimResidency] (
    [ResidencyID] INT NULL,
    [ResidencyValue] NVARCHAR (200) NULL,
    [ResidencyText] NVARCHAR (200) NULL,
    [ResidencyParentId] INT NULL,
    [ResidencyIsActive] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimResidency/working',
    FILE_FORMAT = [parquet]
    );

