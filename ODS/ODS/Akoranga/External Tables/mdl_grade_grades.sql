CREATE EXTERNAL TABLE [Akoranga].[mdl_grade_grades] (
    [id] BIGINT NULL,
    [item_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [raw_grade] NUMERIC (18) NULL,
    [raw_grade_max] NUMERIC (18) NULL,
    [raw_grade_min] NUMERIC (18) NULL,
    [raw_scale_id] BIGINT NULL,
    [user_modified] BIGINT NULL,
    [final_grade] NUMERIC (18) NULL,
    [hidden] BIGINT NULL,
    [locked] BIGINT NULL,
    [lock_time] BIGINT NULL,
    [exported] BIGINT NULL,
    [overridden] BIGINT NULL,
    [excluded] BIGINT NULL,
    [feedback] NVARCHAR (MAX) NULL,
    [feedback_format] BIGINT NULL,
    [information] NVARCHAR (MAX) NULL,
    [information_format] BIGINT NULL,
    [time_created] BIGINT NULL,
    [time_modified] BIGINT NULL,
    [aggregation_status] NVARCHAR (MAX) NULL,
    [aggregation_weight] NUMERIC (18) NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_grade_grades/main',
    FILE_FORMAT = [parquet]
    );

