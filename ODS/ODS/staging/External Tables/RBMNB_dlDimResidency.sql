CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimResidency] (
    [ResidencyID] INT NULL,
    [ResidencyValue] NVARCHAR (200) NULL,
    [ResidencyText] NVARCHAR (200) NULL,
    [ResidencyParentId] INT NULL,
    [ResidencyIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimResidency/staging',
    FILE_FORMAT = [parquet]
    );

