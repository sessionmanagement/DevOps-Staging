CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimContract] (
    [ContractID] INT NULL,
    [TeamConfigurationID] INT NULL,
    [ContractName] NVARCHAR (50) NULL,
    [ContractDescription] NVARCHAR (MAX) NULL,
    [ContractStartDate] DATETIME NULL,
    [ContractEndDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimContract/landing',
    FILE_FORMAT = [parquet]
    );

