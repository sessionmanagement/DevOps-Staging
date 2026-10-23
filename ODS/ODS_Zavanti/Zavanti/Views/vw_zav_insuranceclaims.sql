CREATE VIEW [Zavanti].[vw_zav_insuranceclaims]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[owningbusinessunit]
,[owningbusinessunit_entitytype]
,[owningteam]
,[owningteam_entitytype]
,[owninguser]
,[owninguser_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_insuranceclaimsid1]
,[zav_insuranceclaimsid1_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_amountofclaim]
,[zav_amountofclaim_base]
,[zav_settlementamount]
,[zav_settlementamount_base]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[exchangerate]
,[importsequencenumber]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_claimdetails]
,[zav_datelogged]
,[zav_dateresolved]
,[zav_insuranceclaimsid]
,[zav_insuranceclaimsid1name]
,[zav_name]
,[zav_propertyname]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[owningbusinessunit]
,[owningbusinessunit_entitytype]
,[owningteam]
,[owningteam_entitytype]
,[owninguser]
,[owninguser_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_insuranceclaimsid1]
,[zav_insuranceclaimsid1_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_amountofclaim]
,[zav_amountofclaim_base]
,[zav_settlementamount]
,[zav_settlementamount_base]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[exchangerate]
,[importsequencenumber]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_claimdetails]
,[zav_datelogged]
,[zav_dateresolved]
,[zav_insuranceclaimsid]
,[zav_insuranceclaimsid1name]
,[zav_name]
,[zav_propertyname]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_insuranceclaims/*.csv',FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
) 
WITH
(
[Id] [uniqueidentifier]
,[SinkCreatedOn] [datetime2](7)
,[SinkModifiedOn] [datetime2](7)
,[statecode] [bigint]
,[statuscode] [bigint]
,[createdby] [uniqueidentifier]
,[createdby_entitytype] [varchar](256)
,[createdonbehalfby] [uniqueidentifier]
,[createdonbehalfby_entitytype] [varchar](256)
,[modifiedby] [uniqueidentifier]
,[modifiedby_entitytype] [varchar](256)
,[modifiedonbehalfby] [uniqueidentifier]
,[modifiedonbehalfby_entitytype] [varchar](256)
,[owningbusinessunit] [uniqueidentifier]
,[owningbusinessunit_entitytype] [varchar](256)
,[owningteam] [uniqueidentifier]
,[owningteam_entitytype] [varchar](256)
,[owninguser] [uniqueidentifier]
,[owninguser_entitytype] [varchar](256)
,[transactioncurrencyid] [uniqueidentifier]
,[transactioncurrencyid_entitytype] [varchar](256)
,[zav_insuranceclaimsid1] [uniqueidentifier]
,[zav_insuranceclaimsid1_entitytype] [varchar](256)
,[zav_property] [uniqueidentifier]
,[zav_property_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[zav_amountofclaim] [decimal](38,2)
,[zav_amountofclaim_base] [decimal](38,2)
,[zav_settlementamount] [decimal](38,2)
,[zav_settlementamount_base] [decimal](38,2)
,[createdbyname] [varchar](1026)
,[createdbyyominame] [varchar](1026)
,[createdon] [datetimeoffset](7)
,[createdonbehalfbyname] [varchar](1026)
,[createdonbehalfbyyominame] [varchar](1026)
,[exchangerate] [decimal](38,10)
,[importsequencenumber] [bigint]
,[modifiedbyname] [varchar](1026)
,[modifiedbyyominame] [varchar](1026)
,[modifiedon] [datetime2](7)
,[modifiedonbehalfbyname] [varchar](1026)
,[modifiedonbehalfbyyominame] [varchar](1026)
,[overriddencreatedon] [datetime2](7)
,[owneridname] [varchar](640)
,[owneridtype] [varchar](8000)
,[owneridyominame] [varchar](640)
,[owningbusinessunitname] [varchar](640)
,[timezoneruleversionnumber] [bigint]
,[transactioncurrencyidname] [varchar](400)
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[zav_claimdetails] [varchar](max)
,[zav_datelogged] [datetime2](7)
,[zav_dateresolved] [datetime2](7)
,[zav_insuranceclaimsid] [uniqueidentifier]
,[zav_insuranceclaimsid1name] [varchar](400)
,[zav_name] [varchar](400)
,[zav_propertyname] [varchar](400)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record