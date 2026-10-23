CREATE EXTERNAL TABLE [IntelliHR].[qualification_instances] (
    [qualification_instance_id] NVARCHAR (36) NULL,
    [expiry_date] DATETIME2 (7) NULL,
    [expiry_notification_queued_at] DATETIME2 (7) NULL,
    [issue_date] DATETIME2 (7) NULL,
    [issuing_organisation] NVARCHAR (200) NULL,
    [notes] NVARCHAR (2000) NULL,
    [person_id] NVARCHAR (36) NULL,
    [person_display_name] NVARCHAR (255) NULL,
    [person_employeeNumber] INT NULL,
    [person_auto_increment_intellihr_id] INT NULL,
    [person_link] NVARCHAR (36) NULL,
    [status] NVARCHAR (50) NULL,
    [qualification_library_item_id] NVARCHAR (36) NULL,
    [qualification_library_item_name] NVARCHAR (250) NULL,
    [qualification_library_item_qualification_type_id] NVARCHAR (36) NULL,
    [qualification_library_item_qualification_type_name] NVARCHAR (200) NULL,
    [qualification_library_item_link] NVARCHAR (36) NULL,
    [registration_number] NVARCHAR (200) NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/qualification_instances/main',
    FILE_FORMAT = [parquet]
    );

