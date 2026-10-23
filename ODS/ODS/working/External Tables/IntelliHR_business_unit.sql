CREATE EXTERNAL TABLE [working].[IntelliHR_business_unit] (
    [business_unit_id] NVARCHAR (36) NULL,
    [identifier] NVARCHAR (70) NULL,
    [name] NVARCHAR (100) NULL,
    [code] NVARCHAR (200) NULL,
    [parentId] NVARCHAR (36) NULL,
    [notes] NVARCHAR (50) NULL,
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
    LOCATION = N'IntelliHR/business_unit/working',
    FILE_FORMAT = [parquet]
    );



