CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimTeamConfiguration] (
    [TeamConfigurationID] INT NULL,
    [TeamConfigurationName] NVARCHAR (50) NULL,
    [TeamConfigurationDescription] NVARCHAR (MAX) NULL,
    [TeamConfigurationReferenceNumberRequired] INT NULL,
    [ExtractTypeID] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimTeamConfiguration/landing',
    FILE_FORMAT = [parquet]
    );

