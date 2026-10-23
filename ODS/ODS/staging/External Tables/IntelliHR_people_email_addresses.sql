CREATE EXTERNAL TABLE [staging].[IntelliHR_people_email_addresses] (
    [people_id] NVARCHAR (36) NULL,
    [email] NVARCHAR (255) NULL,
    [isPrimary] INT NULL,
    [isPersonal] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/people_email_addresses/staging',
    FILE_FORMAT = [parquet]
    );

