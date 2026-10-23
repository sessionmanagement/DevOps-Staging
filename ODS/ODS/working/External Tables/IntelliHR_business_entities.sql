CREATE EXTERNAL TABLE [working].[IntelliHR_business_entities] (
    [business_entities_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (75) NULL,
    [legalName] NVARCHAR (65) NULL,
    [number] NVARCHAR (75) NULL,
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
    LOCATION = N'IntelliHR/business_entities/working',
    FILE_FORMAT = [parquet]
    );

