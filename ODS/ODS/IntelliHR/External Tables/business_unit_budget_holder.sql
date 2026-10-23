CREATE EXTERNAL TABLE [IntelliHR].[business_unit_budget_holder] (
    [business_unit_id] NVARCHAR (36) NULL,
    [budget_holders_person_id] NVARCHAR (500) NULL,
    [budget_holders_displayname] NVARCHAR (500) NULL,
    [budget_holders_employee_id] NVARCHAR (10) NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/business_unit_budget_holder/main',
    FILE_FORMAT = [parquet]
    );

