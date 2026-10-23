CREATE TABLE [landing].[edw_dim_powerbi_activity_type] (
    [activity]             VARCHAR (43) NULL,
    [activity_group]       VARCHAR (47) NULL,
    [activity_description] VARCHAR (49) NULL,
    [activity_notes]       VARCHAR (1)  NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_dim_powerbi_activity_type]
    ON [landing].[edw_dim_powerbi_activity_type]([activity] ASC);

