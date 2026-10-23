CREATE VIEW [Zavanti].[vw_zav_postalcity]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_state]
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
,[zav_lga]
,[zav_lga_entitytype]
,[zav_mailtown]
,[zav_mailtown_entitytype]
,[zav_region]
,[zav_region_entitytype]
,[zav_territory]
,[zav_territory_entitytype]
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
,[zav_chintaroid]
,[zav_island]
,[zav_lganame]
,[zav_mailtownname]
,[zav_name]
,[zav_postalcityid]
,[zav_postcode]
,[zav_regionname]
,[zav_suburb]
,[zav_territoryname]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_state]
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
,[zav_lga]
,[zav_lga_entitytype]
,[zav_mailtown]
,[zav_mailtown_entitytype]
,[zav_region]
,[zav_region_entitytype]
,[zav_territory]
,[zav_territory_entitytype]
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
,[zav_chintaroid]
,[zav_island]
,[zav_lganame]
,[zav_mailtownname]
,[zav_name]
,[zav_postalcityid]
,[zav_postcode]
,[zav_regionname]
,[zav_suburb]
,[zav_territoryname]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_postalcity/*.csv',FORMAT = 'CSV',
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
,[zav_state] [bigint]
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
,[zav_lga] [uniqueidentifier]
,[zav_lga_entitytype] [varchar](256)
,[zav_mailtown] [uniqueidentifier]
,[zav_mailtown_entitytype] [varchar](256)
,[zav_region] [uniqueidentifier]
,[zav_region_entitytype] [varchar](256)
,[zav_territory] [uniqueidentifier]
,[zav_territory_entitytype] [varchar](256)
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
,[zav_chintaroid] [varchar](400)
,[zav_island] [varchar](400)
,[zav_lganame] [varchar](400)
,[zav_mailtownname] [varchar](400)
,[zav_name] [varchar](400)
,[zav_postalcityid] [uniqueidentifier]
,[zav_postcode] [varchar](16)
,[zav_regionname] [varchar](400)
,[zav_suburb] [varchar](800)
,[zav_territoryname] [varchar](800)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record