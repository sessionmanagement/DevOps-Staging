CREATE EXTERNAL TABLE [RBMNB].[dlFactPersonSmokingHistory] (
    [PersonSmokingHistoryID] INT NULL,
    [PersonID] INT NULL,
    [SmokingStatusId] INT NULL,
    [PersonSmokingHistoryCreatedUserID] INT NULL,
    [PersonSmokingHistoryCreatedDate] DATETIME NULL,
    [PersonSmokingHistoryAssessmentDate] DATETIME NULL,
    [PersonSmokingHistoryBriefAdviceGiven] INT NULL,
    [PersonSmokingHistorySupportServicesOffered] NVARCHAR (MAX) NULL,
    [PersonSmokingHistoryComments] NVARCHAR (MAX) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPersonSmokingHistory/main',
    FILE_FORMAT = [parquet]
    );

