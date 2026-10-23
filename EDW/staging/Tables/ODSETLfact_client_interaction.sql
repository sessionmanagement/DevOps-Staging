CREATE TABLE [staging].[ODSETLfact_client_interaction] (
    [fact_client_interaction_key]     INT            IDENTITY (1, 1) NOT NULL,
    [dim_company_key]                 INT            NOT NULL,
    [client_interaction_id]           INT            NULL,
    [client_id]                       INT            NULL,
    [client_interaction_type_id]      INT            NULL,
    [dim_client_key]                  INT            NULL,
    [dim_client_interaction_type_key] INT            NULL,
    [dim_employee_key]                INT            NULL,
    [client_interaction_date]         DATETIME2 (7)  NULL,
    [client_interaction_created_date] DATETIME       NULL,
    [client_interaction_comments]     NVARCHAR (MAX) NULL
);
GO

ALTER TABLE [staging].[ODSETLfact_client_interaction]
    ADD CONSTRAINT [PK_Temp_Staging_ODSETLfact_client_interaction] PRIMARY KEY NONCLUSTERED ([fact_client_interaction_key] ASC);
GO

