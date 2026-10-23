CREATE TABLE [staging].[ODSETLdim_powerbi_activity_type] (
    [dim_powerbi_activity_type_key] INT          IDENTITY (1, 1) NOT NULL,
    [activity]                      VARCHAR (43) NOT NULL,
    [activity_group]                VARCHAR (47) NOT NULL,
    [activity_description]          VARCHAR (49) NOT NULL,
    [activity_notes]                VARCHAR (1)  NOT NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_powerbi_activity_type] PRIMARY KEY NONCLUSTERED ([dim_powerbi_activity_type_key] ASC)
);

