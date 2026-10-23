CREATE VIEW [Zavanti].[vw_roleprivileges]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[componentstate]
,[ismanaged]
,[recordfilterid]
,[recordfilterid_entitytype]
,[canbedeleted]
,[overwritetime]
,[privilegedepthmask]
,[privilegeid]
,[recordfilteridname]
,[roleid]
,[roleprivilegeid]
,[roleprivilegeidunique]
,[solutionid]
,[supportingsolutionid]
,[versionnumber]
,[IsDelete]
,[CreatedOn]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[componentstate]
,[ismanaged]
,[recordfilterid]
,[recordfilterid_entitytype]
,[canbedeleted]
,[overwritetime]
,[privilegedepthmask]
,[privilegeid]
,[recordfilteridname]
,[roleid]
,[roleprivilegeid]
,[roleprivilegeidunique]
,[solutionid]
,[supportingsolutionid]
,[versionnumber]
,[IsDelete]
,[CreatedOn]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/roleprivileges/*.csv',FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
) 
WITH
(
[Id] [uniqueidentifier]
,[SinkCreatedOn] [datetime2](7)
,[SinkModifiedOn] [datetime2](7)
,[componentstate] [bigint]
,[ismanaged] [varchar](6)
,[recordfilterid] [uniqueidentifier]
,[recordfilterid_entitytype] [varchar](256)
,[canbedeleted] [varchar](8000)
,[overwritetime] [datetime2](7)
,[privilegedepthmask] [bigint]
,[privilegeid] [uniqueidentifier]
,[recordfilteridname] [varchar](400)
,[roleid] [uniqueidentifier]
,[roleprivilegeid] [uniqueidentifier]
,[roleprivilegeidunique] [uniqueidentifier]
,[solutionid] [uniqueidentifier]
,[supportingsolutionid] [uniqueidentifier]
,[versionnumber] [bigint]
,[IsDelete] [varchar](6)
,[CreatedOn] [datetimeoffset](7)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record