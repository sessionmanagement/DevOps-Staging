CREATE TABLE [reference].[EDW_Mapping_Hist] (
    [EDW_MappingId] INT           NOT NULL,
    [id]            INT           NOT NULL,
    [Value]         VARCHAR (100) NOT NULL,
    [Source_System] VARCHAR (100) NOT NULL,
    [Category]      VARCHAR (100) NOT NULL,
    [Notes]         VARCHAR (250) NOT NULL,
    [EffectiveFrom] DATETIME2 (7) NOT NULL,
    [EffectiveTo]   DATETIME2 (7) NOT NULL
);


GO
CREATE CLUSTERED INDEX [ix_EDW_Mapping_Hist]
    ON [reference].[EDW_Mapping_Hist]([EffectiveTo] ASC, [EffectiveFrom] ASC) WITH (DATA_COMPRESSION = PAGE);

