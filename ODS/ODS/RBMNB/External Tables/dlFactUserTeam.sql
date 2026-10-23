CREATE EXTERNAL TABLE [RBMNB].[dlFactUserTeam] (
    [UserTeamID] INT NULL,
    [UserID] INT NULL,
    [TeamID] INT NULL,
    [UserTeamIsMember] INT NULL,
    [UserTeamCreatedDate] DATETIME NULL,
    [UserTeamCreatedUserID] INT NULL,
    [UserTeamDeletedDate] DATETIME NULL,
    [UserTeamDeletedUserID] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactUserTeam/main',
    FILE_FORMAT = [parquet]
    );

