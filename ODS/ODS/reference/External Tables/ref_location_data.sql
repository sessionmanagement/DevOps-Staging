CREATE EXTERNAL TABLE [reference].[ref_location_data] (
    [service_id] NVARCHAR (40) NULL,
    [service_code] NVARCHAR (4000) NULL,
    [service_name] NVARCHAR (4000) NULL,
    [location_code] NVARCHAR (4000) NULL,
    [location_name] NVARCHAR (4000) NULL,
    [longitude] NVARCHAR (400) NULL,
    [latitude] NVARCHAR (400) NULL,
    [City] NVARCHAR (4000) NULL,
    [Country] NVARCHAR (4000) NULL,
    [location_data] NVARCHAR (4000) NULL
)
    WITH (
    DATA_SOURCE = [ref_data_source],
    LOCATION = N'/ref_location_data.csv',
    FILE_FORMAT = [CsvFormat]
    );

