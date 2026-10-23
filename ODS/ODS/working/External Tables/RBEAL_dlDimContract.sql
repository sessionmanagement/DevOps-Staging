CREATE EXTERNAL TABLE [working].[RBEAL_dlDimContract] (
    [ContractID] INT NULL,
    [TeamConfigurationID] INT NULL,
    [ContractName] NVARCHAR (50) NULL,
    [ContractDescription] NVARCHAR (MAX) NULL,
    [ContractStartDate] DATETIME NULL,
    [ContractEndDate] DATETIME NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimContract/working',
    FILE_FORMAT = [parquet]
    );

