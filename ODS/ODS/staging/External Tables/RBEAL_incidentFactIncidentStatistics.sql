CREATE EXTERNAL TABLE [staging].[RBEAL_incidentFactIncidentStatistics] (
    [IncidentID] INT NULL,
    [IncidentTypeID] INT NULL,
    [IncidentDate] DATETIME NULL,
    [TeamID] INT NULL,
    [AreaID] INT NULL,
    [IncidentLikelihoodID] INT NULL,
    [IncidentSeverityID] INT NULL,
    [PendingDate] DATETIME NULL,
    [AssignedToInvestigatorDate] DATETIME NULL,
    [AssignedToReporterDate] DATETIME NULL,
    [CompletedDate] DATETIME NULL,
    [InvestigationDate] DATETIME NULL,
    [ReviewDate] DATETIME NULL,
    [CurrentIncidentStatusTypeID] INT NULL,
    [OriginatorUserID] INT NULL,
    [InvestigatorUserID] INT NULL,
    [ReporterUserID] INT NULL,
    [RiskTypeID] INT NULL,
    [CompanyId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/incidentFactIncidentStatistics/staging',
    FILE_FORMAT = [parquet]
    );

