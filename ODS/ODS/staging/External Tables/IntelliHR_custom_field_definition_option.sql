CREATE EXTERNAL TABLE [staging].[IntelliHR_custom_field_definition_option] (
    [custom_field_definition_id] NVARCHAR (36) NULL,
    [custom_field_definition_option_id] NVARCHAR (36) NULL,
    [label] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/custom_field_definition_option/staging',
    FILE_FORMAT = [parquet]
    );

