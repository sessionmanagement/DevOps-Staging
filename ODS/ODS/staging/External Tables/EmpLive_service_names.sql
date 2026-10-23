CREATE EXTERNAL TABLE [staging].[EmpLive_service_names] (
    [id] NVARCHAR (36) NULL,
    [is_active] INT NULL,
    [reference_number] NVARCHAR (100) NULL,
    [name] NVARCHAR (500) NULL,
    [cost_code] NVARCHAR (500) NULL,
    [service_id] NVARCHAR (36) NULL,
    [address_1] NVARCHAR (500) NULL,
    [address_2] NVARCHAR (500) NULL,
    [suburb] NVARCHAR (500) NULL,
    [state] NVARCHAR (500) NULL,
    [post_code] NVARCHAR (500) NULL,
    [country] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/service_names/staging',
    FILE_FORMAT = [parquet]
    );

