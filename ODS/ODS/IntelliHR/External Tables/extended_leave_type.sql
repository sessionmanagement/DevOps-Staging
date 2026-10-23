CREATE EXTERNAL TABLE [IntelliHR].[extended_leave_type] (
    [extended_leave_type_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/extended_leave_type/main',
    FILE_FORMAT = [parquet]
    );

