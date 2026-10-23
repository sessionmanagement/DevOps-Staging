CREATE VIEW [Zavanti].[vw_activityparty]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[instancetypecode]
,[msft_datastate]
,[participationtypemask]
,[donotemail]
,[donotfax]
,[donotphone]
,[donotpostalmail]
,[ispartydeleted]
,[activityid]
,[activityid_entitytype]
,[partyid]
,[partyid_entitytype]
,[resourcespecid]
,[resourcespecid_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[activitypartyid]
,[addressused]
,[addressusedemailcolumnnumber]
,[effort]
,[exchangeentryid]
,[owneridtype]
,[owningbusinessunit]
,[owninguser]
,[partyidname]
,[partyobjecttypecode]
,[resourcespecidname]
,[scheduledend]
,[scheduledstart]
,[unresolvedpartyname]
,[versionnumber]
,[IsDelete]
,[CreatedOn]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[instancetypecode]
,[msft_datastate]
,[participationtypemask]
,[donotemail]
,[donotfax]
,[donotphone]
,[donotpostalmail]
,[ispartydeleted]
,[activityid]
,[activityid_entitytype]
,[partyid]
,[partyid_entitytype]
,[resourcespecid]
,[resourcespecid_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[activitypartyid]
,[addressused]
,[addressusedemailcolumnnumber]
,[effort]
,[exchangeentryid]
,[owneridtype]
,[owningbusinessunit]
,[owninguser]
,[partyidname]
,[partyobjecttypecode]
,[resourcespecidname]
,[scheduledend]
,[scheduledstart]
,[unresolvedpartyname]
,[versionnumber]
,[IsDelete]
,[CreatedOn]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/activityparty/*.csv',FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
) 
WITH
(
[Id] [uniqueidentifier]
,[SinkCreatedOn] [datetime2](7)
,[SinkModifiedOn] [datetime2](7)
,[instancetypecode] [bigint]
,[msft_datastate] [bigint]
,[participationtypemask] [bigint]
,[donotemail] [varchar](6)
,[donotfax] [varchar](6)
,[donotphone] [varchar](6)
,[donotpostalmail] [varchar](6)
,[ispartydeleted] [varchar](6)
,[activityid] [uniqueidentifier]
,[activityid_entitytype] [varchar](256)
,[partyid] [uniqueidentifier]
,[partyid_entitytype] [varchar](256)
,[resourcespecid] [uniqueidentifier]
,[resourcespecid_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[activitypartyid] [uniqueidentifier]
,[addressused] [varchar](1280)
,[addressusedemailcolumnnumber] [bigint]
,[effort] [float]
,[exchangeentryid] [varchar](4096)
,[owneridtype] [varchar](8000)
,[owningbusinessunit] [uniqueidentifier]
,[owninguser] [uniqueidentifier]
,[partyidname] [varchar](max)
,[partyobjecttypecode] [varchar](8000)
,[resourcespecidname] [varchar](640)
,[scheduledend] [datetime2](7)
,[scheduledstart] [datetime2](7)
,[unresolvedpartyname] [varchar](800)
,[versionnumber] [bigint]
,[IsDelete] [varchar](6)
,[CreatedOn] [datetimeoffset](7)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record