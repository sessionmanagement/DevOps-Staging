CREATE EXTERNAL TABLE [staging].[IntelliHR_people_custom_fields] (
    [people_id] NVARCHAR (36) NULL,
    [definition_id] NVARCHAR (36) NULL,
    [custom_field_name] NVARCHAR (36) NULL,
    [definition_name] NVARCHAR (200) NULL,
    [definition_type] NVARCHAR (200) NULL,
    [definition_value_id] NVARCHAR (250) NULL,
    [definition_value_label] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/people_custom_fields/staging',
    FILE_FORMAT = [parquet]
    );

