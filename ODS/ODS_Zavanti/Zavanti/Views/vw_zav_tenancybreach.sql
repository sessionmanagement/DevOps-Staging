CREATE VIEW [Zavanti].[vw_zav_tenancybreach]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_breachstatus]
,[zav_antisocialbehaviourtype]
,[zav_assaulttype]
,[zav_breachtype]
,[zav_damagestype]
,[zav_illegalcontaminationtype]
,[zav_rubbishtype]
,[zav_squatterstype]
,[zav_unauthorisedoccupationtype]
,[zav_unlawfulactivitytype]
,[zav_abandonmentphotographswhereapplicabletoth]
,[zav_abandonmenttenancyagreement]
,[zav_assaultallrelevantinformation]
,[zav_assaultbreachnoticeifapplicablewitnesses]
,[zav_assaultphotographsofassault]
,[zav_assaultpolicereport]
,[zav_assaulttenancyagreement]
,[zav_assaulttimelineofvisitshistoryoftenancy]
,[zav_assaulttimelineofvisitshistoryoftenancy1]
,[zav_assualtneighbourwitnessreport]
,[zav_councilinfringementnotices]
,[zav_damagesfirstandfinalpropertyconditionrepo]
,[zav_damagesphotographs]
,[zav_damagestenancyagreement]
,[zav_damagestimelineofvisitshistory]
,[zav_dgbondformnumber]
,[zav_dgcostsofdisposalstorage]
,[zav_dgestimateofvalueofbelongings]
,[zav_dgfirstandfinalpcr]
,[zav_dgnoticetovacate]
,[zav_dgphotos]
,[zav_dgtenancyagreement]
,[zav_enquiresofidentityofowner]
,[zav_estimatedcostsofremoval]
,[zav_expiredwofandregistration]
,[zav_fa2ndinspectionormaintenancenoticeandrepo]
,[zav_fabreachnotices]
,[zav_failtimelineofvisitstopropertybreachnot]
,[zav_failuretenancyagreement]
,[zav_fainspectionormaintenancenoticeandreport]
,[zav_fatenancyagreement]
,[zav_icbondformnumber]
,[zav_iccouncilcleansingorder]
,[zav_icfirstandfinalpcr]
,[zav_icfullcontaminationreports]
,[zav_icinspectionormaintenancenoticeandreport]
,[zav_icinvoicesremediationwork]
,[zav_icinvoicetesting]
,[zav_icphotos]
,[zav_icpolicereferencesummaryifapplicable]
,[zav_icstatementoffinalaccount]
,[zav_ictimelineofvisitshistoryoftenancy]
,[zav_icvacationnoticeifapplicable]
,[zav_illegalcouncilcleansingorder]
,[zav_illegalfirstandfinalpropertyconditionrepo]
,[zav_illegalfullreports]
,[zav_illegalinvoicesremediationwork]
,[zav_illegalinvoicetesting]
,[zav_illegalnewspaperclippings]
,[zav_illegalphotographs]
,[zav_illegalpolicecaptionsummaryifapplicable]
,[zav_illegalstatementoffinalaccount]
,[zav_illegaltenancyagreement]
,[zav_illegaltimelineofvisitshistory]
,[zav_illegalvacationnoticeifapplicable]
,[zav_iltenancyagreement]
,[zav_inspectionnoticesandreports]
,[zav_neighbourwitnessreports]
,[zav_noisecontrolnotices]
,[zav_nrbondformnumber]
,[zav_nrbreachnotice]
,[zav_nrfullnonrentstatement]
,[zav_nrmediationhistory]
,[zav_nrtenancyagreement]
,[zav_pcrstartoftenancy]
,[zav_photographswhereapplicabletothebreach]
,[zav_policereports]
,[zav_rabondformnumber]
,[zav_rabreachnotice]
,[zav_rafullrentstatementrentonly]
,[zav_ramediationhistory]
,[zav_ratenancyagreement]
,[zav_rentstatementandrentarrearsnotices]
,[zav_rubbishbreachnotices]
,[zav_rubbishphotos]
,[zav_squatters90daynotice]
,[zav_squattersbreachnotices]
,[zav_squattersdeathcertificate]
,[zav_squattersphotographsofproperty]
,[zav_squatterspoliceinformation]
,[zav_squatterspossessionorder]
,[zav_squatterstenancyagreement]
,[zav_squattersvacationnotice]
,[zav_tenancyagreement]
,[zav_uaallrelevantinformation]
,[zav_uabreachnoticeifapplicable]
,[zav_uaneighbourwitnessreport]
,[zav_uaphotos]
,[zav_uapolicereport]
,[zav_uatenancyagreement]
,[zav_uatimelineofvisitshistoryoftenancy]
,[zav_unauthorisedalterationsbreachnotices]
,[zav_unauthorizedneighborinformation]
,[zav_unauthorizedphotographs]
,[zav_unauthorizedtenancyagreement]
,[zav_unauthorizedtimelineofvisitshistory]
,[zav_unauthpetbreachnotices]
,[zav_unauthpetevidenceofpet]
,[zav_unauthpetinspectionnoticesandreports]
,[zav_unauthpettenancyagreement]
,[zav_vacatedbondnumberform]
,[zav_vacatedbreachnotice]
,[zav_vacateddamagelist]
,[zav_vacatedfirstandfinalpropertyconditionrepo]
,[zav_vacatedfullrenthistory]
,[zav_vacatedinspectionnoticesandreports]
,[zav_vacatedinvoiceforrepairs]
,[zav_vacatedphotographsofdamage]
,[zav_vacatedtenancyagreement]
,[zav_vacatedvacationnotice]
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
,[zav_memberofstaff]
,[zav_memberofstaff_entitytype]
,[zav_originatingcase]
,[zav_originatingcase_entitytype]
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
,[zav_breachdate]
,[zav_breachid]
,[zav_dateofeviction]
,[zav_datewhenpolicewascontacted]
,[zav_enddateoftribunalorder]
,[zav_memberofstaffname]
,[zav_memberofstaffyominame]
,[zav_name]
,[zav_originatingcasename]
,[zav_outcome]
,[zav_possessionwarrantexecuteddate]
,[zav_purchasewarrantcomments]
,[zav_purchasewarrantenddate]
,[zav_purchasewarrantstartdate]
,[zav_startdateoftribunalorder]
,[zav_tenancybreachid]
,[zav_tenancyname]
,[zav_tribunalhearing]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_breachstatus]
,[zav_antisocialbehaviourtype]
,[zav_assaulttype]
,[zav_breachtype]
,[zav_damagestype]
,[zav_illegalcontaminationtype]
,[zav_rubbishtype]
,[zav_squatterstype]
,[zav_unauthorisedoccupationtype]
,[zav_unlawfulactivitytype]
,[zav_abandonmentphotographswhereapplicabletoth]
,[zav_abandonmenttenancyagreement]
,[zav_assaultallrelevantinformation]
,[zav_assaultbreachnoticeifapplicablewitnesses]
,[zav_assaultphotographsofassault]
,[zav_assaultpolicereport]
,[zav_assaulttenancyagreement]
,[zav_assaulttimelineofvisitshistoryoftenancy]
,[zav_assaulttimelineofvisitshistoryoftenancy1]
,[zav_assualtneighbourwitnessreport]
,[zav_councilinfringementnotices]
,[zav_damagesfirstandfinalpropertyconditionrepo]
,[zav_damagesphotographs]
,[zav_damagestenancyagreement]
,[zav_damagestimelineofvisitshistory]
,[zav_dgbondformnumber]
,[zav_dgcostsofdisposalstorage]
,[zav_dgestimateofvalueofbelongings]
,[zav_dgfirstandfinalpcr]
,[zav_dgnoticetovacate]
,[zav_dgphotos]
,[zav_dgtenancyagreement]
,[zav_enquiresofidentityofowner]
,[zav_estimatedcostsofremoval]
,[zav_expiredwofandregistration]
,[zav_fa2ndinspectionormaintenancenoticeandrepo]
,[zav_fabreachnotices]
,[zav_failtimelineofvisitstopropertybreachnot]
,[zav_failuretenancyagreement]
,[zav_fainspectionormaintenancenoticeandreport]
,[zav_fatenancyagreement]
,[zav_icbondformnumber]
,[zav_iccouncilcleansingorder]
,[zav_icfirstandfinalpcr]
,[zav_icfullcontaminationreports]
,[zav_icinspectionormaintenancenoticeandreport]
,[zav_icinvoicesremediationwork]
,[zav_icinvoicetesting]
,[zav_icphotos]
,[zav_icpolicereferencesummaryifapplicable]
,[zav_icstatementoffinalaccount]
,[zav_ictimelineofvisitshistoryoftenancy]
,[zav_icvacationnoticeifapplicable]
,[zav_illegalcouncilcleansingorder]
,[zav_illegalfirstandfinalpropertyconditionrepo]
,[zav_illegalfullreports]
,[zav_illegalinvoicesremediationwork]
,[zav_illegalinvoicetesting]
,[zav_illegalnewspaperclippings]
,[zav_illegalphotographs]
,[zav_illegalpolicecaptionsummaryifapplicable]
,[zav_illegalstatementoffinalaccount]
,[zav_illegaltenancyagreement]
,[zav_illegaltimelineofvisitshistory]
,[zav_illegalvacationnoticeifapplicable]
,[zav_iltenancyagreement]
,[zav_inspectionnoticesandreports]
,[zav_neighbourwitnessreports]
,[zav_noisecontrolnotices]
,[zav_nrbondformnumber]
,[zav_nrbreachnotice]
,[zav_nrfullnonrentstatement]
,[zav_nrmediationhistory]
,[zav_nrtenancyagreement]
,[zav_pcrstartoftenancy]
,[zav_photographswhereapplicabletothebreach]
,[zav_policereports]
,[zav_rabondformnumber]
,[zav_rabreachnotice]
,[zav_rafullrentstatementrentonly]
,[zav_ramediationhistory]
,[zav_ratenancyagreement]
,[zav_rentstatementandrentarrearsnotices]
,[zav_rubbishbreachnotices]
,[zav_rubbishphotos]
,[zav_squatters90daynotice]
,[zav_squattersbreachnotices]
,[zav_squattersdeathcertificate]
,[zav_squattersphotographsofproperty]
,[zav_squatterspoliceinformation]
,[zav_squatterspossessionorder]
,[zav_squatterstenancyagreement]
,[zav_squattersvacationnotice]
,[zav_tenancyagreement]
,[zav_uaallrelevantinformation]
,[zav_uabreachnoticeifapplicable]
,[zav_uaneighbourwitnessreport]
,[zav_uaphotos]
,[zav_uapolicereport]
,[zav_uatenancyagreement]
,[zav_uatimelineofvisitshistoryoftenancy]
,[zav_unauthorisedalterationsbreachnotices]
,[zav_unauthorizedneighborinformation]
,[zav_unauthorizedphotographs]
,[zav_unauthorizedtenancyagreement]
,[zav_unauthorizedtimelineofvisitshistory]
,[zav_unauthpetbreachnotices]
,[zav_unauthpetevidenceofpet]
,[zav_unauthpetinspectionnoticesandreports]
,[zav_unauthpettenancyagreement]
,[zav_vacatedbondnumberform]
,[zav_vacatedbreachnotice]
,[zav_vacateddamagelist]
,[zav_vacatedfirstandfinalpropertyconditionrepo]
,[zav_vacatedfullrenthistory]
,[zav_vacatedinspectionnoticesandreports]
,[zav_vacatedinvoiceforrepairs]
,[zav_vacatedphotographsofdamage]
,[zav_vacatedtenancyagreement]
,[zav_vacatedvacationnotice]
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
,[zav_memberofstaff]
,[zav_memberofstaff_entitytype]
,[zav_originatingcase]
,[zav_originatingcase_entitytype]
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
,[zav_breachdate]
,[zav_breachid]
,[zav_dateofeviction]
,[zav_datewhenpolicewascontacted]
,[zav_enddateoftribunalorder]
,[zav_memberofstaffname]
,[zav_memberofstaffyominame]
,[zav_name]
,[zav_originatingcasename]
,[zav_outcome]
,[zav_possessionwarrantexecuteddate]
,[zav_purchasewarrantcomments]
,[zav_purchasewarrantenddate]
,[zav_purchasewarrantstartdate]
,[zav_startdateoftribunalorder]
,[zav_tenancybreachid]
,[zav_tenancyname]
,[zav_tribunalhearing]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_tenancybreach/*.csv',FORMAT = 'CSV',
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
,[zav_breachstatus] [bigint]
,[zav_antisocialbehaviourtype] [varchar](8000)
,[zav_assaulttype] [varchar](8000)
,[zav_breachtype] [varchar](8000)
,[zav_damagestype] [varchar](8000)
,[zav_illegalcontaminationtype] [varchar](8000)
,[zav_rubbishtype] [varchar](8000)
,[zav_squatterstype] [varchar](8000)
,[zav_unauthorisedoccupationtype] [varchar](8000)
,[zav_unlawfulactivitytype] [varchar](8000)
,[zav_abandonmentphotographswhereapplicabletoth] [varchar](6)
,[zav_abandonmenttenancyagreement] [varchar](6)
,[zav_assaultallrelevantinformation] [varchar](6)
,[zav_assaultbreachnoticeifapplicablewitnesses] [varchar](6)
,[zav_assaultphotographsofassault] [varchar](6)
,[zav_assaultpolicereport] [varchar](6)
,[zav_assaulttenancyagreement] [varchar](6)
,[zav_assaulttimelineofvisitshistoryoftenancy] [varchar](6)
,[zav_assaulttimelineofvisitshistoryoftenancy1] [varchar](6)
,[zav_assualtneighbourwitnessreport] [varchar](6)
,[zav_councilinfringementnotices] [varchar](6)
,[zav_damagesfirstandfinalpropertyconditionrepo] [varchar](6)
,[zav_damagesphotographs] [varchar](6)
,[zav_damagestenancyagreement] [varchar](6)
,[zav_damagestimelineofvisitshistory] [varchar](6)
,[zav_dgbondformnumber] [varchar](6)
,[zav_dgcostsofdisposalstorage] [varchar](6)
,[zav_dgestimateofvalueofbelongings] [varchar](6)
,[zav_dgfirstandfinalpcr] [varchar](6)
,[zav_dgnoticetovacate] [varchar](6)
,[zav_dgphotos] [varchar](6)
,[zav_dgtenancyagreement] [varchar](6)
,[zav_enquiresofidentityofowner] [varchar](6)
,[zav_estimatedcostsofremoval] [varchar](6)
,[zav_expiredwofandregistration] [varchar](6)
,[zav_fa2ndinspectionormaintenancenoticeandrepo] [varchar](6)
,[zav_fabreachnotices] [varchar](6)
,[zav_failtimelineofvisitstopropertybreachnot] [varchar](6)
,[zav_failuretenancyagreement] [varchar](6)
,[zav_fainspectionormaintenancenoticeandreport] [varchar](6)
,[zav_fatenancyagreement] [varchar](6)
,[zav_icbondformnumber] [varchar](6)
,[zav_iccouncilcleansingorder] [varchar](6)
,[zav_icfirstandfinalpcr] [varchar](6)
,[zav_icfullcontaminationreports] [varchar](6)
,[zav_icinspectionormaintenancenoticeandreport] [varchar](6)
,[zav_icinvoicesremediationwork] [varchar](6)
,[zav_icinvoicetesting] [varchar](6)
,[zav_icphotos] [varchar](6)
,[zav_icpolicereferencesummaryifapplicable] [varchar](6)
,[zav_icstatementoffinalaccount] [varchar](6)
,[zav_ictimelineofvisitshistoryoftenancy] [varchar](6)
,[zav_icvacationnoticeifapplicable] [varchar](6)
,[zav_illegalcouncilcleansingorder] [varchar](6)
,[zav_illegalfirstandfinalpropertyconditionrepo] [varchar](6)
,[zav_illegalfullreports] [varchar](6)
,[zav_illegalinvoicesremediationwork] [varchar](6)
,[zav_illegalinvoicetesting] [varchar](6)
,[zav_illegalnewspaperclippings] [varchar](6)
,[zav_illegalphotographs] [varchar](6)
,[zav_illegalpolicecaptionsummaryifapplicable] [varchar](6)
,[zav_illegalstatementoffinalaccount] [varchar](6)
,[zav_illegaltenancyagreement] [varchar](6)
,[zav_illegaltimelineofvisitshistory] [varchar](6)
,[zav_illegalvacationnoticeifapplicable] [varchar](6)
,[zav_iltenancyagreement] [varchar](6)
,[zav_inspectionnoticesandreports] [varchar](6)
,[zav_neighbourwitnessreports] [varchar](6)
,[zav_noisecontrolnotices] [varchar](6)
,[zav_nrbondformnumber] [varchar](6)
,[zav_nrbreachnotice] [varchar](6)
,[zav_nrfullnonrentstatement] [varchar](6)
,[zav_nrmediationhistory] [varchar](6)
,[zav_nrtenancyagreement] [varchar](6)
,[zav_pcrstartoftenancy] [varchar](6)
,[zav_photographswhereapplicabletothebreach] [varchar](6)
,[zav_policereports] [varchar](6)
,[zav_rabondformnumber] [varchar](6)
,[zav_rabreachnotice] [varchar](6)
,[zav_rafullrentstatementrentonly] [varchar](6)
,[zav_ramediationhistory] [varchar](6)
,[zav_ratenancyagreement] [varchar](6)
,[zav_rentstatementandrentarrearsnotices] [varchar](6)
,[zav_rubbishbreachnotices] [varchar](6)
,[zav_rubbishphotos] [varchar](6)
,[zav_squatters90daynotice] [varchar](6)
,[zav_squattersbreachnotices] [varchar](6)
,[zav_squattersdeathcertificate] [varchar](6)
,[zav_squattersphotographsofproperty] [varchar](6)
,[zav_squatterspoliceinformation] [varchar](6)
,[zav_squatterspossessionorder] [varchar](6)
,[zav_squatterstenancyagreement] [varchar](6)
,[zav_squattersvacationnotice] [varchar](6)
,[zav_tenancyagreement] [varchar](6)
,[zav_uaallrelevantinformation] [varchar](6)
,[zav_uabreachnoticeifapplicable] [varchar](6)
,[zav_uaneighbourwitnessreport] [varchar](6)
,[zav_uaphotos] [varchar](6)
,[zav_uapolicereport] [varchar](6)
,[zav_uatenancyagreement] [varchar](6)
,[zav_uatimelineofvisitshistoryoftenancy] [varchar](6)
,[zav_unauthorisedalterationsbreachnotices] [varchar](6)
,[zav_unauthorizedneighborinformation] [varchar](6)
,[zav_unauthorizedphotographs] [varchar](6)
,[zav_unauthorizedtenancyagreement] [varchar](6)
,[zav_unauthorizedtimelineofvisitshistory] [varchar](6)
,[zav_unauthpetbreachnotices] [varchar](6)
,[zav_unauthpetevidenceofpet] [varchar](6)
,[zav_unauthpetinspectionnoticesandreports] [varchar](6)
,[zav_unauthpettenancyagreement] [varchar](6)
,[zav_vacatedbondnumberform] [varchar](6)
,[zav_vacatedbreachnotice] [varchar](6)
,[zav_vacateddamagelist] [varchar](6)
,[zav_vacatedfirstandfinalpropertyconditionrepo] [varchar](6)
,[zav_vacatedfullrenthistory] [varchar](6)
,[zav_vacatedinspectionnoticesandreports] [varchar](6)
,[zav_vacatedinvoiceforrepairs] [varchar](6)
,[zav_vacatedphotographsofdamage] [varchar](6)
,[zav_vacatedtenancyagreement] [varchar](6)
,[zav_vacatedvacationnotice] [varchar](6)
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
,[zav_memberofstaff] [uniqueidentifier]
,[zav_memberofstaff_entitytype] [varchar](256)
,[zav_originatingcase] [uniqueidentifier]
,[zav_originatingcase_entitytype] [varchar](256)
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
,[zav_breachdate] [datetime2](7)
,[zav_breachid] [varchar](400)
,[zav_dateofeviction] [datetime2](7)
,[zav_datewhenpolicewascontacted] [datetime2](7)
,[zav_enddateoftribunalorder] [datetime2](7)
,[zav_memberofstaffname] [varchar](1026)
,[zav_memberofstaffyominame] [varchar](1026)
,[zav_name] [varchar](400)
,[zav_originatingcasename] [varchar](800)
,[zav_outcome] [varchar](max)
,[zav_possessionwarrantexecuteddate] [datetime2](7)
,[zav_purchasewarrantcomments] [varchar](max)
,[zav_purchasewarrantenddate] [datetime2](7)
,[zav_purchasewarrantstartdate] [datetime2](7)
,[zav_startdateoftribunalorder] [datetime2](7)
,[zav_tenancybreachid] [uniqueidentifier]
,[zav_tenancyname] [varchar](1200)
,[zav_tribunalhearing] [varchar](max)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record