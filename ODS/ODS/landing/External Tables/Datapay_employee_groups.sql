CREATE EXTERNAL TABLE [landing].[Datapay_employee_groups] (
    [company_id] NVARCHAR (50) NULL,
    [employee_group_id] NVARCHAR (50) NULL,
    [name] NVARCHAR (250) NULL,
    [employee_group_type] NVARCHAR (50) NULL,
    [inactive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/employee_groups/landing',
    FILE_FORMAT = [parquet]
    );

