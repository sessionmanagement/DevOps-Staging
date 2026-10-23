CREATE TABLE [edw].[dim_kpi_service_type] (
    [dim_kpi_service_type_key]        INT            IDENTITY (1, 1) NOT NULL,
    [service_type_id]                 INT            NULL,
    [service_type]                    NVARCHAR (255) NULL,
    [service_type_grouping_lookup_id] INT            NULL,
    [service_type_grouping]           NVARCHAR (255) NULL,
    [DWHBatchId]                      INT            NOT NULL,
    [DWHEffectiveFrom]                DATETIME       NOT NULL,
    [DWHEffectiveTo]                  DATETIME       NOT NULL,
    [DWHDMLOperation]                 CHAR (1)       NOT NULL,
    [DWHIsCurrent]                    INT            NOT NULL,
    [DWHSourceSystem]                 NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK__DWH_dim_kpi_service_type_key] PRIMARY KEY NONCLUSTERED ([dim_kpi_service_type_key] ASC)
);

