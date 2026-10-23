CREATE EXTERNAL TABLE [RBMNB].[dlDimContract] (
    [ContractID] INT NULL,
    [TeamConfigurationID] INT NULL,
    [ContractName] NVARCHAR (50) NULL,
    [ContractDescription] NVARCHAR (MAX) NULL,
    [ContractStartDate] DATETIME NULL,
    [ContractEndDate] DATETIME NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimContract/main',
    FILE_FORMAT = [parquet]
    );

