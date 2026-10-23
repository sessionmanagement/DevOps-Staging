CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimContract] (
    [ContractID] INT NULL,
    [TeamConfigurationID] INT NULL,
    [ContractName] NVARCHAR (50) NULL,
    [ContractDescription] NVARCHAR (MAX) NULL,
    [ContractStartDate] DATETIME NULL,
    [ContractEndDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimContract/landing',
    FILE_FORMAT = [parquet]
    );

