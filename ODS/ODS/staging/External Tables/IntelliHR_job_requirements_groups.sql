CREATE EXTERNAL TABLE [staging].[IntelliHR_job_requirements_groups] (
    [job_requirement_group_id] VARCHAR (50) NULL,
    [job_requirement_group_name] NVARCHAR (500) NULL,
    [job_requirement_usage_count] INT NULL,
    [library_item_id] VARCHAR (50) NULL,
    [library_item_name] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/job_requirements_groups/staging',
    FILE_FORMAT = [parquet]
    );
GO

