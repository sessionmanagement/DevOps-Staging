CREATE EXTERNAL TABLE [working].[RBMNB_dlFactAccountActivityParticipant] (
    [AccountActivityParticipantID] INT NULL,
    [AccountActivityID] INT NULL,
    [UserID] INT NULL,
    [AccountActivityParticipantCreatedDate] DATETIME NULL,
    [AccountActivityParticipantCreatedUserID] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactAccountActivityParticipant/working',
    FILE_FORMAT = [parquet]
    );

