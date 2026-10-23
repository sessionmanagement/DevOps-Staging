CREATE TABLE [edw].[dim_powerbi_activity_type] (
    [dim_powerbi_activity_type_key] INT            IDENTITY (1, 1) NOT NULL,
    [activity]                      VARCHAR (43)   NOT NULL,
    [activity_group]                VARCHAR (47)   NOT NULL,
    [activity_description]          VARCHAR (49)   NOT NULL,
    [activity_notes]                VARCHAR (1)    NOT NULL,
    [DWHBatchId]                    INT            NOT NULL,
    [DWHEffectiveFrom]              DATETIME       NOT NULL,
    [DWHEffectiveTo]                DATETIME       NOT NULL,
    [DWHDMLOperation]               CHAR (1)       NOT NULL,
    [DWHIsCurrent]                  BIT            NOT NULL,
    [DWHSourceSystem]               NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK__edw_dim_powerbi_activity_type] PRIMARY KEY NONCLUSTERED ([dim_powerbi_activity_type_key] ASC)
);

