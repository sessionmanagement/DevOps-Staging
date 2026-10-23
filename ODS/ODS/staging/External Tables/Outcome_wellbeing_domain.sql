CREATE EXTERNAL TABLE [staging].[Outcome_wellbeing_domain] (
    [wellbeing_domain_id] INT NULL,
    [wellbeing_domain] NVARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Outcome/wellbeing_domain/staging',
    FILE_FORMAT = [parquet]
    );

