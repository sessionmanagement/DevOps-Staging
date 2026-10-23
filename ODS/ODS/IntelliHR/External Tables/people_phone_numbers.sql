CREATE EXTERNAL TABLE [IntelliHR].[people_phone_numbers] (
    [people_id] NVARCHAR (36) NULL,
    [number] NVARCHAR (200) NULL,
    [fullNumber] NVARCHAR (200) NULL,
    [isPrimary] INT NULL,
    [isPersonal] INT NULL,
    [phoneType] VARCHAR (8) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/people_phone_numbers/main',
    FILE_FORMAT = [parquet]
    );

