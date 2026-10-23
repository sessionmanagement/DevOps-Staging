CREATE EXTERNAL TABLE [staging].[RBMNB_dlFactIncidentAssessment] (
    [IncidentAssessmentID] INT NULL,
    [IncidentID] INT NULL,
    [IncidentSeverityID] INT NULL,
    [IncidentLikelihoodID] INT NULL,
    [IncidentAssessmentRawComments] NVARCHAR (MAX) NULL,
    [IncidentAssessmentHtmlComments] NVARCHAR (MAX) NULL,
    [IncidentAssessmentCreatedUserID] INT NULL,
    [IncidentAssessmentCreatedDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactIncidentAssessment/staging',
    FILE_FORMAT = [parquet]
    );

