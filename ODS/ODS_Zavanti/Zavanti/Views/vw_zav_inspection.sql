CREATE VIEW [Zavanti].[vw_zav_inspection]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_anyotherissues]
,[zav_anyotherissuesorconcerns]
,[zav_areallwindowsecuritystaysinplaceandsecure]
,[zav_arethereanyelectricalwiresexposedinthepro]
,[zav_arethereanypestsorvermin]
,[zav_arethereareanysignsofmouldordampness]
,[zav_aretherechemicalcontaminationresidue]
,[zav_aretherenetcurtainsinbedroomsandpublicfac]
,[zav_doallroomshavethermalbackedcurtains]
,[zav_doesthepropertycontainanytriphazards]
,[zav_doyouhaveanyconcernsforthewellbeingofthe]
,[zav_evacuationrouteclear]
,[zav_evacuationtaginplace]
,[zav_fireevacuationnoticeinplace]
,[zav_hasanyrubbishbeenleftontheproperty]
,[zav_inspectioncategory]
,[zav_inspectiontype]
,[zav_isthehotwatercylindertiedback]
,[zav_isthereevidenceofadditionalpeoplestayingl]
,[zav_isthisatenancyleavingabandonmentinspectio]
,[zav_smokealarmsoperational]
,[crba8_istenantpresent]
,[zav_cancelinspection]
,[zav_ignorepluginvalidate]
,[zav_tenantconfirmedcondition]
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
,[zav_client]
,[zav_client_entitytype]
,[zav_inspectedby]
,[zav_inspectedby_entitytype]
,[zav_nextinspection]
,[zav_nextinspection_entitytype]
,[zav_originatingworktask]
,[zav_originatingworktask_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_propertymanager]
,[zav_propertymanager_entitytype]
,[zav_propertymanagerid]
,[zav_propertymanagerid_entitytype]
,[zav_tenancymanager]
,[zav_tenancymanager_entitytype]
,[zav_tenant]
,[zav_tenant_entitytype]
,[zav_welcomevisitinspection]
,[zav_welcomevisitinspection_entitytype]
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
,[processid]
,[stageid]
,[timezoneruleversionnumber]
,[traversedpath]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_anyotherissuespleaseexplain]
,[zav_canvastemp]
,[zav_chintaroid]
,[zav_clientname]
,[zav_clientyominame]
,[zav_comments]
,[zav_completiondate]
,[zav_enterdatewhentestwasdone]
,[zav_inspectedbyname]
,[zav_inspectedbyyominame]
,[zav_inspectiondate]
,[zav_inspectionid]
,[zav_inspectionid1]
,[zav_inspectionsummary]
,[zav_inspectiontimefrom]
,[zav_inspectiontimeto]
,[zav_maintenancerequired]
,[zav_name]
,[zav_nextinspectionname]
,[zav_nextroutineinspection]
,[zav_originatingworktaskname]
,[zav_paymentreference]
,[zav_propertymanageridname]
,[zav_propertymanageridyominame]
,[zav_propertymanagername]
,[zav_propertymanageryominame]
,[zav_propertyname]
,[zav_relativeurl]
,[zav_scheduleddate]
,[zav_scheduledinspectionend]
,[zav_suggestedimprovements]
,[zav_tenancymanagername]
,[zav_tenancymanageryominame]
,[zav_tenantname]
,[zav_welcomevisitinspectionname]
,[IsDelete]
,[zav_inspectionsigned]
,[zav_inspectionsigned_timestamp]
,[zav_inspectionsigned_url]
,[zav_inspectionsignedid]
,[new_inspectionsigned]
,[zav_scheduleddatedateonly]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_anyotherissues]
,[zav_anyotherissuesorconcerns]
,[zav_areallwindowsecuritystaysinplaceandsecure]
,[zav_arethereanyelectricalwiresexposedinthepro]
,[zav_arethereanypestsorvermin]
,[zav_arethereareanysignsofmouldordampness]
,[zav_aretherechemicalcontaminationresidue]
,[zav_aretherenetcurtainsinbedroomsandpublicfac]
,[zav_doallroomshavethermalbackedcurtains]
,[zav_doesthepropertycontainanytriphazards]
,[zav_doyouhaveanyconcernsforthewellbeingofthe]
,[zav_evacuationrouteclear]
,[zav_evacuationtaginplace]
,[zav_fireevacuationnoticeinplace]
,[zav_hasanyrubbishbeenleftontheproperty]
,[zav_inspectioncategory]
,[zav_inspectiontype]
,[zav_isthehotwatercylindertiedback]
,[zav_isthereevidenceofadditionalpeoplestayingl]
,[zav_isthisatenancyleavingabandonmentinspectio]
,[zav_smokealarmsoperational]
,[crba8_istenantpresent]
,[zav_cancelinspection]
,[zav_ignorepluginvalidate]
,[zav_tenantconfirmedcondition]
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
,[zav_client]
,[zav_client_entitytype]
,[zav_inspectedby]
,[zav_inspectedby_entitytype]
,[zav_nextinspection]
,[zav_nextinspection_entitytype]
,[zav_originatingworktask]
,[zav_originatingworktask_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_propertymanager]
,[zav_propertymanager_entitytype]
,[zav_propertymanagerid]
,[zav_propertymanagerid_entitytype]
,[zav_tenancymanager]
,[zav_tenancymanager_entitytype]
,[zav_tenant]
,[zav_tenant_entitytype]
,[zav_welcomevisitinspection]
,[zav_welcomevisitinspection_entitytype]
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
,[processid]
,[stageid]
,[timezoneruleversionnumber]
,[traversedpath]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_anyotherissuespleaseexplain]
,[zav_canvastemp]
,[zav_chintaroid]
,[zav_clientname]
,[zav_clientyominame]
,[zav_comments]
,[zav_completiondate]
,[zav_enterdatewhentestwasdone]
,[zav_inspectedbyname]
,[zav_inspectedbyyominame]
,[zav_inspectiondate]
,[zav_inspectionid]
,[zav_inspectionid1]
,[zav_inspectionsummary]
,[zav_inspectiontimefrom]
,[zav_inspectiontimeto]
,[zav_maintenancerequired]
,[zav_name]
,[zav_nextinspectionname]
,[zav_nextroutineinspection]
,[zav_originatingworktaskname]
,[zav_paymentreference]
,[zav_propertymanageridname]
,[zav_propertymanageridyominame]
,[zav_propertymanagername]
,[zav_propertymanageryominame]
,[zav_propertyname]
,[zav_relativeurl]
,[zav_scheduleddate]
,[zav_scheduledinspectionend]
,[zav_suggestedimprovements]
,[zav_tenancymanagername]
,[zav_tenancymanageryominame]
,[zav_tenantname]
,[zav_welcomevisitinspectionname]
,[IsDelete]
,[zav_inspectionsigned]
,[zav_inspectionsigned_timestamp]
,[zav_inspectionsigned_url]
,[zav_inspectionsignedid]
,[new_inspectionsigned]
,[zav_scheduleddatedateonly]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_inspection/*.csv',FORMAT = 'CSV',
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
,[zav_anyotherissues] [bigint]
,[zav_anyotherissuesorconcerns] [bigint]
,[zav_areallwindowsecuritystaysinplaceandsecure] [bigint]
,[zav_arethereanyelectricalwiresexposedinthepro] [bigint]
,[zav_arethereanypestsorvermin] [bigint]
,[zav_arethereareanysignsofmouldordampness] [bigint]
,[zav_aretherechemicalcontaminationresidue] [bigint]
,[zav_aretherenetcurtainsinbedroomsandpublicfac] [bigint]
,[zav_doallroomshavethermalbackedcurtains] [bigint]
,[zav_doesthepropertycontainanytriphazards] [bigint]
,[zav_doyouhaveanyconcernsforthewellbeingofthe] [bigint]
,[zav_evacuationrouteclear] [bigint]
,[zav_evacuationtaginplace] [bigint]
,[zav_fireevacuationnoticeinplace] [bigint]
,[zav_hasanyrubbishbeenleftontheproperty] [bigint]
,[zav_inspectioncategory] [bigint]
,[zav_inspectiontype] [bigint]
,[zav_isthehotwatercylindertiedback] [bigint]
,[zav_isthereevidenceofadditionalpeoplestayingl] [bigint]
,[zav_isthisatenancyleavingabandonmentinspectio] [bigint]
,[zav_smokealarmsoperational] [bigint]
,[crba8_istenantpresent] [varchar](6)
,[zav_cancelinspection] [varchar](6)
,[zav_ignorepluginvalidate] [varchar](6)
,[zav_tenantconfirmedcondition] [varchar](6)
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
,[zav_client] [uniqueidentifier]
,[zav_client_entitytype] [varchar](256)
,[zav_inspectedby] [uniqueidentifier]
,[zav_inspectedby_entitytype] [varchar](256)
,[zav_nextinspection] [uniqueidentifier]
,[zav_nextinspection_entitytype] [varchar](256)
,[zav_originatingworktask] [uniqueidentifier]
,[zav_originatingworktask_entitytype] [varchar](256)
,[zav_property] [uniqueidentifier]
,[zav_property_entitytype] [varchar](256)
,[zav_propertymanager] [uniqueidentifier]
,[zav_propertymanager_entitytype] [varchar](256)
,[zav_propertymanagerid] [uniqueidentifier]
,[zav_propertymanagerid_entitytype] [varchar](256)
,[zav_tenancymanager] [uniqueidentifier]
,[zav_tenancymanager_entitytype] [varchar](256)
,[zav_tenant] [uniqueidentifier]
,[zav_tenant_entitytype] [varchar](256)
,[zav_welcomevisitinspection] [uniqueidentifier]
,[zav_welcomevisitinspection_entitytype] [varchar](256)
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
,[processid] [uniqueidentifier]
,[stageid] [uniqueidentifier]
,[timezoneruleversionnumber] [bigint]
,[traversedpath] [varchar](5000)
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[zav_anyotherissuespleaseexplain] [varchar](max)
,[zav_canvastemp] [varchar](400)
,[zav_chintaroid] [varchar](400)
,[zav_clientname] [varchar](640)
,[zav_clientyominame] [varchar](1800)
,[zav_comments] [varchar](max)
,[zav_completiondate] [datetime2](7)
,[zav_enterdatewhentestwasdone] [datetime2](7)
,[zav_inspectedbyname] [varchar](1026)
,[zav_inspectedbyyominame] [varchar](1026)
,[zav_inspectiondate] [datetime2](7)
,[zav_inspectionid] [uniqueidentifier]
,[zav_inspectionid1] [varchar](400)
,[zav_inspectionsummary] [varchar](max)
,[zav_inspectiontimefrom] [datetime2](7)
,[zav_inspectiontimeto] [datetime2](7)
,[zav_maintenancerequired] [varchar](max)
,[zav_name] [varchar](800)
,[zav_nextinspectionname] [varchar](800)
,[zav_nextroutineinspection] [datetime2](7)
,[zav_originatingworktaskname] [varchar](400)
,[zav_paymentreference] [varchar](400)
,[zav_propertymanageridname] [varchar](1026)
,[zav_propertymanageridyominame] [varchar](1026)
,[zav_propertymanagername] [varchar](640)
,[zav_propertymanageryominame] [varchar](1800)
,[zav_propertyname] [varchar](400)
,[zav_relativeurl] [varchar](3600)
,[zav_scheduleddate] [datetime2](7)
,[zav_scheduledinspectionend] [datetime2](7)
,[zav_suggestedimprovements] [varchar](max)
,[zav_tenancymanagername] [varchar](1026)
,[zav_tenancymanageryominame] [varchar](1026)
,[zav_tenantname] [varchar](1200)
,[zav_welcomevisitinspectionname] [varchar](800)
,[IsDelete] [varchar](6)
,[zav_inspectionsigned] [varchar](max)
,[zav_inspectionsigned_timestamp] [bigint]
,[zav_inspectionsigned_url] [varchar](800)
,[zav_inspectionsignedid] [uniqueidentifier]
,[new_inspectionsigned] [varchar](max)
,[zav_scheduleddatedateonly] [datetime2](7)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record