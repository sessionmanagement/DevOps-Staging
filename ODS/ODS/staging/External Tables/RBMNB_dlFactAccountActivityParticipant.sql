CREATE EXTERNAL TABLE [staging].[RBMNB_dlFactAccountActivityParticipant] (
    [AccountActivityParticipantID] INT NULL,
    [AccountActivityID] INT NULL,
    [UserID] INT NULL,
    [AccountActivityParticipantCreatedDate] DATETIME NULL,
    [AccountActivityParticipantCreatedUserID] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactAccountActivityParticipant/staging',
    FILE_FORMAT = [parquet]
    );

