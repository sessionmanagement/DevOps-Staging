CREATE EXTERNAL TABLE [landing].[IntelliHR_jobs_remunerationSchedule_additions] (
    [job_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [type] NVARCHAR (500) NULL,
    [value] FLOAT (53) NULL,
    [currency] NVARCHAR (3) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/jobs_remunerationSchedule_additions/landing',
    FILE_FORMAT = [parquet]
    );

