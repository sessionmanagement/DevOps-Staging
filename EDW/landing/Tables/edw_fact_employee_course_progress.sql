CREATE TABLE [landing].[edw_fact_employee_course_progress] (
    [fact_employee_course_progress_id]                       INT              NULL,
    [employee_course_progress_user_id]                       NVARCHAR (100)   NULL,
    [employee_course_id]                                     INT              NULL,
    [employee_organisation_id]                               NVARCHAR (100)   NULL,
    [employee_primary_company_name]                          NVARCHAR (200)   NULL,
    [employee_position_id]                                   INT              NULL,
    [employee_course_enrolled_date]                          DATETIME         NOT NULL,
    [employee_course_started_date]                           DATETIME         NOT NULL,
    [employee_course_completed_date]                         DATETIME         NOT NULL,
    [employee_course_completion_percentage]                  INT              NULL,
    [employee_course_renewal_status]                         INT              NULL,
    [employee_course_due_date]                               DATETIME         NOT NULL,
    [employee_position_name]                                 NVARCHAR (500)   NULL,
    [is_course_delivered_face_to_face_flag]                  INT              NOT NULL,
    [employee_course_completion_history_previous_completion] INT              NULL,
    [employee_course_completion_grade]                       NUMERIC (38, 18) NULL,
    [is_course_core_training_flag]                           INT              NULL,
    [is_course_linked_to_certification_flag]                 INT              NULL
);







