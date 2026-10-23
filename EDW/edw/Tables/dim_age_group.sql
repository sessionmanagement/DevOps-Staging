CREATE TABLE [edw].[dim_age_group] (
    [dim_age_group_key]        INT            IDENTITY (0, 1) NOT NULL,
    [age_in_years]             SMALLINT       NOT NULL,
    [age_group_tangatawhaiora] VARCHAR (11)   NULL,
    [age_5_Year_Groups]        VARCHAR (12)   NULL,
    [age_decade_Group]         VARCHAR (12)   NULL,
    [age_Group_Broad]          VARCHAR (7)    NULL,
    [age_Group_MoH_Covid]      VARCHAR (8)    NULL,
    [age_group_groupings]      VARCHAR (20)   NOT NULL,
    [DWHSourceSystem]          NVARCHAR (500) NOT NULL,
    [DWHCreatedAt]             DATETIME       NOT NULL,
    [DWHBatchId]               INT            NOT NULL,
    CONSTRAINT [PK_edw_dim_age_group] PRIMARY KEY NONCLUSTERED ([dim_age_group_key] ASC)
);

