CREATE EXTERNAL TABLE [IntelliHR].[people_email_addresses] (
    [people_id] NVARCHAR (36) NULL,
    [email] NVARCHAR (255) NULL,
    [isPrimary] INT NULL,
    [isPersonal] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/people_email_addresses/main',
    FILE_FORMAT = [parquet]
    );

