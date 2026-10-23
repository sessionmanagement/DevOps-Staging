CREATE VIEW [Zavanti].[vw_activitymimeattachment]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[componentstate]
,[msft_datastate]
,[isfollowed]
,[ismanaged]
,[activityid]
,[activityid_entitytype]
,[attachmentid]
,[attachmentid_entitytype]
,[objectid]
,[objectid_entitytype]
,[owningbusinessunit]
,[owningbusinessunit_entitytype]
,[owninguser]
,[owninguser_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[activitymimeattachmentid]
,[activitymimeattachmentidunique]
,[activitysubject]
,[anonymouslink]
,[attachmentcontentid]
,[attachmentnumber]
,[body]
,[filename]
,[filesize]
,[mimetype]
,[objecttypecode]
,[overwritetime]
,[owneridname]
,[owneridtype]
,[solutionid]
,[subject]
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
,[msft_datastate]
,[isfollowed]
,[ismanaged]
,[activityid]
,[activityid_entitytype]
,[attachmentid]
,[attachmentid_entitytype]
,[objectid]
,[objectid_entitytype]
,[owningbusinessunit]
,[owningbusinessunit_entitytype]
,[owninguser]
,[owninguser_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[activitymimeattachmentid]
,[activitymimeattachmentidunique]
,[activitysubject]
,[anonymouslink]
,[attachmentcontentid]
,[attachmentnumber]
,[body]
,[filename]
,[filesize]
,[mimetype]
,[objecttypecode]
,[overwritetime]
,[owneridname]
,[owneridtype]
,[solutionid]
,[subject]
,[supportingsolutionid]
,[versionnumber]
,[IsDelete]
,[CreatedOn]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/activitymimeattachment/*.csv',FORMAT = 'CSV',
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
,[msft_datastate] [bigint]
,[isfollowed] [varchar](6)
,[ismanaged] [varchar](6)
,[activityid] [uniqueidentifier]
,[activityid_entitytype] [varchar](256)
,[attachmentid] [uniqueidentifier]
,[attachmentid_entitytype] [varchar](256)
,[objectid] [uniqueidentifier]
,[objectid_entitytype] [varchar](256)
,[owningbusinessunit] [uniqueidentifier]
,[owningbusinessunit_entitytype] [varchar](256)
,[owninguser] [uniqueidentifier]
,[owninguser_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[activitymimeattachmentid] [uniqueidentifier]
,[activitymimeattachmentidunique] [uniqueidentifier]
,[activitysubject] [varchar](800)
,[anonymouslink] [varchar](8000)
,[attachmentcontentid] [varchar](1000)
,[attachmentnumber] [bigint]
,[body] [varchar](max)
,[filename] [varchar](1020)
,[filesize] [bigint]
,[mimetype] [varchar](1024)
,[objecttypecode] [varchar](8000)
,[overwritetime] [datetime2](7)
,[owneridname] [varchar](640)
,[owneridtype] [varchar](8000)
,[solutionid] [uniqueidentifier]
,[subject] [varchar](8000)
,[supportingsolutionid] [uniqueidentifier]
,[versionnumber] [bigint]
,[IsDelete] [varchar](6)
,[CreatedOn] [datetimeoffset](7)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record