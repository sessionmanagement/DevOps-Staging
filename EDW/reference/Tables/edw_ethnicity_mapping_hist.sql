CREATE TABLE [reference].[edw_ethnicity_mapping_hist] (
    [edw_ethnicity_mappingId] INT           NOT NULL,
    [Input_Value]             VARCHAR (100) NOT NULL,
    [ethnicity_1]             INT           NULL,
    [ethnicity_2]             INT           NULL,
    [ethnicity_3]             INT           NULL,
    [ethnicity_4]             INT           NULL,
    [Source_System]           VARCHAR (100) NOT NULL,
    [Category]                VARCHAR (100) NOT NULL,
    [Notes]                   VARCHAR (250) NULL,
    [EffectiveFrom]           DATETIME2 (7) NOT NULL,
    [EffectiveTo]             DATETIME2 (7) NOT NULL
)
WITH (DATA_COMPRESSION = PAGE);

