CREATE EXTERNAL TABLE [landing].[IntelliHR_qualification_library_items] (
    [qualification_library_items_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (200) NULL,
    [qualification_type_id] NVARCHAR (36) NULL,
    [qualification_type_name] NVARCHAR (200) NULL,
    [qualification_expiry_type] NVARCHAR (200) NULL,
    [qualification_registration_number_visibility_type] NVARCHAR (200) NULL,
    [qualification_attachment_requirement_type] NVARCHAR (200) NULL,
    [expiry_warning_period] INT NULL,
    [send_expiry_warning] INT NULL,
    [qualification_instance_usage_count] INT NULL,
    [job_requirement_group_usage_count] INT NULL,
    [job_requirement_usage_count] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/qualification_library_items/landing',
    FILE_FORMAT = [parquet]
    );

