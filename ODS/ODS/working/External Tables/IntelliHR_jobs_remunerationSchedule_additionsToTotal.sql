CREATE EXTERNAL TABLE [working].[IntelliHR_jobs_remunerationSchedule_additionsToTotal] (
    [job_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [type] NVARCHAR (500) NULL,
    [value] FLOAT (53) NULL,
    [currency] NVARCHAR (3) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/jobs_remunerationSchedule_additionsToTotal/working',
    FILE_FORMAT = [parquet]
    );

