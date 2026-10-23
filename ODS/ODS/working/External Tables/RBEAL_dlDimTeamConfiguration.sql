CREATE EXTERNAL TABLE [working].[RBEAL_dlDimTeamConfiguration] (
    [TeamConfigurationID] INT NULL,
    [TeamConfigurationName] NVARCHAR (50) NULL,
    [TeamConfigurationDescription] NVARCHAR (MAX) NULL,
    [TeamConfigurationReferenceNumberRequired] INT NULL,
    [ExtractTypeID] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimTeamConfiguration/working',
    FILE_FORMAT = [parquet]
    );

