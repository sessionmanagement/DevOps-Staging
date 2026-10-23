CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimResidency] (
    [ResidencyID] INT NULL,
    [ResidencyValue] NVARCHAR (200) NULL,
    [ResidencyText] NVARCHAR (200) NULL,
    [ResidencyParentId] INT NULL,
    [ResidencyIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimResidency/staging',
    FILE_FORMAT = [parquet]
    );

