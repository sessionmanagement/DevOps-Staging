CREATE EXTERNAL TABLE [landing].[IntelliHR_job_change_reason] (
    [job_change_reason_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [isEnabled] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/job_change_reason/landing',
    FILE_FORMAT = [parquet]
    );

