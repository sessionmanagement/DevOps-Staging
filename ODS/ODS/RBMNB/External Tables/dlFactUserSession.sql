CREATE EXTERNAL TABLE [RBMNB].[dlFactUserSession] (
    [UserSessionID] INT NULL,
    [UserID] INT NULL,
    [UserSessionSignOnDate] DATETIME2 (7) NULL,
    [UserSessionIPAddress] NVARCHAR (30) NULL,
    [UserSessionBrowserName] NVARCHAR (30) NULL,
    [UserSessionBrowserVersion] NVARCHAR (30) NULL,
    [ApplicationId] INT NULL,
    [UserSessionUserAgent] NVARCHAR (400) NULL,
    [ImpersonatedByUserId] INT NULL,
    [UserSessionRecordbaseIdentitySignOnSession] NVARCHAR (200) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactUserSession/main',
    FILE_FORMAT = [parquet]
    );

