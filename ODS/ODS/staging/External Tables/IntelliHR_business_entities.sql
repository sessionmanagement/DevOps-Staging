CREATE EXTERNAL TABLE [staging].[IntelliHR_business_entities] (
    [business_entities_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (75) NULL,
    [legalName] NVARCHAR (65) NULL,
    [number] NVARCHAR (75) NULL,
    [isEnabled] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/business_entities/staging',
    FILE_FORMAT = [parquet]
    );

