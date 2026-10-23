CREATE EXTERNAL TABLE [landing].[Outcome_wellbeing_domain] (
    [wellbeing_domain_id] INT NULL,
    [wellbeing_domain] NVARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Outcome/wellbeing_domain/landing',
    FILE_FORMAT = [parquet]
    );

