CREATE EXTERNAL TABLE [on_call].[call_log] (
    [on_call_id] INT NULL,
    [on_call_title] NVARCHAR (100) NULL,
    [call_date_time] DATETIME2 (7) NULL,
    [event_name] NVARCHAR (100) NULL,
    [region_id] INT NULL,
    [service_id] INT NULL,
    [category_id] INT NULL,
    [call_received_from] NVARCHAR (100) NULL,
    [extra_time] NVARCHAR (100) NULL,
    [issue_description] NVARCHAR (MAX) NULL,
    [outcome] NVARCHAR (MAX) NULL,
    [incident_report_required] NVARCHAR (10) NULL,
    [escalated_to_another_tier] NVARCHAR (10) NULL,
    [escalated_to_id] INT NULL,
    [escalated_to] NVARCHAR (100) NULL,
    [escalation_comments] NVARCHAR (500) NULL,
    [shift_covered] NVARCHAR (10) NULL,
    [hours_covered] NVARCHAR (10) NULL,
    [event_status] NVARCHAR (100) NULL,
    [on_call_staff_member_id] INT NULL,
    [travel_time] NVARCHAR (20) NULL,
    [over_96_hours] NVARCHAR (10) NULL,
    [shift_covered_kaimahi] NVARCHAR (10) NULL,
    [created_by] NVARCHAR (100) NULL,
    [created_date_time] DATETIME2 (7) NULL,
    [call_duration] NUMERIC (12, 2) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'On_Call/call_log/main',
    FILE_FORMAT = [parquet]
    );

