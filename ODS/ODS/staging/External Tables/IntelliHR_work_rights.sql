CREATE EXTERNAL TABLE [staging].[IntelliHR_work_rights] (
    [work_rights_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (500) NULL,
    [countryId] NVARCHAR (36) NULL,
    [country] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/work_rights/staging',
    FILE_FORMAT = [parquet]
    );

