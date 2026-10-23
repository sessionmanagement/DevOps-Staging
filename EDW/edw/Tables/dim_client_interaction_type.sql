CREATE TABLE [edw].[dim_client_interaction_type] (
    [dim_client_interaction_type_key]     INT            IDENTITY (1, 1) NOT NULL,
    [company_key]                         INT            NOT NULL,
    [client_interaction_type_id]          INT            NULL,
    [client_interaction_type_code]        NVARCHAR (20) NULL,
    [client_interaction_type_name]        NVARCHAR (50) NULL,
    [client_parent_interaction_type_code] NVARCHAR (20) NULL,
    [client_parent_interaction_type_name] NVARCHAR (20) NULL,
    [DWHBatchId]                          INT            NOT NULL,
    [DWHEffectiveFrom]                    DATETIME       NOT NULL,
    [DWHEffectiveTo]                      DATETIME       NOT NULL,
    [DWHDMLOperation]                     CHAR (1)       NOT NULL,
    [DWHIsCurrent]                        BIT            NOT NULL,
    [DWHSourceSystem]                     NVARCHAR (50) NOT NULL
);
GO

ALTER TABLE [edw].[dim_client_interaction_type]
    ADD CONSTRAINT [PK__edw_dim_client_interaction_type] PRIMARY KEY NONCLUSTERED ([dim_client_interaction_type_key] ASC);
GO

