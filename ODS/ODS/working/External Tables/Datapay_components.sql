CREATE EXTERNAL TABLE [working].[Datapay_components] (
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
    [reference_value_value] NVARCHAR (50) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/components/working',
    FILE_FORMAT = [parquet]
    );

