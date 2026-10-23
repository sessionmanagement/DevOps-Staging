CREATE TABLE [landing].[edw_fact_property_hazard] (
    [property_hazard_id]            UNIQUEIDENTIFIER NULL,
    [hazardsregister_row_id]        UNIQUEIDENTIFIER NULL,
    [property_id]                   UNIQUEIDENTIFIER NULL,
    [hazard_status_label]           VARCHAR (30)     NULL,
    [hazard_condition_label]        VARCHAR (30)     NULL,
    [hazard_asbestos_status_label]  VARCHAR (30)     NULL,
    [hazard_risklevel_label]        VARCHAR (30)     NULL,
    [hazard_asbestos_removed_label] VARCHAR (30)     NULL,
    [hazard_location_label]         VARCHAR (30)     NULL,
    [hazard_name]                   VARCHAR (200)    NULL,
    [hazard_comments]               VARCHAR (2000)   NULL,
    [hazard_date_identified]        DATETIME         NULL,
    [hazard_date_identified_id]     INT              NULL,
    [hazard_state_code]             INT              NULL,
    [hazard_status_code_crm]        INT              NULL,
    [hazard_is_delete_flag]         TINYINT          NULL
);

