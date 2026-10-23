CREATE EXTERNAL TABLE [landing].[Outcome_priority_outcome] (
    [priority_outcome_id] INT NULL,
    [priority_outcome] NVARCHAR (255) NULL,
    [wellbeing_domain_id] NVARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Outcome/priority_outcome/landing',
    FILE_FORMAT = [parquet]
    );

