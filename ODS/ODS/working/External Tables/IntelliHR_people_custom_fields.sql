CREATE EXTERNAL TABLE [working].[IntelliHR_people_custom_fields] (
    [people_id] NVARCHAR (36) NULL,
    [definition_id] NVARCHAR (36) NULL,
    [custom_field_name] NVARCHAR (36) NULL,
    [definition_name] NVARCHAR (200) NULL,
    [definition_type] NVARCHAR (200) NULL,
    [definition_value_id] NVARCHAR (250) NULL,
    [definition_value_label] NVARCHAR (500) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/people_custom_fields/working',
    FILE_FORMAT = [parquet]
    );

