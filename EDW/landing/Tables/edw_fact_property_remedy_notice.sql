CREATE TABLE [landing].[edw_fact_property_remedy_notice] (
    [property_remedy_notice_id]    UNIQUEIDENTIFIER NULL,
    [property_tenancy_id]          UNIQUEIDENTIFIER NULL,
    [property_tenancy_breach_id]   UNIQUEIDENTIFIER NULL,
    [remedy_notice]                VARCHAR (200)    NULL,
    [anti_social_behaviour_report] VARCHAR (3000)   NULL,
    [behaviour_occurred_between]   VARCHAR (3000)   NULL,
    [behaviour_locatation]         VARCHAR (200)    NULL,
    [behaviour_people]             VARCHAR (200)    NULL,
    [unkept_responsibility]        VARCHAR (3000)   NULL,
    [remedy_path]                  VARCHAR (3000)   NULL,
    [notes]                        VARCHAR (3000)   NULL,
    [other_information]            VARCHAR (3000)   NULL,
    [remedy_notice_start_date]     DATETIME         NULL,
    [remedy_notice_owner]          VARCHAR (60)     NULL,
    [modified_by]                  VARCHAR (60)     NULL,
    [modified_date]                DATETIME         NULL,
    [created_date]                 DATETIME         NULL,
    [remedy_notice_state]          VARCHAR (20)     NULL,
    [remedy_notice_status]         VARCHAR (20)     NULL
);

