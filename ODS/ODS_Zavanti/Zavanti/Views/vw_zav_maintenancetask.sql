CREATE VIEW [Zavanti].[vw_zav_maintenancetask]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[new_type]
,[zav_acknowledgmenttype]
,[zav_contractorstatus]
,[zav_damagetype]
,[zav_doarequired]
,[zav_inventoryitem]
,[zav_keyaccessinformation]
,[zav_location]
,[zav_propertystatus]
,[zav_rectificationstatus]
,[zav_sendworkorderto]
,[zav_taskstatus]
,[zav_urgent]
,[zav_worktype]
,[zav_acknowledgementsentby]
,[new_completedbycontractor]
,[new_postinspectiondone]
,[new_tenantconsent]
,[zav_acknowledgmentsenttothetenant]
,[zav_cancelworktask]
,[zav_completedsatisfactorily]
,[zav_confirmedforpayment]
,[zav_dummycompletedbutkeeptaskstatus]
,[zav_ecdprocessedqueue]
,[zav_email]
,[zav_exported]
,[zav_finalisedworktask]
,[zav_flexifund]
,[zav_invoicedetailsprocessedqueue]
,[zav_letter]
,[zav_onhold]
,[zav_ownerrecovery]
,[zav_phonecall]
,[zav_requestreceivedsentprocessedqueue]
,[zav_sendemailnotificationwhenpfmcancelled]
,[zav_supportemail]
,[zav_suppresstenantemail]
,[zav_tenantdamage]
,[zav_tenantliable]
,[zav_tenantscharged]
,[zav_tenantspermission]
,[zav_textmessage]
,[zav_variationprocessedqueue]
,[zav_workquoteprocessedqueue]
,[zav_worktaskcompletionprocessedqueue]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[new_inspectionid]
,[new_inspectionid_entitytype]
,[new_officelocationid]
,[new_officelocationid_entitytype]
,[new_property]
,[new_property_entitytype]
,[owningbusinessunit]
,[owningbusinessunit_entitytype]
,[owningteam]
,[owningteam_entitytype]
,[owninguser]
,[owninguser_entitytype]
,[slaid]
,[slaid_entitytype]
,[slainvokedid]
,[slainvokedid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_acknowledgedby]
,[zav_acknowledgedby_entitytype]
,[zav_cancellationrequestedby]
,[zav_cancellationrequestedby_entitytype]
,[zav_cause]
,[zav_cause_entitytype]
,[zav_client]
,[zav_client_entitytype]
,[zav_doasettings]
,[zav_doasettings_entitytype]
,[zav_emergencyresponsewithin4hoursid]
,[zav_emergencyresponsewithin4hoursid_entitytype]
,[zav_housingofficer]
,[zav_housingofficer_entitytype]
,[zav_housingofficerid]
,[zav_housingofficerid_entitytype]
,[zav_invoiceapprovedby]
,[zav_invoiceapprovedby_entitytype]
,[zav_itemgroup]
,[zav_itemgroup_entitytype]
,[zav_itemtype]
,[zav_itemtype_entitytype]
,[zav_keysupportcontact]
,[zav_keysupportcontact_entitytype]
,[zav_legalownerprimarycontact]
,[zav_legalownerprimarycontact_entitytype]
,[zav_maintenancetype]
,[zav_maintenancetype_entitytype]
,[zav_pricelist]
,[zav_pricelist_entitytype]
,[zav_primarycontact]
,[zav_primarycontact_entitytype]
,[zav_problem]
,[zav_problem_entitytype]
,[zav_program]
,[zav_program_entitytype]
,[zav_propertymanager]
,[zav_propertymanager_entitytype]
,[zav_remedy]
,[zav_remedy_entitytype]
,[zav_resolvebyid]
,[zav_resolvebyid_entitytype]
,[zav_revisedfromworktask]
,[zav_revisedfromworktask_entitytype]
,[zav_serviceagreement]
,[zav_serviceagreement_entitytype]
,[zav_subprogram]
,[zav_subprogram_entitytype]
,[zav_tenancymanager]
,[zav_tenancymanager_entitytype]
,[zav_tenant]
,[zav_tenant_entitytype]
,[zav_tradesperson]
,[zav_tradesperson_entitytype]
,[zav_tradetype]
,[zav_tradetype_entitytype]
,[zav_worktypeid]
,[zav_worktypeid_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[crba8_invoicedto]
,[crba8_invoicedto_entitytype]
,[zav_actualcost]
,[zav_actualcost_base]
,[zav_actualgst]
,[zav_actualgst_base]
,[zav_amounttoberecovered]
,[zav_amounttoberecovered_base]
,[zav_amounttoberecoveredincgst]
,[zav_amounttoberecoveredincgst_base]
,[zav_balanceamount]
,[zav_balanceamount_base]
,[zav_budgetcost]
,[zav_budgetcost_base]
,[zav_budgetgst]
,[zav_budgetgst_base]
,[zav_estimatedcost]
,[zav_estimatedcost_base]
,[zav_estimatedgst]
,[zav_estimatedgst_base]
,[zav_flexifundamount]
,[zav_flexifundamount_base]
,[zav_invoicedamount]
,[zav_invoicedamount_base]
,[zav_pricevariance]
,[zav_pricevariance_base]
,[zav_totalcappedamount]
,[zav_totalcappedamount_base]
,[zav_webexpensesamount]
,[zav_webexpensesamount_base]
,[zav_workdetailstotal]
,[zav_workdetailstotal_base]
,[crba8_invoicedtoidtype]
,[crba8_invoicedtoname]
,[crba8_invoicedtoyominame]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[exchangerate]
,[importsequencenumber]
,[lastonholdtime]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[new_actualstartdate]
,[new_contractorcomment]
,[new_contractorworkcompletedcomments]
,[new_inspectionidname]
,[new_invoiceduedate]
,[new_officelocationidname]
,[new_order]
,[new_postinspectioncompleteddate]
,[new_primarycontactmobilephone]
,[new_propertyname]
,[new_reporteddate]
,[new_scheduledcompletiondate]
,[new_scheduledstartdate]
,[new_tenantconsentdate]
,[new_tradespersonorder]
,[onholdtime]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[processid]
,[slaidname]
,[slainvokedidname]
,[stageid]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[traversedpath]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_accessinstructions]
,[zav_acknowledgedbyname]
,[zav_acknowledgedbyyominame]
,[zav_acknowledgmentdateandtime]
,[zav_acknowledgmentenddateandtime]
,[zav_actualcompletiondate]
,[zav_cancellationrequestedbyname]
,[zav_cancellationrequestedbyyominame]
,[zav_causename]
,[zav_clientname]
,[zav_clientyominame]
,[zav_completedorder]
,[zav_contractorstatusdateandtime]
,[zav_contractorworkcompletiondate]
,[zav_countcompletedworktasks]
,[zav_doasettingsname]
,[zav_emergencyresponsewithin4hoursidname]
,[zav_expectedcompletiondate]
,[zav_expectedonsitedate]
,[zav_flexifundtext]
,[zav_housingofficeridname]
,[zav_housingofficeridyominame]
,[zav_housingofficername]
,[zav_housingofficeryominame]
,[zav_housingworkerchintaro]
,[zav_icodes]
,[zav_instructions]
,[zav_invoiceapprovedbyname]
,[zav_invoiceapprovedbyyominame]
,[zav_invoicenumber]
,[zav_invoicepaiddate]
,[zav_itemgroupname]
,[zav_itemtypename]
,[zav_keysupportcontactname]
,[zav_keysupportcontactyominame]
,[zav_legalownerprimarycontactname]
,[zav_legalownerprimarycontactyominame]
,[zav_maintenanceid]
,[zav_maintenancetaskid]
,[zav_maintenancetypecode]
,[zav_maintenancetypename]
,[zav_name]
,[zav_onholdcomments]
,[zav_otherinstructions]
,[zav_pricelistname]
,[zav_primarycontactname]
,[zav_primarycontactyominame]
,[zav_problemname]
,[zav_programname]
,[zav_propertymanagername]
,[zav_propertymanageryominame]
,[zav_reasonforcancelling]
,[zav_recoverydescription]
,[zav_remedyname]
,[zav_resolvebyfailuretime]
,[zav_resolvebyidname]
,[zav_responsebyfailuretime]
,[zav_revisedfromworktaskname]
,[zav_serviceagreementname]
,[zav_servicename]
,[zav_subprogramname]
,[zav_tenancymanagername]
,[zav_tenancymanageryominame]
,[zav_tenantinvoice]
,[zav_tenantname]
,[zav_tenantsconfirmationdate]
,[zav_timespentmins]
,[zav_totalcappedamount_date]
,[zav_totalcappedamount_state]
,[zav_tradespersonalertsinstructions]
,[zav_tradespersonname]
,[zav_tradespersonyominame]
,[zav_tradetypename]
,[zav_webexpensesamount_date]
,[zav_webexpensesamount_state]
,[zav_workcompleted]
,[zav_worktypeidname]
,[IsDelete]
,[zav_approvalrequired]
,[zav_comments]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[new_type]
,[zav_acknowledgmenttype]
,[zav_contractorstatus]
,[zav_damagetype]
,[zav_doarequired]
,[zav_inventoryitem]
,[zav_keyaccessinformation]
,[zav_location]
,[zav_propertystatus]
,[zav_rectificationstatus]
,[zav_sendworkorderto]
,[zav_taskstatus]
,[zav_urgent]
,[zav_worktype]
,[zav_acknowledgementsentby]
,[new_completedbycontractor]
,[new_postinspectiondone]
,[new_tenantconsent]
,[zav_acknowledgmentsenttothetenant]
,[zav_cancelworktask]
,[zav_completedsatisfactorily]
,[zav_confirmedforpayment]
,[zav_dummycompletedbutkeeptaskstatus]
,[zav_ecdprocessedqueue]
,[zav_email]
,[zav_exported]
,[zav_finalisedworktask]
,[zav_flexifund]
,[zav_invoicedetailsprocessedqueue]
,[zav_letter]
,[zav_onhold]
,[zav_ownerrecovery]
,[zav_phonecall]
,[zav_requestreceivedsentprocessedqueue]
,[zav_sendemailnotificationwhenpfmcancelled]
,[zav_supportemail]
,[zav_suppresstenantemail]
,[zav_tenantdamage]
,[zav_tenantliable]
,[zav_tenantscharged]
,[zav_tenantspermission]
,[zav_textmessage]
,[zav_variationprocessedqueue]
,[zav_workquoteprocessedqueue]
,[zav_worktaskcompletionprocessedqueue]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[new_inspectionid]
,[new_inspectionid_entitytype]
,[new_officelocationid]
,[new_officelocationid_entitytype]
,[new_property]
,[new_property_entitytype]
,[owningbusinessunit]
,[owningbusinessunit_entitytype]
,[owningteam]
,[owningteam_entitytype]
,[owninguser]
,[owninguser_entitytype]
,[slaid]
,[slaid_entitytype]
,[slainvokedid]
,[slainvokedid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_acknowledgedby]
,[zav_acknowledgedby_entitytype]
,[zav_cancellationrequestedby]
,[zav_cancellationrequestedby_entitytype]
,[zav_cause]
,[zav_cause_entitytype]
,[zav_client]
,[zav_client_entitytype]
,[zav_doasettings]
,[zav_doasettings_entitytype]
,[zav_emergencyresponsewithin4hoursid]
,[zav_emergencyresponsewithin4hoursid_entitytype]
,[zav_housingofficer]
,[zav_housingofficer_entitytype]
,[zav_housingofficerid]
,[zav_housingofficerid_entitytype]
,[zav_invoiceapprovedby]
,[zav_invoiceapprovedby_entitytype]
,[zav_itemgroup]
,[zav_itemgroup_entitytype]
,[zav_itemtype]
,[zav_itemtype_entitytype]
,[zav_keysupportcontact]
,[zav_keysupportcontact_entitytype]
,[zav_legalownerprimarycontact]
,[zav_legalownerprimarycontact_entitytype]
,[zav_maintenancetype]
,[zav_maintenancetype_entitytype]
,[zav_pricelist]
,[zav_pricelist_entitytype]
,[zav_primarycontact]
,[zav_primarycontact_entitytype]
,[zav_problem]
,[zav_problem_entitytype]
,[zav_program]
,[zav_program_entitytype]
,[zav_propertymanager]
,[zav_propertymanager_entitytype]
,[zav_remedy]
,[zav_remedy_entitytype]
,[zav_resolvebyid]
,[zav_resolvebyid_entitytype]
,[zav_revisedfromworktask]
,[zav_revisedfromworktask_entitytype]
,[zav_serviceagreement]
,[zav_serviceagreement_entitytype]
,[zav_subprogram]
,[zav_subprogram_entitytype]
,[zav_tenancymanager]
,[zav_tenancymanager_entitytype]
,[zav_tenant]
,[zav_tenant_entitytype]
,[zav_tradesperson]
,[zav_tradesperson_entitytype]
,[zav_tradetype]
,[zav_tradetype_entitytype]
,[zav_worktypeid]
,[zav_worktypeid_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[crba8_invoicedto]
,[crba8_invoicedto_entitytype]
,[zav_actualcost]
,[zav_actualcost_base]
,[zav_actualgst]
,[zav_actualgst_base]
,[zav_amounttoberecovered]
,[zav_amounttoberecovered_base]
,[zav_amounttoberecoveredincgst]
,[zav_amounttoberecoveredincgst_base]
,[zav_balanceamount]
,[zav_balanceamount_base]
,[zav_budgetcost]
,[zav_budgetcost_base]
,[zav_budgetgst]
,[zav_budgetgst_base]
,[zav_estimatedcost]
,[zav_estimatedcost_base]
,[zav_estimatedgst]
,[zav_estimatedgst_base]
,[zav_flexifundamount]
,[zav_flexifundamount_base]
,[zav_invoicedamount]
,[zav_invoicedamount_base]
,[zav_pricevariance]
,[zav_pricevariance_base]
,[zav_totalcappedamount]
,[zav_totalcappedamount_base]
,[zav_webexpensesamount]
,[zav_webexpensesamount_base]
,[zav_workdetailstotal]
,[zav_workdetailstotal_base]
,[crba8_invoicedtoidtype]
,[crba8_invoicedtoname]
,[crba8_invoicedtoyominame]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[exchangerate]
,[importsequencenumber]
,[lastonholdtime]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[new_actualstartdate]
,[new_contractorcomment]
,[new_contractorworkcompletedcomments]
,[new_inspectionidname]
,[new_invoiceduedate]
,[new_officelocationidname]
,[new_order]
,[new_postinspectioncompleteddate]
,[new_primarycontactmobilephone]
,[new_propertyname]
,[new_reporteddate]
,[new_scheduledcompletiondate]
,[new_scheduledstartdate]
,[new_tenantconsentdate]
,[new_tradespersonorder]
,[onholdtime]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[processid]
,[slaidname]
,[slainvokedidname]
,[stageid]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[traversedpath]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_accessinstructions]
,[zav_acknowledgedbyname]
,[zav_acknowledgedbyyominame]
,[zav_acknowledgmentdateandtime]
,[zav_acknowledgmentenddateandtime]
,[zav_actualcompletiondate]
,[zav_cancellationrequestedbyname]
,[zav_cancellationrequestedbyyominame]
,[zav_causename]
,[zav_clientname]
,[zav_clientyominame]
,[zav_completedorder]
,[zav_contractorstatusdateandtime]
,[zav_contractorworkcompletiondate]
,[zav_countcompletedworktasks]
,[zav_doasettingsname]
,[zav_emergencyresponsewithin4hoursidname]
,[zav_expectedcompletiondate]
,[zav_expectedonsitedate]
,[zav_flexifundtext]
,[zav_housingofficeridname]
,[zav_housingofficeridyominame]
,[zav_housingofficername]
,[zav_housingofficeryominame]
,[zav_housingworkerchintaro]
,[zav_icodes]
,[zav_instructions]
,[zav_invoiceapprovedbyname]
,[zav_invoiceapprovedbyyominame]
,[zav_invoicenumber]
,[zav_invoicepaiddate]
,[zav_itemgroupname]
,[zav_itemtypename]
,[zav_keysupportcontactname]
,[zav_keysupportcontactyominame]
,[zav_legalownerprimarycontactname]
,[zav_legalownerprimarycontactyominame]
,[zav_maintenanceid]
,[zav_maintenancetaskid]
,[zav_maintenancetypecode]
,[zav_maintenancetypename]
,[zav_name]
,[zav_onholdcomments]
,[zav_otherinstructions]
,[zav_pricelistname]
,[zav_primarycontactname]
,[zav_primarycontactyominame]
,[zav_problemname]
,[zav_programname]
,[zav_propertymanagername]
,[zav_propertymanageryominame]
,[zav_reasonforcancelling]
,[zav_recoverydescription]
,[zav_remedyname]
,[zav_resolvebyfailuretime]
,[zav_resolvebyidname]
,[zav_responsebyfailuretime]
,[zav_revisedfromworktaskname]
,[zav_serviceagreementname]
,[zav_servicename]
,[zav_subprogramname]
,[zav_tenancymanagername]
,[zav_tenancymanageryominame]
,[zav_tenantinvoice]
,[zav_tenantname]
,[zav_tenantsconfirmationdate]
,[zav_timespentmins]
,[zav_totalcappedamount_date]
,[zav_totalcappedamount_state]
,[zav_tradespersonalertsinstructions]
,[zav_tradespersonname]
,[zav_tradespersonyominame]
,[zav_tradetypename]
,[zav_webexpensesamount_date]
,[zav_webexpensesamount_state]
,[zav_workcompleted]
,[zav_worktypeidname]
,[IsDelete]
,[zav_approvalrequired]
,[zav_comments]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_maintenancetask/*.csv',FORMAT = 'CSV',
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
,[new_type] [bigint]
,[zav_acknowledgmenttype] [bigint]
,[zav_contractorstatus] [bigint]
,[zav_damagetype] [bigint]
,[zav_doarequired] [bigint]
,[zav_inventoryitem] [bigint]
,[zav_keyaccessinformation] [bigint]
,[zav_location] [bigint]
,[zav_propertystatus] [bigint]
,[zav_rectificationstatus] [bigint]
,[zav_sendworkorderto] [bigint]
,[zav_taskstatus] [bigint]
,[zav_urgent] [bigint]
,[zav_worktype] [bigint]
,[zav_acknowledgementsentby] [varchar](8000)
,[new_completedbycontractor] [varchar](6)
,[new_postinspectiondone] [varchar](6)
,[new_tenantconsent] [varchar](6)
,[zav_acknowledgmentsenttothetenant] [varchar](6)
,[zav_cancelworktask] [varchar](6)
,[zav_completedsatisfactorily] [varchar](6)
,[zav_confirmedforpayment] [varchar](6)
,[zav_dummycompletedbutkeeptaskstatus] [varchar](6)
,[zav_ecdprocessedqueue] [varchar](6)
,[zav_email] [varchar](6)
,[zav_exported] [varchar](6)
,[zav_finalisedworktask] [varchar](6)
,[zav_flexifund] [varchar](6)
,[zav_invoicedetailsprocessedqueue] [varchar](6)
,[zav_letter] [varchar](6)
,[zav_onhold] [varchar](6)
,[zav_ownerrecovery] [varchar](6)
,[zav_phonecall] [varchar](6)
,[zav_requestreceivedsentprocessedqueue] [varchar](6)
,[zav_sendemailnotificationwhenpfmcancelled] [varchar](6)
,[zav_supportemail] [varchar](6)
,[zav_suppresstenantemail] [varchar](6)
,[zav_tenantdamage] [varchar](6)
,[zav_tenantliable] [varchar](6)
,[zav_tenantscharged] [varchar](6)
,[zav_tenantspermission] [varchar](6)
,[zav_textmessage] [varchar](6)
,[zav_variationprocessedqueue] [varchar](6)
,[zav_workquoteprocessedqueue] [varchar](6)
,[zav_worktaskcompletionprocessedqueue] [varchar](6)
,[createdby] [uniqueidentifier]
,[createdby_entitytype] [varchar](256)
,[createdonbehalfby] [uniqueidentifier]
,[createdonbehalfby_entitytype] [varchar](256)
,[modifiedby] [uniqueidentifier]
,[modifiedby_entitytype] [varchar](256)
,[modifiedonbehalfby] [uniqueidentifier]
,[modifiedonbehalfby_entitytype] [varchar](256)
,[new_inspectionid] [uniqueidentifier]
,[new_inspectionid_entitytype] [varchar](256)
,[new_officelocationid] [uniqueidentifier]
,[new_officelocationid_entitytype] [varchar](256)
,[new_property] [uniqueidentifier]
,[new_property_entitytype] [varchar](256)
,[owningbusinessunit] [uniqueidentifier]
,[owningbusinessunit_entitytype] [varchar](256)
,[owningteam] [uniqueidentifier]
,[owningteam_entitytype] [varchar](256)
,[owninguser] [uniqueidentifier]
,[owninguser_entitytype] [varchar](256)
,[slaid] [uniqueidentifier]
,[slaid_entitytype] [varchar](256)
,[slainvokedid] [uniqueidentifier]
,[slainvokedid_entitytype] [varchar](256)
,[transactioncurrencyid] [uniqueidentifier]
,[transactioncurrencyid_entitytype] [varchar](256)
,[zav_acknowledgedby] [uniqueidentifier]
,[zav_acknowledgedby_entitytype] [varchar](256)
,[zav_cancellationrequestedby] [uniqueidentifier]
,[zav_cancellationrequestedby_entitytype] [varchar](256)
,[zav_cause] [uniqueidentifier]
,[zav_cause_entitytype] [varchar](256)
,[zav_client] [uniqueidentifier]
,[zav_client_entitytype] [varchar](256)
,[zav_doasettings] [uniqueidentifier]
,[zav_doasettings_entitytype] [varchar](256)
,[zav_emergencyresponsewithin4hoursid] [uniqueidentifier]
,[zav_emergencyresponsewithin4hoursid_entitytype] [varchar](256)
,[zav_housingofficer] [uniqueidentifier]
,[zav_housingofficer_entitytype] [varchar](256)
,[zav_housingofficerid] [uniqueidentifier]
,[zav_housingofficerid_entitytype] [varchar](256)
,[zav_invoiceapprovedby] [uniqueidentifier]
,[zav_invoiceapprovedby_entitytype] [varchar](256)
,[zav_itemgroup] [uniqueidentifier]
,[zav_itemgroup_entitytype] [varchar](256)
,[zav_itemtype] [uniqueidentifier]
,[zav_itemtype_entitytype] [varchar](256)
,[zav_keysupportcontact] [uniqueidentifier]
,[zav_keysupportcontact_entitytype] [varchar](256)
,[zav_legalownerprimarycontact] [uniqueidentifier]
,[zav_legalownerprimarycontact_entitytype] [varchar](256)
,[zav_maintenancetype] [uniqueidentifier]
,[zav_maintenancetype_entitytype] [varchar](256)
,[zav_pricelist] [uniqueidentifier]
,[zav_pricelist_entitytype] [varchar](256)
,[zav_primarycontact] [uniqueidentifier]
,[zav_primarycontact_entitytype] [varchar](256)
,[zav_problem] [uniqueidentifier]
,[zav_problem_entitytype] [varchar](256)
,[zav_program] [uniqueidentifier]
,[zav_program_entitytype] [varchar](256)
,[zav_propertymanager] [uniqueidentifier]
,[zav_propertymanager_entitytype] [varchar](256)
,[zav_remedy] [uniqueidentifier]
,[zav_remedy_entitytype] [varchar](256)
,[zav_resolvebyid] [uniqueidentifier]
,[zav_resolvebyid_entitytype] [varchar](256)
,[zav_revisedfromworktask] [uniqueidentifier]
,[zav_revisedfromworktask_entitytype] [varchar](256)
,[zav_serviceagreement] [uniqueidentifier]
,[zav_serviceagreement_entitytype] [varchar](256)
,[zav_subprogram] [uniqueidentifier]
,[zav_subprogram_entitytype] [varchar](256)
,[zav_tenancymanager] [uniqueidentifier]
,[zav_tenancymanager_entitytype] [varchar](256)
,[zav_tenant] [uniqueidentifier]
,[zav_tenant_entitytype] [varchar](256)
,[zav_tradesperson] [uniqueidentifier]
,[zav_tradesperson_entitytype] [varchar](256)
,[zav_tradetype] [uniqueidentifier]
,[zav_tradetype_entitytype] [varchar](256)
,[zav_worktypeid] [uniqueidentifier]
,[zav_worktypeid_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[crba8_invoicedto] [uniqueidentifier]
,[crba8_invoicedto_entitytype] [varchar](256)
,[zav_actualcost] [decimal](38,4)
,[zav_actualcost_base] [decimal](38,4)
,[zav_actualgst] [decimal](38,4)
,[zav_actualgst_base] [decimal](38,4)
,[zav_amounttoberecovered] [decimal](38,4)
,[zav_amounttoberecovered_base] [decimal](38,4)
,[zav_amounttoberecoveredincgst] [decimal](38,0)
,[zav_amounttoberecoveredincgst_base] [decimal](38,0)
,[zav_balanceamount] [decimal](38,4)
,[zav_balanceamount_base] [decimal](38,4)
,[zav_budgetcost] [decimal](38,4)
,[zav_budgetcost_base] [decimal](38,4)
,[zav_budgetgst] [decimal](38,4)
,[zav_budgetgst_base] [decimal](38,4)
,[zav_estimatedcost] [decimal](38,2)
,[zav_estimatedcost_base] [decimal](38,2)
,[zav_estimatedgst] [decimal](38,2)
,[zav_estimatedgst_base] [decimal](38,2)
,[zav_flexifundamount] [decimal](38,4)
,[zav_flexifundamount_base] [decimal](38,4)
,[zav_invoicedamount] [decimal](38,2)
,[zav_invoicedamount_base] [decimal](38,2)
,[zav_pricevariance] [decimal](38,4)
,[zav_pricevariance_base] [decimal](38,4)
,[zav_totalcappedamount] [decimal](38,2)
,[zav_totalcappedamount_base] [decimal](38,2)
,[zav_webexpensesamount] [decimal](38,2)
,[zav_webexpensesamount_base] [decimal](38,2)
,[zav_workdetailstotal] [decimal](38,4)
,[zav_workdetailstotal_base] [decimal](38,4)
,[crba8_invoicedtoidtype] [varchar](8000)
,[crba8_invoicedtoname] [varchar](max)
,[crba8_invoicedtoyominame] [varchar](max)
,[createdbyname] [varchar](1026)
,[createdbyyominame] [varchar](1026)
,[createdon] [datetimeoffset](7)
,[createdonbehalfbyname] [varchar](1026)
,[createdonbehalfbyyominame] [varchar](1026)
,[exchangerate] [decimal](38,10)
,[importsequencenumber] [bigint]
,[lastonholdtime] [datetime2](7)
,[modifiedbyname] [varchar](1026)
,[modifiedbyyominame] [varchar](1026)
,[modifiedon] [datetime2](7)
,[modifiedonbehalfbyname] [varchar](1026)
,[modifiedonbehalfbyyominame] [varchar](1026)
,[new_actualstartdate] [datetime2](7)
,[new_contractorcomment] [varchar](max)
,[new_contractorworkcompletedcomments] [varchar](max)
,[new_inspectionidname] [varchar](800)
,[new_invoiceduedate] [datetime2](7)
,[new_officelocationidname] [varchar](400)
,[new_order] [varchar](400)
,[new_postinspectioncompleteddate] [datetime2](7)
,[new_primarycontactmobilephone] [varchar](400)
,[new_propertyname] [varchar](400)
,[new_reporteddate] [datetime2](7)
,[new_scheduledcompletiondate] [datetime2](7)
,[new_scheduledstartdate] [datetime2](7)
,[new_tenantconsentdate] [datetime2](7)
,[new_tradespersonorder] [varchar](400)
,[onholdtime] [bigint]
,[overriddencreatedon] [datetime2](7)
,[owneridname] [varchar](640)
,[owneridtype] [varchar](8000)
,[owneridyominame] [varchar](640)
,[owningbusinessunitname] [varchar](640)
,[processid] [uniqueidentifier]
,[slaidname] [varchar](400)
,[slainvokedidname] [varchar](max)
,[stageid] [uniqueidentifier]
,[timezoneruleversionnumber] [bigint]
,[transactioncurrencyidname] [varchar](400)
,[traversedpath] [varchar](5000)
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[zav_accessinstructions] [varchar](max)
,[zav_acknowledgedbyname] [varchar](1026)
,[zav_acknowledgedbyyominame] [varchar](1026)
,[zav_acknowledgmentdateandtime] [datetime2](7)
,[zav_acknowledgmentenddateandtime] [datetime2](7)
,[zav_actualcompletiondate] [datetime2](7)
,[zav_cancellationrequestedbyname] [varchar](1026)
,[zav_cancellationrequestedbyyominame] [varchar](1026)
,[zav_causename] [varchar](400)
,[zav_clientname] [varchar](640)
,[zav_clientyominame] [varchar](1800)
,[zav_completedorder] [bigint]
,[zav_contractorstatusdateandtime] [datetime2](7)
,[zav_contractorworkcompletiondate] [datetime2](7)
,[zav_countcompletedworktasks] [bigint]
,[zav_doasettingsname] [varchar](400)
,[zav_emergencyresponsewithin4hoursidname] [varchar](640)
,[zav_expectedcompletiondate] [datetime2](7)
,[zav_expectedonsitedate] [datetime2](7)
,[zav_flexifundtext] [varchar](max)
,[zav_housingofficeridname] [varchar](1026)
,[zav_housingofficeridyominame] [varchar](1026)
,[zav_housingofficername] [varchar](640)
,[zav_housingofficeryominame] [varchar](1800)
,[zav_housingworkerchintaro] [varchar](200)
,[zav_icodes] [varchar](max)
,[zav_instructions] [varchar](max)
,[zav_invoiceapprovedbyname] [varchar](1026)
,[zav_invoiceapprovedbyyominame] [varchar](1026)
,[zav_invoicenumber] [varchar](400)
,[zav_invoicepaiddate] [datetime2](7)
,[zav_itemgroupname] [varchar](400)
,[zav_itemtypename] [varchar](400)
,[zav_keysupportcontactname] [varchar](640)
,[zav_keysupportcontactyominame] [varchar](1800)
,[zav_legalownerprimarycontactname] [varchar](640)
,[zav_legalownerprimarycontactyominame] [varchar](1800)
,[zav_maintenanceid] [varchar](400)
,[zav_maintenancetaskid] [uniqueidentifier]
,[zav_maintenancetypecode] [varchar](400)
,[zav_maintenancetypename] [varchar](400)
,[zav_name] [varchar](400)
,[zav_onholdcomments] [varchar](400)
,[zav_otherinstructions] [varchar](max)
,[zav_pricelistname] [varchar](400)
,[zav_primarycontactname] [varchar](640)
,[zav_primarycontactyominame] [varchar](1800)
,[zav_problemname] [varchar](400)
,[zav_programname] [varchar](400)
,[zav_propertymanagername] [varchar](1026)
,[zav_propertymanageryominame] [varchar](1026)
,[zav_reasonforcancelling] [varchar](800)
,[zav_recoverydescription] [varchar](800)
,[zav_remedyname] [varchar](400)
,[zav_resolvebyfailuretime] [datetime2](7)
,[zav_resolvebyidname] [varchar](640)
,[zav_responsebyfailuretime] [datetime2](7)
,[zav_revisedfromworktaskname] [varchar](400)
,[zav_serviceagreementname] [varchar](400)
,[zav_servicename] [varchar](400)
,[zav_subprogramname] [varchar](400)
,[zav_tenancymanagername] [varchar](1026)
,[zav_tenancymanageryominame] [varchar](1026)
,[zav_tenantinvoice] [varchar](400)
,[zav_tenantname] [varchar](1200)
,[zav_tenantsconfirmationdate] [datetime2](7)
,[zav_timespentmins] [bigint]
,[zav_totalcappedamount_date] [datetime2](7)
,[zav_totalcappedamount_state] [bigint]
,[zav_tradespersonalertsinstructions] [varchar](max)
,[zav_tradespersonname] [varchar](640)
,[zav_tradespersonyominame] [varchar](640)
,[zav_tradetypename] [varchar](400)
,[zav_webexpensesamount_date] [datetime2](7)
,[zav_webexpensesamount_state] [bigint]
,[zav_workcompleted] [varchar](max)
,[zav_worktypeidname] [varchar](400)
,[IsDelete] [varchar](6)
,[zav_approvalrequired] [varchar](6)
,[zav_comments] [varchar](4000)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record