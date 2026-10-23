CREATE EXTERNAL TABLE [working].[IntelliHR_job_requirements_groups] (
    [job_requirement_group_id] VARCHAR (50) NULL,
    [job_requirement_group_name] NVARCHAR (500) NULL,
    [job_requirement_usage_count] INT NULL,
    [library_item_id] VARCHAR (50) NULL,
    [library_item_name] NVARCHAR (500) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/job_requirements_groups/working',
    FILE_FORMAT = [parquet]
    );
GO

