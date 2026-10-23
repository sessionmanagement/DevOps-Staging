CREATE TABLE [staging].[ODSETLfact_client_relationship] (
    [ODSfact_client_relationshipID] INT            IDENTITY (1, 1) NOT NULL,
    [dim_company_key]               INT            NOT NULL,
    [dim_primary_client_key]        INT            NOT NULL,
    [dim_related_client_key]        INT            NOT NULL,
    [dim_primary_client_unique_key] NVARCHAR (30)  NULL,
    [dim_related_client_unique_key] NVARCHAR (30)  NULL,
    [client_relationship_id]        INT            NULL,
    [primary_client_id]             INT            NULL,
    [primary_first_name]            NVARCHAR (50)  NULL,
    [primary_last_name]             NVARCHAR (50)  NULL,
    [relationship]                  NVARCHAR (200) NULL,
    [related_client_id]             INT            NULL,
    [related_first_name]            NVARCHAR (50)  NULL,
    [related_last_name]             NVARCHAR (50)  NULL,
    [relationship_start_date]       DATETIME       NULL,
    [relationship_end_date]         DATETIME       NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLfact_client_relationship] PRIMARY KEY NONCLUSTERED ([ODSfact_client_relationshipID] ASC)
);

