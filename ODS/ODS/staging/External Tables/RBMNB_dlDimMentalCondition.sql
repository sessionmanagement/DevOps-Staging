CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimMentalCondition] (
    [MentalConditionID] INT NULL,
    [MentalConditionValue] NVARCHAR (200) NULL,
    [MentalConditionText] NVARCHAR (200) NULL,
    [MentalConditionParentId] INT NULL,
    [MentalConditionIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimMentalCondition/staging',
    FILE_FORMAT = [parquet]
    );

