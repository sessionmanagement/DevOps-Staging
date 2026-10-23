CREATE EXTERNAL TABLE [landing].[IntelliHR_people_email_addresses] (
    [people_id] NVARCHAR (36) NULL,
    [email] NVARCHAR (255) NULL,
    [isPrimary] INT NULL,
    [isPersonal] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/people_email_addresses/landing',
    FILE_FORMAT = [parquet]
    );

