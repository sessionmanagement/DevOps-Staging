CREATE EXTERNAL TABLE [RBEAL].[dlDimMentalCondition] (
    [MentalConditionID] INT NULL,
    [MentalConditionValue] NVARCHAR (200) NULL,
    [MentalConditionText] NVARCHAR (200) NULL,
    [MentalConditionParentId] INT NULL,
    [MentalConditionIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimMentalCondition/main',
    FILE_FORMAT = [parquet]
    );

