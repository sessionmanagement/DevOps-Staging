CREATE EXTERNAL TABLE [working].[RBEAL_dlDimEthnicity] (
    [EthnicityID] INT NULL,
    [EthnicityValue] NVARCHAR (200) NULL,
    [EthnicityText] NVARCHAR (200) NULL,
    [EthnicityParentId] INT NULL,
    [EthnicityIsActive] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimEthnicity/working',
    FILE_FORMAT = [parquet]
    );

