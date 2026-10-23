CREATE TABLE [landing].[edw_fact_client_account_activity] (
    [fact_client_account_activity_id]             NVARCHAR (100) NULL,
    [client_account_activity_id]                  INT            NULL,
    [client_account_activity_location]            NVARCHAR (200) NULL,
    [client_account_activity_subject]             NVARCHAR (200) NULL,
    [client_account_activity_description_html]    NVARCHAR (MAX) NULL,
    [client_account_activity_description_raw]     NVARCHAR (MAX) NULL,
    [client_account_activity_start_date]          DATETIME       NULL,
    [client_account_activity_end_date]            DATETIME       NULL,
    [client_account_activity_type_id]             INT            NULL,
    [client_account_activity_classification_id]   INT            NULL,
    [client_account_activity_created_date]        DATETIME       NULL,
    [client_account_activity_created_user_id]     INT            NULL,
    [client_account_activity_udf1]                NVARCHAR (100) NULL,
    [client_account_activity_udf2]                NVARCHAR (100) NULL,
    [client_account_activity_udf3]                NVARCHAR (100) NULL,
    [client_account_activity_udf4]                NVARCHAR (100) NULL,
    [client_account_activity_udf5]                NVARCHAR (100) NULL,
    [client_account_activity_other_participants]  NVARCHAR (MAX) NULL,
    [client_team_id]                              INT            NULL,
    [client_account_activity_audience_size]       INT            NULL,
    [client_account_activity_classification_text] NVARCHAR (100) NULL,
    [client_account_activity_type_text]           NVARCHAR (100) NULL,
    [client_account_name]                         NVARCHAR (200) NULL,
    [company_id]                                  INT            NULL,
    [primary_contact_id]                          INT            NULL,
    [participated_employee_id]                    INT            NULL,
    [created_employee_id]                         INT            NULL
);








GO


