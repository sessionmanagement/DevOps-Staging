CREATE TABLE [staging].[EDWedwkpi_snapshot_service] (
    [EDWkpi_snapshot_serviceID]       INT            IDENTITY (1, 1) NOT NULL,
    [dim_kpi_key]                     INT            NOT NULL,
    [dim_company_key]                 INT            NOT NULL,
    [dim_service_key]                 INT            NOT NULL,
    [entity_key]                      VARCHAR (38)   NOT NULL,
    [kpi_id]                          INT            NULL,
    [service_id]                      INT            NULL,
    [kpi_value]                       DECIMAL (3, 2) NULL,
    [user_friendly_score_explanation] VARCHAR (200)  NOT NULL,
    [kpi_status]                      INT            NULL,
    [snapshot_date]                   DATE           NULL,
    CONSTRAINT [PK_Temp_Staging_EDWedwkpi_snapshot_service] PRIMARY KEY NONCLUSTERED ([EDWkpi_snapshot_serviceID] ASC)
);

