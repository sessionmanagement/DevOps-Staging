CREATE EXTERNAL TABLE [working].[IntelliHR_people_phone_numbers] (
    [people_id] NVARCHAR (36) NULL,
    [number] NVARCHAR (200) NULL,
    [fullNumber] NVARCHAR (200) NULL,
    [isPrimary] INT NULL,
    [isPersonal] INT NULL,
    [phoneType] VARCHAR (8) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/people_phone_numbers/working',
    FILE_FORMAT = [parquet]
    );

