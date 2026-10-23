CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimPhysicalCondition] (
    [PhysicalConditionID] INT NULL,
    [PhysicalConditionValue] NVARCHAR (200) NULL,
    [PhysicalConditionText] NVARCHAR (200) NULL,
    [PhysicalConditionParentId] INT NULL,
    [PhysicalConditionIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimPhysicalCondition/staging',
    FILE_FORMAT = [parquet]
    );

