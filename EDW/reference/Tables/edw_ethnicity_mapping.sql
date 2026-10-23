CREATE TABLE [reference].[edw_ethnicity_mapping] (
    [edw_ethnicity_mappingId] INT                                         IDENTITY (1, 1) NOT NULL,
    [Input_Value]             VARCHAR (100)                               NOT NULL,
    [ethnicity_1]             INT                                         NULL,
    [ethnicity_2]             INT                                         NULL,
    [ethnicity_3]             INT                                         NULL,
    [ethnicity_4]             INT                                         NULL,
    [Source_System]           VARCHAR (100)                               NOT NULL,
    [Category]                VARCHAR (100)                               NOT NULL,
    [Notes]                   VARCHAR (250)                               NULL,
    [EffectiveFrom]           DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [EffectiveTo]             DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [edw_ethnicity_mapping_PK] PRIMARY KEY CLUSTERED ([edw_ethnicity_mappingId] ASC),
    PERIOD FOR SYSTEM_TIME ([EffectiveFrom], [EffectiveTo])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[reference].[edw_ethnicity_mapping_hist], DATA_CONSISTENCY_CHECK=ON));

