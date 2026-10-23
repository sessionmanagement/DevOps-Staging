CREATE TABLE [reference].[edw_service_lookup_hist] (
    [edw_service_lookupId] INT           NOT NULL,
    [service_id_from]      VARCHAR (100) NOT NULL,
    [service_company_from] VARCHAR (100) NOT NULL,
    [service_id_to]        VARCHAR (100) NOT NULL,
    [service_company_to]   VARCHAR (100) NOT NULL,
    [Source_System]        VARCHAR (100) NOT NULL,
    [Category]             VARCHAR (100) NOT NULL,
    [Notes]                VARCHAR (250) NULL,
    [EffectiveFrom]        DATETIME2 (7) NOT NULL,
    [EffectiveTo]          DATETIME2 (7) NOT NULL
)
WITH (DATA_COMPRESSION = PAGE);

