CREATE EXTERNAL TABLE [working].[EmpLive_time_categories] (
    [id] NVARCHAR (36) NULL,
    [name] NVARCHAR (255) NULL,
    [abbreviation] NVARCHAR (100) NULL,
    [comments] NVARCHAR (1000) NULL,
    [add_to_duration] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/time_categories/working',
    FILE_FORMAT = [parquet]
    );

