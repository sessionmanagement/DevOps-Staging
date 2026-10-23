CREATE TABLE [edw].[dim_property_breach_type] (
    [dim_property_breach_type_key] INT            IDENTITY (1, 1) NOT NULL,
    [breach_type_id]               INT            NULL,
    [breach_type]                  NVARCHAR (80)  NULL,
    [DWHBatchId]                   INT            NOT NULL,
    [DWHEffectiveFrom]             DATETIME       NOT NULL,
    [DWHEffectiveTo]               DATETIME       NOT NULL,
    [DWHDMLOperation]              CHAR (1)       NOT NULL,
    [DWHIsCurrent]                 BIT            NOT NULL,
    [DWHSourceSystem]              NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK__edw_dim_property_breach_type] PRIMARY KEY NONCLUSTERED ([dim_property_breach_type_key] ASC)
);

