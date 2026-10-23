CREATE VIEW [Zavanti].[vw_GlobalOptionsetMetadata]
AS

SELECT 
[OptionSetName]
,[Option]
,[IsUserLocalizedLabel]
,[LocalizedLabelLanguageCode]
,[LocalizedLabel]
,[GlobalOptionSetName]
,[EntityName]
FROM
(
SELECT 
[OptionSetName]
,[Option]
,[IsUserLocalizedLabel]
,[LocalizedLabelLanguageCode]
,[LocalizedLabel]
,[GlobalOptionSetName]
,[EntityName]

	
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/OptionsetMetadata/GlobalOptionsetMetadata.csv',FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
) 
WITH
(
[OptionSetName] [varchar](128)
,[Option] [bigint]
,[IsUserLocalizedLabel] [varchar](6)
,[LocalizedLabelLanguageCode] [bigint]
,[LocalizedLabel] [varchar](700)
,[GlobalOptionSetName] [varchar](128)
,[EntityName] [varchar](128)
)
AS d
)
AS [data]