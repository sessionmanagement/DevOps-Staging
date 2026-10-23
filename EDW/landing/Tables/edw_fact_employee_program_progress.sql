CREATE TABLE [landing].[edw_fact_employee_program_progress] (
    [fact_employee_program_progress_id]      INT             NULL,
    [employee_organisation_id]               NVARCHAR (100)  NULL,
    [employee_primary_company_name]          NVARCHAR (200)  NULL,
    [employee_position_id]                   INT             NULL,
    [employee_program_id]                    INT             NULL,
    [employee_program_progress_user_id]      NVARCHAR (200)  NULL,
    [employee_course_set_id]                 INT             NULL,
    [employee_program_status]                INT             NULL,
    [employee_program_started_date]          DATETIME2 (7)   NULL,
    [employee_program_due_date]              DATETIME2 (7)   NULL,
    [employee_program_completed_date]        DATETIME2 (7)   NULL,
    [employee_program_created_date]          DATETIME2 (7)   NULL,
    [employee_position_name]                 NVARCHAR (200)  NULL,
    [employee_context_level]                 INT             NULL,
    [employee_program_path]                  NVARCHAR (1000) NULL,
    [employee_program_depth]                 INT             NULL,
    [employee_parent_program_id]             INT             NULL,
    [employee_program_assigned_date]         DATETIME2 (7)   NULL,
    [employee_program_exception_status]      INT             NULL,
    [is_program_delivered_face_to_face_flag] INT             NULL
);





