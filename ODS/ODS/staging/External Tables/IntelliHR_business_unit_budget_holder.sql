CREATE EXTERNAL TABLE [staging].[IntelliHR_business_unit_budget_holder] (
    [business_unit_id] NVARCHAR (36) NULL,
    [budget_holders_person_id] NVARCHAR (500) NULL,
    [budget_holders_displayname] NVARCHAR (500) NULL,
    [budget_holders_employee_id] NVARCHAR (10) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/business_unit_budget_holder/staging',
    FILE_FORMAT = [parquet]
    );

