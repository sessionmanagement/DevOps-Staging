CREATE EXTERNAL TABLE [IntelliHR].[employment_conditions] (
    [employment_conditions_id] NVARCHAR (50) NULL,
    [name] NVARCHAR (500) NULL,
    [awardName] NVARCHAR (500) NULL,
    [isEnabled] INT NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/employment_conditions/main',
    FILE_FORMAT = [parquet]
    );

