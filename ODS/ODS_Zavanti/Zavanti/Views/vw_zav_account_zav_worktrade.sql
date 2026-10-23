CREATE VIEW [Zavanti].[vw_zav_account_zav_worktrade]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[accountid]
,[versionnumber]
,[zav_account_zav_worktradeid]
,[zav_worktradeid]
,[IsDelete]
,[CreatedOn]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[accountid]
,[versionnumber]
,[zav_account_zav_worktradeid]
,[zav_worktradeid]
,[IsDelete]
,[CreatedOn]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_account_zav_worktrade/*.csv',FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
) 
WITH
(
[Id] [uniqueidentifier]
,[SinkCreatedOn] [datetime2](7)
,[SinkModifiedOn] [datetime2](7)
,[accountid] [uniqueidentifier]
,[versionnumber] [bigint]
,[zav_account_zav_worktradeid] [uniqueidentifier]
,[zav_worktradeid] [uniqueidentifier]
,[IsDelete] [varchar](6)
,[CreatedOn] [datetimeoffset](7)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record