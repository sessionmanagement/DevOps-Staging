CREATE VIEW [Zavanti].[vw_team]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[membershiptype]
,[msft_datastate]
,[teamtype]
,[isdefault]
,[issastokenset]
,[systemmanaged]
,[administratorid]
,[administratorid_entitytype]
,[businessunitid]
,[businessunitid_entitytype]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[delegatedauthorizationid]
,[delegatedauthorizationid_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[queueid]
,[queueid_entitytype]
,[regardingobjectid]
,[regardingobjectid_entitytype]
,[teamtemplateid]
,[teamtemplateid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[administratoridname]
,[administratoridyominame]
,[azureactivedirectoryobjectid]
,[businessunitidname]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[delegatedauthorizationidname]
,[description]
,[emailaddress]
,[exchangerate]
,[importsequencenumber]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[name]
,[organizationid]
,[organizationidname]
,[overriddencreatedon]
,[processid]
,[queueidname]
,[regardingobjecttypecode]
,[sastoken]
,[sharelinkqualifier]
,[stageid]
,[teamid]
,[transactioncurrencyidname]
,[traversedpath]
,[versionnumber]
,[yominame]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[membershiptype]
,[msft_datastate]
,[teamtype]
,[isdefault]
,[issastokenset]
,[systemmanaged]
,[administratorid]
,[administratorid_entitytype]
,[businessunitid]
,[businessunitid_entitytype]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[delegatedauthorizationid]
,[delegatedauthorizationid_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[queueid]
,[queueid_entitytype]
,[regardingobjectid]
,[regardingobjectid_entitytype]
,[teamtemplateid]
,[teamtemplateid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[administratoridname]
,[administratoridyominame]
,[azureactivedirectoryobjectid]
,[businessunitidname]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[delegatedauthorizationidname]
,[description]
,[emailaddress]
,[exchangerate]
,[importsequencenumber]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[name]
,[organizationid]
,[organizationidname]
,[overriddencreatedon]
,[processid]
,[queueidname]
,[regardingobjecttypecode]
,[sastoken]
,[sharelinkqualifier]
,[stageid]
,[teamid]
,[transactioncurrencyidname]
,[traversedpath]
,[versionnumber]
,[yominame]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/team/*.csv',FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
) 
WITH
(
[Id] [uniqueidentifier]
,[SinkCreatedOn] [datetime2](7)
,[SinkModifiedOn] [datetime2](7)
,[membershiptype] [bigint]
,[msft_datastate] [bigint]
,[teamtype] [bigint]
,[isdefault] [varchar](6)
,[issastokenset] [varchar](6)
,[systemmanaged] [varchar](6)
,[administratorid] [uniqueidentifier]
,[administratorid_entitytype] [varchar](256)
,[businessunitid] [uniqueidentifier]
,[businessunitid_entitytype] [varchar](256)
,[createdby] [uniqueidentifier]
,[createdby_entitytype] [varchar](256)
,[createdonbehalfby] [uniqueidentifier]
,[createdonbehalfby_entitytype] [varchar](256)
,[delegatedauthorizationid] [uniqueidentifier]
,[delegatedauthorizationid_entitytype] [varchar](256)
,[modifiedby] [uniqueidentifier]
,[modifiedby_entitytype] [varchar](256)
,[modifiedonbehalfby] [uniqueidentifier]
,[modifiedonbehalfby_entitytype] [varchar](256)
,[queueid] [uniqueidentifier]
,[queueid_entitytype] [varchar](256)
,[regardingobjectid] [uniqueidentifier]
,[regardingobjectid_entitytype] [varchar](256)
,[teamtemplateid] [uniqueidentifier]
,[teamtemplateid_entitytype] [varchar](256)
,[transactioncurrencyid] [uniqueidentifier]
,[transactioncurrencyid_entitytype] [varchar](256)
,[administratoridname] [varchar](640)
,[administratoridyominame] [varchar](640)
,[azureactivedirectoryobjectid] [uniqueidentifier]
,[businessunitidname] [varchar](640)
,[createdbyname] [varchar](640)
,[createdbyyominame] [varchar](640)
,[createdon] [datetimeoffset](7)
,[createdonbehalfbyname] [varchar](640)
,[createdonbehalfbyyominame] [varchar](640)
,[delegatedauthorizationidname] [varchar](400)
,[description] [varchar](max)
,[emailaddress] [varchar](400)
,[exchangerate] [decimal](38,12)
,[importsequencenumber] [bigint]
,[modifiedbyname] [varchar](640)
,[modifiedbyyominame] [varchar](640)
,[modifiedon] [datetime2](7)
,[modifiedonbehalfbyname] [varchar](640)
,[modifiedonbehalfbyyominame] [varchar](640)
,[name] [varchar](640)
,[organizationid] [uniqueidentifier]
,[organizationidname] [varchar](640)
,[overriddencreatedon] [datetime2](7)
,[processid] [uniqueidentifier]
,[queueidname] [varchar](800)
,[regardingobjecttypecode] [varchar](8000)
,[sastoken] [varchar](200)
,[sharelinkqualifier] [varchar](5000)
,[stageid] [uniqueidentifier]
,[teamid] [uniqueidentifier]
,[transactioncurrencyidname] [varchar](400)
,[traversedpath] [varchar](5000)
,[versionnumber] [bigint]
,[yominame] [varchar](640)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record