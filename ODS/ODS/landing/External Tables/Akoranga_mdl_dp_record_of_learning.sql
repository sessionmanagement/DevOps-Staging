CREATE EXTERNAL TABLE [landing].[Akoranga_mdl_dp_record_of_learning] (
    [id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [instance_id] BIGINT NULL,
    [type] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_dp_record_of_learning/landing',
    FILE_FORMAT = [parquet]
    );

