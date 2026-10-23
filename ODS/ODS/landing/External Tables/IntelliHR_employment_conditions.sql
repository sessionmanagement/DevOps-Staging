CREATE EXTERNAL TABLE [landing].[IntelliHR_employment_conditions] (
    [employment_conditions_id] NVARCHAR (50) NULL,
    [name] NVARCHAR (500) NULL,
    [awardName] NVARCHAR (500) NULL,
    [isEnabled] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/employment_conditions/landing',
    FILE_FORMAT = [parquet]
    );

