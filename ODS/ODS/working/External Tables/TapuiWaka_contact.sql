CREATE EXTERNAL TABLE [working].[TapuiWaka_contact] (
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
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'TapuiWaka/contact/working',
    FILE_FORMAT = [parquet]
    );

