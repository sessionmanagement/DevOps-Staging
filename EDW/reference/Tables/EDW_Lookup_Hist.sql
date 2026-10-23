CREATE TABLE [reference].[EDW_Lookup_Hist] (
    [EDW_LookupId]  INT           NOT NULL,
    [Input_Value]   VARCHAR (100) NOT NULL,
    [Output_Value]  VARCHAR (100) NOT NULL,
    [Source_System] VARCHAR (100) NOT NULL,
    [Category]      VARCHAR (100) NOT NULL,
    [Notes]         VARCHAR (250) NULL,
    [EffectiveFrom] DATETIME2 (7) NOT NULL,
    [EffectiveTo]   DATETIME2 (7) NOT NULL
);


GO
CREATE CLUSTERED INDEX [ix_EDW_Lookup_Hist]
    ON [reference].[EDW_Lookup_Hist]([EffectiveTo] ASC, [EffectiveFrom] ASC) WITH (DATA_COMPRESSION = PAGE);

