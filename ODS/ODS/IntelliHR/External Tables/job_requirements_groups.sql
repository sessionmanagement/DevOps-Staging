CREATE EXTERNAL TABLE [IntelliHR].[job_requirements_groups] (
    [job_requirement_group_id] VARCHAR (50) NULL,
    [job_requirement_group_name] NVARCHAR (500) NULL,
    [job_requirement_usage_count] INT NULL,
    [library_item_id] VARCHAR (50) NULL,
    [library_item_name] NVARCHAR (500) NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/job_requirements_groups/main',
    FILE_FORMAT = [parquet]
    );
GO

