CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimEthnicity] (
    [EthnicityID] INT NULL,
    [EthnicityValue] NVARCHAR (200) NULL,
    [EthnicityText] NVARCHAR (200) NULL,
    [EthnicityParentId] INT NULL,
    [EthnicityIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimEthnicity/staging',
    FILE_FORMAT = [parquet]
    );

