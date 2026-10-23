CREATE VIEW [Zavanti].[vw_zav_zav_propertydetail_zav_subpropertytype]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[versionnumber]
,[zav_propertydetailid]
,[zav_subpropertytypeid]
,[zav_zav_propertydetail_zav_subpropertytypeid]
,[IsDelete]
,[CreatedOn]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[versionnumber]
,[zav_propertydetailid]
,[zav_subpropertytypeid]
,[zav_zav_propertydetail_zav_subpropertytypeid]
,[IsDelete]
,[CreatedOn]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_zav_propertydetail_zav_subpropertytype/*.csv',FORMAT = 'CSV',
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
,[zav_propertydetailid] [uniqueidentifier]
,[zav_subpropertytypeid] [uniqueidentifier]
,[zav_zav_propertydetail_zav_subpropertytypeid] [uniqueidentifier]
,[IsDelete] [varchar](6)
,[CreatedOn] [datetimeoffset](7)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record