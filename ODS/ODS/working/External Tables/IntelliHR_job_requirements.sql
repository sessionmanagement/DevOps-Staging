CREATE EXTERNAL TABLE [working].[IntelliHR_job_requirements] (
    [job_id] VARCHAR (100) NULL,
    [job_requirement_id] NVARCHAR (100) NULL,
    [startDate] DATETIME2 (7) NULL,
    [endDate] DATETIME2 (7) NULL,
    [notifyEmployee] VARCHAR (7) NULL,
    [jobRequriementableId] VARCHAR (100) NULL,
    [jobRequirementableType] VARCHAR (100) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/job_requirements/working',
    FILE_FORMAT = [parquet]
    );
GO

