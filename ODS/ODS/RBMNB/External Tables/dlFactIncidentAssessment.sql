CREATE EXTERNAL TABLE [RBMNB].[dlFactIncidentAssessment] (
    [IncidentAssessmentID] INT NULL,
    [IncidentID] INT NULL,
    [IncidentSeverityID] INT NULL,
    [IncidentLikelihoodID] INT NULL,
    [IncidentAssessmentRawComments] NVARCHAR (MAX) NULL,
    [IncidentAssessmentHtmlComments] NVARCHAR (MAX) NULL,
    [IncidentAssessmentCreatedUserID] INT NULL,
    [IncidentAssessmentCreatedDate] DATETIME NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactIncidentAssessment/main',
    FILE_FORMAT = [parquet]
    );

