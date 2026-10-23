CREATE EXTERNAL TABLE [Datapay].[employee_groups] (
    [company_id] NVARCHAR (50) NULL,
    [employee_group_id] NVARCHAR (50) NULL,
    [name] NVARCHAR (250) NULL,
    [employee_group_type] NVARCHAR (50) NULL,
    [inactive] INT NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/employee_groups/main',
    FILE_FORMAT = [parquet]
    );

