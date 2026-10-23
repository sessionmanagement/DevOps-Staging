CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimTeamConfigurationField] (
    [TeamConfigurationFieldID] INT NULL,
    [TeamConfigurationID] INT NULL,
    [TeamConfigurationFieldField] NVARCHAR (50) NULL,
    [TeamConfigurationFieldLabel] NVARCHAR (50) NULL,
    [LookupGroupID] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimTeamConfigurationField/staging',
    FILE_FORMAT = [parquet]
    );

