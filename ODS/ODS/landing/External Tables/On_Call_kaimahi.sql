CREATE EXTERNAL TABLE [landing].[On_Call_kaimahi] (
    [kaimahi_id] INT NULL,
    [kaimahi_name] NVARCHAR (100) NULL,
    [user_email] NVARCHAR (200) NULL,
    [region_1_id] INT NULL,
    [region_1_name] NVARCHAR (100) NULL,
    [region_2_id] INT NULL,
    [region_2_name] NVARCHAR (100) NULL,
    [region_3_id] INT NULL,
    [region_3_name] NVARCHAR (100) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'On_Call/kaimahi/landing',
    FILE_FORMAT = [parquet]
    );

