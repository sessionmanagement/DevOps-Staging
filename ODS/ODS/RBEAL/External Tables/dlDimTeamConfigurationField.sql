CREATE EXTERNAL TABLE [RBEAL].[dlDimTeamConfigurationField] (
    [TeamConfigurationFieldID] INT NULL,
    [TeamConfigurationID] INT NULL,
    [TeamConfigurationFieldField] NVARCHAR (50) NULL,
    [TeamConfigurationFieldLabel] NVARCHAR (50) NULL,
    [LookupGroupID] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimTeamConfigurationField/main',
    FILE_FORMAT = [parquet]
    );

