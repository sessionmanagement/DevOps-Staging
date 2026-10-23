CREATE EXTERNAL TABLE [EmpLive].[service_names] (
    [id] NVARCHAR (36) NULL,
    [is_active] INT NULL,
    [reference_number] NVARCHAR (100) NULL,
    [name] NVARCHAR (500) NULL,
    [cost_code] NVARCHAR (500) NULL,
    [service_id] NVARCHAR (36) NULL,
    [address_1] NVARCHAR (500) NULL,
    [address_2] NVARCHAR (500) NULL,
    [suburb] NVARCHAR (500) NULL,
    [state] NVARCHAR (500) NULL,
    [post_code] NVARCHAR (500) NULL,
    [country] NVARCHAR (500) NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/service_names/main',
    FILE_FORMAT = [parquet]
    );

