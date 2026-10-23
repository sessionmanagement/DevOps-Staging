CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimTeamFunction] (
    [TeamFunctionID] INT NULL,
    [TeamConfigurationID] INT NULL,
    [TeamFunctionCode] NVARCHAR (50) NULL,
    [TeamFunctionName] NVARCHAR (50) NULL,
    [TeamFunctionDescription] NVARCHAR (MAX) NULL,
    [TeamFunctionAllowConcurrentReferrals] INT NULL,
    [TeamFunctionIsAccomodationBased] INT NULL,
    [TeamFunctionRecentlyDischargedPeriodDays] INT NULL,
    [DefaultTaskProcessID] INT NULL,
    [TeamFunctionAllowExitWithoutDischarge] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimTeamFunction/staging',
    FILE_FORMAT = [parquet]
    );

