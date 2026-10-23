CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimResidency] (
    [ResidencyID] INT NULL,
    [ResidencyValue] NVARCHAR (200) NULL,
    [ResidencyText] NVARCHAR (200) NULL,
    [ResidencyParentId] INT NULL,
    [ResidencyIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimResidency/landing',
    FILE_FORMAT = [parquet]
    );

