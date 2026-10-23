CREATE TABLE [landing].[edw_fact_client_relationship] (
    [company_id]              INT            NULL,
    [client_relationship_id]  INT            NULL,
    [primary_client_id]       INT            NULL,
    [primary_first_name]      NVARCHAR (50)  NULL,
    [primary_last_name]       NVARCHAR (50)  NULL,
    [relationship]            NVARCHAR (200) NULL,
    [related_client_id]       INT            NULL,
    [related_first_name]      NVARCHAR (50)  NULL,
    [related_last_name]       NVARCHAR (50)  NULL,
    [relationship_start_date] DATETIME       NULL,
    [relationship_end_date]   DATETIME       NULL
);

