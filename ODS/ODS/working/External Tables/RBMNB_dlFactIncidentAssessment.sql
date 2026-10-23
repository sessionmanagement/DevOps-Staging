CREATE EXTERNAL TABLE [working].[RBMNB_dlFactIncidentAssessment] (
    [IncidentAssessmentID] INT NULL,
    [IncidentID] INT NULL,
    [IncidentSeverityID] INT NULL,
    [IncidentLikelihoodID] INT NULL,
    [IncidentAssessmentRawComments] NVARCHAR (MAX) NULL,
    [IncidentAssessmentHtmlComments] NVARCHAR (MAX) NULL,
    [IncidentAssessmentCreatedUserID] INT NULL,
    [IncidentAssessmentCreatedDate] DATETIME NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactIncidentAssessment/working',
    FILE_FORMAT = [parquet]
    );

