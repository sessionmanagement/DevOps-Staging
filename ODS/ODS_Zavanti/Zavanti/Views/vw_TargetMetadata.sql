CREATE VIEW [Zavanti].[vw_TargetMetadata]
AS

SELECT 
[EntityName]
,[AttributeName]
,[ReferencedEntity]
,[ReferencedAttribute]
FROM
(
SELECT 
[EntityName]
,[AttributeName]
,[ReferencedEntity]
,[ReferencedAttribute]

	
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/OptionsetMetadata/TargetMetadata.csv',FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
) 
WITH
(
[EntityName] [varchar](128)
,[AttributeName] [varchar](128)
,[ReferencedEntity] [varchar](128)
,[ReferencedAttribute] [varchar](128)
)
AS d
)
AS [data]