CREATE EXTERNAL TABLE [working].[IntelliHR_business_unit_budget_holder] (
    [business_unit_id] NVARCHAR (36) NULL,
    [budget_holders_person_id] NVARCHAR (500) NULL,
    [budget_holders_displayname] NVARCHAR (500) NULL,
    [budget_holders_employee_id] NVARCHAR (10) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/business_unit_budget_holder/working',
    FILE_FORMAT = [parquet]
    );

