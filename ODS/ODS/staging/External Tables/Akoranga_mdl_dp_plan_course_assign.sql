CREATE EXTERNAL TABLE [staging].[Akoranga_mdl_dp_plan_course_assign] (
    [id] BIGINT NULL,
    [plan_id] BIGINT NULL,
    [course_id] BIGINT NULL,
    [priority] BIGINT NULL,
    [due_date] BIGINT NULL,
    [approved] BIGINT NULL,
    [reason_for_decision] NVARCHAR (MAX) NULL,
    [completion_status] BIGINT NULL,
    [grade] NUMERIC (18) NULL,
    [manual] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_dp_plan_course_assign/staging',
    FILE_FORMAT = [parquet]
    );

