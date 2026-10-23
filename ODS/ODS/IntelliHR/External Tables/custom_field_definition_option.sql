CREATE EXTERNAL TABLE [IntelliHR].[custom_field_definition_option] (
    [custom_field_definition_id] NVARCHAR (36) NULL,
    [custom_field_definition_option_id] NVARCHAR (36) NULL,
    [label] NVARCHAR (500) NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/custom_field_definition_option/main',
    FILE_FORMAT = [parquet]
    );

