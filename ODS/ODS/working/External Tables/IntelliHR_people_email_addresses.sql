CREATE EXTERNAL TABLE [working].[IntelliHR_people_email_addresses] (
    [people_id] NVARCHAR (36) NULL,
    [email] NVARCHAR (255) NULL,
    [isPrimary] INT NULL,
    [isPersonal] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/people_email_addresses/working',
    FILE_FORMAT = [parquet]
    );

