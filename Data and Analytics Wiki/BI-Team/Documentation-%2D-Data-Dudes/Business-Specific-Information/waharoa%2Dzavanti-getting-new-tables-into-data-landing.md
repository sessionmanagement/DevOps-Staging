             
Open in private web

![==image_0==.png](/.attachments/==image_0==-4a5e890d-ac63-4924-a279-1b384b21a7b3.png) 

Sign in to the following site make.preview.powerapps.com with the appropriate Waharoa user name and password. (Get this from key vault)

![image.png](/.attachments/image-7967b26c-58c5-49fb-a5da-c2e32487b760.png)

![==image_1==.png](/.attachments/==image_1==-72a4743d-ff5b-4079-a27e-994bf34524fc.png) 

Open the synapse link, change the environment to waharoa production

![image.png](/.attachments/image-fd57cce5-ee3e-44fe-b1f5-71efbb3bb83e.png)

Open the tables tab and search for the table you want to sync
![==image_2==.png](/.attachments/==image_2==-adfc397c-e595-4272-b06e-6280f20ad6c9.png) 

Look at the advanced table options and check it has track changes

![==image_3==.png](/.attachments/==image_3==-fd7a30d3-0bc5-49c4-a020-57cb483f6ccc.png) 

Open manage tables advanced and enable options, select the table you want to add select it and click save

![image.png](/.attachments/image-6ee590dc-b942-41e8-9b1a-f463f2a1b50a.png)



Once the table shows up in the dataverse_development database 

![image.png](/.attachments/image-f23e5472-77fa-47b7-898c-7d1c99398351.png)

Then run the following script and take the relevant create view statement and run that in the ODS

do this for each of the three environments




``` SQL


/*
Notes:
	1)	openrowset path will need to be changed between environments
	2)	metatdata tables are a special case that dont follow the standard filepath
	3)	RowNumber is only needed for standard tables where we want to return the latest record across the id field

*/


/*
-- Prod settings
DECLARE @waharoa_storage varchar(200) = 'https://stprodaussvcwaharoa01.dfs.core.windows.net/'
DECLARE @azure_storage_dataverse_container varchar(200) = 'dataverse-production-unq4700e6c14e7940f8b4bd16591871c'
*/


-- Test Settings
--DECLARE @waharoa_storage varchar(200) = 'https://sttestaussvcwaharoa01.dfs.core.windows.net/'
--DECLARE @azure_storage_dataverse_container varchar(200) = 'dataverse-development-unq1cbc77b3627646c9a4491204085ce'


-- Dev Settings
DECLARE @waharoa_storage varchar(200) = 'https://stdevaussvcwaharoa01.dfs.core.windows.net/'
DECLARE @azure_storage_dataverse_container varchar(200) = 'dataverse-development-unq1cbc77b3627646c9a4491204085ce'


DECLARE @first_data_row INT = 1 -- if no header row then should be 1


SELECT 
b.TABLE_NAME  AS Dataverse_Source_Name,
'DROP VIEW [Zavanti].[vw_' + b.TABLE_NAME + ']'  +  CHAR(10)  +  CHAR(10)  AS SQL_Drop_Ext_Table_View,
'CREATE VIEW [Zavanti].[vw_' + b.TABLE_NAME + ']
AS

SELECT '
+ CHAR(10) + b.SQL_Fields +  CHAR(10) + 
'FROM
(
SELECT '
+ CHAR(10) + b.SQL_Fields +  CHAR(10) + '
	' + CASE WHEN CHARINDEX('[SinkModifiedOn]', b.SQL_Fields)> 0 THEN ',ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record ' ELSE '' END + '
FROM OPENROWSET(
   BULK ''' + @waharoa_storage + @azure_storage_dataverse_container + '/' + CASE WHEN b.TABLE_NAME LIKE '%Metadata' THEN   'OptionsetMetadata/' +  b.TABLE_NAME + '.csv'',' ELSE  + b.TABLE_NAME + '/*.csv'',' END +
    'FORMAT = ''CSV'',
    FIELDTERMINATOR = '','',
    ROWTERMINATOR = ''\n'',
    FIRSTROW = '+ CAST(@first_data_row AS VARCHAR(10)) +  '
) 
WITH
(' + CHAR(10) + b.SQL_Field_defs + CHAR(10) + ')
AS d
)
AS [data]
' + CASE WHEN CHARINDEX('[SinkModifiedOn]', b.SQL_Fields)> 0 THEN 'WHERE row_num = 1 -- return only latest record' ELSE '' END + '
GO
' AS SQL_Create_Ext_Table_View
,'SELECT ''Zavanti.vw_' + b.TABLE_NAME + '''  AS Table_Name, COUNT(*) AS Row_Count FROM  [Zavanti].[vw_' + b.TABLE_NAME + ']' + 
char(10) +
'UNION ALL' +
char(10) AS SQL_View_Row_Count
FROM (
	SELECT a.TABLE_NAME
		,STRING_AGG('[' + CAST(a.COLUMN_NAME AS VARCHAR(MAX)) + '] [' + CAST(a.DATA_TYPE AS VARCHAR(MAX)) + ']' + coalesce(a.STRING_Details, a.DECIMAL_Details, a.DATETIME_Details, ''), CHAR(10) + ',') WITHIN
		GROUP (
				ORDER BY a.ORDINAL_POSITION ASC
				) AS SQL_Field_defs
		,STRING_AGG('[' + CAST(a.COLUMN_NAME AS VARCHAR(MAX)) + ']', CHAR(10) + ',') WITHIN
		GROUP (
				ORDER BY a.ORDINAL_POSITION ASC
				) AS SQL_Fields
	FROM (
		SELECT isc.TABLE_NAME
			,isc.COLUMN_NAME
			,isc.DATA_TYPE
			,isc.ORDINAL_POSITION
			,'(' + CASE 
				WHEN isc.CHARACTER_MAXIMUM_LENGTH = - 1
					THEN 'max'
				ELSE CAST(isc.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10))
				END + ')' AS STRING_Details
			,CASE 
				WHEN isc.DATA_TYPE = 'bigint'
					THEN ''
				ELSE '(' + CAST(isc.NUMERIC_PRECISION AS VARCHAR(10)) + ',' + CAST(isc.NUMERIC_SCALE AS VARCHAR(10)) + ')'
				END AS DECIMAL_Details
			,'(' + CAST(isc.DATETIME_PRECISION AS VARCHAR(10)) + ')' AS DATETIME_Details
		FROM INFORMATION_SCHEMA.COLUMNS as isc
		INNER JOIN INFORMATION_SCHEMA.TABLES as ist ON isc.TABLE_CATALOG = ist.TABLE_CATALOG
			AND  isc.TABLE_NAME = ist.TABLE_NAME
		WHERE ist.TABLE_TYPE = 'BASE TABLE'
		) AS a
	GROUP BY a.TABLE_NAME
	) AS b
ORDER BY b.TABLE_NAME 


```


