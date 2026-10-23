CREATE EXTERNAL TABLE [landing].[EmpLive_roles] (
    [id] NVARCHAR (36) NULL,
    [is_active] INT NULL,
    [name] NVARCHAR (255) NULL,
    [cost_code] NVARCHAR (255) NULL,
    [comments] NVARCHAR (1000) NULL,
    [contract_id] NVARCHAR (36) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/roles/landing',
    FILE_FORMAT = [parquet]
    );

