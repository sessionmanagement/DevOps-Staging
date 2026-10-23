CREATE TABLE [landing].[edw_dim_client_absence] (
    [company_id]                             INT            NULL,
    [dim_client_unique_key]                  VARCHAR (30)   NULL,
    [client_id]                              INT            NULL,
    [client_absence_approved_by_funder_flag] INT            NULL,
    [client_absence_start_date_time]         DATETIME       NULL,
    [client_absence_end_date_time]           DATETIME       NULL,
    [client_absence_type]                    NVARCHAR (50)  NULL,
    [client_absence_reason_id]               INT            NULL,
    [client_absence_reason]                  NVARCHAR (200) NULL
);



