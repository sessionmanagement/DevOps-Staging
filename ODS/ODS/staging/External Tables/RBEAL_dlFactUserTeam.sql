CREATE EXTERNAL TABLE [staging].[RBEAL_dlFactUserTeam] (
    [UserTeamID] INT NULL,
    [UserID] INT NULL,
    [TeamID] INT NULL,
    [UserTeamIsMember] INT NULL,
    [UserTeamCreatedDate] DATETIME NULL,
    [UserTeamCreatedUserID] INT NULL,
    [UserTeamDeletedDate] DATETIME NULL,
    [UserTeamDeletedUserID] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactUserTeam/staging',
    FILE_FORMAT = [parquet]
    );

