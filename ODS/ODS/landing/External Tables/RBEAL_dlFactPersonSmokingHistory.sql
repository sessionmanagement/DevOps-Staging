CREATE EXTERNAL TABLE [landing].[RBEAL_dlFactPersonSmokingHistory] (
    [PersonSmokingHistoryID] INT NULL,
    [PersonID] INT NULL,
    [SmokingStatusId] INT NULL,
    [PersonSmokingHistoryCreatedUserID] INT NULL,
    [PersonSmokingHistoryCreatedDate] DATETIME NULL,
    [PersonSmokingHistoryAssessmentDate] DATETIME NULL,
    [PersonSmokingHistoryBriefAdviceGiven] INT NULL,
    [PersonSmokingHistorySupportServicesOffered] NVARCHAR (MAX) NULL,
    [PersonSmokingHistoryComments] NVARCHAR (MAX) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonSmokingHistory/landing',
    FILE_FORMAT = [parquet]
    );

