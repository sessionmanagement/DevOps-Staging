CREATE TABLE [reference].[edw_ethnicity] (
    [ethnicity_id]        INT           NOT NULL,
    [ethncity_section]    NVARCHAR (40) NOT NULL,
    [ethnicity_group]     NVARCHAR (40) NULL,
    [ethnicity_sub_group] NVARCHAR (40) NULL,
    [ethnicity]           NVARCHAR (80) NULL,
    [priority_group]      INT           NULL,
    [priority_section]    INT           NULL,
    CONSTRAINT [PK_edw_ethnicity] PRIMARY KEY CLUSTERED ([ethnicity_id] ASC)
);

