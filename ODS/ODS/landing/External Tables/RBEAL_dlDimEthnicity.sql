CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimEthnicity] (
    [EthnicityID] INT NULL,
    [EthnicityValue] NVARCHAR (200) NULL,
    [EthnicityText] NVARCHAR (200) NULL,
    [EthnicityParentId] INT NULL,
    [EthnicityIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimEthnicity/landing',
    FILE_FORMAT = [parquet]
    );

