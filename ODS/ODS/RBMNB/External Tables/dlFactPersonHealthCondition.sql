CREATE EXTERNAL TABLE [RBMNB].[dlFactPersonHealthCondition] (
    [PersonHealthConditionId] INT NULL,
    [PersonId] INT NULL,
    [PersonHealthConditionHealthConditionType] NVARCHAR (50) NULL,
    [HealthConditionTypeId] INT NULL,
    [PersonHealthConditionNotes] VARCHAR (MAX) NULL,
    [PersonHealthConditionRank] INT NULL,
    [PersonHealthConditionCreatedDate] DATETIME NULL,
    [PersonHealthConditionCreatedUserId] INT NULL,
    [PersonHealthConditionIsCurrent] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPersonHealthCondition/main',
    FILE_FORMAT = [parquet]
    );

