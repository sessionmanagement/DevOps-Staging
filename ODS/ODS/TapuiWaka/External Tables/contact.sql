CREATE EXTERNAL TABLE [TapuiWaka].[contact] (
    [contact_id] UNIQUEIDENTIFIER NULL,
    [login_id] UNIQUEIDENTIFIER NULL,
    [first_name] NVARCHAR (255) NULL,
    [last_name] NVARCHAR (255) NULL,
    [email_address] NVARCHAR (255) NULL,
    [mobile_number_country_code] NVARCHAR (10) NULL,
    [mobile_number] NVARCHAR (20) NULL,
    [phone_number_country_code] NVARCHAR (10) NULL,
    [phone_number] NVARCHAR (20) NULL,
    [operator_pin_code] INT NULL,
    [service_notification_type] NVARCHAR (50) NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'TapuiWaka/contact/main',
    FILE_FORMAT = [parquet]
    );

