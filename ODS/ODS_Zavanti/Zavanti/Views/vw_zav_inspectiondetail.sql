CREATE VIEW [Zavanti].[vw_zav_inspectiondetail]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_1verygood]
,[zav_2good]
,[zav_3moderate]
,[zav_4poor]
,[zav_5verypoor]
,[zav_assetcondition]
,[zav_clean]
,[zav_maintflag]
,[zav_undamaged]
,[zav_working]
,[zav_worktaskraised]
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
,[zav_area]
,[zav_area_entitytype]
,[zav_assets]
,[zav_assets_entitytype]
,[zav_icode]
,[zav_icode_entitytype]
,[zav_inspectionid]
,[zav_inspectionid_entitytype]
,[zav_maintenancetask]
,[zav_maintenancetask_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_propertyassets]
,[zav_propertyassets_entitytype]
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
,[zav_areaname]
,[zav_areaseq]
,[zav_assetsname]
,[zav_comments]
,[zav_conditiongrade]
,[zav_fixtureseq]
,[zav_generalcomments]
,[zav_icodename]
,[zav_inspectiondetailid]
,[zav_inspectionidname]
,[zav_maintenancetaskname]
,[zav_name]
,[zav_propertyassetsname]
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
,[zav_1verygood]
,[zav_2good]
,[zav_3moderate]
,[zav_4poor]
,[zav_5verypoor]
,[zav_assetcondition]
,[zav_clean]
,[zav_maintflag]
,[zav_undamaged]
,[zav_working]
,[zav_worktaskraised]
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
,[zav_area]
,[zav_area_entitytype]
,[zav_assets]
,[zav_assets_entitytype]
,[zav_icode]
,[zav_icode_entitytype]
,[zav_inspectionid]
,[zav_inspectionid_entitytype]
,[zav_maintenancetask]
,[zav_maintenancetask_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_propertyassets]
,[zav_propertyassets_entitytype]
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
,[zav_areaname]
,[zav_areaseq]
,[zav_assetsname]
,[zav_comments]
,[zav_conditiongrade]
,[zav_fixtureseq]
,[zav_generalcomments]
,[zav_icodename]
,[zav_inspectiondetailid]
,[zav_inspectionidname]
,[zav_maintenancetaskname]
,[zav_name]
,[zav_propertyassetsname]
,[zav_propertyname]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_inspectiondetail/*.csv',FORMAT = 'CSV',
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
,[zav_1verygood] [bigint]
,[zav_2good] [bigint]
,[zav_3moderate] [bigint]
,[zav_4poor] [bigint]
,[zav_5verypoor] [bigint]
,[zav_assetcondition] [bigint]
,[zav_clean] [bigint]
,[zav_maintflag] [bigint]
,[zav_undamaged] [bigint]
,[zav_working] [bigint]
,[zav_worktaskraised] [varchar](6)
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
,[zav_area] [uniqueidentifier]
,[zav_area_entitytype] [varchar](256)
,[zav_assets] [uniqueidentifier]
,[zav_assets_entitytype] [varchar](256)
,[zav_icode] [uniqueidentifier]
,[zav_icode_entitytype] [varchar](256)
,[zav_inspectionid] [uniqueidentifier]
,[zav_inspectionid_entitytype] [varchar](256)
,[zav_maintenancetask] [uniqueidentifier]
,[zav_maintenancetask_entitytype] [varchar](256)
,[zav_property] [uniqueidentifier]
,[zav_property_entitytype] [varchar](256)
,[zav_propertyassets] [uniqueidentifier]
,[zav_propertyassets_entitytype] [varchar](256)
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
,[zav_areaname] [varchar](400)
,[zav_areaseq] [bigint]
,[zav_assetsname] [varchar](400)
,[zav_comments] [varchar](max)
,[zav_conditiongrade] [varchar](max)
,[zav_fixtureseq] [bigint]
,[zav_generalcomments] [varchar](max)
,[zav_icodename] [varchar](420)
,[zav_inspectiondetailid] [uniqueidentifier]
,[zav_inspectionidname] [varchar](800)
,[zav_maintenancetaskname] [varchar](400)
,[zav_name] [varchar](400)
,[zav_propertyassetsname] [varchar](3200)
,[zav_propertyname] [varchar](400)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record