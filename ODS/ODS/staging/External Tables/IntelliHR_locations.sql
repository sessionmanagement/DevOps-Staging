CREATE EXTERNAL TABLE [staging].[IntelliHR_locations] (
    [locations_id] NVARCHAR (36) NULL,
    [parentId] NVARCHAR (36) NULL,
    [name] NVARCHAR (150) NULL,
    [address] NVARCHAR (100) NULL,
    [isEnabled] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/locations/staging',
    FILE_FORMAT = [parquet]
    );

