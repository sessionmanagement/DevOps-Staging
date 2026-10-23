CREATE EXTERNAL TABLE [RBMNB].[dlFactAccountActivity] (
    [AccountActivityID] INT NULL,
    [AccountID] INT NULL,
    [AccountActivityLocation] NVARCHAR (300) NULL,
    [AccountActivitySubject] NVARCHAR (300) NULL,
    [AccountActivityDescriptionHTML] NVARCHAR (MAX) NULL,
    [AccountActivityDescriptionRaw] NVARCHAR (MAX) NULL,
    [AccountActivityStartDate] DATETIME NULL,
    [AccountActivityEndDate] DATETIME NULL,
    [AccountActivityTypeID] INT NULL,
    [AccountActivityClassificationID] INT NULL,
    [AccountActivityCreatedDate] DATETIME NULL,
    [AccountActivityCreatedUserID] INT NULL,
    [AccountActivityUDF1] NVARCHAR (MAX) NULL,
    [AccountActivityUDF2] NVARCHAR (MAX) NULL,
    [AccountActivityUDF3] NVARCHAR (MAX) NULL,
    [AccountActivityUDF4] NVARCHAR (MAX) NULL,
    [AccountActivityUDF5] NVARCHAR (MAX) NULL,
    [AccountActivityOtherParticipants] NVARCHAR (MAX) NULL,
    [TeamID] INT NULL,
    [AccountActivityAudienceSize] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactAccountActivity/main',
    FILE_FORMAT = [parquet]
    );

