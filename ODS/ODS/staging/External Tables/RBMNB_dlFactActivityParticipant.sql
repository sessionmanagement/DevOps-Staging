CREATE EXTERNAL TABLE [staging].[RBMNB_dlFactActivityParticipant] (
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
    [ActivityParticipantCreatedApplicationSyncDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactActivityParticipant/staging',
    FILE_FORMAT = [parquet]
    );

