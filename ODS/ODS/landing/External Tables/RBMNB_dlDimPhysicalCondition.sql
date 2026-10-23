CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimPhysicalCondition] (
    [PhysicalConditionID] INT NULL,
    [PhysicalConditionValue] NVARCHAR (200) NULL,
    [PhysicalConditionText] NVARCHAR (200) NULL,
    [PhysicalConditionParentId] INT NULL,
    [PhysicalConditionIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimPhysicalCondition/landing',
    FILE_FORMAT = [parquet]
    );

