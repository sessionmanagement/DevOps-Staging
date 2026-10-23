CREATE EXTERNAL TABLE [IntelliHR].[work_classes] (
    [work_classes_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [isEnabled] INT NULL,
    [worktype_id] NVARCHAR (36) NULL,
    [worktype_name] NVARCHAR (500) NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/work_classes/main',
    FILE_FORMAT = [parquet]
    );

