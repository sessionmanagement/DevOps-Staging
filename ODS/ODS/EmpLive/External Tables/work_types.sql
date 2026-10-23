CREATE EXTERNAL TABLE [EmpLive].[work_types] (
    [id] NVARCHAR (36) NULL,
    [name] NVARCHAR (255) NULL,
    [abbreviation] NVARCHAR (100) NULL,
    [is_leave] INT NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/work_types/main',
    FILE_FORMAT = [parquet]
    );

