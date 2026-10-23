CREATE VIEW [Zavanti].[vw_opportunity]  AS    
SELECT  
[Id] 
,[SinkCreatedOn] 
,[SinkModifiedOn] 
,[statecode] 
,[statuscode] 
,[budgetstatus] 
,[initialcommunication] 
,[msdyn_forecastcategory] 
,[msdyn_opportunitygrade] 
,[msdyn_opportunityscoretrend] 
,[msft_datastate] 
,[need] 
,[new_applicationtype] 
,[new_nonerentarrearsplan] 
,[new_rentarrearsplan] 
,[opportunityratingcode] 
,[pricingerrorcode] 
,[prioritycode] 
,[purchaseprocess] 
,[purchasetimeframe] 
,[salesstage] 
,[salesstagecode] 
,[skippricecalculation] 
,[timeline] 
,[zav_arrearsarrangementbeenactivatedinzavanti] 
,[zav_arrearsarrangementbeensignedwiththeclient] 
,[zav_band] 
,[zav_bondrefundsngclaimcompleted] 
,[zav_bondrefundsngclaimlodged] 
,[zav_chadefinedtenancyfailure] 
,[zav_chpinitiatedtransfertype] 
,[zav_complexityofneed] 
,[zav_correspondenceaddressedcoappstate] 
,[zav_correspondenceaddressedmainappstate] 
,[zav_exitpoint] 
,[zav_expectedpaymentday] 
,[zav_expectedpaymentfrequency] 
,[zav_fixedterm] 
,[zav_frequency] 
,[zav_hastenantrescindednoticetovacate] 
,[zav_hpftenancy] 
,[zav_inadvanceflag] 
,[zav_inapphousednoofbedroomsreqd] 
,[zav_inputrequiredfromcort] 
,[zav_jwlallocation] 
,[zav_leavingreason] 
,[zav_maintenancefundclaimcompleted] 
,[zav_maintenancefundclaimlodgedwithhud] 
,[zav_nahaevortype] 
,[zav_paymenttype] 
,[zav_potentialdogflag] 
,[zav_prioritywaitturnaffordable] 
,[zav_rebatestatus] 
,[zav_refundreason] 
,[zav_rentchargedday] 
,[zav_rentpaidinadvance] 
,[zav_routineinspectionfrequency] 
,[zav_specialneedsgrantgenerated] 
,[zav_splitfrequency] 
,[zav_sustainabilityoftenancy] 
,[zav_tenancyappropriatelyreason] 
,[zav_tenancyappropriatelystatus] 
,[zav_tenancybondrefundformhasbeencompleted] 
,[zav_tenancybondrefundformlodgedwithts] 
,[zav_tenancyprogramme] 
,[zav_tenancyroomstatus] 
,[zav_tenancysource] 
,[zav_tenancytype] 
,[zav_transfertype] 
,[zav_weeksbondisbeingaskedfor] 
,[zav_writeoffrequired] 
,[zav_riskstotenantsustainability] 
,[zav_specialneedsofthetenant1] 
,[zav_specialneedsofthetenant2] 
,[captureproposalfeedback] 
,[completefinalproposal] 
,[completeinternalreview] 
,[confirminterest] 
,[crba8_navigatornotified] 
,[decisionmaker] 
,[developproposal] 
,[evaluatefit] 
,[filedebrief] 
,[identifycompetitors] 
,[identifycustomercontacts] 
,[identifypursuitteam] 
,[isprivate] 
,[isrevenuesystemcalculated] 
,[msdyn_gdproptout] 
,[new_activatetenancy] 
,[new_interpretorrequired] 
,[new_isthisapartnershiparrangement] 
,[new_keysreceivedfromtenant] 
,[new_potentialrisktostaff] 
,[participatesinworkflow] 
,[presentfinalproposal] 
,[presentproposal] 
,[pursuitdecision] 
,[resolvefeedback] 
,[sendthankyounote] 
,[zav_agreementtoextendthetenancyreceived] 
,[zav_bondguaranteeinformationprovided] 
,[zav_bondinformationentered] 
,[zav_bondloan] 
,[zav_bondlodgementcomplete] 
,[zav_checkedforothertenancieswithbalancesdue] 
,[zav_checkthatbodycorporresidents] 
,[zav_consenttoholdpersonalinformation] 
,[zav_expectedpaymentdatecorrect] 
,[zav_expectedpaymentdaycheckbox] 
,[zav_familiarwithsupportsneighbours] 
,[zav_firstinspectionscheduled] 
,[zav_followedmarketrentreviewinbos] 
,[zav_guidanceonrentpaymentprocess] 
,[zav_householdcompositioncorrect] 
,[zav_householdmemberscorrect] 
,[zav_ignorecreatevoidchecklist] 
,[zav_ingoingpropertyconditionreport] 
,[zav_ingoingtenancyinspectionpropertycondition] 
,[zav_insulationstatement] 
,[zav_insurancestatement] 
,[zav_invoicesforfinalchargestotenantadded] 
,[zav_isanytenantundertheageof18] 
,[zav_isthisapartnershiparrangement] 
,[zav_isthistenancyappropriatelyhoused] 
,[zav_keyshandedoveratthesigningofthetenancyagr] 
,[zav_leaseagreement] 
,[zav_marketrenter] 
,[zav_msdnotifiedtostopredirection] 
,[zav_msdreferralletterreceived] 
,[zav_offboardingactivitiescompleted] 
,[zav_offertenantredirectionforwaterpayment] 
,[zav_pcrsigned] 
,[zav_petauthorisationpaperworkcompleted] 
,[zav_previoustenancyfinalised] 
,[zav_primarysupportneedsentered] 
,[zav_providehealthanddisabilityinformation] 
,[zav_providetenancypack] 
,[zav_risksentered] 
,[zav_routineinspectionfrequencycheckbox] 
,[zav_setupinspectiondatechecknextinspectiondat] 
,[zav_setupofrentreviewdates] 
,[zav_signedmsdresponsibilitiesconditions] 
,[zav_signedsngforms] 
,[zav_subsidy] 
,[zav_supportpeopleandemergencycontactsuptodate] 
,[zav_tenancycontributionrenthasbeensetup] 
,[zav_tenancyinitialassessmentcompleted] 
,[zav_tenancyprogrammecorrect] 
,[zav_tenancystartedinboswithallcorrectdetails] 
,[zav_tenantconfirmedcondition] 
,[zav_tenantconfirmsingoinginventorylist] 
,[zav_transfer] 
,[zav_understandsoohprocess] 
,[zav_vacateconfirmation] 
,[zav_washouseholdingreatestneed] 
,[zav_wastenanthomeless] 
,[zav_waterredirectionstarted] 
,[zav_welcomevisitcomplete] 
,[accountid] 
,[accountid_entitytype] 
,[campaignid] 
,[campaignid_entitytype] 
,[contactid] 
,[contactid_entitytype] 
,[crba8_navigatornotifiedby] 
,[crba8_navigatornotifiedby_entitytype] 
,[createdby] 
,[createdby_entitytype] 
,[createdonbehalfby] 
,[createdonbehalfby_entitytype] 
,[modifiedby] 
,[modifiedby_entitytype] 
,[modifiedonbehalfby] 
,[modifiedonbehalfby_entitytype] 
,[msdyn_opportunitykpiid] 
,[msdyn_opportunitykpiid_entitytype] 
,[msdyn_predictivescoreid] 
,[msdyn_predictivescoreid_entitytype] 
,[msdyn_segmentid] 
,[msdyn_segmentid_entitytype] 
,[new_emergencycontactrelationship1] 
,[new_emergencycontactrelationship1_entitytype] 
,[new_emergencycontactrelationship1_new] 
,[new_emergencycontactrelationship1_new_entitytype] 
,[new_emergencycontactrelationship2] 
,[new_emergencycontactrelationship2_entitytype] 
,[new_emergencycontactrelationship2_new] 
,[new_emergencycontactrelationship2_new_entitytype] 
,[originatingleadid] 
,[originatingleadid_entitytype] 
,[owningbusinessunit] 
,[owningbusinessunit_entitytype] 
,[owningteam] 
,[owningteam_entitytype] 
,[owninguser] 
,[owninguser_entitytype] 
,[parentaccountid] 
,[parentaccountid_entitytype] 
,[parentcontactid] 
,[parentcontactid_entitytype] 
,[pricelevelid] 
,[pricelevelid_entitytype] 
,[slaid] 
,[slaid_entitytype] 
,[slainvokedid] 
,[slainvokedid_entitytype] 
,[transactioncurrencyid] 
,[transactioncurrencyid_entitytype] 
,[zav_activatetenancyby] 
,[zav_activatetenancyby_entitytype] 
,[zav_bondguaranteeinformationprovidedby] 
,[zav_bondguaranteeinformationprovidedby_entitytype] 
,[zav_checkthatbodycorporresidentsuser] 
,[zav_checkthatbodycorporresidentsuser_entitytype] 
,[zav_consenttoholdpersonalinformationby] 
,[zav_consenttoholdpersonalinformationby_entitytype] 
,[zav_correspondenceaddressedcoappcity] 
,[zav_correspondenceaddressedcoappcity_entitytype] 
,[zav_correspondenceaddressedcoappregion] 
,[zav_correspondenceaddressedcoappregion_entitytype] 
,[zav_correspondenceaddressedmainappcity] 
,[zav_correspondenceaddressedmainappcity_entitytype] 
,[zav_correspondenceaddressedmainappregion] 
,[zav_correspondenceaddressedmainappregion_entitytype] 
,[zav_expectedpaymentdayby] 
,[zav_expectedpaymentdayby_entitytype] 
,[zav_followedmarketrentreviewinbosuser] 
,[zav_followedmarketrentreviewinbosuser_entitytype] 
,[zav_forwardingaddresscity] 
,[zav_forwardingaddresscity_entitytype] 
,[zav_forwardingaddressregion] 
,[zav_forwardingaddressregion_entitytype] 
,[zav_guidanceonrentpaymentprocessby] 
,[zav_guidanceonrentpaymentprocessby_entitytype] 
,[zav_household] 
,[zav_household_entitytype] 
,[zav_householdcompositioncorrectby] 
,[zav_householdcompositioncorrectby_entitytype] 
,[zav_ingoingpropertyconditionreportby] 
,[zav_ingoingpropertyconditionreportby_entitytype] 
,[zav_ingoingtenancyinspectionpropertyuser] 
,[zav_ingoingtenancyinspectionpropertyuser_entitytype] 
,[zav_insulationstatementby] 
,[zav_insulationstatementby_entitytype] 
,[zav_insurancestatementby] 
,[zav_insurancestatementby_entitytype] 
,[zav_keyshandedoveratthesigningofthetenancyby] 
,[zav_keyshandedoveratthesigningofthetenancyby_entitytype] 
,[zav_leaseagreementby] 
,[zav_leaseagreementby_entitytype] 
,[zav_offertenantredirectionforwaterpaymentuser] 
,[zav_offertenantredirectionforwaterpaymentuser_entitytype] 
,[zav_program] 
,[zav_program_entitytype] 
,[zav_property] 
,[zav_property_entitytype] 
,[zav_providehealthanddisabilityinformationuser] 
,[zav_providehealthanddisabilityinformationuser_entitytype] 
,[zav_providetenancypackby] 
,[zav_providetenancypackby_entitytype] 
,[zav_routineinspectionfrequencyby] 
,[zav_routineinspectionfrequencyby_entitytype] 
,[zav_secondclient] 
,[zav_secondclient_entitytype] 
,[zav_setupinspectiondateby] 
,[zav_setupinspectiondateby_entitytype] 
,[zav_setupofrentreviewdatesby] 
,[zav_setupofrentreviewdatesby_entitytype] 
,[zav_signedmsdresponsibilitiesconditionsuser] 
,[zav_signedmsdresponsibilitiesconditionsuser_entitytype] 
,[zav_signedsngformsuser] 
,[zav_signedsngformsuser_entitytype] 
,[zav_subprogram] 
,[zav_subprogram_entitytype] 
,[zav_supportpeopleandemergencyuser] 
,[zav_supportpeopleandemergencyuser_entitytype] 
,[zav_tenancyappropriatelyuser] 
,[zav_tenancyappropriatelyuser_entitytype] 
,[zav_tenancycontributionrenthasbeensetupuser] 
,[zav_tenancycontributionrenthasbeensetupuser_entitytype] 
,[zav_tenancymanager] 
,[zav_tenancymanager_entitytype] 
,[zav_tenancymanagerid] 
,[zav_tenancymanagerid_entitytype] 
,[zav_tenancystartedinboswithcorrectdetailsuser] 
,[zav_tenancystartedinboswithcorrectdetailsuser_entitytype] 
,[zav_tenancytypeid] 
,[zav_tenancytypeid_entitytype] 
,[zav_tenantconfirmedconditionby] 
,[zav_tenantconfirmedconditionby_entitytype] 
,[zav_tenantconfirmsingoinginventorylistuser] 
,[zav_tenantconfirmsingoinginventorylistuser_entitytype] 
,[zav_transferapplication] 
,[zav_transferapplication_entitytype] 
,[zav_transfertotenancy] 
,[zav_transfertotenancy_entitytype] 
,[zav_voidcategory] 
,[zav_voidcategory_entitytype] 
,[zav_voidchecklist] 
,[zav_voidchecklist_entitytype] 
,[zav_voidproperty] 
,[zav_voidproperty_entitytype] 
,[ownerid] 
,[ownerid_entitytype] 
,[customerid] 
,[customerid_entitytype] 
,[actualvalue] 
,[actualvalue_base] 
,[budgetamount] 
,[budgetamount_base] 
,[discountamount] 
,[discountamount_base] 
,[estimatedvalue] 
,[estimatedvalue_base] 
,[freightamount] 
,[freightamount_base] 
,[new_bondbalance] 
,[new_bondbalance_base] 
,[new_newrent] 
,[new_newrent_base] 
,[new_nonrent] 
,[new_nonrent_base] 
,[new_rent] 
,[new_rent_base] 
,[new_transactionbalancetotal] 
,[new_transactionbalancetotal_base] 
,[totalamount] 
,[totalamount_base] 
,[totalamountlessfreight] 
,[totalamountlessfreight_base] 
,[totaldiscountamount] 
,[totaldiscountamount_base] 
,[totallineitemamount] 
,[totallineitemamount_base] 
,[totallineitemdiscountamount] 
,[totallineitemdiscountamount_base] 
,[totaltax] 
,[totaltax_base] 
,[zav_approvedsngcap] 
,[zav_approvedsngcap_base] 
,[zav_balancewithtenancyservices] 
,[zav_balancewithtenancyservices_base] 
,[zav_bondamount] 
,[zav_bondamount_base] 
,[zav_chintarobondamount] 
,[zav_chintarobondamount_base] 
,[zav_expectedbondamount] 
,[zav_expectedbondamount_base] 
,[zav_inhand] 
,[zav_inhand_base] 
,[zav_marketrent] 
,[zav_marketrent_base] 
,[zav_newestrentupdate] 
,[zav_newestrentupdate_base] 
,[zav_refundrequired] 
,[zav_refundrequired_base] 
,[zav_rentowesasofexpectedvacatedate] 
,[zav_rentowesasofexpectedvacatedate_base] 
,[zav_rentpayable] 
,[zav_rentpayable_base] 
,[zav_rentpayablebasicrentcraweekly] 
,[zav_rentpayablebasicrentcraweekly_base] 
,[zav_totalotherandamenities] 
,[zav_totalotherandamenities_base] 
,[zav_totalrentamount] 
,[zav_totalrentamount_base] 
,[zav_totaltenantliabilityamount] 
,[zav_totaltenantliabilityamount_base] 
,[zav_totalutilitiesamount] 
,[zav_totalutilitiesamount_base] 
,[zav_totalwateramount] 
,[zav_totalwateramount_base] 
,[accountidname] 
,[accountidyominame] 
,[actualclosedate] 
,[campaignidname] 
,[closeprobability] 
,[contactidname] 
,[contactidyominame] 
,[crba8_navigatornotifiedbyname] 
,[crba8_navigatornotifiedbyyominame] 
,[crba8_navigatornotifiedon] 
,[createdbyname] 
,[createdbyyominame] 
,[createdon] 
,[createdonbehalfbyname] 
,[createdonbehalfbyyominame] 
,[currentsituation] 
,[customeridname] 
,[customeridtype] 
,[customeridyominame] 
,[customerneed] 
,[customerpainpoints] 
,[description] 
,[discountpercentage] 
,[emailaddress] 
,[estimatedclosedate] 
,[exchangerate] 
,[finaldecisiondate] 
,[importsequencenumber] 
,[lastonholdtime] 
,[modifiedbyname] 
,[modifiedbyyominame] 
,[modifiedon] 
,[modifiedonbehalfbyname] 
,[modifiedonbehalfbyyominame] 
,[msdyn_opportunitykpiidname] 
,[msdyn_opportunityscore] 
,[msdyn_predictivescoreidname] 
,[msdyn_scorehistory] 
,[msdyn_scorereasons] 
,[msdyn_segmentidname] 
,[msdyn_similaropportunities] 
,[name] 
,[new_deadlineforpaymenttoba] 
,[new_effectivenewrentstartdate] 
,[new_emergencycontactmobile1] 
,[new_emergencycontactmobile2] 
,[new_emergencycontactname1] 
,[new_emergencycontactname2] 
,[new_emergencycontactrelationship1_newname] 
,[new_emergencycontactrelationship1name] 
,[new_emergencycontactrelationship2_newname] 
,[new_emergencycontactrelationship2name] 
,[new_exitcomment] 
,[new_keysreceivedfromtenantdate] 
,[new_nobedroomsexitedto] 
,[new_nonrent_date] 
,[new_nonrent_state] 
,[new_rent_date] 
,[new_rent_state] 
,[new_riskslist] 
,[new_tenant1mobilephone] 
,[new_tenant2mobilephone] 
,[new_test] 
,[onholdtime] 
,[opportunityid] 
,[originatingleadidname] 
,[originatingleadidyominame] 
,[overriddencreatedon] 
,[owneridname] 
,[owneridtype] 
,[owneridyominame] 
,[owningbusinessunitname] 
,[parentaccountidname] 
,[parentaccountidyominame] 
,[parentcontactidname] 
,[parentcontactidyominame] 
,[pricelevelidname] 
,[processid] 
,[proposedsolution] 
,[qualificationcomments] 
,[quotecomments] 
,[schedulefollowup_prospect] 
,[schedulefollowup_qualify] 
,[scheduleproposalmeeting] 
,[slainvokedidname] 
,[slaname] 
,[stageid] 
,[stepid] 
,[stepname] 
,[teamsfollowed] 
,[timespentbymeonemailandmeetings] 
,[timezoneruleversionnumber] 
,[transactioncurrencyidname] 
,[traversedpath] 
,[utcconversiontimezonecode] 
,[versionnumber] 
,[zav_accrisstartdate] 
,[zav_activatetenancybyname] 
,[zav_activatetenancybyyominame] 
,[zav_activatetenancydate] 
,[zav_actualstartdate] 
,[zav_bondcomments] 
,[zav_bondguaranteeinformationprovidedbyname] 
,[zav_bondguaranteeinformationprovidedbyyominame] 
,[zav_bondguaranteeinformationprovideddate] 
,[zav_bondlodged] 
,[zav_bondreference] 
,[zav_bondrefundformlodged] 
,[zav_checkthatbodycorporresidentsdate] 
,[zav_checkthatbodycorporresidentsusername] 
,[zav_checkthatbodycorporresidentsuseryominame] 
,[zav_chintaroid] 
,[zav_comments] 
,[zav_commenttofinance] 
,[zav_consenttoholdpersonalinformationbyname] 
,[zav_consenttoholdpersonalinformationbyyominame] 
,[zav_consenttoholdpersonalinformationdate] 
,[zav_correspondenceaddressedcoappcityname] 
,[zav_correspondenceaddressedcoapppostcode] 
,[zav_correspondenceaddressedcoappregionname] 
,[zav_correspondenceaddressedcoappstreet] 
,[zav_correspondenceaddressedcoappstreetname] 
,[zav_correspondenceaddressedcoappsuburb] 
,[zav_correspondenceaddressedcoappunit] 
,[zav_correspondenceaddressedmainappbuildingnam] 
,[zav_correspondenceaddressedmainappcityname] 
,[zav_correspondenceaddressedmainapppostcode] 
,[zav_correspondenceaddressedmainappregionname] 
,[zav_correspondenceaddressedmainappstreet] 
,[zav_correspondenceaddressedmainappstreetname] 
,[zav_correspondenceaddressedmainappsuburb] 
,[zav_correspondenceaddressedmainappunit] 
,[zav_detailsofadvicegiven] 
,[zav_emergencycontactcomment1] 
,[zav_emergencycontactcomment2] 
,[zav_emergencycontactemail1] 
,[zav_emergencycontactemail2] 
,[zav_equitypercentage] 
,[zav_expectedpaymentdaybyname] 
,[zav_expectedpaymentdaybyyominame] 
,[zav_expectedpaymentdaydate] 
,[zav_expectedvacateddate] 
,[zav_expexitdate] 
,[zav_fixedtermtenancyenddate] 
,[zav_followedmarketrentreviewinbosdate] 
,[zav_followedmarketrentreviewinbosusername] 
,[zav_followedmarketrentreviewinbosuseryominame] 
,[zav_forwardingaddresscityname] 
,[zav_forwardingaddressregionname] 
,[zav_forwardingaddressstreetname] 
,[zav_forwardingaddressstreetnumber] 
,[zav_forwardingaddresssuburb] 
,[zav_forwardingaddressunit] 
,[zav_forwardingaddresszippostalcode] 
,[zav_guidanceonrentpaymentprocessbyname] 
,[zav_guidanceonrentpaymentprocessbyyominame] 
,[zav_guidanceonrentpaymentprocessdate] 
,[zav_habitattenantapplicationnumber] 
,[zav_householdcompositioncorrectbyname] 
,[zav_householdcompositioncorrectbyyominame] 
,[zav_householdcompositioncorrectdate] 
,[zav_householdname] 
,[zav_hudmsdreferencenumber] 
,[zav_ingoingpropertyconditionreportbyname] 
,[zav_ingoingpropertyconditionreportbyyominame] 
,[zav_ingoingpropertyconditionreportdate] 
,[zav_ingoingtenancyinspectionpropertydate] 
,[zav_ingoingtenancyinspectionpropertyusername] 
,[zav_ingoingtenancyinspectionpropertyuseryominame] 
,[zav_insulationstatementbyname] 
,[zav_insulationstatementbyyominame] 
,[zav_insulationstatementdate] 
,[zav_insurancestatementbyname] 
,[zav_insurancestatementbyyominame] 
,[zav_insurancestatementdate] 
,[zav_keyshandedoveratthesigningofthetenancybyname] 
,[zav_keyshandedoveratthesigningofthetenancybyyominame] 
,[zav_keyshandedoveratthesigningofthetenancydat] 
,[zav_kiangoratenancytype] 
,[zav_lastinspection] 
,[zav_lastrentreview] 
,[zav_leaseagreementbyname] 
,[zav_leaseagreementbyyominame] 
,[zav_leaseagreementdate] 
,[zav_maintenanceclaimlodgedwithhud] 
,[zav_maintenancefundclaimlodgeddate] 
,[zav_nameofpartners] 
,[zav_newestrentupdatestartdate] 
,[zav_nextinspection] 
,[zav_nextrentreview] 
,[zav_noofdayscharged] 
,[zav_notes] 
,[zav_noticetovacatedate] 
,[zav_numberoftenancysignatories] 
,[zav_offertenantredirectionforwaterpaymentdate] 
,[zav_offertenantredirectionforwaterpaymentusername] 
,[zav_offertenantredirectionforwaterpaymentuseryominame] 
,[zav_partnersphone] 
,[zav_paymentbookid] 
,[zav_paymentreferenceno] 
,[zav_paytotenancyservicesby] 
,[zav_petage] 
,[zav_petbreed] 
,[zav_petname] 
,[zav_petregistrationdetails] 
,[zav_pettype] 
,[zav_programname] 
,[zav_propertyname] 
,[zav_providehealthanddisabilityinformationdate] 
,[zav_providehealthanddisabilityinformationusername] 
,[zav_providehealthanddisabilityinformationuseryominame] 
,[zav_providetenancypackbyname] 
,[zav_providetenancypackbyyominame] 
,[zav_providetenancypackdate] 
,[zav_refundlodged] 
,[zav_relativeurl] 
,[zav_rentchargedto] 
,[zav_rentchargedtotest] 
,[zav_rentchargedtotest1] 
,[zav_rentchargedtotest2] 
,[zav_rentpaidto] 
,[zav_rentpaidtouserlocal] 
,[zav_rentpaymentdays] 
,[zav_renttobepaidat] 
,[zav_rescinddate] 
,[zav_routineinspectionfrequencybyname] 
,[zav_routineinspectionfrequencybyyominame] 
,[zav_routineinspectionfrequencydate] 
,[zav_secondclientname] 
,[zav_secondclientyominame] 
,[zav_setupinspectiondatebyname] 
,[zav_setupinspectiondatebyyominame] 
,[zav_setupinspectiondatedate] 
,[zav_setupofrentreviewdatesbyname] 
,[zav_setupofrentreviewdatesbyyominame] 
,[zav_setupofrentreviewdatesdate] 
,[zav_shorttermindays] 
,[zav_shorttermtenancyenddate] 
,[zav_signedmsdresponsibilitiesconditionsdate] 
,[zav_signedmsdresponsibilitiesconditionsusername] 
,[zav_signedmsdresponsibilitiesconditionsuseryominame] 
,[zav_signedsngformsdate] 
,[zav_signedsngformsusername] 
,[zav_signedsngformsuseryominame] 
,[zav_sngclaimlodgeddatecomments] 
,[zav_sngclaimlodgementdate] 
,[zav_sngclaimrelodgeddate1] 
,[zav_sngclaimrelodgeddate1comments] 
,[zav_sngclaimrelodgeddate2] 
,[zav_sngclaimrelodgeddate2comments] 
,[zav_sngclaimrelodgeddate3] 
,[zav_sngclaimrelodgeddate3comments] 
,[zav_sngclaimrelodgeddate4] 
,[zav_sngclaimrelodgeddate4comments] 
,[zav_sngclaimuploadedtomsd] 
,[zav_startingdateforrentamount] 
,[zav_subprogramname] 
,[zav_supportpeopleandemergedate] 
,[zav_supportpeopleandemergencyusername] 
,[zav_supportpeopleandemergencyuseryominame] 
,[zav_tenancyappropriatelydate] 
,[zav_tenancyappropriatelydescription] 
,[zav_tenancyappropriatelyusername] 
,[zav_tenancyappropriatelyuseryominame] 
,[zav_tenancycontributionrenthasbeensetupdate] 
,[zav_tenancycontributionrenthasbeensetupusername] 
,[zav_tenancycontributionrenthasbeensetupuseryominame] 
,[zav_tenancygreetingline] 
,[zav_tenancyid] 
,[zav_tenancymanageremail] 
,[zav_tenancymanageridname] 
,[zav_tenancymanageridyominame] 
,[zav_tenancymanagermobile] 
,[zav_tenancymanagername] 
,[zav_tenancymanageryominame] 
,[zav_tenancyreferencenumber] 
,[zav_tenancyservicebondnumber] 
,[zav_tenancyservicespropertyid] 
,[zav_tenancystartdate] 
,[zav_tenancystartedinboswithcorrectdetailsdate] 
,[zav_tenancystartedinboswithcorrectdetailsusername] 
,[zav_tenancystartedinboswithcorrectdetailsuseryominame] 
,[zav_tenancytypeidname] 
,[zav_tenantconfirmedconditionbyname] 
,[zav_tenantconfirmedconditionbyyominame] 
,[zav_tenantconfirmedconditiondate] 
,[zav_tenantconfirmsingoinginventorylistdate] 
,[zav_tenantconfirmsingoinginventorylistusername] 
,[zav_tenantconfirmsingoinginventorylistuseryominame] 
,[zav_theoutcomeoftherequest] 
,[zav_thereasonformakingtherequest] 
,[zav_tobepaidweeks] 
,[zav_totalotherandamenities_date] 
,[zav_totalotherandamenities_state] 
,[zav_totalrentamount_date] 
,[zav_totalrentamount_state] 
,[zav_totaltenantliabilityamount_date] 
,[zav_totaltenantliabilityamount_state] 
,[zav_totalutilitiesamount_date] 
,[zav_totalutilitiesamount_state] 
,[zav_totalwateramount_date] 
,[zav_totalwateramount_state] 
,[zav_transferapplicationname] 
,[zav_transferlodged] 
,[zav_transferreddate] 
,[zav_transfertotenancyname] 
,[zav_vacancybedrooms] 
,[zav_vacateddate] 
,[zav_voidcategoryname] 
,[zav_voidchecklistname] 
,[zav_voidpropertyname] 
,[zav_whennotifiedtomsd] 
,[zav_wstpacparticular] 
,[IsDelete] 
,[zav_housingfirst] 
,[zav_watermeterreadingingoing] 
,[zav_watermeterreadingoutgoing] 
,[zav_financeadvisedtopayhud] 
,[zav_financeadvisedtopayhudcomments] 
,[zav_notificationarrearsexiststoggle] 
,[zav_notificationarrearsexists] 
,[zav_managedarrears] 
,[zav_managedarrears_base] 
,[zav_unmanagedarrears] 
,[zav_unmanagedarrears_base] 
,[zav_arrangementindefault] 
,[zav_arrearsstatus] 
,[zav_numberofdaysinarrears] 
,[zav_triggerarrearsflow] 
,[zav_newarrangementindefault] 
,[zav_paymentnotes] 
,[zav_totalclientdamagesamount] 
,[zav_totalclientdamagesamount_base] 
,[zav_totalclientdamagesamount_date] 
,[zav_totalclientdamagesamount_state] 
,[zav_isthisavacatingmoteltenancy] 
,[zav_bondnotificationpreference] 
,[zav_noweekspetbondbeingcharged] 
,[zav_tenanttype] 
,[zav_bondsubmitted] 
,[zav_expectedpetbondamount] 
,[zav_expectedpetbondamount_base] 
,[zav_petbondbalance] 
,[zav_petbondbalance_base] 
,[zav_petbondbalancewithtenancyservices] 
,[zav_petbondbalancewithtenancyservices_base] 
,[zav_tenancyprogrammehistory] 
,[zav_bondnumbercheck]
FROM  (  
SELECT  [Id] 
,[SinkCreatedOn] 
,[SinkModifiedOn] 
,[statecode] 
,[statuscode] 
,[budgetstatus] 
,[initialcommunication] 
,[msdyn_forecastcategory] 
,[msdyn_opportunitygrade] 
,[msdyn_opportunityscoretrend] 
,[msft_datastate] 
,[need] 
,[new_applicationtype] 
,[new_nonerentarrearsplan] 
,[new_rentarrearsplan] 
,[opportunityratingcode] 
,[pricingerrorcode] 
,[prioritycode] 
,[purchaseprocess] 
,[purchasetimeframe] 
,[salesstage] 
,[salesstagecode] 
,[skippricecalculation] 
,[timeline] 
,[zav_arrearsarrangementbeenactivatedinzavanti] 
,[zav_arrearsarrangementbeensignedwiththeclient] 
,[zav_band] 
,[zav_bondrefundsngclaimcompleted] 
,[zav_bondrefundsngclaimlodged] 
,[zav_chadefinedtenancyfailure] 
,[zav_chpinitiatedtransfertype] 
,[zav_complexityofneed] 
,[zav_correspondenceaddressedcoappstate] 
,[zav_correspondenceaddressedmainappstate] 
,[zav_exitpoint] 
,[zav_expectedpaymentday] 
,[zav_expectedpaymentfrequency] 
,[zav_fixedterm] 
,[zav_frequency] 
,[zav_hastenantrescindednoticetovacate] 
,[zav_hpftenancy] 
,[zav_inadvanceflag] 
,[zav_inapphousednoofbedroomsreqd] 
,[zav_inputrequiredfromcort] 
,[zav_jwlallocation] 
,[zav_leavingreason] 
,[zav_maintenancefundclaimcompleted] 
,[zav_maintenancefundclaimlodgedwithhud] 
,[zav_nahaevortype] 
,[zav_paymenttype] 
,[zav_potentialdogflag] 
,[zav_prioritywaitturnaffordable] 
,[zav_rebatestatus] 
,[zav_refundreason] 
,[zav_rentchargedday] 
,[zav_rentpaidinadvance] 
,[zav_routineinspectionfrequency] 
,[zav_specialneedsgrantgenerated] 
,[zav_splitfrequency] 
,[zav_sustainabilityoftenancy] 
,[zav_tenancyappropriatelyreason] 
,[zav_tenancyappropriatelystatus] 
,[zav_tenancybondrefundformhasbeencompleted] 
,[zav_tenancybondrefundformlodgedwithts] 
,[zav_tenancyprogramme] 
,[zav_tenancyroomstatus] 
,[zav_tenancysource] 
,[zav_tenancytype] 
,[zav_transfertype] 
,[zav_weeksbondisbeingaskedfor] 
,[zav_writeoffrequired] 
,[zav_riskstotenantsustainability] 
,[zav_specialneedsofthetenant1] 
,[zav_specialneedsofthetenant2] 
,[captureproposalfeedback] 
,[completefinalproposal] 
,[completeinternalreview] 
,[confirminterest] 
,[crba8_navigatornotified] 
,[decisionmaker] 
,[developproposal] 
,[evaluatefit] 
,[filedebrief] 
,[identifycompetitors] 
,[identifycustomercontacts] 
,[identifypursuitteam] 
,[isprivate] 
,[isrevenuesystemcalculated] 
,[msdyn_gdproptout] 
,[new_activatetenancy] 
,[new_interpretorrequired] 
,[new_isthisapartnershiparrangement] 
,[new_keysreceivedfromtenant] 
,[new_potentialrisktostaff] 
,[participatesinworkflow] 
,[presentfinalproposal] 
,[presentproposal] 
,[pursuitdecision] 
,[resolvefeedback] 
,[sendthankyounote] 
,[zav_agreementtoextendthetenancyreceived] 
,[zav_bondguaranteeinformationprovided] 
,[zav_bondinformationentered] 
,[zav_bondloan] 
,[zav_bondlodgementcomplete] 
,[zav_checkedforothertenancieswithbalancesdue] 
,[zav_checkthatbodycorporresidents] 
,[zav_consenttoholdpersonalinformation] 
,[zav_expectedpaymentdatecorrect] 
,[zav_expectedpaymentdaycheckbox] 
,[zav_familiarwithsupportsneighbours] 
,[zav_firstinspectionscheduled] 
,[zav_followedmarketrentreviewinbos] 
,[zav_guidanceonrentpaymentprocess] 
,[zav_householdcompositioncorrect] 
,[zav_householdmemberscorrect] 
,[zav_ignorecreatevoidchecklist] 
,[zav_ingoingpropertyconditionreport] 
,[zav_ingoingtenancyinspectionpropertycondition] 
,[zav_insulationstatement] 
,[zav_insurancestatement] 
,[zav_invoicesforfinalchargestotenantadded] 
,[zav_isanytenantundertheageof18] 
,[zav_isthisapartnershiparrangement] 
,[zav_isthistenancyappropriatelyhoused] 
,[zav_keyshandedoveratthesigningofthetenancyagr] 
,[zav_leaseagreement] 
,[zav_marketrenter] 
,[zav_msdnotifiedtostopredirection] 
,[zav_msdreferralletterreceived] 
,[zav_offboardingactivitiescompleted] 
,[zav_offertenantredirectionforwaterpayment] 
,[zav_pcrsigned] 
,[zav_petauthorisationpaperworkcompleted] 
,[zav_previoustenancyfinalised] 
,[zav_primarysupportneedsentered] 
,[zav_providehealthanddisabilityinformation] 
,[zav_providetenancypack] 
,[zav_risksentered] 
,[zav_routineinspectionfrequencycheckbox] 
,[zav_setupinspectiondatechecknextinspectiondat] 
,[zav_setupofrentreviewdates] 
,[zav_signedmsdresponsibilitiesconditions] 
,[zav_signedsngforms] 
,[zav_subsidy] 
,[zav_supportpeopleandemergencycontactsuptodate] 
,[zav_tenancycontributionrenthasbeensetup] 
,[zav_tenancyinitialassessmentcompleted] 
,[zav_tenancyprogrammecorrect] 
,[zav_tenancystartedinboswithallcorrectdetails] 
,[zav_tenantconfirmedcondition] 
,[zav_tenantconfirmsingoinginventorylist] 
,[zav_transfer] 
,[zav_understandsoohprocess] 
,[zav_vacateconfirmation] 
,[zav_washouseholdingreatestneed] 
,[zav_wastenanthomeless] 
,[zav_waterredirectionstarted] 
,[zav_welcomevisitcomplete] 
,[accountid] 
,[accountid_entitytype] 
,[campaignid] 
,[campaignid_entitytype] 
,[contactid] 
,[contactid_entitytype] 
,[crba8_navigatornotifiedby] 
,[crba8_navigatornotifiedby_entitytype] 
,[createdby] 
,[createdby_entitytype] 
,[createdonbehalfby] 
,[createdonbehalfby_entitytype] 
,[modifiedby] 
,[modifiedby_entitytype] 
,[modifiedonbehalfby] 
,[modifiedonbehalfby_entitytype] 
,[msdyn_opportunitykpiid] 
,[msdyn_opportunitykpiid_entitytype] 
,[msdyn_predictivescoreid] 
,[msdyn_predictivescoreid_entitytype] 
,[msdyn_segmentid] 
,[msdyn_segmentid_entitytype] 
,[new_emergencycontactrelationship1] 
,[new_emergencycontactrelationship1_entitytype] 
,[new_emergencycontactrelationship1_new] 
,[new_emergencycontactrelationship1_new_entitytype] 
,[new_emergencycontactrelationship2] 
,[new_emergencycontactrelationship2_entitytype] 
,[new_emergencycontactrelationship2_new] 
,[new_emergencycontactrelationship2_new_entitytype] 
,[originatingleadid] 
,[originatingleadid_entitytype] 
,[owningbusinessunit] 
,[owningbusinessunit_entitytype] 
,[owningteam] 
,[owningteam_entitytype] 
,[owninguser] 
,[owninguser_entitytype] 
,[parentaccountid] 
,[parentaccountid_entitytype] 
,[parentcontactid] 
,[parentcontactid_entitytype] 
,[pricelevelid] 
,[pricelevelid_entitytype] 
,[slaid] 
,[slaid_entitytype] 
,[slainvokedid] 
,[slainvokedid_entitytype] 
,[transactioncurrencyid] 
,[transactioncurrencyid_entitytype] 
,[zav_activatetenancyby] 
,[zav_activatetenancyby_entitytype] 
,[zav_bondguaranteeinformationprovidedby] 
,[zav_bondguaranteeinformationprovidedby_entitytype] 
,[zav_checkthatbodycorporresidentsuser] 
,[zav_checkthatbodycorporresidentsuser_entitytype] 
,[zav_consenttoholdpersonalinformationby] 
,[zav_consenttoholdpersonalinformationby_entitytype] 
,[zav_correspondenceaddressedcoappcity] 
,[zav_correspondenceaddressedcoappcity_entitytype] 
,[zav_correspondenceaddressedcoappregion] 
,[zav_correspondenceaddressedcoappregion_entitytype] 
,[zav_correspondenceaddressedmainappcity] 
,[zav_correspondenceaddressedmainappcity_entitytype] 
,[zav_correspondenceaddressedmainappregion] 
,[zav_correspondenceaddressedmainappregion_entitytype] 
,[zav_expectedpaymentdayby] 
,[zav_expectedpaymentdayby_entitytype] 
,[zav_followedmarketrentreviewinbosuser] 
,[zav_followedmarketrentreviewinbosuser_entitytype] 
,[zav_forwardingaddresscity] 
,[zav_forwardingaddresscity_entitytype] 
,[zav_forwardingaddressregion] 
,[zav_forwardingaddressregion_entitytype] 
,[zav_guidanceonrentpaymentprocessby] 
,[zav_guidanceonrentpaymentprocessby_entitytype] 
,[zav_household] 
,[zav_household_entitytype] 
,[zav_householdcompositioncorrectby] 
,[zav_householdcompositioncorrectby_entitytype] 
,[zav_ingoingpropertyconditionreportby] 
,[zav_ingoingpropertyconditionreportby_entitytype] 
,[zav_ingoingtenancyinspectionpropertyuser] 
,[zav_ingoingtenancyinspectionpropertyuser_entitytype] 
,[zav_insulationstatementby] 
,[zav_insulationstatementby_entitytype] 
,[zav_insurancestatementby] 
,[zav_insurancestatementby_entitytype] 
,[zav_keyshandedoveratthesigningofthetenancyby] 
,[zav_keyshandedoveratthesigningofthetenancyby_entitytype] 
,[zav_leaseagreementby] 
,[zav_leaseagreementby_entitytype] 
,[zav_offertenantredirectionforwaterpaymentuser] 
,[zav_offertenantredirectionforwaterpaymentuser_entitytype] 
,[zav_program] 
,[zav_program_entitytype] 
,[zav_property] 
,[zav_property_entitytype] 
,[zav_providehealthanddisabilityinformationuser] 
,[zav_providehealthanddisabilityinformationuser_entitytype] 
,[zav_providetenancypackby] 
,[zav_providetenancypackby_entitytype] 
,[zav_routineinspectionfrequencyby] 
,[zav_routineinspectionfrequencyby_entitytype] 
,[zav_secondclient] 
,[zav_secondclient_entitytype] 
,[zav_setupinspectiondateby] 
,[zav_setupinspectiondateby_entitytype] 
,[zav_setupofrentreviewdatesby] 
,[zav_setupofrentreviewdatesby_entitytype] 
,[zav_signedmsdresponsibilitiesconditionsuser] 
,[zav_signedmsdresponsibilitiesconditionsuser_entitytype] 
,[zav_signedsngformsuser] 
,[zav_signedsngformsuser_entitytype] 
,[zav_subprogram] 
,[zav_subprogram_entitytype] 
,[zav_supportpeopleandemergencyuser] 
,[zav_supportpeopleandemergencyuser_entitytype] 
,[zav_tenancyappropriatelyuser] 
,[zav_tenancyappropriatelyuser_entitytype] 
,[zav_tenancycontributionrenthasbeensetupuser] 
,[zav_tenancycontributionrenthasbeensetupuser_entitytype] 
,[zav_tenancymanager] 
,[zav_tenancymanager_entitytype] 
,[zav_tenancymanagerid] 
,[zav_tenancymanagerid_entitytype] 
,[zav_tenancystartedinboswithcorrectdetailsuser] 
,[zav_tenancystartedinboswithcorrectdetailsuser_entitytype] 
,[zav_tenancytypeid] 
,[zav_tenancytypeid_entitytype] 
,[zav_tenantconfirmedconditionby] 
,[zav_tenantconfirmedconditionby_entitytype] 
,[zav_tenantconfirmsingoinginventorylistuser] 
,[zav_tenantconfirmsingoinginventorylistuser_entitytype] 
,[zav_transferapplication] 
,[zav_transferapplication_entitytype] 
,[zav_transfertotenancy] 
,[zav_transfertotenancy_entitytype] 
,[zav_voidcategory] 
,[zav_voidcategory_entitytype] 
,[zav_voidchecklist] 
,[zav_voidchecklist_entitytype] 
,[zav_voidproperty] 
,[zav_voidproperty_entitytype] 
,[ownerid] 
,[ownerid_entitytype] 
,[customerid] 
,[customerid_entitytype] 
,[actualvalue] 
,[actualvalue_base] 
,[budgetamount] 
,[budgetamount_base] 
,[discountamount] 
,[discountamount_base] 
,[estimatedvalue] 
,[estimatedvalue_base] 
,[freightamount] 
,[freightamount_base] 
,[new_bondbalance] 
,[new_bondbalance_base] 
,[new_newrent] 
,[new_newrent_base] 
,[new_nonrent] 
,[new_nonrent_base] 
,[new_rent] 
,[new_rent_base] 
,[new_transactionbalancetotal] 
,[new_transactionbalancetotal_base] 
,[totalamount] 
,[totalamount_base] 
,[totalamountlessfreight] 
,[totalamountlessfreight_base] 
,[totaldiscountamount] 
,[totaldiscountamount_base] 
,[totallineitemamount] 
,[totallineitemamount_base] 
,[totallineitemdiscountamount] 
,[totallineitemdiscountamount_base] 
,[totaltax] 
,[totaltax_base] 
,[zav_approvedsngcap] 
,[zav_approvedsngcap_base] 
,[zav_balancewithtenancyservices] 
,[zav_balancewithtenancyservices_base] 
,[zav_bondamount] 
,[zav_bondamount_base] 
,[zav_chintarobondamount] 
,[zav_chintarobondamount_base] 
,[zav_expectedbondamount] 
,[zav_expectedbondamount_base] 
,[zav_inhand] 
,[zav_inhand_base] 
,[zav_marketrent] 
,[zav_marketrent_base] 
,[zav_newestrentupdate] 
,[zav_newestrentupdate_base] 
,[zav_refundrequired] 
,[zav_refundrequired_base] 
,[zav_rentowesasofexpectedvacatedate] 
,[zav_rentowesasofexpectedvacatedate_base] 
,[zav_rentpayable] 
,[zav_rentpayable_base] 
,[zav_rentpayablebasicrentcraweekly] 
,[zav_rentpayablebasicrentcraweekly_base] 
,[zav_totalotherandamenities] 
,[zav_totalotherandamenities_base] 
,[zav_totalrentamount] 
,[zav_totalrentamount_base] 
,[zav_totaltenantliabilityamount] 
,[zav_totaltenantliabilityamount_base] 
,[zav_totalutilitiesamount] 
,[zav_totalutilitiesamount_base] 
,[zav_totalwateramount] 
,[zav_totalwateramount_base] 
,[accountidname] 
,[accountidyominame] 
,[actualclosedate] 
,[campaignidname] 
,[closeprobability] 
,[contactidname] 
,[contactidyominame] 
,[crba8_navigatornotifiedbyname] 
,[crba8_navigatornotifiedbyyominame] 
,[crba8_navigatornotifiedon] 
,[createdbyname] 
,[createdbyyominame] 
,[createdon] 
,[createdonbehalfbyname] 
,[createdonbehalfbyyominame] 
,[currentsituation] 
,[customeridname] 
,[customeridtype] 
,[customeridyominame] 
,[customerneed] 
,[customerpainpoints] 
,[description] 
,[discountpercentage] 
,[emailaddress] 
,[estimatedclosedate] 
,[exchangerate] 
,[finaldecisiondate] 
,[importsequencenumber] 
,[lastonholdtime] 
,[modifiedbyname] 
,[modifiedbyyominame] 
,[modifiedon] 
,[modifiedonbehalfbyname] 
,[modifiedonbehalfbyyominame] 
,[msdyn_opportunitykpiidname] 
,[msdyn_opportunityscore] 
,[msdyn_predictivescoreidname] 
,[msdyn_scorehistory] 
,[msdyn_scorereasons] 
,[msdyn_segmentidname] 
,[msdyn_similaropportunities] 
,[name] 
,[new_deadlineforpaymenttoba] 
,[new_effectivenewrentstartdate] 
,[new_emergencycontactmobile1] 
,[new_emergencycontactmobile2] 
,[new_emergencycontactname1] 
,[new_emergencycontactname2] 
,[new_emergencycontactrelationship1_newname] 
,[new_emergencycontactrelationship1name] 
,[new_emergencycontactrelationship2_newname] 
,[new_emergencycontactrelationship2name] 
,[new_exitcomment] 
,[new_keysreceivedfromtenantdate] 
,[new_nobedroomsexitedto] 
,[new_nonrent_date] 
,[new_nonrent_state] 
,[new_rent_date] 
,[new_rent_state] 
,[new_riskslist] 
,[new_tenant1mobilephone] 
,[new_tenant2mobilephone] 
,[new_test] 
,[onholdtime] 
,[opportunityid] 
,[originatingleadidname] 
,[originatingleadidyominame] 
,[overriddencreatedon] 
,[owneridname] 
,[owneridtype] 
,[owneridyominame] 
,[owningbusinessunitname] 
,[parentaccountidname] 
,[parentaccountidyominame] 
,[parentcontactidname] 
,[parentcontactidyominame] 
,[pricelevelidname] 
,[processid] 
,[proposedsolution] 
,[qualificationcomments] 
,[quotecomments] 
,[schedulefollowup_prospect] 
,[schedulefollowup_qualify] 
,[scheduleproposalmeeting] 
,[slainvokedidname] 
,[slaname] 
,[stageid] 
,[stepid] 
,[stepname] 
,[teamsfollowed] 
,[timespentbymeonemailandmeetings] 
,[timezoneruleversionnumber] 
,[transactioncurrencyidname] 
,[traversedpath] 
,[utcconversiontimezonecode] 
,[versionnumber] 
,[zav_accrisstartdate] 
,[zav_activatetenancybyname] 
,[zav_activatetenancybyyominame] 
,[zav_activatetenancydate] 
,[zav_actualstartdate] 
,[zav_bondcomments] 
,[zav_bondguaranteeinformationprovidedbyname] 
,[zav_bondguaranteeinformationprovidedbyyominame] 
,[zav_bondguaranteeinformationprovideddate] 
,[zav_bondlodged] 
,[zav_bondreference] 
,[zav_bondrefundformlodged] 
,[zav_checkthatbodycorporresidentsdate] 
,[zav_checkthatbodycorporresidentsusername] 
,[zav_checkthatbodycorporresidentsuseryominame] 
,[zav_chintaroid] 
,[zav_comments] 
,[zav_commenttofinance] 
,[zav_consenttoholdpersonalinformationbyname] 
,[zav_consenttoholdpersonalinformationbyyominame] 
,[zav_consenttoholdpersonalinformationdate] 
,[zav_correspondenceaddressedcoappcityname] 
,[zav_correspondenceaddressedcoapppostcode] 
,[zav_correspondenceaddressedcoappregionname] 
,[zav_correspondenceaddressedcoappstreet] 
,[zav_correspondenceaddressedcoappstreetname] 
,[zav_correspondenceaddressedcoappsuburb] 
,[zav_correspondenceaddressedcoappunit] 
,[zav_correspondenceaddressedmainappbuildingnam] 
,[zav_correspondenceaddressedmainappcityname] 
,[zav_correspondenceaddressedmainapppostcode] 
,[zav_correspondenceaddressedmainappregionname] 
,[zav_correspondenceaddressedmainappstreet] 
,[zav_correspondenceaddressedmainappstreetname] 
,[zav_correspondenceaddressedmainappsuburb] 
,[zav_correspondenceaddressedmainappunit] 
,[zav_detailsofadvicegiven] 
,[zav_emergencycontactcomment1] 
,[zav_emergencycontactcomment2] 
,[zav_emergencycontactemail1] 
,[zav_emergencycontactemail2] 
,[zav_equitypercentage] 
,[zav_expectedpaymentdaybyname] 
,[zav_expectedpaymentdaybyyominame] 
,[zav_expectedpaymentdaydate] 
,[zav_expectedvacateddate] 
,[zav_expexitdate] 
,[zav_fixedtermtenancyenddate] 
,[zav_followedmarketrentreviewinbosdate] 
,[zav_followedmarketrentreviewinbosusername] 
,[zav_followedmarketrentreviewinbosuseryominame] 
,[zav_forwardingaddresscityname] 
,[zav_forwardingaddressregionname] 
,[zav_forwardingaddressstreetname] 
,[zav_forwardingaddressstreetnumber] 
,[zav_forwardingaddresssuburb] 
,[zav_forwardingaddressunit] 
,[zav_forwardingaddresszippostalcode] 
,[zav_guidanceonrentpaymentprocessbyname] 
,[zav_guidanceonrentpaymentprocessbyyominame] 
,[zav_guidanceonrentpaymentprocessdate] 
,[zav_habitattenantapplicationnumber] 
,[zav_householdcompositioncorrectbyname] 
,[zav_householdcompositioncorrectbyyominame] 
,[zav_householdcompositioncorrectdate] 
,[zav_householdname] 
,[zav_hudmsdreferencenumber] 
,[zav_ingoingpropertyconditionreportbyname] 
,[zav_ingoingpropertyconditionreportbyyominame] 
,[zav_ingoingpropertyconditionreportdate] 
,[zav_ingoingtenancyinspectionpropertydate] 
,[zav_ingoingtenancyinspectionpropertyusername] 
,[zav_ingoingtenancyinspectionpropertyuseryominame] 
,[zav_insulationstatementbyname] 
,[zav_insulationstatementbyyominame] 
,[zav_insulationstatementdate] 
,[zav_insurancestatementbyname] 
,[zav_insurancestatementbyyominame] 
,[zav_insurancestatementdate] 
,[zav_keyshandedoveratthesigningofthetenancybyname] 
,[zav_keyshandedoveratthesigningofthetenancybyyominame] 
,[zav_keyshandedoveratthesigningofthetenancydat] 
,[zav_kiangoratenancytype] 
,[zav_lastinspection] 
,[zav_lastrentreview] 
,[zav_leaseagreementbyname] 
,[zav_leaseagreementbyyominame] 
,[zav_leaseagreementdate] 
,[zav_maintenanceclaimlodgedwithhud] 
,[zav_maintenancefundclaimlodgeddate] 
,[zav_nameofpartners] 
,[zav_newestrentupdatestartdate] 
,[zav_nextinspection] 
,[zav_nextrentreview] 
,[zav_noofdayscharged] 
,[zav_notes] 
,[zav_noticetovacatedate] 
,[zav_numberoftenancysignatories] 
,[zav_offertenantredirectionforwaterpaymentdate] 
,[zav_offertenantredirectionforwaterpaymentusername] 
,[zav_offertenantredirectionforwaterpaymentuseryominame] 
,[zav_partnersphone] 
,[zav_paymentbookid] 
,[zav_paymentreferenceno] 
,[zav_paytotenancyservicesby] 
,[zav_petage] 
,[zav_petbreed] 
,[zav_petname] 
,[zav_petregistrationdetails] 
,[zav_pettype] 
,[zav_programname] 
,[zav_propertyname] 
,[zav_providehealthanddisabilityinformationdate] 
,[zav_providehealthanddisabilityinformationusername] 
,[zav_providehealthanddisabilityinformationuseryominame] 
,[zav_providetenancypackbyname] 
,[zav_providetenancypackbyyominame] 
,[zav_providetenancypackdate] 
,[zav_refundlodged] 
,[zav_relativeurl] 
,[zav_rentchargedto] 
,[zav_rentchargedtotest] 
,[zav_rentchargedtotest1] 
,[zav_rentchargedtotest2] 
,[zav_rentpaidto] 
,[zav_rentpaidtouserlocal] 
,[zav_rentpaymentdays] 
,[zav_renttobepaidat] 
,[zav_rescinddate] 
,[zav_routineinspectionfrequencybyname] 
,[zav_routineinspectionfrequencybyyominame] 
,[zav_routineinspectionfrequencydate] 
,[zav_secondclientname] 
,[zav_secondclientyominame] 
,[zav_setupinspectiondatebyname] 
,[zav_setupinspectiondatebyyominame] 
,[zav_setupinspectiondatedate] 
,[zav_setupofrentreviewdatesbyname] 
,[zav_setupofrentreviewdatesbyyominame] 
,[zav_setupofrentreviewdatesdate] 
,[zav_shorttermindays] 
,[zav_shorttermtenancyenddate] 
,[zav_signedmsdresponsibilitiesconditionsdate] 
,[zav_signedmsdresponsibilitiesconditionsusername] 
,[zav_signedmsdresponsibilitiesconditionsuseryominame] 
,[zav_signedsngformsdate] 
,[zav_signedsngformsusername] 
,[zav_signedsngformsuseryominame] 
,[zav_sngclaimlodgeddatecomments] 
,[zav_sngclaimlodgementdate] 
,[zav_sngclaimrelodgeddate1] 
,[zav_sngclaimrelodgeddate1comments] 
,[zav_sngclaimrelodgeddate2] 
,[zav_sngclaimrelodgeddate2comments] 
,[zav_sngclaimrelodgeddate3] 
,[zav_sngclaimrelodgeddate3comments] 
,[zav_sngclaimrelodgeddate4] 
,[zav_sngclaimrelodgeddate4comments] 
,[zav_sngclaimuploadedtomsd] 
,[zav_startingdateforrentamount] 
,[zav_subprogramname] 
,[zav_supportpeopleandemergedate] 
,[zav_supportpeopleandemergencyusername] 
,[zav_supportpeopleandemergencyuseryominame] 
,[zav_tenancyappropriatelydate] 
,[zav_tenancyappropriatelydescription] 
,[zav_tenancyappropriatelyusername] 
,[zav_tenancyappropriatelyuseryominame] 
,[zav_tenancycontributionrenthasbeensetupdate] 
,[zav_tenancycontributionrenthasbeensetupusername] 
,[zav_tenancycontributionrenthasbeensetupuseryominame] 
,[zav_tenancygreetingline] 
,[zav_tenancyid] 
,[zav_tenancymanageremail] 
,[zav_tenancymanageridname] 
,[zav_tenancymanageridyominame] 
,[zav_tenancymanagermobile] 
,[zav_tenancymanagername] 
,[zav_tenancymanageryominame] 
,[zav_tenancyreferencenumber] 
,[zav_tenancyservicebondnumber] 
,[zav_tenancyservicespropertyid] 
,[zav_tenancystartdate] 
,[zav_tenancystartedinboswithcorrectdetailsdate] 
,[zav_tenancystartedinboswithcorrectdetailsusername] 
,[zav_tenancystartedinboswithcorrectdetailsuseryominame] 
,[zav_tenancytypeidname] 
,[zav_tenantconfirmedconditionbyname] 
,[zav_tenantconfirmedconditionbyyominame] 
,[zav_tenantconfirmedconditiondate] 
,[zav_tenantconfirmsingoinginventorylistdate] 
,[zav_tenantconfirmsingoinginventorylistusername] 
,[zav_tenantconfirmsingoinginventorylistuseryominame] 
,[zav_theoutcomeoftherequest] 
,[zav_thereasonformakingtherequest] 
,[zav_tobepaidweeks] 
,[zav_totalotherandamenities_date] 
,[zav_totalotherandamenities_state] 
,[zav_totalrentamount_date] 
,[zav_totalrentamount_state] 
,[zav_totaltenantliabilityamount_date] 
,[zav_totaltenantliabilityamount_state] 
,[zav_totalutilitiesamount_date] 
,[zav_totalutilitiesamount_state] 
,[zav_totalwateramount_date] 
,[zav_totalwateramount_state] 
,[zav_transferapplicationname] 
,[zav_transferlodged] 
,[zav_transferreddate] 
,[zav_transfertotenancyname] 
,[zav_vacancybedrooms] 
,[zav_vacateddate] 
,[zav_voidcategoryname] 
,[zav_voidchecklistname] 
,[zav_voidpropertyname] 
,[zav_whennotifiedtomsd] 
,[zav_wstpacparticular] 
,[IsDelete] 
,[zav_housingfirst] 
,[zav_watermeterreadingingoing] 
,[zav_watermeterreadingoutgoing] 
,[zav_financeadvisedtopayhud] 
,[zav_financeadvisedtopayhudcomments] 
,[zav_notificationarrearsexiststoggle] 
,[zav_notificationarrearsexists] 
,[zav_managedarrears] 
,[zav_managedarrears_base] 
,[zav_unmanagedarrears] 
,[zav_unmanagedarrears_base] 
,[zav_arrangementindefault] 
,[zav_arrearsstatus] 
,[zav_numberofdaysinarrears] 
,[zav_triggerarrearsflow] 
,[zav_newarrangementindefault] 
,[zav_paymentnotes] 
,[zav_totalclientdamagesamount] 
,[zav_totalclientdamagesamount_base] 
,[zav_totalclientdamagesamount_date] 
,[zav_totalclientdamagesamount_state] 
,[zav_isthisavacatingmoteltenancy] 
,[zav_bondnotificationpreference] 
,[zav_noweekspetbondbeingcharged] 
,[zav_tenanttype] 
,[zav_bondsubmitted] 
,[zav_expectedpetbondamount] 
,[zav_expectedpetbondamount_base] 
,[zav_petbondbalance] 
,[zav_petbondbalance_base] 
,[zav_petbondbalancewithtenancyservices] 
,[zav_petbondbalancewithtenancyservices_base] 
,[zav_tenancyprogrammehistory] 
,[zav_bondnumbercheck]    
,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num
-- used to identify latest record  
FROM OPENROWSET(     BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/opportunity/*.csv'
,FORMAT = 'CSV'
,      FIELDTERMINATOR = '
,'
,      ROWTERMINATOR = '\n'
,      FIRSTROW = 1  )   WITH  ( [Id] [uniqueidentifier] 
,[SinkCreatedOn] [datetime2](7) 
,[SinkModifiedOn] [datetime2](7) 
,[statecode] [bigint] 
,[statuscode] [bigint] 
,[budgetstatus] [bigint] 
,[initialcommunication] [bigint] 
,[msdyn_forecastcategory] [bigint] 
,[msdyn_opportunitygrade] [bigint] 
,[msdyn_opportunityscoretrend] [bigint] 
,[msft_datastate] [bigint] 
,[need] [bigint] 
,[new_applicationtype] [bigint] 
,[new_nonerentarrearsplan] [bigint] 
,[new_rentarrearsplan] [bigint] 
,[opportunityratingcode] [bigint] 
,[pricingerrorcode] [bigint] 
,[prioritycode] [bigint] 
,[purchaseprocess] [bigint] 
,[purchasetimeframe] [bigint] 
,[salesstage] [bigint] 
,[salesstagecode] [bigint] 
,[skippricecalculation] [bigint] 
,[timeline] [bigint] 
,[zav_arrearsarrangementbeenactivatedinzavanti] [bigint] 
,[zav_arrearsarrangementbeensignedwiththeclient] [bigint] 
,[zav_band] [bigint] 
,[zav_bondrefundsngclaimcompleted] [bigint] 
,[zav_bondrefundsngclaimlodged] [bigint] 
,[zav_chadefinedtenancyfailure] [bigint] 
,[zav_chpinitiatedtransfertype] [bigint] 
,[zav_complexityofneed] [bigint] 
,[zav_correspondenceaddressedcoappstate] [bigint] 
,[zav_correspondenceaddressedmainappstate] [bigint] 
,[zav_exitpoint] [bigint] 
,[zav_expectedpaymentday] [bigint] 
,[zav_expectedpaymentfrequency] [bigint] 
,[zav_fixedterm] [bigint] 
,[zav_frequency] [bigint] 
,[zav_hastenantrescindednoticetovacate] [bigint] 
,[zav_hpftenancy] [bigint] 
,[zav_inadvanceflag] [bigint] 
,[zav_inapphousednoofbedroomsreqd] [bigint] 
,[zav_inputrequiredfromcort] [bigint] 
,[zav_jwlallocation] [bigint] 
,[zav_leavingreason] [bigint] 
,[zav_maintenancefundclaimcompleted] [bigint] 
,[zav_maintenancefundclaimlodgedwithhud] [bigint] 
,[zav_nahaevortype] [bigint] 
,[zav_paymenttype] [bigint] 
,[zav_potentialdogflag] [bigint] 
,[zav_prioritywaitturnaffordable] [bigint] 
,[zav_rebatestatus] [bigint] 
,[zav_refundreason] [bigint] 
,[zav_rentchargedday] [bigint] 
,[zav_rentpaidinadvance] [bigint] 
,[zav_routineinspectionfrequency] [bigint] 
,[zav_specialneedsgrantgenerated] [bigint] 
,[zav_splitfrequency] [bigint] 
,[zav_sustainabilityoftenancy] [bigint] 
,[zav_tenancyappropriatelyreason] [bigint] 
,[zav_tenancyappropriatelystatus] [bigint] 
,[zav_tenancybondrefundformhasbeencompleted] [bigint] 
,[zav_tenancybondrefundformlodgedwithts] [bigint] 
,[zav_tenancyprogramme] [bigint] 
,[zav_tenancyroomstatus] [bigint] 
,[zav_tenancysource] [bigint] 
,[zav_tenancytype] [bigint] 
,[zav_transfertype] [bigint] 
,[zav_weeksbondisbeingaskedfor] [bigint] 
,[zav_writeoffrequired] [bigint] 
,[zav_riskstotenantsustainability] [varchar](8000) 
,[zav_specialneedsofthetenant1] [varchar](8000) 
,[zav_specialneedsofthetenant2] [varchar](8000) 
,[captureproposalfeedback] [varchar](6) 
,[completefinalproposal] [varchar](6) 
,[completeinternalreview] [varchar](6) 
,[confirminterest] [varchar](6) 
,[crba8_navigatornotified] [varchar](6) 
,[decisionmaker] [varchar](6) 
,[developproposal] [varchar](6) 
,[evaluatefit] [varchar](6) 
,[filedebrief] [varchar](6) 
,[identifycompetitors] [varchar](6) 
,[identifycustomercontacts] [varchar](6) 
,[identifypursuitteam] [varchar](6) 
,[isprivate] [varchar](6) 
,[isrevenuesystemcalculated] [varchar](6) 
,[msdyn_gdproptout] [varchar](6) 
,[new_activatetenancy] [varchar](6) 
,[new_interpretorrequired] [varchar](6) 
,[new_isthisapartnershiparrangement] [varchar](6) 
,[new_keysreceivedfromtenant] [varchar](6) 
,[new_potentialrisktostaff] [varchar](6) 
,[participatesinworkflow] [varchar](6) 
,[presentfinalproposal] [varchar](6) 
,[presentproposal] [varchar](6) 
,[pursuitdecision] [varchar](6) 
,[resolvefeedback] [varchar](6) 
,[sendthankyounote] [varchar](6) 
,[zav_agreementtoextendthetenancyreceived] [varchar](6) 
,[zav_bondguaranteeinformationprovided] [varchar](6) 
,[zav_bondinformationentered] [varchar](6) 
,[zav_bondloan] [varchar](6) 
,[zav_bondlodgementcomplete] [varchar](6) 
,[zav_checkedforothertenancieswithbalancesdue] [varchar](6) 
,[zav_checkthatbodycorporresidents] [varchar](6) 
,[zav_consenttoholdpersonalinformation] [varchar](6) 
,[zav_expectedpaymentdatecorrect] [varchar](6) 
,[zav_expectedpaymentdaycheckbox] [varchar](6) 
,[zav_familiarwithsupportsneighbours] [varchar](6) 
,[zav_firstinspectionscheduled] [varchar](6) 
,[zav_followedmarketrentreviewinbos] [varchar](6) 
,[zav_guidanceonrentpaymentprocess] [varchar](6) 
,[zav_householdcompositioncorrect] [varchar](6) 
,[zav_householdmemberscorrect] [varchar](6) 
,[zav_ignorecreatevoidchecklist] [varchar](6) 
,[zav_ingoingpropertyconditionreport] [varchar](6) 
,[zav_ingoingtenancyinspectionpropertycondition] [varchar](6) 
,[zav_insulationstatement] [varchar](6) 
,[zav_insurancestatement] [varchar](6) 
,[zav_invoicesforfinalchargestotenantadded] [varchar](6) 
,[zav_isanytenantundertheageof18] [varchar](6) 
,[zav_isthisapartnershiparrangement] [varchar](6) 
,[zav_isthistenancyappropriatelyhoused] [varchar](6) 
,[zav_keyshandedoveratthesigningofthetenancyagr] [varchar](6) 
,[zav_leaseagreement] [varchar](6) 
,[zav_marketrenter] [varchar](6) 
,[zav_msdnotifiedtostopredirection] [varchar](6) 
,[zav_msdreferralletterreceived] [varchar](6) 
,[zav_offboardingactivitiescompleted] [varchar](6) 
,[zav_offertenantredirectionforwaterpayment] [varchar](6) 
,[zav_pcrsigned] [varchar](6) 
,[zav_petauthorisationpaperworkcompleted] [varchar](6) 
,[zav_previoustenancyfinalised] [varchar](6) 
,[zav_primarysupportneedsentered] [varchar](6) 
,[zav_providehealthanddisabilityinformation] [varchar](6) 
,[zav_providetenancypack] [varchar](6) 
,[zav_risksentered] [varchar](6) 
,[zav_routineinspectionfrequencycheckbox] [varchar](6) 
,[zav_setupinspectiondatechecknextinspectiondat] [varchar](6) 
,[zav_setupofrentreviewdates] [varchar](6) 
,[zav_signedmsdresponsibilitiesconditions] [varchar](6) 
,[zav_signedsngforms] [varchar](6) 
,[zav_subsidy] [varchar](6) 
,[zav_supportpeopleandemergencycontactsuptodate] [varchar](6) 
,[zav_tenancycontributionrenthasbeensetup] [varchar](6) 
,[zav_tenancyinitialassessmentcompleted] [varchar](6) 
,[zav_tenancyprogrammecorrect] [varchar](6) 
,[zav_tenancystartedinboswithallcorrectdetails] [varchar](6) 
,[zav_tenantconfirmedcondition] [varchar](6) 
,[zav_tenantconfirmsingoinginventorylist] [varchar](6) 
,[zav_transfer] [varchar](6) 
,[zav_understandsoohprocess] [varchar](6) 
,[zav_vacateconfirmation] [varchar](6) 
,[zav_washouseholdingreatestneed] [varchar](6) 
,[zav_wastenanthomeless] [varchar](6) 
,[zav_waterredirectionstarted] [varchar](6) 
,[zav_welcomevisitcomplete] [varchar](6) 
,[accountid] [uniqueidentifier] 
,[accountid_entitytype] [varchar](256) 
,[campaignid] [uniqueidentifier] 
,[campaignid_entitytype] [varchar](256) 
,[contactid] [uniqueidentifier] 
,[contactid_entitytype] [varchar](256) 
,[crba8_navigatornotifiedby] [uniqueidentifier] 
,[crba8_navigatornotifiedby_entitytype] [varchar](256) 
,[createdby] [uniqueidentifier] 
,[createdby_entitytype] [varchar](256) 
,[createdonbehalfby] [uniqueidentifier] 
,[createdonbehalfby_entitytype] [varchar](256) 
,[modifiedby] [uniqueidentifier] 
,[modifiedby_entitytype] [varchar](256) 
,[modifiedonbehalfby] [uniqueidentifier] 
,[modifiedonbehalfby_entitytype] [varchar](256) 
,[msdyn_opportunitykpiid] [uniqueidentifier] 
,[msdyn_opportunitykpiid_entitytype] [varchar](256) 
,[msdyn_predictivescoreid] [uniqueidentifier] 
,[msdyn_predictivescoreid_entitytype] [varchar](256) 
,[msdyn_segmentid] [uniqueidentifier] 
,[msdyn_segmentid_entitytype] [varchar](256) 
,[new_emergencycontactrelationship1] [uniqueidentifier] 
,[new_emergencycontactrelationship1_entitytype] [varchar](256) 
,[new_emergencycontactrelationship1_new] [uniqueidentifier] 
,[new_emergencycontactrelationship1_new_entitytype] [varchar](256) 
,[new_emergencycontactrelationship2] [uniqueidentifier] 
,[new_emergencycontactrelationship2_entitytype] [varchar](256) 
,[new_emergencycontactrelationship2_new] [uniqueidentifier] 
,[new_emergencycontactrelationship2_new_entitytype] [varchar](256) 
,[originatingleadid] [uniqueidentifier] 
,[originatingleadid_entitytype] [varchar](256) 
,[owningbusinessunit] [uniqueidentifier] 
,[owningbusinessunit_entitytype] [varchar](256) 
,[owningteam] [uniqueidentifier] 
,[owningteam_entitytype] [varchar](256) 
,[owninguser] [uniqueidentifier] 
,[owninguser_entitytype] [varchar](256) 
,[parentaccountid] [uniqueidentifier] 
,[parentaccountid_entitytype] [varchar](256) 
,[parentcontactid] [uniqueidentifier] 
,[parentcontactid_entitytype] [varchar](256) 
,[pricelevelid] [uniqueidentifier] 
,[pricelevelid_entitytype] [varchar](256) 
,[slaid] [uniqueidentifier] 
,[slaid_entitytype] [varchar](256) 
,[slainvokedid] [uniqueidentifier] 
,[slainvokedid_entitytype] [varchar](256) 
,[transactioncurrencyid] [uniqueidentifier] 
,[transactioncurrencyid_entitytype] [varchar](256) 
,[zav_activatetenancyby] [uniqueidentifier] 
,[zav_activatetenancyby_entitytype] [varchar](256) 
,[zav_bondguaranteeinformationprovidedby] [uniqueidentifier] 
,[zav_bondguaranteeinformationprovidedby_entitytype] [varchar](256) 
,[zav_checkthatbodycorporresidentsuser] [uniqueidentifier] 
,[zav_checkthatbodycorporresidentsuser_entitytype] [varchar](256) 
,[zav_consenttoholdpersonalinformationby] [uniqueidentifier] 
,[zav_consenttoholdpersonalinformationby_entitytype] [varchar](256) 
,[zav_correspondenceaddressedcoappcity] [uniqueidentifier] 
,[zav_correspondenceaddressedcoappcity_entitytype] [varchar](256) 
,[zav_correspondenceaddressedcoappregion] [uniqueidentifier] 
,[zav_correspondenceaddressedcoappregion_entitytype] [varchar](256) 
,[zav_correspondenceaddressedmainappcity] [uniqueidentifier] 
,[zav_correspondenceaddressedmainappcity_entitytype] [varchar](256) 
,[zav_correspondenceaddressedmainappregion] [uniqueidentifier] 
,[zav_correspondenceaddressedmainappregion_entitytype] [varchar](256) 
,[zav_expectedpaymentdayby] [uniqueidentifier] 
,[zav_expectedpaymentdayby_entitytype] [varchar](256) 
,[zav_followedmarketrentreviewinbosuser] [uniqueidentifier] 
,[zav_followedmarketrentreviewinbosuser_entitytype] [varchar](256) 
,[zav_forwardingaddresscity] [uniqueidentifier] 
,[zav_forwardingaddresscity_entitytype] [varchar](256) 
,[zav_forwardingaddressregion] [uniqueidentifier] 
,[zav_forwardingaddressregion_entitytype] [varchar](256) 
,[zav_guidanceonrentpaymentprocessby] [uniqueidentifier] 
,[zav_guidanceonrentpaymentprocessby_entitytype] [varchar](256) 
,[zav_household] [uniqueidentifier] 
,[zav_household_entitytype] [varchar](256) 
,[zav_householdcompositioncorrectby] [uniqueidentifier] 
,[zav_householdcompositioncorrectby_entitytype] [varchar](256) 
,[zav_ingoingpropertyconditionreportby] [uniqueidentifier] 
,[zav_ingoingpropertyconditionreportby_entitytype] [varchar](256) 
,[zav_ingoingtenancyinspectionpropertyuser] [uniqueidentifier] 
,[zav_ingoingtenancyinspectionpropertyuser_entitytype] [varchar](256) 
,[zav_insulationstatementby] [uniqueidentifier] 
,[zav_insulationstatementby_entitytype] [varchar](256) 
,[zav_insurancestatementby] [uniqueidentifier] 
,[zav_insurancestatementby_entitytype] [varchar](256) 
,[zav_keyshandedoveratthesigningofthetenancyby] [uniqueidentifier] 
,[zav_keyshandedoveratthesigningofthetenancyby_entitytype] [varchar](256) 
,[zav_leaseagreementby] [uniqueidentifier] 
,[zav_leaseagreementby_entitytype] [varchar](256) 
,[zav_offertenantredirectionforwaterpaymentuser] [uniqueidentifier] 
,[zav_offertenantredirectionforwaterpaymentuser_entitytype] [varchar](256) 
,[zav_program] [uniqueidentifier] 
,[zav_program_entitytype] [varchar](256) 
,[zav_property] [uniqueidentifier] 
,[zav_property_entitytype] [varchar](256) 
,[zav_providehealthanddisabilityinformationuser] [uniqueidentifier] 
,[zav_providehealthanddisabilityinformationuser_entitytype] [varchar](256) 
,[zav_providetenancypackby] [uniqueidentifier] 
,[zav_providetenancypackby_entitytype] [varchar](256) 
,[zav_routineinspectionfrequencyby] [uniqueidentifier] 
,[zav_routineinspectionfrequencyby_entitytype] [varchar](256) 
,[zav_secondclient] [uniqueidentifier] 
,[zav_secondclient_entitytype] [varchar](256) 
,[zav_setupinspectiondateby] [uniqueidentifier] 
,[zav_setupinspectiondateby_entitytype] [varchar](256) 
,[zav_setupofrentreviewdatesby] [uniqueidentifier] 
,[zav_setupofrentreviewdatesby_entitytype] [varchar](256) 
,[zav_signedmsdresponsibilitiesconditionsuser] [uniqueidentifier] 
,[zav_signedmsdresponsibilitiesconditionsuser_entitytype] [varchar](256) 
,[zav_signedsngformsuser] [uniqueidentifier] 
,[zav_signedsngformsuser_entitytype] [varchar](256) 
,[zav_subprogram] [uniqueidentifier] 
,[zav_subprogram_entitytype] [varchar](256) 
,[zav_supportpeopleandemergencyuser] [uniqueidentifier] 
,[zav_supportpeopleandemergencyuser_entitytype] [varchar](256) 
,[zav_tenancyappropriatelyuser] [uniqueidentifier] 
,[zav_tenancyappropriatelyuser_entitytype] [varchar](256) 
,[zav_tenancycontributionrenthasbeensetupuser] [uniqueidentifier] 
,[zav_tenancycontributionrenthasbeensetupuser_entitytype] [varchar](256) 
,[zav_tenancymanager] [uniqueidentifier] 
,[zav_tenancymanager_entitytype] [varchar](256) 
,[zav_tenancymanagerid] [uniqueidentifier] 
,[zav_tenancymanagerid_entitytype] [varchar](256) 
,[zav_tenancystartedinboswithcorrectdetailsuser] [uniqueidentifier] 
,[zav_tenancystartedinboswithcorrectdetailsuser_entitytype] [varchar](256) 
,[zav_tenancytypeid] [uniqueidentifier] 
,[zav_tenancytypeid_entitytype] [varchar](256) 
,[zav_tenantconfirmedconditionby] [uniqueidentifier] 
,[zav_tenantconfirmedconditionby_entitytype] [varchar](256) 
,[zav_tenantconfirmsingoinginventorylistuser] [uniqueidentifier] 
,[zav_tenantconfirmsingoinginventorylistuser_entitytype] [varchar](256) 
,[zav_transferapplication] [uniqueidentifier] 
,[zav_transferapplication_entitytype] [varchar](256) 
,[zav_transfertotenancy] [uniqueidentifier] 
,[zav_transfertotenancy_entitytype] [varchar](256) 
,[zav_voidcategory] [uniqueidentifier] 
,[zav_voidcategory_entitytype] [varchar](256) 
,[zav_voidchecklist] [uniqueidentifier] 
,[zav_voidchecklist_entitytype] [varchar](256) 
,[zav_voidproperty] [uniqueidentifier] 
,[zav_voidproperty_entitytype] [varchar](256) 
,[ownerid] [uniqueidentifier] 
,[ownerid_entitytype] [varchar](256) 
,[customerid] [uniqueidentifier] 
,[customerid_entitytype] [varchar](256) 
,[actualvalue] [decimal](38,2) 
,[actualvalue_base] [decimal](38,4) 
,[budgetamount] [decimal](38,2) 
,[budgetamount_base] [decimal](38,4) 
,[discountamount] [decimal](38,2) 
,[discountamount_base] [decimal](38,4) 
,[estimatedvalue] [decimal](38,2) 
,[estimatedvalue_base] [decimal](38,4) 
,[freightamount] [decimal](38,2) 
,[freightamount_base] [decimal](38,4) 
,[new_bondbalance] [decimal](38,4) 
,[new_bondbalance_base] [decimal](38,4) 
,[new_newrent] [decimal](38,4) 
,[new_newrent_base] [decimal](38,4) 
,[new_nonrent] [decimal](38,2) 
,[new_nonrent_base] [decimal](38,2) 
,[new_rent] [decimal](38,2) 
,[new_rent_base] [decimal](38,2) 
,[new_transactionbalancetotal] [decimal](38,2) 
,[new_transactionbalancetotal_base] [decimal](38,2) 
,[totalamount] [decimal](38,2) 
,[totalamount_base] [decimal](38,4) 
,[totalamountlessfreight] [decimal](38,2) 
,[totalamountlessfreight_base] [decimal](38,4) 
,[totaldiscountamount] [decimal](38,2) 
,[totaldiscountamount_base] [decimal](38,4) 
,[totallineitemamount] [decimal](38,2) 
,[totallineitemamount_base] [decimal](38,4) 
,[totallineitemdiscountamount] [decimal](38,2) 
,[totallineitemdiscountamount_base] [decimal](38,4) 
,[totaltax] [decimal](38,2) 
,[totaltax_base] [decimal](38,4) 
,[zav_approvedsngcap] [decimal](38,0) 
,[zav_approvedsngcap_base] [decimal](38,0) 
,[zav_balancewithtenancyservices] [decimal](38,2) 
,[zav_balancewithtenancyservices_base] [decimal](38,2) 
,[zav_bondamount] [decimal](38,4) 
,[zav_bondamount_base] [decimal](38,4) 
,[zav_chintarobondamount] [decimal](38,4) 
,[zav_chintarobondamount_base] [decimal](38,4) 
,[zav_expectedbondamount] [decimal](38,2) 
,[zav_expectedbondamount_base] [decimal](38,2) 
,[zav_inhand] [decimal](38,4) 
,[zav_inhand_base] [decimal](38,4) 
,[zav_marketrent] [decimal](38,2) 
,[zav_marketrent_base] [decimal](38,2) 
,[zav_newestrentupdate] [decimal](38,2) 
,[zav_newestrentupdate_base] [decimal](38,2) 
,[zav_refundrequired] [decimal](38,4) 
,[zav_refundrequired_base] [decimal](38,4) 
,[zav_rentowesasofexpectedvacatedate] [decimal](38,4) 
,[zav_rentowesasofexpectedvacatedate_base] [decimal](38,4) 
,[zav_rentpayable] [decimal](38,4) 
,[zav_rentpayable_base] [decimal](38,4) 
,[zav_rentpayablebasicrentcraweekly] [decimal](38,4) 
,[zav_rentpayablebasicrentcraweekly_base] [decimal](38,4) 
,[zav_totalotherandamenities] [decimal](38,2) 
,[zav_totalotherandamenities_base] [decimal](38,2) 
,[zav_totalrentamount] [decimal](38,2) 
,[zav_totalrentamount_base] [decimal](38,2) 
,[zav_totaltenantliabilityamount] [decimal](38,2) 
,[zav_totaltenantliabilityamount_base] [decimal](38,2) 
,[zav_totalutilitiesamount] [decimal](38,2) 
,[zav_totalutilitiesamount_base] [decimal](38,2) 
,[zav_totalwateramount] [decimal](38,2) 
,[zav_totalwateramount_base] [decimal](38,2) 
,[accountidname] [varchar](640) 
,[accountidyominame] [varchar](640) 
,[actualclosedate] [datetime2](7) 
,[campaignidname] [varchar](512) 
,[closeprobability] [bigint] 
,[contactidname] [varchar](640) 
,[contactidyominame] [varchar](640) 
,[crba8_navigatornotifiedbyname] [varchar](1026) 
,[crba8_navigatornotifiedbyyominame] [varchar](1026) 
,[crba8_navigatornotifiedon] [datetime2](7) 
,[createdbyname] [varchar](640) 
,[createdbyyominame] [varchar](640) 
,[createdon] [datetimeoffset](7) 
,[createdonbehalfbyname] [varchar](640) 
,[createdonbehalfbyyominame] [varchar](640) 
,[currentsituation] [varchar](max) 
,[customeridname] [varchar](max) 
,[customeridtype] [varchar](8000) 
,[customeridyominame] [varchar](max) 
,[customerneed] [varchar](max) 
,[customerpainpoints] [varchar](max) 
,[description] [varchar](max) 
,[discountpercentage] [decimal](38,2) 
,[emailaddress] [varchar](max) 
,[estimatedclosedate] [datetime2](7) 
,[exchangerate] [decimal](38,10) 
,[finaldecisiondate] [datetime2](7) 
,[importsequencenumber] [bigint] 
,[lastonholdtime] [datetime2](7) 
,[modifiedbyname] [varchar](640) 
,[modifiedbyyominame] [varchar](640) 
,[modifiedon] [datetime2](7) 
,[modifiedonbehalfbyname] [varchar](640) 
,[modifiedonbehalfbyyominame] [varchar](640) 
,[msdyn_opportunitykpiidname] [varchar](400) 
,[msdyn_opportunityscore] [bigint] 
,[msdyn_predictivescoreidname] [varchar](512) 
,[msdyn_scorehistory] [varchar](max) 
,[msdyn_scorereasons] [varchar](max) 
,[msdyn_segmentidname] [varchar](400) 
,[msdyn_similaropportunities] [varchar](max) 
,[name] [varchar](1600) 
,[new_deadlineforpaymenttoba] [datetime2](7) 
,[new_effectivenewrentstartdate] [datetime2](7) 
,[new_emergencycontactmobile1] [varchar](400) 
,[new_emergencycontactmobile2] [varchar](400) 
,[new_emergencycontactname1] [varchar](400) 
,[new_emergencycontactname2] [varchar](400) 
,[new_emergencycontactrelationship1_newname] [varchar](400) 
,[new_emergencycontactrelationship1name] [varchar](400) 
,[new_emergencycontactrelationship2_newname] [varchar](400) 
,[new_emergencycontactrelationship2name] [varchar](400) 
,[new_exitcomment] [varchar](max) 
,[new_keysreceivedfromtenantdate] [datetime2](7) 
,[new_nobedroomsexitedto] [bigint] 
,[new_nonrent_date] [datetime2](7) 
,[new_nonrent_state] [bigint] 
,[new_rent_date] [datetime2](7) 
,[new_rent_state] [bigint] 
,[new_riskslist] [varchar](max) 
,[new_tenant1mobilephone] [varchar](400) 
,[new_tenant2mobilephone] [varchar](400) 
,[new_test] [varchar](400) 
,[onholdtime] [bigint] 
,[opportunityid] [uniqueidentifier] 
,[originatingleadidname] [varchar](640) 
,[originatingleadidyominame] [varchar](640) 
,[overriddencreatedon] [datetime2](7) 
,[owneridname] [varchar](640) 
,[owneridtype] [varchar](8000) 
,[owneridyominame] [varchar](640) 
,[owningbusinessunitname] [varchar](640) 
,[parentaccountidname] [varchar](640) 
,[parentaccountidyominame] [varchar](640) 
,[parentcontactidname] [varchar](640) 
,[parentcontactidyominame] [varchar](640) 
,[pricelevelidname] [varchar](400) 
,[processid] [uniqueidentifier] 
,[proposedsolution] [varchar](max) 
,[qualificationcomments] [varchar](max) 
,[quotecomments] [varchar](max) 
,[schedulefollowup_prospect] [datetime2](7) 
,[schedulefollowup_qualify] [datetime2](7) 
,[scheduleproposalmeeting] [datetime2](7) 
,[slainvokedidname] [varchar](640) 
,[slaname] [varchar](400) 
,[stageid] [uniqueidentifier] 
,[stepid] [uniqueidentifier] 
,[stepname] [varchar](800) 
,[teamsfollowed] [bigint] 
,[timespentbymeonemailandmeetings] [varchar](5000) 
,[timezoneruleversionnumber] [bigint] 
,[transactioncurrencyidname] [varchar](400) 
,[traversedpath] [varchar](5000) 
,[utcconversiontimezonecode] [bigint] 
,[versionnumber] [bigint] 
,[zav_accrisstartdate] [datetime2](7) 
,[zav_activatetenancybyname] [varchar](1026) 
,[zav_activatetenancybyyominame] [varchar](1026) 
,[zav_activatetenancydate] [datetime2](7) 
,[zav_actualstartdate] [datetime2](7) 
,[zav_bondcomments] [varchar](max) 
,[zav_bondguaranteeinformationprovidedbyname] [varchar](1026) 
,[zav_bondguaranteeinformationprovidedbyyominame] [varchar](1026) 
,[zav_bondguaranteeinformationprovideddate] [datetime2](7) 
,[zav_bondlodged] [datetime2](7) 
,[zav_bondreference] [varchar](400) 
,[zav_bondrefundformlodged] [datetime2](7) 
,[zav_checkthatbodycorporresidentsdate] [datetime2](7) 
,[zav_checkthatbodycorporresidentsusername] [varchar](1026) 
,[zav_checkthatbodycorporresidentsuseryominame] [varchar](1026) 
,[zav_chintaroid] [varchar](400) 
,[zav_comments] [varchar](max) 
,[zav_commenttofinance] [varchar](max) 
,[zav_consenttoholdpersonalinformationbyname] [varchar](1026) 
,[zav_consenttoholdpersonalinformationbyyominame] [varchar](1026) 
,[zav_consenttoholdpersonalinformationdate] [datetime2](7) 
,[zav_correspondenceaddressedcoappcityname] [varchar](400) 
,[zav_correspondenceaddressedcoapppostcode] [varchar](400) 
,[zav_correspondenceaddressedcoappregionname] [varchar](400) 
,[zav_correspondenceaddressedcoappstreet] [varchar](400) 
,[zav_correspondenceaddressedcoappstreetname] [varchar](400) 
,[zav_correspondenceaddressedcoappsuburb] [varchar](800) 
,[zav_correspondenceaddressedcoappunit] [varchar](960) 
,[zav_correspondenceaddressedmainappbuildingnam] [varchar](400) 
,[zav_correspondenceaddressedmainappcityname] [varchar](400) 
,[zav_correspondenceaddressedmainapppostcode] [varchar](400) 
,[zav_correspondenceaddressedmainappregionname] [varchar](400) 
,[zav_correspondenceaddressedmainappstreet] [varchar](400) 
,[zav_correspondenceaddressedmainappstreetname] [varchar](400) 
,[zav_correspondenceaddressedmainappsuburb] [varchar](800) 
,[zav_correspondenceaddressedmainappunit] [varchar](996) 
,[zav_detailsofadvicegiven] [varchar](max) 
,[zav_emergencycontactcomment1] [varchar](800) 
,[zav_emergencycontactcomment2] [varchar](800) 
,[zav_emergencycontactemail1] [varchar](400) 
,[zav_emergencycontactemail2] [varchar](400) 
,[zav_equitypercentage] [decimal](38,2) 
,[zav_expectedpaymentdaybyname] [varchar](1026) 
,[zav_expectedpaymentdaybyyominame] [varchar](1026) 
,[zav_expectedpaymentdaydate] [datetime2](7) 
,[zav_expectedvacateddate] [datetime2](7) 
,[zav_expexitdate] [datetime2](7) 
,[zav_fixedtermtenancyenddate] [datetime2](7) 
,[zav_followedmarketrentreviewinbosdate] [datetime2](7) 
,[zav_followedmarketrentreviewinbosusername] [varchar](1026) 
,[zav_followedmarketrentreviewinbosuseryominame] [varchar](1026) 
,[zav_forwardingaddresscityname] [varchar](400) 
,[zav_forwardingaddressregionname] [varchar](400) 
,[zav_forwardingaddressstreetname] [varchar](400) 
,[zav_forwardingaddressstreetnumber] [varchar](400) 
,[zav_forwardingaddresssuburb] [varchar](400) 
,[zav_forwardingaddressunit] [varchar](400) 
,[zav_forwardingaddresszippostalcode] [varchar](400) 
,[zav_guidanceonrentpaymentprocessbyname] [varchar](1026) 
,[zav_guidanceonrentpaymentprocessbyyominame] [varchar](1026) 
,[zav_guidanceonrentpaymentprocessdate] [datetime2](7) 
,[zav_habitattenantapplicationnumber] [varchar](400) 
,[zav_householdcompositioncorrectbyname] [varchar](1026) 
,[zav_householdcompositioncorrectbyyominame] [varchar](1026) 
,[zav_householdcompositioncorrectdate] [datetime2](7) 
,[zav_householdname] [varchar](400) 
,[zav_hudmsdreferencenumber] [varchar](400) 
,[zav_ingoingpropertyconditionreportbyname] [varchar](1026) 
,[zav_ingoingpropertyconditionreportbyyominame] [varchar](1026) 
,[zav_ingoingpropertyconditionreportdate] [datetime2](7) 
,[zav_ingoingtenancyinspectionpropertydate] [datetime2](7) 
,[zav_ingoingtenancyinspectionpropertyusername] [varchar](1026) 
,[zav_ingoingtenancyinspectionpropertyuseryominame] [varchar](1026) 
,[zav_insulationstatementbyname] [varchar](1026) 
,[zav_insulationstatementbyyominame] [varchar](1026) 
,[zav_insulationstatementdate] [datetime2](7) 
,[zav_insurancestatementbyname] [varchar](1026) 
,[zav_insurancestatementbyyominame] [varchar](1026) 
,[zav_insurancestatementdate] [datetime2](7) 
,[zav_keyshandedoveratthesigningofthetenancybyname] [varchar](1026) 
,[zav_keyshandedoveratthesigningofthetenancybyyominame] [varchar](1026) 
,[zav_keyshandedoveratthesigningofthetenancydat] [datetime2](7) 
,[zav_kiangoratenancytype] [varchar](400) 
,[zav_lastinspection] [datetime2](7) 
,[zav_lastrentreview] [datetime2](7) 
,[zav_leaseagreementbyname] [varchar](1026) 
,[zav_leaseagreementbyyominame] [varchar](1026) 
,[zav_leaseagreementdate] [datetime2](7) 
,[zav_maintenanceclaimlodgedwithhud] [datetime2](7) 
,[zav_maintenancefundclaimlodgeddate] [datetime2](7) 
,[zav_nameofpartners] [varchar](max) 
,[zav_newestrentupdatestartdate] [datetime2](7) 
,[zav_nextinspection] [datetime2](7) 
,[zav_nextrentreview] [datetime2](7) 
,[zav_noofdayscharged] [bigint] 
,[zav_notes] [varchar](max) 
,[zav_noticetovacatedate] [datetime2](7) 
,[zav_numberoftenancysignatories] [bigint] 
,[zav_offertenantredirectionforwaterpaymentdate] [datetime2](7) 
,[zav_offertenantredirectionforwaterpaymentusername] [varchar](1026) 
,[zav_offertenantredirectionforwaterpaymentuseryominame] [varchar](1026) 
,[zav_partnersphone] [varchar](400) 
,[zav_paymentbookid] [varchar](400) 
,[zav_paymentreferenceno] [varchar](400) 
,[zav_paytotenancyservicesby] [datetime2](7) 
,[zav_petage] [decimal](38,3) 
,[zav_petbreed] [varchar](400) 
,[zav_petname] [varchar](4000) 
,[zav_petregistrationdetails] [varchar](400) 
,[zav_pettype] [varchar](400) 
,[zav_programname] [varchar](400) 
,[zav_propertyname] [varchar](400) 
,[zav_providehealthanddisabilityinformationdate] [datetime2](7) 
,[zav_providehealthanddisabilityinformationusername] [varchar](1026) 
,[zav_providehealthanddisabilityinformationuseryominame] [varchar](1026) 
,[zav_providetenancypackbyname] [varchar](1026) 
,[zav_providetenancypackbyyominame] [varchar](1026) 
,[zav_providetenancypackdate] [datetime2](7) 
,[zav_refundlodged] [datetime2](7) 
,[zav_relativeurl] [varchar](3600) 
,[zav_rentchargedto] [datetime2](7) 
,[zav_rentchargedtotest] [datetime2](7) 
,[zav_rentchargedtotest1] [datetime2](7) 
,[zav_rentchargedtotest2] [datetime2](7) 
,[zav_rentpaidto] [datetime2](7) 
,[zav_rentpaidtouserlocal] [datetime2](7) 
,[zav_rentpaymentdays] [bigint] 
,[zav_renttobepaidat] [varchar](4000) 
,[zav_rescinddate] [datetime2](7) 
,[zav_routineinspectionfrequencybyname] [varchar](1026) 
,[zav_routineinspectionfrequencybyyominame] [varchar](1026) 
,[zav_routineinspectionfrequencydate] [datetime2](7) 
,[zav_secondclientname] [varchar](640) 
,[zav_secondclientyominame] [varchar](1800) 
,[zav_setupinspectiondatebyname] [varchar](1026) 
,[zav_setupinspectiondatebyyominame] [varchar](1026) 
,[zav_setupinspectiondatedate] [datetime2](7) 
,[zav_setupofrentreviewdatesbyname] [varchar](1026) 
,[zav_setupofrentreviewdatesbyyominame] [varchar](1026) 
,[zav_setupofrentreviewdatesdate] [datetime2](7) 
,[zav_shorttermindays] [bigint] 
,[zav_shorttermtenancyenddate] [datetime2](7) 
,[zav_signedmsdresponsibilitiesconditionsdate] [datetime2](7) 
,[zav_signedmsdresponsibilitiesconditionsusername] [varchar](1026) 
,[zav_signedmsdresponsibilitiesconditionsuseryominame] [varchar](1026) 
,[zav_signedsngformsdate] [datetime2](7) 
,[zav_signedsngformsusername] [varchar](1026) 
,[zav_signedsngformsuseryominame] [varchar](1026) 
,[zav_sngclaimlodgeddatecomments] [varchar](3600) 
,[zav_sngclaimlodgementdate] [datetime2](7) 
,[zav_sngclaimrelodgeddate1] [datetime2](7) 
,[zav_sngclaimrelodgeddate1comments] [varchar](3600) 
,[zav_sngclaimrelodgeddate2] [datetime2](7) 
,[zav_sngclaimrelodgeddate2comments] [varchar](3600) 
,[zav_sngclaimrelodgeddate3] [datetime2](7) 
,[zav_sngclaimrelodgeddate3comments] [varchar](3600) 
,[zav_sngclaimrelodgeddate4] [datetime2](7) 
,[zav_sngclaimrelodgeddate4comments] [varchar](3600) 
,[zav_sngclaimuploadedtomsd] [datetime2](7) 
,[zav_startingdateforrentamount] [datetime2](7) 
,[zav_subprogramname] [varchar](400) 
,[zav_supportpeopleandemergedate] [datetime2](7) 
,[zav_supportpeopleandemergencyusername] [varchar](1026) 
,[zav_supportpeopleandemergencyuseryominame] [varchar](1026) 
,[zav_tenancyappropriatelydate] [datetime2](7) 
,[zav_tenancyappropriatelydescription] [varchar](max) 
,[zav_tenancyappropriatelyusername] [varchar](1026) 
,[zav_tenancyappropriatelyuseryominame] [varchar](1026) 
,[zav_tenancycontributionrenthasbeensetupdate] [datetime2](7) 
,[zav_tenancycontributionrenthasbeensetupusername] [varchar](1026) 
,[zav_tenancycontributionrenthasbeensetupuseryominame] [varchar](1026) 
,[zav_tenancygreetingline] [varchar](1200) 
,[zav_tenancyid] [varchar](400) 
,[zav_tenancymanageremail] [varchar](400) 
,[zav_tenancymanageridname] [varchar](1026) 
,[zav_tenancymanageridyominame] [varchar](1026) 
,[zav_tenancymanagermobile] [varchar](400) 
,[zav_tenancymanagername] [varchar](640) 
,[zav_tenancymanageryominame] [varchar](1800) 
,[zav_tenancyreferencenumber] [varchar](400) 
,[zav_tenancyservicebondnumber] [varchar](400) 
,[zav_tenancyservicespropertyid] [varchar](40) 
,[zav_tenancystartdate] [datetime2](7) 
,[zav_tenancystartedinboswithcorrectdetailsdate] [datetime2](7) 
,[zav_tenancystartedinboswithcorrectdetailsusername] [varchar](1026) 
,[zav_tenancystartedinboswithcorrectdetailsuseryominame] [varchar](1026) 
,[zav_tenancytypeidname] [varchar](400) 
,[zav_tenantconfirmedconditionbyname] [varchar](1026) 
,[zav_tenantconfirmedconditionbyyominame] [varchar](1026) 
,[zav_tenantconfirmedconditiondate] [datetime2](7) 
,[zav_tenantconfirmsingoinginventorylistdate] [datetime2](7) 
,[zav_tenantconfirmsingoinginventorylistusername] [varchar](1026) 
,[zav_tenantconfirmsingoinginventorylistuseryominame] [varchar](1026) 
,[zav_theoutcomeoftherequest] [varchar](max) 
,[zav_thereasonformakingtherequest] [varchar](max) 
,[zav_tobepaidweeks] [bigint] 
,[zav_totalotherandamenities_date] [datetime2](7) 
,[zav_totalotherandamenities_state] [bigint] 
,[zav_totalrentamount_date] [datetime2](7) 
,[zav_totalrentamount_state] [bigint] 
,[zav_totaltenantliabilityamount_date] [datetime2](7) 
,[zav_totaltenantliabilityamount_state] [bigint] 
,[zav_totalutilitiesamount_date] [datetime2](7) 
,[zav_totalutilitiesamount_state] [bigint] 
,[zav_totalwateramount_date] [datetime2](7) 
,[zav_totalwateramount_state] [bigint] 
,[zav_transferapplicationname] [varchar](400) 
,[zav_transferlodged] [datetime2](7) 
,[zav_transferreddate] [datetime2](7) 
,[zav_transfertotenancyname] [varchar](1600) 
,[zav_vacancybedrooms] [bigint] 
,[zav_vacateddate] [datetime2](7) 
,[zav_voidcategoryname] [varchar](16) 
,[zav_voidchecklistname] [varchar](400) 
,[zav_voidpropertyname] [varchar](400) 
,[zav_whennotifiedtomsd] [datetime2](7) 
,[zav_wstpacparticular] [varchar](400) 
,[IsDelete] [varchar](6) 
,[zav_housingfirst] [varchar](6) 
,[zav_watermeterreadingingoing] [bigint] 
,[zav_watermeterreadingoutgoing] [bigint] 
,[zav_financeadvisedtopayhud] [datetime2](7) 
,[zav_financeadvisedtopayhudcomments] [varchar](3600) 
,[zav_notificationarrearsexiststoggle] [varchar](6) 
,[zav_notificationarrearsexists] [varchar](400) 
,[zav_managedarrears] [decimal](38,2) 
,[zav_managedarrears_base] [decimal](38,2) 
,[zav_unmanagedarrears] [decimal](38,2) 
,[zav_unmanagedarrears_base] [decimal](38,2) 
,[zav_arrangementindefault] [varchar](6) 
,[zav_arrearsstatus] [bigint] 
,[zav_numberofdaysinarrears] [bigint] 
,[zav_triggerarrearsflow] [varchar](6) 
,[zav_newarrangementindefault] [bigint] 
,[zav_paymentnotes] [varchar](400) 
,[zav_totalclientdamagesamount] [decimal](38,2) 
,[zav_totalclientdamagesamount_base] [decimal](38,2) 
,[zav_totalclientdamagesamount_date] [datetime2](7) 
,[zav_totalclientdamagesamount_state] [bigint] 
,[zav_isthisavacatingmoteltenancy] [bigint] 
,[zav_bondnotificationpreference] [bigint] 
,[zav_noweekspetbondbeingcharged] [bigint] 
,[zav_tenanttype] [bigint] 
,[zav_bondsubmitted] [varchar](6) 
,[zav_expectedpetbondamount] [decimal](38,2) 
,[zav_expectedpetbondamount_base] [decimal](38,2) 
,[zav_petbondbalance] [decimal](38,2) 
,[zav_petbondbalance_base] [decimal](38,2) 
,[zav_petbondbalancewithtenancyservices] [decimal](38,2) 
,[zav_petbondbalancewithtenancyservices_base] [decimal](38,2) 
,[zav_tenancyprogrammehistory] [varchar](max) 
,[zav_bondnumbercheck] [varchar](6) )  AS d  )  AS [data]  WHERE row_num = 1 
-- return only latest record  GO  
GO


