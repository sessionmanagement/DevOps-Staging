CREATE TABLE [landing].[edw_dim_course] (
    [course_id]                      INT             NOT NULL,
    [course_full_name]               NVARCHAR (400)  NULL,
    [course_short_name]              NVARCHAR (400)  NULL,
    [course_id_number]               NVARCHAR (100)  NULL,
    [course_format]                  NVARCHAR (100)  NULL,
    [course_start_date]              DATETIME        NOT NULL,
    [course_end_date]                DATETIME        NOT NULL,
    [course_created_date]            DATETIME        NOT NULL,
    [is_enable_completion]           INT             NULL,
    [course_category_id]             INT             NULL,
    [course_category_name]           NVARCHAR (200)  NULL,
    [course_category_path_id]        INT             NULL,
    [course_category_path]           NVARCHAR (1000) NULL,
    [course_linked_to_certification] NVARCHAR (500)  NULL,
    [is_course_visible]              INT             NULL,
    [course_audience_visible]        INT             NULL
);

