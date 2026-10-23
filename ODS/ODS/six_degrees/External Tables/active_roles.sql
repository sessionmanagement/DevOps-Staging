CREATE EXTERNAL TABLE [six_degrees].[active_roles] (
    [role] NVARCHAR (255) NULL,
    [row_checksum] NVARCHAR (255) NULL,
    [modified_on] NVARCHAR (20) NULL,
    [name] NVARCHAR (255) NULL,
    [role_mapping] NVARCHAR (255) NULL,
    [role_category] NVARCHAR (255) NULL,
    [job_family] NVARCHAR (255) NULL,
    [hardcoded_current_position_intellihr] NVARCHAR (255) NULL,
    [child_position_created_for_six_degrees] NVARCHAR (255) NULL,
    [parent_position_created_for_six_degrees] NVARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'six_degrees/active_roles',
    FILE_FORMAT = [parquet]
    );

