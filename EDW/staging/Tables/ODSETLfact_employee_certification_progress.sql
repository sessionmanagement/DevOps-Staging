CREATE TABLE [staging].[ODSETLfact_employee_certification_progress] (
    [fact_employee_certification_progress_key]       INT            IDENTITY (1, 1) NOT NULL,
    [dim_employee_key]                               INT            NULL,
    [dim_certification_key]                          INT            NULL,
    [dim_service_key]                                INT            NULL,
    [dim_business_unit_hierarchy_key]                INT            NULL,
    [fact_employee_certification_progress_id]        INT            NULL,
    [employee_organisation_id]                       NVARCHAR (200) NULL,
    [employee_primary_company_name]                  NVARCHAR (200) NULL,
    [employee_position_id]                           INT            NULL,
    [employee_certification_progress_user_id]        NVARCHAR (200) NULL,
    [employee_course_set_id]                         INT            NULL,
    [employee_certification_status]                  INT            NULL,
    [is_recertification]                             INT            NULL,
    [is_unassigned_to_employee_flag]                 INT            NULL,
    [employee_certification_due_date]                DATE           NULL,
    [employee_certification_expiry_date]             DATE           NULL,
    [employee_certification_window_opens_date]       DATE           NULL,
    [employee_certification_completed_date]          DATE           NULL,
    [employee_certification_renewal_status]          INT            NULL,
    [employee_certification_completion_history_link] INT            NULL,
    [employee_certification_id]                      INT            NULL,
    [employee_certification_completed_history_date]  DATE           NULL,
    [employee_context_level]                         INT            NULL,
    [employee_certification_path]                    NVARCHAR (500) NULL,
    [employee_certification_depth]                   INT            NULL,
    [employee_parent_certification_id]               INT            NULL,
    [employee_position_name]                         NVARCHAR (500) NULL,
    [is_cerification_delivered_face_to_face_flag]    INT            NOT NULL,
    [employee_certification_assigned_date]           DATETIME2 (7)  NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLfact_employee_certification_progress] PRIMARY KEY NONCLUSTERED ([fact_employee_certification_progress_key] ASC)
);







