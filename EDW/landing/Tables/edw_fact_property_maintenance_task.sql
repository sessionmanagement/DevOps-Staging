CREATE TABLE [landing].[edw_fact_property_maintenance_task] (
    [property_maintenance_task_id]                                 UNIQUEIDENTIFIER   NULL,
    [property_maintenance_id]                                      UNIQUEIDENTIFIER   NULL,
    [property_id]                                                  UNIQUEIDENTIFIER   NULL,
    [property_maintenance_type_id]                                 UNIQUEIDENTIFIER   NULL,
    [property_program_id]                                          UNIQUEIDENTIFIER   NULL,
    [property_subprogram_id]                                       UNIQUEIDENTIFIER   NULL,
    [tenancy_id]                                                   UNIQUEIDENTIFIER   NULL,
    [property_tenancy_type_id]                                     UNIQUEIDENTIFIER   NULL,
    [property_maintenance_task_acknowledgment_date_id]             INT                NULL,
    [property_maintenance_task_acknowledgment_end_date_id]         INT                NULL,
    [property_maintenance_task_actual_completion_date_id]          INT                NULL,
    [property_maintenance_task_contractor_work_completion_date_id] INT                NULL,
    [property_maintenance_task_expected_completion_date_id]        INT                NULL,
    [property_maintenance_task_expected_onsite_date_id]            INT                NULL,
    [property_maintenance_task_total_capped_amount_date_id]        INT                NULL,
    [property_maintenance_task_web_expenses_amount_date_id]        INT                NULL,
    [property_maintenance_assets_installation_date_id]             INT                NULL,
    [property_maintenance_task_contractor_status_date_id]          INT                NULL,
    [property_maintenance_task_icode]                              VARCHAR (50)       NULL,
    [property_maintenance_task_information_code_name]              VARCHAR (200)      NULL,
    [property_maintenance_task_location_code]                      VARCHAR (10)       NULL,
    [property_maintenance_task_location_name]                      VARCHAR (50)       NULL,
    [property_maintenance_task_work_task_name]                     VARCHAR (100)      NULL,
    [property_maintenance_task_area_seq]                           BIGINT             NULL,
    [property_maintenance_task_assets_name]                        VARCHAR (100)      NULL,
    [property_maintenance_contract_service_name]                   VARCHAR (100)      NULL,
    [property_maintenance_task_comments]                           VARCHAR (MAX)      NULL,
    [property_maintenance_task_information_code_detail_name]       VARCHAR (200)      NULL,
    [property_maintenance_task_maintenance_code]                   VARCHAR (10)       NULL,
    [property_maintenance_task_maintenance_type_name]              VARCHAR (50)       NULL,
    [property_maintenance_task_amount]                             NUMERIC (38, 4)    NULL,
    [property_maintenance_task_created_datetime]                   DATETIMEOFFSET (7) NULL,
    [property_maintenance_task_modified_datetime]                  DATETIME2 (7)      NULL,
    [property_maintenance_task_is_delete_flag]                     INT                NULL
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_fact_property_maintenance_task]
    ON [landing].[edw_fact_property_maintenance_task]([property_maintenance_task_id] ASC, [property_maintenance_id] ASC);

