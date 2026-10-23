CREATE EXTERNAL TABLE [working].[RBMNB_incidentFactIncidentStatistics] (
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
    [CompanyId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/incidentFactIncidentStatistics/working',
    FILE_FORMAT = [parquet]
    );

