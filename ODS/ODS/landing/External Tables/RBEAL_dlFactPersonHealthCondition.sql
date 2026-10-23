CREATE EXTERNAL TABLE [landing].[RBEAL_dlFactPersonHealthCondition] (
    [PersonHealthConditionId] INT NULL,
    [PersonId] INT NULL,
    [PersonHealthConditionHealthConditionType] NVARCHAR (50) NULL,
    [HealthConditionTypeId] INT NULL,
    [PersonHealthConditionNotes] VARCHAR (MAX) NULL,
    [PersonHealthConditionRank] INT NULL,
    [PersonHealthConditionCreatedDate] DATETIME NULL,
    [PersonHealthConditionCreatedUserId] INT NULL,
    [PersonHealthConditionIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonHealthCondition/landing',
    FILE_FORMAT = [parquet]
    );

