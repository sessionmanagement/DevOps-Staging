CREATE TABLE [reference].[edw_service_lookup] (
    [edw_service_lookupId] INT                                         IDENTITY (1, 1) NOT NULL,
    [service_id_from]      VARCHAR (100)                               NOT NULL,
    [service_company_from] VARCHAR (100)                               NOT NULL,
    [service_id_to]        VARCHAR (100)                               NOT NULL,
    [service_company_to]   VARCHAR (100)                               NOT NULL,
    [Source_System]        VARCHAR (100)                               NOT NULL,
    [Category]             VARCHAR (100)                               NOT NULL,
    [Notes]                VARCHAR (250)                               NULL,
    [EffectiveFrom]        DATETIME2 (7) GENERATED ALWAYS AS ROW START NOT NULL,
    [EffectiveTo]          DATETIME2 (7) GENERATED ALWAYS AS ROW END   NOT NULL,
    CONSTRAINT [edw_service_lookup_PK] PRIMARY KEY CLUSTERED ([edw_service_lookupId] ASC),
    PERIOD FOR SYSTEM_TIME ([EffectiveFrom], [EffectiveTo])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[reference].[edw_service_lookup_hist], DATA_CONSISTENCY_CHECK=ON));

