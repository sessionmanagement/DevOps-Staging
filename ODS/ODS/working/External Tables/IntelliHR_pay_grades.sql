CREATE EXTERNAL TABLE [working].[IntelliHR_pay_grades] (
    [pay_grades_id] NVARCHAR (36) NULL,
    [code] NVARCHAR (50) NULL,
    [name] NVARCHAR (100) NULL,
    [isEnabled] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/pay_grades/working',
    FILE_FORMAT = [parquet]
    );

