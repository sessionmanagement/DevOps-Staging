CREATE VIEW [Zavanti].[vw_zav_propertyassets]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_yearofexpiry]
,[zav_yearofmanufacture]
,[zav_compliancecertificate]
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
,[zav_assetmodel]
,[zav_assetmodel_entitytype]
,[zav_assets]
,[zav_assets_entitytype]
,[zav_assettype]
,[zav_assettype_entitytype]
,[zav_location]
,[zav_location_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_reportcode]
,[zav_reportcode_entitytype]
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
,[zav_assetmodelname]
,[zav_assetsname]
,[zav_assettypename]
,[zav_assettypeuserdefined]
,[zav_batchno]
,[zav_compliancecertificateissueddate]
,[zav_datelastchecked]
,[zav_fixtureseq]
,[zav_installationdate]
,[zav_locationname]
,[zav_name]
,[zav_nextmaintenancedate]
,[zav_propertyassetsid]
,[zav_propertyname]
,[zav_reportcodename]
,[zav_serialno]
,[zav_termnumberofmonths]
,[zav_warrantyexpirydate]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_yearofexpiry]
,[zav_yearofmanufacture]
,[zav_compliancecertificate]
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
,[zav_assetmodel]
,[zav_assetmodel_entitytype]
,[zav_assets]
,[zav_assets_entitytype]
,[zav_assettype]
,[zav_assettype_entitytype]
,[zav_location]
,[zav_location_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_reportcode]
,[zav_reportcode_entitytype]
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
,[zav_assetmodelname]
,[zav_assetsname]
,[zav_assettypename]
,[zav_assettypeuserdefined]
,[zav_batchno]
,[zav_compliancecertificateissueddate]
,[zav_datelastchecked]
,[zav_fixtureseq]
,[zav_installationdate]
,[zav_locationname]
,[zav_name]
,[zav_nextmaintenancedate]
,[zav_propertyassetsid]
,[zav_propertyname]
,[zav_reportcodename]
,[zav_serialno]
,[zav_termnumberofmonths]
,[zav_warrantyexpirydate]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_propertyassets/*.csv',FORMAT = 'CSV',
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
,[zav_yearofexpiry] [bigint]
,[zav_yearofmanufacture] [bigint]
,[zav_compliancecertificate] [varchar](6)
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
,[zav_assetmodel] [uniqueidentifier]
,[zav_assetmodel_entitytype] [varchar](256)
,[zav_assets] [uniqueidentifier]
,[zav_assets_entitytype] [varchar](256)
,[zav_assettype] [uniqueidentifier]
,[zav_assettype_entitytype] [varchar](256)
,[zav_location] [uniqueidentifier]
,[zav_location_entitytype] [varchar](256)
,[zav_property] [uniqueidentifier]
,[zav_property_entitytype] [varchar](256)
,[zav_reportcode] [uniqueidentifier]
,[zav_reportcode_entitytype] [varchar](256)
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
,[zav_assetmodelname] [varchar](400)
,[zav_assetsname] [varchar](400)
,[zav_assettypename] [varchar](400)
,[zav_assettypeuserdefined] [varchar](400)
,[zav_batchno] [varchar](400)
,[zav_compliancecertificateissueddate] [datetime2](7)
,[zav_datelastchecked] [datetime2](7)
,[zav_fixtureseq] [bigint]
,[zav_installationdate] [datetime2](7)
,[zav_locationname] [varchar](400)
,[zav_name] [varchar](3200)
,[zav_nextmaintenancedate] [datetime2](7)
,[zav_propertyassetsid] [uniqueidentifier]
,[zav_propertyname] [varchar](400)
,[zav_reportcodename] [varchar](400)
,[zav_serialno] [varchar](400)
,[zav_termnumberofmonths] [bigint]
,[zav_warrantyexpirydate] [datetime2](7)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record