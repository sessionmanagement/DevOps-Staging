CREATE EXTERNAL TABLE [working].[IntelliHR_custom_field_definition_option] (
    [custom_field_definition_id] NVARCHAR (36) NULL,
    [custom_field_definition_option_id] NVARCHAR (36) NULL,
    [label] NVARCHAR (500) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/custom_field_definition_option/working',
    FILE_FORMAT = [parquet]
    );

