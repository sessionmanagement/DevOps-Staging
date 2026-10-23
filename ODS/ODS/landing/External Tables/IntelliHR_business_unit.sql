CREATE EXTERNAL TABLE [landing].[IntelliHR_business_unit] (
    [business_unit_id] NVARCHAR (36) NULL,
    [identifier] NVARCHAR (70) NULL,
    [name] NVARCHAR (100) NULL,
    [code] NVARCHAR (200) NULL,
    [parentId] NVARCHAR (36) NULL,
    [notes] NVARCHAR (50) NULL,
    [isEnabled] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/business_unit/landing',
    FILE_FORMAT = [parquet]
    );



