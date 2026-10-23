CREATE EXTERNAL TABLE [working].[Datapay_leave_types] (
    [leave_type_id] NVARCHAR (50) NULL,
    [name] NVARCHAR (50) NULL,
    [type] NVARCHAR (50) NULL,
    [paygroup_id] NVARCHAR (50) NULL,
    [company_id] NVARCHAR (50) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/leave_types/working',
    FILE_FORMAT = [parquet]
    );

