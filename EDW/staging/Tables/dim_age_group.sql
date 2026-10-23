CREATE TABLE [staging].[dim_age_group] (
    [age_in_years]             SMALLINT     NULL,
    [age_group_tangatawhaiora] VARCHAR (11) NULL,
    [age_5_Year_Groups]        VARCHAR (12) NULL,
    [age_decade_Group]         VARCHAR (12) NULL,
    [age_Group_Broad]          VARCHAR (7)  NULL,
    [age_Group_MoH_Covid]      VARCHAR (8)  NULL,
    [age_group_groupings]      VARCHAR (20) NOT NULL
);

