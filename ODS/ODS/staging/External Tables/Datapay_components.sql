CREATE EXTERNAL TABLE [staging].[Datapay_components] (
    [company_id] NVARCHAR (50) NULL,
    [component_id] NVARCHAR (50) NULL,
    [code] NVARCHAR (50) NULL,
    [name] NVARCHAR (100) NULL,
    [category] NVARCHAR (50) NULL,
    [subcategory] NVARCHAR (100) NULL,
    [component_parameter_id] NVARCHAR (50) NULL,
    [parameter_name] NVARCHAR (100) NULL,
    [value_type] NVARCHAR (50) NULL,
    [role] NVARCHAR (50) NULL,
    [reference_value_id] NVARCHAR (50) NULL,
    [reference_value_name] NVARCHAR (100) NULL,
    [reference_value_value] NVARCHAR (50) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/components/staging',
    FILE_FORMAT = [parquet]
    );

