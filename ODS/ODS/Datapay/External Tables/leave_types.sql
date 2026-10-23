CREATE EXTERNAL TABLE [Datapay].[leave_types] (
    [leave_type_id] NVARCHAR (50) NULL,
    [name] NVARCHAR (50) NULL,
    [type] NVARCHAR (50) NULL,
    [paygroup_id] NVARCHAR (50) NULL,
    [company_id] NVARCHAR (50) NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/leave_types/main',
    FILE_FORMAT = [parquet]
    );

