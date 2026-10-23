CREATE EXTERNAL TABLE [landing].[IntelliHR_pay_grades] (
    [pay_grades_id] NVARCHAR (36) NULL,
    [code] NVARCHAR (50) NULL,
    [name] NVARCHAR (100) NULL,
    [isEnabled] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/pay_grades/landing',
    FILE_FORMAT = [parquet]
    );

