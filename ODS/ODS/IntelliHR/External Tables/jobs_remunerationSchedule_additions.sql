CREATE EXTERNAL TABLE [IntelliHR].[jobs_remunerationSchedule_additions] (
    [job_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [type] NVARCHAR (500) NULL,
    [value] FLOAT (53) NULL,
    [currency] NVARCHAR (3) NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/jobs_remunerationSchedule_additions/main',
    FILE_FORMAT = [parquet]
    );

