CREATE EXTERNAL TABLE [staging].[RBEAL_dlFactAccountActivityParticipant] (
    [AccountActivityParticipantID] INT NULL,
    [AccountActivityID] INT NULL,
    [UserID] INT NULL,
    [AccountActivityParticipantCreatedDate] DATETIME NULL,
    [AccountActivityParticipantCreatedUserID] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactAccountActivityParticipant/staging',
    FILE_FORMAT = [parquet]
    );

