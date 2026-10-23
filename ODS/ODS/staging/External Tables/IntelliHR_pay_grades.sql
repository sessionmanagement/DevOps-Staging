CREATE EXTERNAL TABLE [staging].[IntelliHR_pay_grades] (
    [pay_grades_id] NVARCHAR (36) NULL,
    [code] NVARCHAR (50) NULL,
    [name] NVARCHAR (100) NULL,
    [isEnabled] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/pay_grades/staging',
    FILE_FORMAT = [parquet]
    );

