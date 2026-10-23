CREATE EXTERNAL TABLE [staging].[EmpLive_pay_levels] (
    [id] NVARCHAR (36) NULL,
    [name] NVARCHAR (255) NULL,
    [cost_code] NVARCHAR (50) NULL,
    [contract_id] NVARCHAR (36) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/pay_levels/staging',
    FILE_FORMAT = [parquet]
    );

