CREATE EXTERNAL TABLE [Akoranga].[mdl_dp_plan_course_assign] (
    [id] BIGINT NULL,
    [plan_id] BIGINT NULL,
    [course_id] BIGINT NULL,
    [priority] BIGINT NULL,
    [due_date] BIGINT NULL,
    [approved] BIGINT NULL,
    [reason_for_decision] NVARCHAR (MAX) NULL,
    [completion_status] BIGINT NULL,
    [grade] NUMERIC (18) NULL,
    [manual] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_dp_plan_course_assign/main',
    FILE_FORMAT = [parquet]
    );

