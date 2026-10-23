CREATE VIEW [Zavanti].[vw_StatusMetadata]
AS

SELECT 
[EntityName]
,[State]
,[Status]
,[IsUserLocalizedLabel]
,[LocalizedLabelLanguageCode]
,[LocalizedLabel]
FROM
(
SELECT 
[EntityName]
,[State]
,[Status]
,[IsUserLocalizedLabel]
,[LocalizedLabelLanguageCode]
,[LocalizedLabel]

	
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/OptionsetMetadata/StatusMetadata.csv',FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
) 
WITH
(
[EntityName] [varchar](128)
,[State] [bigint]
,[Status] [bigint]
,[IsUserLocalizedLabel] [varchar](6)
,[LocalizedLabelLanguageCode] [bigint]
,[LocalizedLabel] [varchar](700)
)
AS d
)
AS [data]