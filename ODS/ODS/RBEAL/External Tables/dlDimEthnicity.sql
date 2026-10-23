CREATE EXTERNAL TABLE [RBEAL].[dlDimEthnicity] (
    [EthnicityID] INT NULL,
    [EthnicityValue] NVARCHAR (200) NULL,
    [EthnicityText] NVARCHAR (200) NULL,
    [EthnicityParentId] INT NULL,
    [EthnicityIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimEthnicity/main',
    FILE_FORMAT = [parquet]
    );

