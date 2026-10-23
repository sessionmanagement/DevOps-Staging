CREATE TABLE [landing].[edw_fact_client_primhd_service_review] (
    [dim_company_key]                   INT            NULL,
    [primhd_service_review_id]          INT            NULL,
    [client_id]                         INT            NULL,
    [client_referral_id]                INT            NULL,
    [created_by_employee_id]            NVARCHAR (50)  NULL,
    [created_by_user_email_address]     NVARCHAR (300) NULL,
    [review_date]                       DATETIME       NULL,
    [created_date]                      DATETIME       NULL,
    [accommodation_status_value]        NVARCHAR (200) NULL,
    [accommodation_status_text]         NVARCHAR (200) NULL,
    [parent_accommodation_status_value] NVARCHAR (200) NULL,
    [parent_accommodation_status_text]  NVARCHAR (200) NULL,
    [education_status_value]            NVARCHAR (200) NULL,
    [education_status_text]             NVARCHAR (200) NULL,
    [parent_education_status_value]     NVARCHAR (200) NULL,
    [parent_education_status_text]      NVARCHAR (200) NULL,
    [employment_status_value]           NVARCHAR (200) NULL,
    [employment_status_text]            NVARCHAR (200) NULL,
    [parent_employment_status_value]    NVARCHAR (200) NULL,
    [parent_employment_status_text]     NVARCHAR (200) NULL,
    [wellness_plan_status_value]        NVARCHAR (200) NULL,
    [wellness_plan_status_text]         NVARCHAR (200) NULL,
    [parent_wellness_plan_status_value] NVARCHAR (200) NULL,
    [parent_wellness_plan_status_text]  NVARCHAR (200) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [fact_client_primhd_service_review]
    ON [landing].[edw_fact_client_primhd_service_review]([dim_company_key] ASC, [primhd_service_review_id] ASC);

