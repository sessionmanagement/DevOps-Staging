CREATE EXTERNAL TABLE [Akoranga].[mdl_totara_core_course_vis_map] (
    [id] BIGINT NULL,
    [course_id] BIGINT NULL,
    [role_id] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_totara_core_course_vis_map/main',
    FILE_FORMAT = [parquet]
    );

