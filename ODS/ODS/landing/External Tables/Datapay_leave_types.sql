CREATE EXTERNAL TABLE [landing].[Datapay_leave_types] (
    [leave_type_id] NVARCHAR (50) NULL,
    [name] NVARCHAR (50) NULL,
    [type] NVARCHAR (50) NULL,
    [paygroup_id] NVARCHAR (50) NULL,
    [company_id] NVARCHAR (50) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/leave_types/landing',
    FILE_FORMAT = [parquet]
    );

