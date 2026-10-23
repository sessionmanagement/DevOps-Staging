CREATE EXTERNAL TABLE [working].[EmpLive_work_types] (
    [id] NVARCHAR (36) NULL,
    [name] NVARCHAR (255) NULL,
    [abbreviation] NVARCHAR (100) NULL,
    [is_leave] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/work_types/working',
    FILE_FORMAT = [parquet]
    );

