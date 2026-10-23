CREATE EXTERNAL TABLE [staging].[Akoranga_mdl_dp_plan] (
    [id] BIGINT NULL,
    [template_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [name] NVARCHAR (MAX) NULL,
    [description] NVARCHAR (MAX) NULL,
    [start_date] BIGINT NULL,
    [end_date] BIGINT NULL,
    [time_completed] BIGINT NULL,
    [certif_status] BIGINT NULL,
    [created_by] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_dp_plan/staging',
    FILE_FORMAT = [parquet]
    );

