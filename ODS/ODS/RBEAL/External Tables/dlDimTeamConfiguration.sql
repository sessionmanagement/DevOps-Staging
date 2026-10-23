CREATE EXTERNAL TABLE [RBEAL].[dlDimTeamConfiguration] (
    [TeamConfigurationID] INT NULL,
    [TeamConfigurationName] NVARCHAR (50) NULL,
    [TeamConfigurationDescription] NVARCHAR (MAX) NULL,
    [TeamConfigurationReferenceNumberRequired] INT NULL,
    [ExtractTypeID] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimTeamConfiguration/main',
    FILE_FORMAT = [parquet]
    );

