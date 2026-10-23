CREATE EXTERNAL TABLE [landing].[Akoranga_mdl_enrol] (
    [id] BIGINT NULL,
    [enrol] NVARCHAR (MAX) NULL,
    [status] BIGINT NULL,
    [course_id] BIGINT NULL,
    [sortorder] BIGINT NULL,
    [name] NVARCHAR (MAX) NULL,
    [enrol_period] BIGINT NULL,
    [enrol_start_date] BIGINT NULL,
    [enrol_end_date] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_enrol/landing',
    FILE_FORMAT = [parquet]
    );

