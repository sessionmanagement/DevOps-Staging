CREATE EXTERNAL TABLE [IntelliHR].[job_requirements] (
    [job_id] VARCHAR (100) NULL,
    [job_requirement_id] NVARCHAR (100) NULL,
    [startDate] DATETIME2 (7) NULL,
    [endDate] DATETIME2 (7) NULL,
    [notifyEmployee] VARCHAR (7) NULL,
    [jobRequriementableId] VARCHAR (100) NULL,
    [jobRequirementableType] VARCHAR (100) NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/job_requirements/main',
    FILE_FORMAT = [parquet]
    );
GO

