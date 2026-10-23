CREATE TABLE [landing].[edw_fact_client_interaction] (
    [company_key]                     INT            NULL,
    [client_interaction_id]           INT            NULL,
    [client_id]                       INT            NULL,
    [client_interaction_type_id]      INT            NULL,
    [employee_id]                     NVARCHAR (50)  NULL,
    [employee_email]                  NVARCHAR (100) NULL,
    [client_interaction_date]         DATETIME2 (7)  NULL,
    [client_interaction_created_date] DATETIME       NULL,
    [client_interaction_comments]     NVARCHAR (MAX) NULL
);
GO

CREATE UNIQUE NONCLUSTERED INDEX [fact_client_interaction]
    ON [landing].[edw_fact_client_interaction]([company_key] ASC, [client_interaction_id] ASC, [client_id] ASC);
GO

