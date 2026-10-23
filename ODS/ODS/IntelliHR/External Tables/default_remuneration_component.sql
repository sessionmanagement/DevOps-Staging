CREATE EXTERNAL TABLE [IntelliHR].[default_remuneration_component] (
    [default_remuneration_component_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [value] DECIMAL (10, 2) NULL,
    [isInUse] INT NULL,
    [automaticallyAddToJobs] INT NULL,
    [isEnabled] INT NULL,
    [currency] NVARCHAR (3) NULL,
    [type] NVARCHAR (500) NULL,
    [valueType] NVARCHAR (500) NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/default_remuneration_component/main',
    FILE_FORMAT = [parquet]
    );

