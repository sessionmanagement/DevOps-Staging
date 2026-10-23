CREATE EXTERNAL TABLE [RBMNB].[dlFactActivityParticipant] (
    [ActivityParticipantID] INT NULL,
    [ActivityID] INT NULL,
    [ActivityParticipantEntityType] NVARCHAR (50) NULL,
    [EntityID] INT NULL,
    [ReferralID] INT NULL,
    [ActivityParticipantIsAttendee] INT NULL,
    [ActivityParticipantIsRelatedTo] INT NULL,
    [ActivityParticipantCreatedDate] DATETIME NULL,
    [ActivityParticipantCreatedUserID] INT NULL,
    [ActivityParticipantOtherContactName] NVARCHAR (MAX) NULL,
    [OtherContactTypeID] INT NULL,
    [CreatedApplicationId] INT NULL,
    [ActivityParticipantCreatedApplicationSyncDate] DATETIME NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactActivityParticipant/main',
    FILE_FORMAT = [parquet]
    );

