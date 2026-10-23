CREATE VIEW [Zavanti].[vw_zav_riskregister]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_riskregisterstatus]
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
,[zav_application]
,[zav_application_entitytype]
,[zav_contact]
,[zav_contact_entitytype]
,[zav_household]
,[zav_household_entitytype]
,[zav_householdmember]
,[zav_householdmember_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_riskcategory]
,[zav_riskcategory_entitytype]
,[zav_risksubcategory]
,[zav_risksubcategory_entitytype]
,[zav_tenancy]
,[zav_tenancy_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
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
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_applicationname]
,[zav_applicationyominame]
,[zav_chintaroid]
,[zav_comments]
,[zav_contactname]
,[zav_contactwithhazardouscustomers]
,[zav_contactyominame]
,[zav_dateriskregistered]
,[zav_householdmembername]
,[zav_householdname]
,[zav_name]
,[zav_nextriskreviewdate]
,[zav_propertyname]
,[zav_riskcategoryname]
,[zav_riskregisterid]
,[zav_risksubcategoryname]
,[zav_subcategorydescription]
,[zav_tenancyname]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_riskregisterstatus]
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
,[zav_application]
,[zav_application_entitytype]
,[zav_contact]
,[zav_contact_entitytype]
,[zav_household]
,[zav_household_entitytype]
,[zav_householdmember]
,[zav_householdmember_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_riskcategory]
,[zav_riskcategory_entitytype]
,[zav_risksubcategory]
,[zav_risksubcategory_entitytype]
,[zav_tenancy]
,[zav_tenancy_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
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
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_applicationname]
,[zav_applicationyominame]
,[zav_chintaroid]
,[zav_comments]
,[zav_contactname]
,[zav_contactwithhazardouscustomers]
,[zav_contactyominame]
,[zav_dateriskregistered]
,[zav_householdmembername]
,[zav_householdname]
,[zav_name]
,[zav_nextriskreviewdate]
,[zav_propertyname]
,[zav_riskcategoryname]
,[zav_riskregisterid]
,[zav_risksubcategoryname]
,[zav_subcategorydescription]
,[zav_tenancyname]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_riskregister/*.csv',FORMAT = 'CSV',
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
,[zav_riskregisterstatus] [bigint]
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
,[zav_application] [uniqueidentifier]
,[zav_application_entitytype] [varchar](256)
,[zav_contact] [uniqueidentifier]
,[zav_contact_entitytype] [varchar](256)
,[zav_household] [uniqueidentifier]
,[zav_household_entitytype] [varchar](256)
,[zav_householdmember] [uniqueidentifier]
,[zav_householdmember_entitytype] [varchar](256)
,[zav_property] [uniqueidentifier]
,[zav_property_entitytype] [varchar](256)
,[zav_riskcategory] [uniqueidentifier]
,[zav_riskcategory_entitytype] [varchar](256)
,[zav_risksubcategory] [uniqueidentifier]
,[zav_risksubcategory_entitytype] [varchar](256)
,[zav_tenancy] [uniqueidentifier]
,[zav_tenancy_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[createdbyname] [varchar](1026)
,[createdbyyominame] [varchar](1026)
,[createdon] [datetimeoffset](7)
,[createdonbehalfbyname] [varchar](1026)
,[createdonbehalfbyyominame] [varchar](1026)
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
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[zav_applicationname] [varchar](640)
,[zav_applicationyominame] [varchar](1800)
,[zav_chintaroid] [varchar](400)
,[zav_comments] [varchar](max)
,[zav_contactname] [varchar](640)
,[zav_contactwithhazardouscustomers] [varchar](8000)
,[zav_contactyominame] [varchar](1800)
,[zav_dateriskregistered] [datetime2](7)
,[zav_householdmembername] [varchar](400)
,[zav_householdname] [varchar](400)
,[zav_name] [varchar](2000)
,[zav_nextriskreviewdate] [datetime2](7)
,[zav_propertyname] [varchar](400)
,[zav_riskcategoryname] [varchar](196)
,[zav_riskregisterid] [uniqueidentifier]
,[zav_risksubcategoryname] [varchar](368)
,[zav_subcategorydescription] [varchar](2000)
,[zav_tenancyname] [varchar](1200)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record