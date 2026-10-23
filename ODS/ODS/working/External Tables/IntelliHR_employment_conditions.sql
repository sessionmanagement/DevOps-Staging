CREATE EXTERNAL TABLE [working].[IntelliHR_employment_conditions] (
    [employment_conditions_id] NVARCHAR (50) NULL,
    [name] NVARCHAR (500) NULL,
    [awardName] NVARCHAR (500) NULL,
    [isEnabled] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/employment_conditions/working',
    FILE_FORMAT = [parquet]
    );

