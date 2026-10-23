CREATE TABLE [landing].[edw_dim_client_team] (
    [company_key]                       INT            NULL,
    [service_id]                        NVARCHAR (300) NULL,
    [team_id]                           INT            NULL,
    [team_name]                         NVARCHAR (100) NULL,
    [team_description]                  NVARCHAR (MAX) NULL,
    [team_function]                     NVARCHAR (50)  NULL,
    [team_is_accommodation_based]       INT            NULL,
    [dim_team_start_date_key]           DATETIME       NULL,
    [dim_team_end_date_key]             DATETIME       NULL,
    [team_bed_number]                   INT            NULL,
    [team_is_allocated_support]         INT            NULL,
    [team_is_employment_team]           INT            NULL,
    [team_status]                       VARCHAR (6)    NULL,
    [client_team_primhd_exclusion_flag] INT            NULL,
    [client_team_area]                  NVARCHAR (50)  NULL,
    [client_team_parent_area]           NVARCHAR (50)  NULL,
    [client_team_grand_parent_area]     NVARCHAR (50)  NULL
);








GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_dim_client_team]
    ON [landing].[edw_dim_client_team]([service_id] ASC, [team_id] ASC, [company_key] ASC);

