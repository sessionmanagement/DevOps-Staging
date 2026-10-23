CREATE VIEW [Zavanti].[vw_teamprofiles]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[fieldsecurityprofileid]
,[teamid]
,[teamprofileid]
,[versionnumber]
,[IsDelete]
,[CreatedOn]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[fieldsecurityprofileid]
,[teamid]
,[teamprofileid]
,[versionnumber]
,[IsDelete]
,[CreatedOn]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/teamprofiles/*.csv',FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
) 
WITH
(
[Id] [uniqueidentifier]
,[SinkCreatedOn] [datetime2](7)
,[SinkModifiedOn] [datetime2](7)
,[fieldsecurityprofileid] [uniqueidentifier]
,[teamid] [uniqueidentifier]
,[teamprofileid] [uniqueidentifier]
,[versionnumber] [bigint]
,[IsDelete] [varchar](6)
,[CreatedOn] [datetimeoffset](7)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record