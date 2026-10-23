CREATE VIEW [Zavanti].[vw_zav_voidchecklist]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_voidcheckliststatus]
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
,[zav_clonedfromid]
,[zav_clonedfromid_entitytype]
,[zav_offeredproperty]
,[zav_offeredproperty_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_vacatedtenancy]
,[zav_vacatedtenancy_entitytype]
,[zav_voidcategory]
,[zav_voidcategory_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[crba8_comments]
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
,[zav_allcomplianceissuescompleted]
,[zav_assessmentcompletedandscopeofworksunderst]
,[zav_assessmentscoping]
,[zav_bondrecoveryformscompleted]
,[zav_bosmsdapprovedproperty]
,[zav_bosupdatedvacancylisted]
,[zav_bosupdatedvacatedate]
,[zav_carparkingprovisioned]
,[zav_clonedfromidname]
,[zav_confirmtenancyhasbeenacceptedinbos]
,[zav_damageassessment]
,[zav_datebondformsignedgiventoagentowner]
,[zav_dateendofholdforpropertyredevelopment]
,[zav_datefinancenotifiedleasepropertyhandedbac]
,[zav_datefirstoffermade]
,[zav_datehudnotifiedoftenancytribunalapplicati]
,[zav_datekeyreceivedfromtenant]
,[zav_datekeysreturnedfromcontractor]
,[zav_datekeysreturnedfromspecialistcontractor]
,[zav_datekeyssenttospecialistcontractor]
,[zav_datekeyssurrenderedtoagentowner]
,[zav_datekeystocontractor]
,[zav_datekeystolossadjusterinsurance]
,[zav_datekeystopropertyteam]
,[zav_datekeystotenancyteamtoallocate]
,[zav_datemsdnotifiedofpendingtermination]
,[zav_datenoticereceived]
,[zav_dateofferconfirmedaccepted]
,[zav_dateoffinalinspectionafterkeysreceived]
,[zav_dateofhandover]
,[zav_datepossessiongranted]
,[zav_datepostworkinspectioncompleted]
,[zav_dateprevacateinspection]
,[zav_datesecondoffermade]
,[zav_datetamgainaccessabandonedproperty]
,[zav_datetenancyterminated]
,[zav_dateworkscopecompleted]
,[zav_deepclean]
,[zav_defectslistcompleted]
,[zav_defectsremediatedbyowner]
,[zav_exitfinalinspectionphotographs]
,[zav_expectedreadytoletdate]
,[zav_finalcleancomplete]
,[zav_financeadvisedofpaymentcycleamountandbond]
,[zav_fulllegalcomplianceachieved]
,[zav_fullphotographsetcreated]
,[zav_furnitureandequipmentprovided]
,[zav_handbacktotenancyteam]
,[zav_handoverinspectionwithowner]
,[zav_healthyhomesdatareceivedandstatementcanbe]
,[zav_healthyhomesdataupdated]
,[zav_icpnumbersrecorded]
,[zav_initialsnaggingworkscompleted]
,[zav_insuranceconfirmedanddetailsupdated]
,[zav_insurancedetailsconfirmedandentered]
,[zav_insurancenotified]
,[zav_itprovisioningdataandcamerasifapplicable]
,[zav_keysrecovered]
,[zav_keysreturnedtoowner]
,[zav_locationsloaded]
,[zav_madesafeandsecure]
,[zav_methamphetminechecksteppingtoprocess]
,[zav_methanphetamineclearance]
,[zav_name]
,[zav_occupancyagreementsprepared]
,[zav_offeredpropertyname]
,[zav_ongoingdefectslistcreated]
,[zav_pcrcompleted]
,[zav_propertydeactivatedinsystem]
,[zav_propertyfilecreatedandloaded]
,[zav_propertyname]
,[zav_propertytoberedeveloped]
,[zav_propertyunitssubmittedtobosapproved]
,[zav_refurbishmentcompleted]
,[zav_repairscompleted]
,[zav_residentialtenancyagreementprepared]
,[zav_rubbishandequipmentremoved]
,[zav_safetycheck]
,[zav_safetycheckcompleted]
,[zav_servicenamehasbeenenteredatproperty]
,[zav_shortlistcreated]
,[zav_signedleaseoragreementreceived]
,[zav_subprogramprogramenteredatproperty]
,[zav_targetcompletiondatevacant]
,[zav_targetcompletiondatevoid]
,[zav_tenancyresolvedandexited]
,[zav_tenantimprovementsscopedandagreed]
,[zav_upcomingmaintenancejobsbooked]
,[zav_utilitiesconnectionsrecordedandsetupifapp]
,[zav_utilitiesdisconnected]
,[zav_vacatedtenancyname]
,[zav_voidcategoryname]
,[zav_voidchecklistid]
,[zav_voidcompleteddate]
,[zav_watermeterreadingsandnumbers]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_voidcheckliststatus]
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
,[zav_clonedfromid]
,[zav_clonedfromid_entitytype]
,[zav_offeredproperty]
,[zav_offeredproperty_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_vacatedtenancy]
,[zav_vacatedtenancy_entitytype]
,[zav_voidcategory]
,[zav_voidcategory_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[crba8_comments]
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
,[zav_allcomplianceissuescompleted]
,[zav_assessmentcompletedandscopeofworksunderst]
,[zav_assessmentscoping]
,[zav_bondrecoveryformscompleted]
,[zav_bosmsdapprovedproperty]
,[zav_bosupdatedvacancylisted]
,[zav_bosupdatedvacatedate]
,[zav_carparkingprovisioned]
,[zav_clonedfromidname]
,[zav_confirmtenancyhasbeenacceptedinbos]
,[zav_damageassessment]
,[zav_datebondformsignedgiventoagentowner]
,[zav_dateendofholdforpropertyredevelopment]
,[zav_datefinancenotifiedleasepropertyhandedbac]
,[zav_datefirstoffermade]
,[zav_datehudnotifiedoftenancytribunalapplicati]
,[zav_datekeyreceivedfromtenant]
,[zav_datekeysreturnedfromcontractor]
,[zav_datekeysreturnedfromspecialistcontractor]
,[zav_datekeyssenttospecialistcontractor]
,[zav_datekeyssurrenderedtoagentowner]
,[zav_datekeystocontractor]
,[zav_datekeystolossadjusterinsurance]
,[zav_datekeystopropertyteam]
,[zav_datekeystotenancyteamtoallocate]
,[zav_datemsdnotifiedofpendingtermination]
,[zav_datenoticereceived]
,[zav_dateofferconfirmedaccepted]
,[zav_dateoffinalinspectionafterkeysreceived]
,[zav_dateofhandover]
,[zav_datepossessiongranted]
,[zav_datepostworkinspectioncompleted]
,[zav_dateprevacateinspection]
,[zav_datesecondoffermade]
,[zav_datetamgainaccessabandonedproperty]
,[zav_datetenancyterminated]
,[zav_dateworkscopecompleted]
,[zav_deepclean]
,[zav_defectslistcompleted]
,[zav_defectsremediatedbyowner]
,[zav_exitfinalinspectionphotographs]
,[zav_expectedreadytoletdate]
,[zav_finalcleancomplete]
,[zav_financeadvisedofpaymentcycleamountandbond]
,[zav_fulllegalcomplianceachieved]
,[zav_fullphotographsetcreated]
,[zav_furnitureandequipmentprovided]
,[zav_handbacktotenancyteam]
,[zav_handoverinspectionwithowner]
,[zav_healthyhomesdatareceivedandstatementcanbe]
,[zav_healthyhomesdataupdated]
,[zav_icpnumbersrecorded]
,[zav_initialsnaggingworkscompleted]
,[zav_insuranceconfirmedanddetailsupdated]
,[zav_insurancedetailsconfirmedandentered]
,[zav_insurancenotified]
,[zav_itprovisioningdataandcamerasifapplicable]
,[zav_keysrecovered]
,[zav_keysreturnedtoowner]
,[zav_locationsloaded]
,[zav_madesafeandsecure]
,[zav_methamphetminechecksteppingtoprocess]
,[zav_methanphetamineclearance]
,[zav_name]
,[zav_occupancyagreementsprepared]
,[zav_offeredpropertyname]
,[zav_ongoingdefectslistcreated]
,[zav_pcrcompleted]
,[zav_propertydeactivatedinsystem]
,[zav_propertyfilecreatedandloaded]
,[zav_propertyname]
,[zav_propertytoberedeveloped]
,[zav_propertyunitssubmittedtobosapproved]
,[zav_refurbishmentcompleted]
,[zav_repairscompleted]
,[zav_residentialtenancyagreementprepared]
,[zav_rubbishandequipmentremoved]
,[zav_safetycheck]
,[zav_safetycheckcompleted]
,[zav_servicenamehasbeenenteredatproperty]
,[zav_shortlistcreated]
,[zav_signedleaseoragreementreceived]
,[zav_subprogramprogramenteredatproperty]
,[zav_targetcompletiondatevacant]
,[zav_targetcompletiondatevoid]
,[zav_tenancyresolvedandexited]
,[zav_tenantimprovementsscopedandagreed]
,[zav_upcomingmaintenancejobsbooked]
,[zav_utilitiesconnectionsrecordedandsetupifapp]
,[zav_utilitiesdisconnected]
,[zav_vacatedtenancyname]
,[zav_voidcategoryname]
,[zav_voidchecklistid]
,[zav_voidcompleteddate]
,[zav_watermeterreadingsandnumbers]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_voidchecklist/*.csv',FORMAT = 'CSV',
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
,[zav_voidcheckliststatus] [bigint]
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
,[zav_clonedfromid] [uniqueidentifier]
,[zav_clonedfromid_entitytype] [varchar](256)
,[zav_offeredproperty] [uniqueidentifier]
,[zav_offeredproperty_entitytype] [varchar](256)
,[zav_property] [uniqueidentifier]
,[zav_property_entitytype] [varchar](256)
,[zav_vacatedtenancy] [uniqueidentifier]
,[zav_vacatedtenancy_entitytype] [varchar](256)
,[zav_voidcategory] [uniqueidentifier]
,[zav_voidcategory_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[crba8_comments] [varchar](7200)
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
,[zav_allcomplianceissuescompleted] [datetime2](7)
,[zav_assessmentcompletedandscopeofworksunderst] [datetime2](7)
,[zav_assessmentscoping] [datetime2](7)
,[zav_bondrecoveryformscompleted] [datetime2](7)
,[zav_bosmsdapprovedproperty] [datetime2](7)
,[zav_bosupdatedvacancylisted] [datetime2](7)
,[zav_bosupdatedvacatedate] [datetime2](7)
,[zav_carparkingprovisioned] [datetime2](7)
,[zav_clonedfromidname] [varchar](400)
,[zav_confirmtenancyhasbeenacceptedinbos] [datetime2](7)
,[zav_damageassessment] [datetime2](7)
,[zav_datebondformsignedgiventoagentowner] [datetime2](7)
,[zav_dateendofholdforpropertyredevelopment] [datetime2](7)
,[zav_datefinancenotifiedleasepropertyhandedbac] [datetime2](7)
,[zav_datefirstoffermade] [datetime2](7)
,[zav_datehudnotifiedoftenancytribunalapplicati] [datetime2](7)
,[zav_datekeyreceivedfromtenant] [datetime2](7)
,[zav_datekeysreturnedfromcontractor] [datetime2](7)
,[zav_datekeysreturnedfromspecialistcontractor] [datetime2](7)
,[zav_datekeyssenttospecialistcontractor] [datetime2](7)
,[zav_datekeyssurrenderedtoagentowner] [datetime2](7)
,[zav_datekeystocontractor] [datetime2](7)
,[zav_datekeystolossadjusterinsurance] [datetime2](7)
,[zav_datekeystopropertyteam] [datetime2](7)
,[zav_datekeystotenancyteamtoallocate] [datetime2](7)
,[zav_datemsdnotifiedofpendingtermination] [datetime2](7)
,[zav_datenoticereceived] [datetime2](7)
,[zav_dateofferconfirmedaccepted] [datetime2](7)
,[zav_dateoffinalinspectionafterkeysreceived] [datetime2](7)
,[zav_dateofhandover] [datetime2](7)
,[zav_datepossessiongranted] [datetime2](7)
,[zav_datepostworkinspectioncompleted] [datetime2](7)
,[zav_dateprevacateinspection] [datetime2](7)
,[zav_datesecondoffermade] [datetime2](7)
,[zav_datetamgainaccessabandonedproperty] [datetime2](7)
,[zav_datetenancyterminated] [datetime2](7)
,[zav_dateworkscopecompleted] [datetime2](7)
,[zav_deepclean] [datetime2](7)
,[zav_defectslistcompleted] [datetime2](7)
,[zav_defectsremediatedbyowner] [datetime2](7)
,[zav_exitfinalinspectionphotographs] [datetime2](7)
,[zav_expectedreadytoletdate] [datetime2](7)
,[zav_finalcleancomplete] [datetime2](7)
,[zav_financeadvisedofpaymentcycleamountandbond] [datetime2](7)
,[zav_fulllegalcomplianceachieved] [datetime2](7)
,[zav_fullphotographsetcreated] [datetime2](7)
,[zav_furnitureandequipmentprovided] [datetime2](7)
,[zav_handbacktotenancyteam] [datetime2](7)
,[zav_handoverinspectionwithowner] [datetime2](7)
,[zav_healthyhomesdatareceivedandstatementcanbe] [datetime2](7)
,[zav_healthyhomesdataupdated] [datetime2](7)
,[zav_icpnumbersrecorded] [datetime2](7)
,[zav_initialsnaggingworkscompleted] [datetime2](7)
,[zav_insuranceconfirmedanddetailsupdated] [datetime2](7)
,[zav_insurancedetailsconfirmedandentered] [datetime2](7)
,[zav_insurancenotified] [datetime2](7)
,[zav_itprovisioningdataandcamerasifapplicable] [datetime2](7)
,[zav_keysrecovered] [datetime2](7)
,[zav_keysreturnedtoowner] [datetime2](7)
,[zav_locationsloaded] [datetime2](7)
,[zav_madesafeandsecure] [datetime2](7)
,[zav_methamphetminechecksteppingtoprocess] [datetime2](7)
,[zav_methanphetamineclearance] [datetime2](7)
,[zav_name] [varchar](400)
,[zav_occupancyagreementsprepared] [datetime2](7)
,[zav_offeredpropertyname] [varchar](400)
,[zav_ongoingdefectslistcreated] [datetime2](7)
,[zav_pcrcompleted] [datetime2](7)
,[zav_propertydeactivatedinsystem] [datetime2](7)
,[zav_propertyfilecreatedandloaded] [datetime2](7)
,[zav_propertyname] [varchar](400)
,[zav_propertytoberedeveloped] [datetime2](7)
,[zav_propertyunitssubmittedtobosapproved] [datetime2](7)
,[zav_refurbishmentcompleted] [datetime2](7)
,[zav_repairscompleted] [datetime2](7)
,[zav_residentialtenancyagreementprepared] [datetime2](7)
,[zav_rubbishandequipmentremoved] [datetime2](7)
,[zav_safetycheck] [datetime2](7)
,[zav_safetycheckcompleted] [datetime2](7)
,[zav_servicenamehasbeenenteredatproperty] [datetime2](7)
,[zav_shortlistcreated] [datetime2](7)
,[zav_signedleaseoragreementreceived] [datetime2](7)
,[zav_subprogramprogramenteredatproperty] [datetime2](7)
,[zav_targetcompletiondatevacant] [datetime2](7)
,[zav_targetcompletiondatevoid] [datetime2](7)
,[zav_tenancyresolvedandexited] [datetime2](7)
,[zav_tenantimprovementsscopedandagreed] [datetime2](7)
,[zav_upcomingmaintenancejobsbooked] [datetime2](7)
,[zav_utilitiesconnectionsrecordedandsetupifapp] [datetime2](7)
,[zav_utilitiesdisconnected] [datetime2](7)
,[zav_vacatedtenancyname] [varchar](1200)
,[zav_voidcategoryname] [varchar](16)
,[zav_voidchecklistid] [uniqueidentifier]
,[zav_voidcompleteddate] [datetime2](7)
,[zav_watermeterreadingsandnumbers] [datetime2](7)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record