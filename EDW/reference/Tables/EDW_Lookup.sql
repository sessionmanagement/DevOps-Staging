CREATE TABLE [reference].[EDW_Lookup] (
    [EDW_LookupId]  INT                                         IDENTITY (1, 1) NOT NULL,
    [Input_Value]   VARCHAR (100)                               NOT NULL,
    [Output_Value]  VARCHAR (100)                               NOT NULL,
    [Source_System] VARCHAR (100)                               NOT NULL,
    [Category]      VARCHAR (100)                               NOT NULL,
    [Notes]         VARCHAR (250)                               NULL,
    [EffectiveFrom] DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [EffectiveTo]   DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [EDW_Lookup_PK] PRIMARY KEY CLUSTERED ([EDW_LookupId] ASC),
    PERIOD FOR SYSTEM_TIME ([EffectiveFrom], [EffectiveTo])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[reference].[EDW_Lookup_Hist], DATA_CONSISTENCY_CHECK=ON));


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_EDW_Lookup]
    ON [reference].[EDW_Lookup]([Input_Value] ASC, [Category] ASC);

