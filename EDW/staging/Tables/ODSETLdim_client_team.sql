CREATE TABLE [staging].[ODSETLdim_client_team] (
    [company_id]                         INT            NOT NULL,
    [dim_client_team_unique_key]         NVARCHAR (450) NOT NULL,
    [service_id]                         NVARCHAR (300) NULL,
    [client_team_id]                     INT            NOT NULL,
    [client_team_name]                   NVARCHAR (100) NULL,
    [client_team_description]            NVARCHAR (500) NULL,
    [client_team_function]               NVARCHAR (50)  NULL,
    [client_team_is_accommodation_based] INT            NULL,
    [dim_client_team_start_date]         DATETIME       NULL,
    [dim_client_team_end_date]           DATETIME       NULL,
    [client_team_bed_number]             INT            NULL,
    [client_team_is_allocated_support]   INT            NULL,
    [client_team_is_employment_team]     INT            NULL,
    [client_team_status]                 VARCHAR (6)    NULL,
    [client_team_primhd_exclusion_flag]  INT            NULL,
    [client_team_area]                   NVARCHAR (50)  NULL,
    [client_team_parent_area]            NVARCHAR (50)  NULL,
    [client_team_grand_parent_area]      NVARCHAR (50)  NULL
);










GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_dim_team]
    ON [staging].[ODSETLdim_client_team]([dim_client_team_unique_key] ASC);

