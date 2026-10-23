CREATE TABLE [landing].[edw_fact_property_inspection] (
    [property_inspection_id]                              UNIQUEIDENTIFIER   NULL,
    [property_id]                                         UNIQUEIDENTIFIER   NULL,
    [property_tenancy_id]                                 UNIQUEIDENTIFIER   NULL,
    [property_maintenance_id]                             UNIQUEIDENTIFIER   NULL,
    [property_inspection_code]                            VARCHAR (20)       NULL,
    [property_inspection_name]                            VARCHAR (200)      NULL,
    [property_inspection_date_id]                         INT                NULL,
    [property_inspection_scheduled_date_id]               INT                NULL,
    [property_inspection_scheduled_time_id]               INT                NULL,
    [property_inspection_completion_date_id]              INT                NULL,
    [property_inspection_scheduled_end_time_id]           INT                NULL,
    [property_inspection_next_routine_inspection_date_id] INT                NULL,
    [property_inspection_summary]                         VARCHAR (MAX)      NULL,
    [property_inspection_inspected_by]                    VARCHAR (100)      NULL,
    [property_inspection_category]                        VARCHAR (40)       NULL,
    [property_inspection_type]                            VARCHAR (40)       NULL,
    [property_inspection_maintenance_summary]             VARCHAR (MAX)      NULL,
    [property_inspection_state]                           VARCHAR (10)       NULL,
    [property_inspection_status]                          VARCHAR (40)       NULL,
    [property_inspection_tenant_present_flag]             INT                NULL,
    [property_inspection_cancel_inspection_flag]          INT                NULL,
    [property_inspection_ignore_plugin_validate_flag]     INT                NULL,
    [property_inspection_tenant_confirmed_condition_flag] INT                NULL,
    [property_inspection_owning_business_unit_name]       VARCHAR (20)       NULL,
    [property_inspection_client]                          VARCHAR (100)      NULL,
    [property_inspection_property]                        VARCHAR (100)      NULL,
    [property_inspection_property_manager]                VARCHAR (100)      NULL,
    [property_inspection_tenancy_manager]                 VARCHAR (100)      NULL,
    [property_inspection_tenant]                          VARCHAR (100)      NULL,
    [property_inspection_owner_name]                      VARCHAR (100)      NULL,
    [property_inspection_other_issue_comments]            VARCHAR (MAX)      NULL,
    [property_inspection_chintaro_id]                     VARCHAR (10)       NULL,
    [property_inspection_comments]                        VARCHAR (MAX)      NULL,
    [property_inspection_relative_url]                    VARCHAR (200)      NULL,
    [property_inspection_suggested_improvements]          VARCHAR (MAX)      NULL,
    [property_inspection_created_datetime]                DATETIMEOFFSET (7) NULL,
    [property_inspection_modified_datetime]               DATETIME2 (7)      NULL,
    [property_inspection_is_delete_flag]                  VARCHAR (6)        NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_fact_property_inspection]
    ON [landing].[edw_fact_property_inspection]([property_inspection_id] ASC);

