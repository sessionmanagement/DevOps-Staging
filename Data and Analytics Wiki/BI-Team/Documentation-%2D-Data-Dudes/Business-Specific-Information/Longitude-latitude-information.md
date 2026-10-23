
Location of the [reference].[ref_location_data] table

Update this csv file to pass through the data to dim_service


![image.png](/.attachments/image-e750f89c-1431-480f-90f8-420d187555b2.png)




CREATE EXTERNAL TABLE [reference].[ref_location_data]
(
	[service_id] [nvarchar](40),
	[service_code] [nvarchar](4000),
	[service_name] [nvarchar](4000),
	[location_code] [nvarchar](4000),
	[location_name] [nvarchar](4000),
	[longitude] [nvarchar](400),
	[latitude] [nvarchar](400),
	[City] [nvarchar](4000),
	[Country] [nvarchar](4000),
	[location_data] [nvarchar](4000)
)
WITH (DATA_SOURCE = [ref_data_source],LOCATION = N'/ref_location_data.csv',FILE_FORMAT = [CsvFormat])
GO
