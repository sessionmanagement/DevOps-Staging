CREATE TABLE [staging].[ODSETLdim_void_category] (
    [void_category_id]              UNIQUEIDENTIFIER NULL,
    [void_category_state_code]      BIGINT           NULL,
    [void_category_status_code]     BIGINT           NULL,
    [void_category_code]            BIGINT           NULL,
    [void_category_target_group]    VARCHAR (MAX)    NULL,
    [owning_user_id]                UNIQUEIDENTIFIER NULL,
    [owner_id]                      UNIQUEIDENTIFIER NULL,
    [overridden_created_on]         DATETIME2 (7)    NULL,
    [owner_id_name]                 VARCHAR (640)    NULL,
    [owner_id_yomi_name]            VARCHAR (640)    NULL,
    [owning_business_unit_name]     VARCHAR (640)    NULL,
    [time_zone_rule_version_number] BIGINT           NULL,
    [utc_conversion_timezone_code]  BIGINT           NULL,
    [version_number]                BIGINT           NULL,
    [void_category_comments]        VARCHAR (MAX)    NULL,
    [void_category_days_vacant_kpi] BIGINT           NULL,
    [void_category_days_void_kpi]   BIGINT           NULL,
    [void_category_description]     VARCHAR (644)    NULL,
    [void_category_name]            VARCHAR (16)     NULL,
    [void_category_total_days_kpi]  BIGINT           NULL,
    [void_category_is_delete_flag]  INT              NULL
);

