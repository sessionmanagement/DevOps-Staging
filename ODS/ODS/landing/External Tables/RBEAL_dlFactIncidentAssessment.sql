CREATE EXTERNAL TABLE [landing].[RBEAL_dlFactIncidentAssessment] (
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
    LOCATION = N'RBEAL/dlFactIncidentAssessment/landing',
    FILE_FORMAT = [parquet]
    );

