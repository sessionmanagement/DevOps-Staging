CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimTeamConfigurationField] (
    [TeamConfigurationFieldID] INT NULL,
    [TeamConfigurationID] INT NULL,
    [TeamConfigurationFieldField] NVARCHAR (50) NULL,
    [TeamConfigurationFieldLabel] NVARCHAR (50) NULL,
    [LookupGroupID] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimTeamConfigurationField/landing',
    FILE_FORMAT = [parquet]
    );

