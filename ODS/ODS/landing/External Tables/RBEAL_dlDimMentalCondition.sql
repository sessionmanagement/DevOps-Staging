CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimMentalCondition] (
    [MentalConditionID] INT NULL,
    [MentalConditionValue] NVARCHAR (200) NULL,
    [MentalConditionText] NVARCHAR (200) NULL,
    [MentalConditionParentId] INT NULL,
    [MentalConditionIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimMentalCondition/landing',
    FILE_FORMAT = [parquet]
    );

