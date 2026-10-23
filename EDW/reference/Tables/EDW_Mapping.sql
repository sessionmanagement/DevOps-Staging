CREATE TABLE [reference].[EDW_Mapping] (
    [EDW_MappingId] INT                                         IDENTITY (1, 1) NOT NULL,
    [id]            INT                                         NOT NULL,
    [Value]         VARCHAR (100)                               NOT NULL,
    [Source_System] VARCHAR (100)                               NOT NULL,
    [Category]      VARCHAR (100)                               NOT NULL,
    [Notes]         VARCHAR (250)                               NOT NULL,
    [EffectiveFrom] DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [EffectiveTo]   DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [EDW_Mapping_PK] PRIMARY KEY CLUSTERED ([EDW_MappingId] ASC),
    PERIOD FOR SYSTEM_TIME ([EffectiveFrom], [EffectiveTo])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[reference].[EDW_Mapping_Hist], DATA_CONSISTENCY_CHECK=ON));


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_EDW_Mapping]
    ON [reference].[EDW_Mapping]([id] ASC, [Category] ASC);

