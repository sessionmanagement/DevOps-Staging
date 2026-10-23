CREATE VIEW [Zavanti].[vw_zav_zav_property_zav_location]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[versionnumber]
,[zav_locationid]
,[zav_propertyid]
,[zav_zav_property_zav_locationid]
,[IsDelete]
,[CreatedOn]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[versionnumber]
,[zav_locationid]
,[zav_propertyid]
,[zav_zav_property_zav_locationid]
,[IsDelete]
,[CreatedOn]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_zav_property_zav_location/*.csv',FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
) 
WITH
(
[Id] [uniqueidentifier]
,[SinkCreatedOn] [datetime2](7)
,[SinkModifiedOn] [datetime2](7)
,[versionnumber] [bigint]
,[zav_locationid] [uniqueidentifier]
,[zav_propertyid] [uniqueidentifier]
,[zav_zav_property_zav_locationid] [uniqueidentifier]
,[IsDelete] [varchar](6)
,[CreatedOn] [datetimeoffset](7)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record