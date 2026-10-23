CREATE EXTERNAL TABLE [landing].[IntelliHR_qualification_types] (
    [qualification_type_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (200) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/qualification_types/landing',
    FILE_FORMAT = [parquet]
    );

