CREATE EXTERNAL TABLE [on_call].[kaimahi] (
    [kaimahi_id] INT NULL,
    [kaimahi_name] NVARCHAR (100) NULL,
    [user_email] NVARCHAR (200) NULL,
    [region_1_id] INT NULL,
    [region_1_name] NVARCHAR (100) NULL,
    [region_2_id] INT NULL,
    [region_2_name] NVARCHAR (100) NULL,
    [region_3_id] INT NULL,
    [region_3_name] NVARCHAR (100) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'On_Call/kaimahi/main',
    FILE_FORMAT = [parquet]
    );

