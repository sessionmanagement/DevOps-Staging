CREATE EXTERNAL TABLE [staging].[EmpLive_jobs] (
    [id] NVARCHAR (36) NULL,
    [reference_number] NVARCHAR (255) NULL,
    [name] NVARCHAR (255) NULL,
    [start_date] DATETIME2 (7) NULL,
    [end_date] DATETIME2 (7) NULL,
    [cost_code] NVARCHAR (255) NULL,
    [comments] NVARCHAR (500) NULL,
    [contact_name] NVARCHAR (255) NULL,
    [contact_phone] NVARCHAR (255) NULL,
    [address_1] NVARCHAR (255) NULL,
    [address_2] NVARCHAR (255) NULL,
    [suburb] NVARCHAR (255) NULL,
    [state] NVARCHAR (50) NULL,
    [post_code] NVARCHAR (10) NULL,
    [country] NVARCHAR (100) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/jobs/staging',
    FILE_FORMAT = [parquet]
    );

