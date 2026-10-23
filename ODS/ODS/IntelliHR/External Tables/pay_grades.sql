CREATE EXTERNAL TABLE [IntelliHR].[pay_grades] (
    [pay_grades_id] NVARCHAR (36) NULL,
    [code] NVARCHAR (50) NULL,
    [name] NVARCHAR (100) NULL,
    [isEnabled] INT NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/pay_grades/main',
    FILE_FORMAT = [parquet]
    );

