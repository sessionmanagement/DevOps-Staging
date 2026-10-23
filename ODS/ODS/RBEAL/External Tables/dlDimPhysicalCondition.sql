CREATE EXTERNAL TABLE [RBEAL].[dlDimPhysicalCondition] (
    [PhysicalConditionID] INT NULL,
    [PhysicalConditionValue] NVARCHAR (200) NULL,
    [PhysicalConditionText] NVARCHAR (200) NULL,
    [PhysicalConditionParentId] INT NULL,
    [PhysicalConditionIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimPhysicalCondition/main',
    FILE_FORMAT = [parquet]
    );

