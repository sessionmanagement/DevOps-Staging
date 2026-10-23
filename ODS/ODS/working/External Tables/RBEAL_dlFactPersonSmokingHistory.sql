CREATE EXTERNAL TABLE [working].[RBEAL_dlFactPersonSmokingHistory] (
    [PersonSmokingHistoryID] INT NULL,
    [PersonID] INT NULL,
    [SmokingStatusId] INT NULL,
    [PersonSmokingHistoryCreatedUserID] INT NULL,
    [PersonSmokingHistoryCreatedDate] DATETIME NULL,
    [PersonSmokingHistoryAssessmentDate] DATETIME NULL,
    [PersonSmokingHistoryBriefAdviceGiven] INT NULL,
    [PersonSmokingHistorySupportServicesOffered] NVARCHAR (MAX) NULL,
    [PersonSmokingHistoryComments] NVARCHAR (MAX) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonSmokingHistory/working',
    FILE_FORMAT = [parquet]
    );

