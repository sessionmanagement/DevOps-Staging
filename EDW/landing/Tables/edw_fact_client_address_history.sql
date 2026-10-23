CREATE TABLE [landing].[edw_fact_client_address_history] (
    [company_key]                         INT             NULL,
    [client_id]                           INT             NULL,
    [client_address_id]                   INT             NULL,
    [client_address_name]                 NVARCHAR (50)   NULL,
    [client_address_line1]                NVARCHAR (200)  NULL,
    [client_address_line2]                NVARCHAR (200)  NULL,
    [client_address_line3]                NVARCHAR (200)  NULL,
    [client_address_suburb]               NVARCHAR (100)  NULL,
    [client_address_town_or_city]         NVARCHAR (50)   NULL,
    [client_address_post_code]            NVARCHAR (50)   NULL,
    [client_address_created_date]         NVARCHAR (4000) NULL,
    [client_address_start_date]           NVARCHAR (4000) NULL,
    [client_address_end_date]             NVARCHAR (4000) NULL,
    [client_address_is_postal_indicator]  INT             NULL,
    [client_address_is_primary_indicator] INT             NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_fact_client_address_history]
    ON [landing].[edw_fact_client_address_history]([client_address_id] ASC, [company_key] ASC);

