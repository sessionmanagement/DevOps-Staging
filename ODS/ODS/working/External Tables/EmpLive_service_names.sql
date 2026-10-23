CREATE EXTERNAL TABLE [working].[EmpLive_service_names] (
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
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/service_names/working',
    FILE_FORMAT = [parquet]
    );

