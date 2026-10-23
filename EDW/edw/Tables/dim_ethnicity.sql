CREATE TABLE [edw].[dim_ethnicity] (
    [dim_ethnicity_key] INT             IDENTITY (1, 1) NOT NULL,
    [dim_ethnicity_id]  NVARCHAR (2009) NULL,
    [ethnicity_group]   VARCHAR (47)    NOT NULL,
    [ethnicity_level1]  NVARCHAR (200)  NULL,
    [ethnicity_level2]  NVARCHAR (200)  NULL,
    [ethnicity_level3]  NVARCHAR (200)  NULL,
    [ethnicity_level4]  NVARCHAR (200)  NULL,
    [ethnicity_level5]  NVARCHAR (200)  NULL,
    [DWHBatchId]        INT             NOT NULL,
    [DWHCreatedAt]      DATETIME        NOT NULL,
    [DWHModifiedOn]     DATETIME        NOT NULL,
    [DWHDMLOperation]   CHAR (1)        NOT NULL,
    [DWHSourceSystem]   NVARCHAR (500)  NOT NULL,
    CONSTRAINT [PK__edw_dim_ethnicity] PRIMARY KEY NONCLUSTERED ([dim_ethnicity_key] ASC)
);



