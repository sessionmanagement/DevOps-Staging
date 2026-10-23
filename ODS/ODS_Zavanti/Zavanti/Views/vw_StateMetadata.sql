CREATE VIEW [Zavanti].[vw_StateMetadata]
AS

SELECT 
[EntityName]
,[State]
,[IsUserLocalizedLabel]
,[LocalizedLabelLanguageCode]
,[LocalizedLabel]
FROM
(
SELECT 
[EntityName]
,[State]
,[IsUserLocalizedLabel]
,[LocalizedLabelLanguageCode]
,[LocalizedLabel]

	
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/OptionsetMetadata/StateMetadata.csv',FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
) 
WITH
(
[EntityName] [varchar](128)
,[State] [bigint]
,[IsUserLocalizedLabel] [varchar](6)
,[LocalizedLabelLanguageCode] [bigint]
,[LocalizedLabel] [varchar](700)
)
AS d
)
AS [data]