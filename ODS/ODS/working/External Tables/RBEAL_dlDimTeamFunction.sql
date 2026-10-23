CREATE EXTERNAL TABLE [working].[RBEAL_dlDimTeamFunction] (
    [TeamFunctionID] INT NULL,
    [TeamConfigurationID] INT NULL,
    [TeamFunctionCode] NVARCHAR (50) NULL,
    [TeamFunctionName] NVARCHAR (50) NULL,
    [TeamFunctionDescription] NVARCHAR (MAX) NULL,
    [TeamFunctionAllowConcurrentReferrals] INT NULL,
    [TeamFunctionIsAccomodationBased] INT NULL,
    [TeamFunctionRecentlyDischargedPeriodDays] INT NULL,
    [DefaultTaskProcessID] INT NULL,
    [TeamFunctionAllowExitWithoutDischarge] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimTeamFunction/working',
    FILE_FORMAT = [parquet]
    );

