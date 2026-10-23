CREATE EXTERNAL TABLE [staging].[RBMNB_dlFactActivity] (
    [ActivityID] INT NULL,
    [ActivityStartDate] DATETIME NULL,
    [ActivityEndDate] DATETIME NULL,
    [ActivityDescription] NVARCHAR (MAX) NULL,
    [ActivitySubject] NVARCHAR (300) NULL,
    [ActivityLocation] NVARCHAR (300) NULL,
    [ActivityMapReference] NVARCHAR (50) NULL,
    [ActivityCreatedDate] DATETIME NULL,
    [ActivityCreatedUserID] INT NULL,
    [ActivityUDF1] NVARCHAR (MAX) NULL,
    [ActivityUDF2] NVARCHAR (MAX) NULL,
    [ActivityUDF3] NVARCHAR (MAX) NULL,
    [ActivityUDF4] NVARCHAR (MAX) NULL,
    [ActivityUDF5] NVARCHAR (MAX) NULL,
    [ActivityTypeID] INT NULL,
    [TeamID] INT NULL,
    [ActivityClassificationID] INT NULL,
    [OnBehalfOfUserID] INT NULL,
    [CreatedApplicationId] INT NULL,
    [ActivityCreatedApplicationSyncDate] DATETIME NULL,
    [QuickActivityTemplateID] INT NULL,
    [PrimaryActivityID] INT NULL,
    [GroupActivityID] INT NULL,
    [TeamAutocodingID] INT NULL,
    [ActivityTravelDistance] FLOAT (53) NULL,
    [ActivityEditorViewState] NVARCHAR (MAX) NULL,
    [ActivitySavedByHumanAfterStartDate] INT NULL,
    [ActivityRecurrenceGroupId] INT NULL,
    [ActivityWhanauInvolvement] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactActivity/staging',
    FILE_FORMAT = [parquet]
    );

