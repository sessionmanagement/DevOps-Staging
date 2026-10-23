CREATE VIEW [Zavanti].[vw_zav_maintenancedetail]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_completionstatus]
,[zav_damagemaintenance]
,[zav_damagetype]
,[zav_pricestatus]
,[zav_pricing]
,[zav_taxtype]
,[zav_tenantconsentnew]
,[new_isexported]
,[new_issynchronizedtobc]
,[new_runningimporting]
,[zav_dummycaneditaftercompleted]
,[zav_isfromimporttool]
,[zav_nextexport]
,[zav_runningallpluginswithasyncmode]
,[zav_tenantconsent]
,[zav_tenantdamage]
,[zav_tenantscharged]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[new_assetregisterid]
,[new_assetregisterid_entitytype]
,[owningbusinessunit]
,[owningbusinessunit_entitytype]
,[owningteam]
,[owningteam_entitytype]
,[owninguser]
,[owninguser_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_informationcode]
,[zav_informationcode_entitytype]
,[zav_informationcodedetail]
,[zav_informationcodedetail_entitytype]
,[zav_location]
,[zav_location_entitytype]
,[zav_maintenancetaskid]
,[zav_maintenancetaskid_entitytype]
,[zav_maintenancetype]
,[zav_maintenancetype_entitytype]
,[zav_propertyassets]
,[zav_propertyassets_entitytype]
,[zav_replacingwhichpropertyasset]
,[zav_replacingwhichpropertyasset_entitytype]
,[zav_serviceagreement]
,[zav_serviceagreement_entitytype]
,[zav_sorworkcodes]
,[zav_sorworkcodes_entitytype]
,[zav_tenancy]
,[zav_tenancy_entitytype]
,[zav_unit]
,[zav_unit_entitytype]
,[zav_workitemtype]
,[zav_workitemtype_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_amount]
,[zav_amount_base]
,[zav_amounttoberecovered]
,[zav_amounttoberecovered_base]
,[zav_grossamount]
,[zav_grossamount_base]
,[zav_gst]
,[zav_gst_base]
,[zav_priceperunit]
,[zav_priceperunit_base]
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
,[new_assetregisteridname]
,[new_contractservicename]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_actualcompletiondate]
,[zav_chintaroid]
,[zav_comments]
,[zav_completioncomment]
,[zav_creditnotenumber]
,[zav_informationcodedetailname]
,[zav_informationcodename]
,[zav_invoicedate]
,[zav_invoicenumber]
,[zav_leasetypecode]
,[zav_leasetypename]
,[zav_linecontractcode]
,[zav_lineworkcategorycode]
,[zav_lineworkcategoryname]
,[zav_lineworktypecode]
,[zav_loc8workorderno]
,[zav_locationname]
,[zav_maintenancecode]
,[zav_maintenancedetailid]
,[zav_maintenancetaskidname]
,[zav_maintenancetypename]
,[zav_name]
,[zav_propertyassetsname]
,[zav_propertyid]
,[zav_quantity]
,[zav_replacingwhichpropertyassetname]
,[zav_serviceagreementname]
,[zav_sorcode]
,[zav_sorworkcodesname]
,[zav_tenancyname]
,[zav_tenantconsentdate]
,[zav_unitname]
,[zav_vendorno]
,[zav_workitemgroup]
,[zav_workitemtypename]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_completionstatus]
,[zav_damagemaintenance]
,[zav_damagetype]
,[zav_pricestatus]
,[zav_pricing]
,[zav_taxtype]
,[zav_tenantconsentnew]
,[new_isexported]
,[new_issynchronizedtobc]
,[new_runningimporting]
,[zav_dummycaneditaftercompleted]
,[zav_isfromimporttool]
,[zav_nextexport]
,[zav_runningallpluginswithasyncmode]
,[zav_tenantconsent]
,[zav_tenantdamage]
,[zav_tenantscharged]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[new_assetregisterid]
,[new_assetregisterid_entitytype]
,[owningbusinessunit]
,[owningbusinessunit_entitytype]
,[owningteam]
,[owningteam_entitytype]
,[owninguser]
,[owninguser_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_informationcode]
,[zav_informationcode_entitytype]
,[zav_informationcodedetail]
,[zav_informationcodedetail_entitytype]
,[zav_location]
,[zav_location_entitytype]
,[zav_maintenancetaskid]
,[zav_maintenancetaskid_entitytype]
,[zav_maintenancetype]
,[zav_maintenancetype_entitytype]
,[zav_propertyassets]
,[zav_propertyassets_entitytype]
,[zav_replacingwhichpropertyasset]
,[zav_replacingwhichpropertyasset_entitytype]
,[zav_serviceagreement]
,[zav_serviceagreement_entitytype]
,[zav_sorworkcodes]
,[zav_sorworkcodes_entitytype]
,[zav_tenancy]
,[zav_tenancy_entitytype]
,[zav_unit]
,[zav_unit_entitytype]
,[zav_workitemtype]
,[zav_workitemtype_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_amount]
,[zav_amount_base]
,[zav_amounttoberecovered]
,[zav_amounttoberecovered_base]
,[zav_grossamount]
,[zav_grossamount_base]
,[zav_gst]
,[zav_gst_base]
,[zav_priceperunit]
,[zav_priceperunit_base]
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
,[new_assetregisteridname]
,[new_contractservicename]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_actualcompletiondate]
,[zav_chintaroid]
,[zav_comments]
,[zav_completioncomment]
,[zav_creditnotenumber]
,[zav_informationcodedetailname]
,[zav_informationcodename]
,[zav_invoicedate]
,[zav_invoicenumber]
,[zav_leasetypecode]
,[zav_leasetypename]
,[zav_linecontractcode]
,[zav_lineworkcategorycode]
,[zav_lineworkcategoryname]
,[zav_lineworktypecode]
,[zav_loc8workorderno]
,[zav_locationname]
,[zav_maintenancecode]
,[zav_maintenancedetailid]
,[zav_maintenancetaskidname]
,[zav_maintenancetypename]
,[zav_name]
,[zav_propertyassetsname]
,[zav_propertyid]
,[zav_quantity]
,[zav_replacingwhichpropertyassetname]
,[zav_serviceagreementname]
,[zav_sorcode]
,[zav_sorworkcodesname]
,[zav_tenancyname]
,[zav_tenantconsentdate]
,[zav_unitname]
,[zav_vendorno]
,[zav_workitemgroup]
,[zav_workitemtypename]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_maintenancedetail/*.csv',FORMAT = 'CSV',
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
,[zav_completionstatus] [bigint]
,[zav_damagemaintenance] [bigint]
,[zav_damagetype] [bigint]
,[zav_pricestatus] [bigint]
,[zav_pricing] [bigint]
,[zav_taxtype] [bigint]
,[zav_tenantconsentnew] [bigint]
,[new_isexported] [varchar](6)
,[new_issynchronizedtobc] [varchar](6)
,[new_runningimporting] [varchar](6)
,[zav_dummycaneditaftercompleted] [varchar](6)
,[zav_isfromimporttool] [varchar](6)
,[zav_nextexport] [varchar](6)
,[zav_runningallpluginswithasyncmode] [varchar](6)
,[zav_tenantconsent] [varchar](6)
,[zav_tenantdamage] [varchar](6)
,[zav_tenantscharged] [varchar](6)
,[createdby] [uniqueidentifier]
,[createdby_entitytype] [varchar](256)
,[createdonbehalfby] [uniqueidentifier]
,[createdonbehalfby_entitytype] [varchar](256)
,[modifiedby] [uniqueidentifier]
,[modifiedby_entitytype] [varchar](256)
,[modifiedonbehalfby] [uniqueidentifier]
,[modifiedonbehalfby_entitytype] [varchar](256)
,[new_assetregisterid] [uniqueidentifier]
,[new_assetregisterid_entitytype] [varchar](256)
,[owningbusinessunit] [uniqueidentifier]
,[owningbusinessunit_entitytype] [varchar](256)
,[owningteam] [uniqueidentifier]
,[owningteam_entitytype] [varchar](256)
,[owninguser] [uniqueidentifier]
,[owninguser_entitytype] [varchar](256)
,[transactioncurrencyid] [uniqueidentifier]
,[transactioncurrencyid_entitytype] [varchar](256)
,[zav_informationcode] [uniqueidentifier]
,[zav_informationcode_entitytype] [varchar](256)
,[zav_informationcodedetail] [uniqueidentifier]
,[zav_informationcodedetail_entitytype] [varchar](256)
,[zav_location] [uniqueidentifier]
,[zav_location_entitytype] [varchar](256)
,[zav_maintenancetaskid] [uniqueidentifier]
,[zav_maintenancetaskid_entitytype] [varchar](256)
,[zav_maintenancetype] [uniqueidentifier]
,[zav_maintenancetype_entitytype] [varchar](256)
,[zav_propertyassets] [uniqueidentifier]
,[zav_propertyassets_entitytype] [varchar](256)
,[zav_replacingwhichpropertyasset] [uniqueidentifier]
,[zav_replacingwhichpropertyasset_entitytype] [varchar](256)
,[zav_serviceagreement] [uniqueidentifier]
,[zav_serviceagreement_entitytype] [varchar](256)
,[zav_sorworkcodes] [uniqueidentifier]
,[zav_sorworkcodes_entitytype] [varchar](256)
,[zav_tenancy] [uniqueidentifier]
,[zav_tenancy_entitytype] [varchar](256)
,[zav_unit] [uniqueidentifier]
,[zav_unit_entitytype] [varchar](256)
,[zav_workitemtype] [uniqueidentifier]
,[zav_workitemtype_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[zav_amount] [decimal](38,4)
,[zav_amount_base] [decimal](38,4)
,[zav_amounttoberecovered] [decimal](38,4)
,[zav_amounttoberecovered_base] [decimal](38,4)
,[zav_grossamount] [decimal](38,2)
,[zav_grossamount_base] [decimal](38,2)
,[zav_gst] [decimal](38,4)
,[zav_gst_base] [decimal](38,4)
,[zav_priceperunit] [decimal](38,4)
,[zav_priceperunit_base] [decimal](38,4)
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
,[new_assetregisteridname] [varchar](400)
,[new_contractservicename] [varchar](400)
,[overriddencreatedon] [datetime2](7)
,[owneridname] [varchar](640)
,[owneridtype] [varchar](8000)
,[owneridyominame] [varchar](640)
,[owningbusinessunitname] [varchar](640)
,[timezoneruleversionnumber] [bigint]
,[transactioncurrencyidname] [varchar](400)
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[zav_actualcompletiondate] [datetime2](7)
,[zav_chintaroid] [bigint]
,[zav_comments] [varchar](max)
,[zav_completioncomment] [varchar](max)
,[zav_creditnotenumber] [varchar](400)
,[zav_informationcodedetailname] [varchar](1200)
,[zav_informationcodename] [varchar](420)
,[zav_invoicedate] [datetime2](7)
,[zav_invoicenumber] [varchar](400)
,[zav_leasetypecode] [varchar](400)
,[zav_leasetypename] [varchar](400)
,[zav_linecontractcode] [varchar](400)
,[zav_lineworkcategorycode] [varchar](400)
,[zav_lineworkcategoryname] [varchar](400)
,[zav_lineworktypecode] [varchar](400)
,[zav_loc8workorderno] [varchar](400)
,[zav_locationname] [varchar](400)
,[zav_maintenancecode] [varchar](400)
,[zav_maintenancedetailid] [uniqueidentifier]
,[zav_maintenancetaskidname] [varchar](400)
,[zav_maintenancetypename] [varchar](400)
,[zav_name] [varchar](2000)
,[zav_propertyassetsname] [varchar](3200)
,[zav_propertyid] [varchar](400)
,[zav_quantity] [decimal](38,2)
,[zav_replacingwhichpropertyassetname] [varchar](3200)
,[zav_serviceagreementname] [varchar](400)
,[zav_sorcode] [varchar](400)
,[zav_sorworkcodesname] [varchar](400)
,[zav_tenancyname] [varchar](1200)
,[zav_tenantconsentdate] [datetime2](7)
,[zav_unitname] [varchar](400)
,[zav_vendorno] [varchar](400)
,[zav_workitemgroup] [varchar](400)
,[zav_workitemtypename] [varchar](400)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record