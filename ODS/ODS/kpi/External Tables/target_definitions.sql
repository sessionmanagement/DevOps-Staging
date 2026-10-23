CREATE EXTERNAL TABLE [kpi].[target_definitions] (
    [id] INT NULL,
    [service_id] INT NULL,
    [service_code] NVARCHAR (255) NULL,
    [service_name] NVARCHAR (255) NULL,
    [case_load] FLOAT (53) NULL,
    [fully_staffed_fte] FLOAT (53) NULL,
    [support_hours] FLOAT (53) NULL,
    [region] NVARCHAR (255) NULL,
    [temp_region] NVARCHAR (255) NULL,
    [district] NVARCHAR (255) NULL,
    [service_type_lookup_id] INT NULL,
    [fully_staffed_applies] BIT NULL,
    [prog_delievered_target_applies] BIT NULL,
    [programmes_delivered] FLOAT (53) NULL,
    [bed_nights] FLOAT (53) NULL,
    [bed_nights_applied] BIT NULL,
    [support_hours_applied] BIT NULL,
    [case_load_targets_appliced] BIT NULL,
    [service_action_plan_link] NVARCHAR (255) NULL,
    [outcome_tool_review] FLOAT (53) NULL,
    [goal_planning_applied] BIT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'kpi/target_definitions/main',
    FILE_FORMAT = [parquet]
    );



