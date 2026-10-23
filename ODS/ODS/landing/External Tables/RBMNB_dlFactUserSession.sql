CREATE EXTERNAL TABLE [landing].[RBMNB_dlFactUserSession] (
    [UserSessionID] INT NULL,
    [UserID] INT NULL,
    [UserSessionSignOnDate] DATETIME2 (7) NULL,
    [UserSessionIPAddress] NVARCHAR (30) NULL,
    [UserSessionBrowserName] NVARCHAR (30) NULL,
    [UserSessionBrowserVersion] NVARCHAR (30) NULL,
    [ApplicationId] INT NULL,
    [UserSessionUserAgent] NVARCHAR (400) NULL,
    [ImpersonatedByUserId] INT NULL,
    [UserSessionRecordbaseIdentitySignOnSession] NVARCHAR (200) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactUserSession/landing',
    FILE_FORMAT = [parquet]
    );

