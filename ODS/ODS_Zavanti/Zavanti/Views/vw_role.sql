CREATE VIEW [Zavanti].[vw_role]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[componentstate]
,[isinherited]
,[ismanaged]
,[businessunitid]
,[businessunitid_entitytype]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[parentroleid]
,[parentroleid_entitytype]
,[parentrootroleid]
,[parentrootroleid_entitytype]
,[roletemplateid]
,[roletemplateid_entitytype]
,[businessunitidname]
,[canbedeleted]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[importsequencenumber]
,[iscustomizable]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[name]
,[organizationid]
,[organizationidname]
,[overriddencreatedon]
,[overwritetime]
,[parentroleidname]
,[parentrootroleidname]
,[roleid]
,[roleidunique]
,[solutionid]
,[supportingsolutionid]
,[versionnumber]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[componentstate]
,[isinherited]
,[ismanaged]
,[businessunitid]
,[businessunitid_entitytype]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[parentroleid]
,[parentroleid_entitytype]
,[parentrootroleid]
,[parentrootroleid_entitytype]
,[roletemplateid]
,[roletemplateid_entitytype]
,[businessunitidname]
,[canbedeleted]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[importsequencenumber]
,[iscustomizable]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[name]
,[organizationid]
,[organizationidname]
,[overriddencreatedon]
,[overwritetime]
,[parentroleidname]
,[parentrootroleidname]
,[roleid]
,[roleidunique]
,[solutionid]
,[supportingsolutionid]
,[versionnumber]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/role/*.csv',FORMAT = 'CSV',
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
,[isinherited] [bigint]
,[ismanaged] [varchar](6)
,[businessunitid] [uniqueidentifier]
,[businessunitid_entitytype] [varchar](256)
,[createdby] [uniqueidentifier]
,[createdby_entitytype] [varchar](256)
,[createdonbehalfby] [uniqueidentifier]
,[createdonbehalfby_entitytype] [varchar](256)
,[modifiedby] [uniqueidentifier]
,[modifiedby_entitytype] [varchar](256)
,[modifiedonbehalfby] [uniqueidentifier]
,[modifiedonbehalfby_entitytype] [varchar](256)
,[parentroleid] [uniqueidentifier]
,[parentroleid_entitytype] [varchar](256)
,[parentrootroleid] [uniqueidentifier]
,[parentrootroleid_entitytype] [varchar](256)
,[roletemplateid] [uniqueidentifier]
,[roletemplateid_entitytype] [varchar](256)
,[businessunitidname] [varchar](640)
,[canbedeleted] [varchar](8000)
,[createdbyname] [varchar](640)
,[createdbyyominame] [varchar](640)
,[createdon] [datetimeoffset](7)
,[createdonbehalfbyname] [varchar](640)
,[createdonbehalfbyyominame] [varchar](640)
,[importsequencenumber] [bigint]
,[iscustomizable] [varchar](8000)
,[modifiedbyname] [varchar](640)
,[modifiedbyyominame] [varchar](640)
,[modifiedon] [datetime2](7)
,[modifiedonbehalfbyname] [varchar](640)
,[modifiedonbehalfbyyominame] [varchar](640)
,[name] [varchar](400)
,[organizationid] [uniqueidentifier]
,[organizationidname] [varchar](640)
,[overriddencreatedon] [datetime2](7)
,[overwritetime] [datetime2](7)
,[parentroleidname] [varchar](400)
,[parentrootroleidname] [varchar](400)
,[roleid] [uniqueidentifier]
,[roleidunique] [uniqueidentifier]
,[solutionid] [uniqueidentifier]
,[supportingsolutionid] [uniqueidentifier]
,[versionnumber] [bigint]
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record