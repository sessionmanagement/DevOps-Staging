CREATE EXTERNAL TABLE [staging].[IntelliHR_job_requirements] (
    [job_id] VARCHAR (100) NULL,
    [job_requirement_id] NVARCHAR (100) NULL,
    [startDate] DATETIME2 (7) NULL,
    [endDate] DATETIME2 (7) NULL,
    [notifyEmployee] VARCHAR (7) NULL,
    [jobRequriementableId] VARCHAR (100) NULL,
    [jobRequirementableType] VARCHAR (100) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/job_requirements/staging',
    FILE_FORMAT = [parquet]
    );
GO

