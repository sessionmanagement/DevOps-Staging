CREATE EXTERNAL TABLE [working].[Akoranga_mdl_totara_core_program_vis_map] (
    [id] BIGINT NULL,
    [program_id] BIGINT NULL,
    [role_id] BIGINT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_totara_core_program_vis_map/working',
    FILE_FORMAT = [parquet]
    );

