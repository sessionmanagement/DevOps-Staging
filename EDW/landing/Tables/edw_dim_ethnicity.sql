CREATE TABLE [landing].[edw_dim_ethnicity] (
    [ConcatenatedEthnicity]  NVARCHAR (2009) NULL,
    [ClientEthnicityGrouped] VARCHAR (47)    NULL,
    [ethnicity_level1]       NVARCHAR (200)  NULL,
    [ethnicity_level2]       NVARCHAR (200)  NULL,
    [ethnicity_level3]       NVARCHAR (200)  NULL,
    [ethnicity_level4]       NVARCHAR (200)  NULL,
    [ethnicity_level5]       NVARCHAR (200)  NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_dim_ethnicity]
    ON [landing].[edw_dim_ethnicity]([ConcatenatedEthnicity] ASC);

