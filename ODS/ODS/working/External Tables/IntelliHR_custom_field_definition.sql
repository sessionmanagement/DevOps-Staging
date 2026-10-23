CREATE EXTERNAL TABLE [working].[IntelliHR_custom_field_definition] (
    [custom_field_definition_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [type] NVARCHAR (20) NULL,
    [isEnabled] INT NULL,
    [isSensitive] INT NULL,
    [apiName] NVARCHAR (500) NULL,
    [modelType] NVARCHAR (500) NULL,
    [description] NVARCHAR (500) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/custom_field_definition/working',
    FILE_FORMAT = [parquet]
    );

