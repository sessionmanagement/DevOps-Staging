CREATE TABLE [edw].[dim_nationality] (
    [dim_nationality_key] INT            IDENTITY (1, 1) NOT NULL,
    [nationality_id]      NVARCHAR (36)  NULL,
    [nationality_name]    NVARCHAR (100) NULL,
    [DWHBatchId]          INT            NOT NULL,
    [DWHCreatedAt]        DATETIME       NOT NULL,
    [DWHModifiedOn]       DATETIME       NOT NULL,
    [DWHDMLOperation]     CHAR (1)       NOT NULL,
    [DWHSourceSystem]     NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK__edw_dim_nationality] PRIMARY KEY NONCLUSTERED ([dim_nationality_key] ASC)
);





