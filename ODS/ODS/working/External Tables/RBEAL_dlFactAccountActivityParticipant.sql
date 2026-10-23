CREATE EXTERNAL TABLE [working].[RBEAL_dlFactAccountActivityParticipant] (
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
    LOCATION = N'RBEAL/dlFactAccountActivityParticipant/working',
    FILE_FORMAT = [parquet]
    );

