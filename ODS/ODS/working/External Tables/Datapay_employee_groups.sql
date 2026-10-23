CREATE EXTERNAL TABLE [working].[Datapay_employee_groups] (
    [company_id] NVARCHAR (50) NULL,
    [employee_group_id] NVARCHAR (50) NULL,
    [name] NVARCHAR (250) NULL,
    [employee_group_type] NVARCHAR (50) NULL,
    [inactive] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/employee_groups/working',
    FILE_FORMAT = [parquet]
    );

