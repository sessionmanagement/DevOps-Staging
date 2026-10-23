CREATE VIEW [Zavanti].[vw_zav_house]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_gender]
,[zav_incomesource]
,[new_ismainapplicant]
,[zav_headofthehousehold]
,[zav_isimportfromchintaro]
,[zav_isrevision]
,[zav_nocheckamendent]
,[zav_signatoryflag]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[new_relationship_new]
,[new_relationship_new_entitytype]
,[owningbusinessunit]
,[owningbusinessunit_entitytype]
,[owningteam]
,[owningteam_entitytype]
,[owninguser]
,[owninguser_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_fullname]
,[zav_fullname_entitytype]
,[zav_householdid]
,[zav_householdid_entitytype]
,[zav_relationship]
,[zav_relationship_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_householdmemberincome]
,[zav_householdmemberincome_base]
,[zav_rentshare]
,[zav_rentshare_base]
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
,[new_relationship_newname]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_age]
,[zav_comments]
,[zav_dateofbirth]
,[zav_enddate]
,[zav_firstname]
,[zav_fullnamename]
,[zav_fullnameyominame]
,[zav_householdidname]
,[zav_householdreferenceno]
,[zav_houseid]
,[zav_ifother]
,[zav_lastname]
,[zav_medical]
,[zav_name]
,[zav_relationshipname]
,[zav_riskcategory]
,[zav_specialcautions]
,[zav_startdate]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_gender]
,[zav_incomesource]
,[new_ismainapplicant]
,[zav_headofthehousehold]
,[zav_isimportfromchintaro]
,[zav_isrevision]
,[zav_nocheckamendent]
,[zav_signatoryflag]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[new_relationship_new]
,[new_relationship_new_entitytype]
,[owningbusinessunit]
,[owningbusinessunit_entitytype]
,[owningteam]
,[owningteam_entitytype]
,[owninguser]
,[owninguser_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_fullname]
,[zav_fullname_entitytype]
,[zav_householdid]
,[zav_householdid_entitytype]
,[zav_relationship]
,[zav_relationship_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_householdmemberincome]
,[zav_householdmemberincome_base]
,[zav_rentshare]
,[zav_rentshare_base]
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
,[new_relationship_newname]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_age]
,[zav_comments]
,[zav_dateofbirth]
,[zav_enddate]
,[zav_firstname]
,[zav_fullnamename]
,[zav_fullnameyominame]
,[zav_householdidname]
,[zav_householdreferenceno]
,[zav_houseid]
,[zav_ifother]
,[zav_lastname]
,[zav_medical]
,[zav_name]
,[zav_relationshipname]
,[zav_riskcategory]
,[zav_specialcautions]
,[zav_startdate]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_house/*.csv',FORMAT = 'CSV',
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
,[zav_gender] [bigint]
,[zav_incomesource] [bigint]
,[new_ismainapplicant] [varchar](6)
,[zav_headofthehousehold] [varchar](6)
,[zav_isimportfromchintaro] [varchar](6)
,[zav_isrevision] [varchar](6)
,[zav_nocheckamendent] [varchar](6)
,[zav_signatoryflag] [varchar](6)
,[createdby] [uniqueidentifier]
,[createdby_entitytype] [varchar](256)
,[createdonbehalfby] [uniqueidentifier]
,[createdonbehalfby_entitytype] [varchar](256)
,[modifiedby] [uniqueidentifier]
,[modifiedby_entitytype] [varchar](256)
,[modifiedonbehalfby] [uniqueidentifier]
,[modifiedonbehalfby_entitytype] [varchar](256)
,[new_relationship_new] [uniqueidentifier]
,[new_relationship_new_entitytype] [varchar](256)
,[owningbusinessunit] [uniqueidentifier]
,[owningbusinessunit_entitytype] [varchar](256)
,[owningteam] [uniqueidentifier]
,[owningteam_entitytype] [varchar](256)
,[owninguser] [uniqueidentifier]
,[owninguser_entitytype] [varchar](256)
,[transactioncurrencyid] [uniqueidentifier]
,[transactioncurrencyid_entitytype] [varchar](256)
,[zav_fullname] [uniqueidentifier]
,[zav_fullname_entitytype] [varchar](256)
,[zav_householdid] [uniqueidentifier]
,[zav_householdid_entitytype] [varchar](256)
,[zav_relationship] [uniqueidentifier]
,[zav_relationship_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[zav_householdmemberincome] [decimal](38,4)
,[zav_householdmemberincome_base] [decimal](38,4)
,[zav_rentshare] [decimal](38,0)
,[zav_rentshare_base] [decimal](38,0)
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
,[new_relationship_newname] [varchar](400)
,[overriddencreatedon] [datetime2](7)
,[owneridname] [varchar](640)
,[owneridtype] [varchar](8000)
,[owneridyominame] [varchar](640)
,[owningbusinessunitname] [varchar](640)
,[timezoneruleversionnumber] [bigint]
,[transactioncurrencyidname] [varchar](400)
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[zav_age] [bigint]
,[zav_comments] [varchar](max)
,[zav_dateofbirth] [datetime2](7)
,[zav_enddate] [datetime2](7)
,[zav_firstname] [varchar](400)
,[zav_fullnamename] [varchar](640)
,[zav_fullnameyominame] [varchar](1800)
,[zav_householdidname] [varchar](400)
,[zav_householdreferenceno] [varchar](400)
,[zav_houseid] [uniqueidentifier]
,[zav_ifother] [varchar](max)
,[zav_lastname] [varchar](400)
,[zav_medical] [varchar](400)
,[zav_name] [varchar](400)
,[zav_relationshipname] [varchar](400)
,[zav_riskcategory] [varchar](800)
,[zav_specialcautions] [varchar](400)
,[zav_startdate] [datetime2](7)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record