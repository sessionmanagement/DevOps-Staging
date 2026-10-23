CREATE EXTERNAL TABLE [RBEAL].[dlFactAccountActivityParticipant] (
    [AccountActivityParticipantID] INT NULL,
    [AccountActivityID] INT NULL,
    [UserID] INT NULL,
    [AccountActivityParticipantCreatedDate] DATETIME NULL,
    [AccountActivityParticipantCreatedUserID] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactAccountActivityParticipant/main',
    FILE_FORMAT = [parquet]
    );

