CREATE EXTERNAL TABLE [staging].[RBEAL_dlFactPersonRisk] (
    [PersonRiskID] INT NULL,
    [PersonID] INT NULL,
    [RiskTypeID] INT NULL,
    [PersonRiskDescription] NVARCHAR (250) NULL,
    [PersonRiskRawEarlySigns] NVARCHAR (MAX) NULL,
    [PersonRiskHTMLEarlySigns] NVARCHAR (MAX) NULL,
    [PersonRiskRawStrategy] NVARCHAR (MAX) NULL,
    [PersonRiskHTMLStrategy] NVARCHAR (MAX) NULL,
    [PersonRiskRawComments] NVARCHAR (MAX) NULL,
    [PersonRiskHTMLComments] NVARCHAR (MAX) NULL,
    [PersonRiskReviewDate] DATETIME NULL,
    [HistoricalID] INT NULL,
    [PersonRiskCreatedDate] DATETIME NULL,
    [PersonRiskCreatedUserID] INT NULL,
    [PersonRiskAlertFlag] INT NULL,
    [PersonRiskHistoricDate] DATETIME2 (7) NULL,
    [PersonRiskReviewDateOffset] DATETIME2 (0) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonRisk/staging',
    FILE_FORMAT = [parquet]
    );

