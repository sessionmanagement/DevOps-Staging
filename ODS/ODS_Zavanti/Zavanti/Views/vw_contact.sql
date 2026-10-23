CREATE VIEW [Zavanti].[vw_contact]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[accountrolecode]
,[address1_addresstypecode]
,[address1_freighttermscode]
,[address1_shippingmethodcode]
,[address2_addresstypecode]
,[address2_freighttermscode]
,[address2_shippingmethodcode]
,[address3_addresstypecode]
,[address3_freighttermscode]
,[address3_shippingmethodcode]
,[customersizecode]
,[customertypecode]
,[educationcode]
,[familystatuscode]
,[gendercode]
,[haschildrencode]
,[leadsourcecode]
,[msdyn_decisioninfluencetag]
,[msdyn_orgchangestatus]
,[msft_datastate]
,[paymenttermscode]
,[preferredappointmentdaycode]
,[preferredappointmenttimecode]
,[preferredcontactmethodcode]
,[shippingmethodcode]
,[territorycode]
,[zav_address1state]
,[zav_aremainapplicantsabletosignlegaldocumenos]
,[zav_band]
,[zav_contacttitle]
,[zav_contacttype]
,[zav_cra]
,[zav_disability]
,[zav_doesanymemberofyourhouseholdhaveamedicos]
,[zav_doesanymemberofyourhouseholdhavedisabilos]
,[zav_doyourequirealiveincaros]
,[zav_employment]
,[zav_gender]
,[zav_hearingimpaireddescription]
,[zav_isthereanagenttoactonbehalfofindividual]
,[zav_proficiencyspokenenglish]
,[zav_proficiencywrittenenglish]
,[zav_rentareaoverride]
,[zav_targetgroup]
,[zav_visuallyimpaireddescription]
,[zav_agentfor]
,[zav_otherneedsofthehousehold]
,[zav_secondarysupportneeds]
,[zav_specialneedsofthetenant]
,[zav_supportneeds]
,[creditonhold]
,[donotbulkemail]
,[donotbulkpostalmail]
,[donotemail]
,[donotfax]
,[donotphone]
,[donotpostalmail]
,[donotsendmm]
,[followemail]
,[isautocreate]
,[isbackofficecustomer]
,[isprivate]
,[marketingonly]
,[merged]
,[msdyn_gdproptout]
,[msdyn_isassistantinorgchart]
,[new_arrearsactionflag]
,[new_interpretorrequired]
,[new_nzresident]
,[new_potentialrisktostaff]
,[new_student]
,[participatesinworkflow]
,[zav_applydisabilityallowance]
,[zav_australianresident]
,[zav_carowner]
,[zav_centrelinkincomeauthority]
,[zav_centrepaydeduction]
,[zav_crachangesevor]
,[zav_dhsregistration]
,[zav_donotallowinvitations]
,[zav_donotallownewsletters]
,[zav_driverslicence]
,[zav_identificationother]
,[zav_iwimember]
,[zav_nfa]
,[zav_passport]
,[zav_postaladdresssameasmainaddress]
,[zav_primarytenant]
,[zav_prison]
,[zav_proofofincome]
,[zav_publichousingreg]
,[accountid]
,[accountid_entitytype]
,[bcbi_companyid]
,[bcbi_companyid_entitytype]
,[createdby]
,[createdby_entitytype]
,[createdbyexternalparty]
,[createdbyexternalparty_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[defaultpricelevelid]
,[defaultpricelevelid_entitytype]
,[masterid]
,[masterid_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedbyexternalparty]
,[modifiedbyexternalparty_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[msdyn_contactkpiid]
,[msdyn_contactkpiid_entitytype]
,[msdyn_segmentid]
,[msdyn_segmentid_entitytype]
,[new_emergencycontactrelationship1_new]
,[new_emergencycontactrelationship1_new_entitytype]
,[new_emergencycontactrelationship2_new]
,[new_emergencycontactrelationship2_new_entitytype]
,[new_officelocationid]
,[new_officelocationid_entitytype]
,[originatingleadid]
,[originatingleadid_entitytype]
,[owningbusinessunit]
,[owningbusinessunit_entitytype]
,[owningteam]
,[owningteam_entitytype]
,[owninguser]
,[owninguser_entitytype]
,[parentcontactid]
,[parentcontactid_entitytype]
,[preferredequipmentid]
,[preferredequipmentid_entitytype]
,[preferredserviceid]
,[preferredserviceid_entitytype]
,[preferredsystemuserid]
,[preferredsystemuserid_entitytype]
,[slaid]
,[slaid_entitytype]
,[slainvokedid]
,[slainvokedid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_address3city]
,[zav_address3city_entitytype]
,[zav_address3region]
,[zav_address3region_entitytype]
,[zav_city1]
,[zav_city1_entitytype]
,[zav_city2]
,[zav_city2_entitytype]
,[zav_contact]
,[zav_contact_entitytype]
,[zav_country]
,[zav_country_entitytype]
,[zav_countrywhereborn]
,[zav_countrywhereborn_entitytype]
,[zav_emergencycontactrelationship1]
,[zav_emergencycontactrelationship1_entitytype]
,[zav_emergencycontactrelationship2]
,[zav_emergencycontactrelationship2_entitytype]
,[zav_ethnicity]
,[zav_ethnicity_entitytype]
,[zav_household]
,[zav_household_entitytype]
,[zav_interpreterlanguage]
,[zav_interpreterlanguage_entitytype]
,[zav_iwiaffiliation]
,[zav_iwiaffiliation_entitytype]
,[zav_mainlanguage]
,[zav_mainlanguage_entitytype]
,[zav_postalregionid]
,[zav_postalregionid_entitytype]
,[zav_referral]
,[zav_referral_entitytype]
,[zav_regionid]
,[zav_regionid_entitytype]
,[zav_supportagency]
,[zav_supportagency_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[parentcustomerid]
,[parentcustomerid_entitytype]
,[aging30]
,[aging30_base]
,[aging60]
,[aging60_base]
,[aging90]
,[aging90_base]
,[annualincome]
,[annualincome_base]
,[creditlimit]
,[creditlimit_base]
,[accountidname]
,[accountidyominame]
,[address1_addressid]
,[address1_city]
,[address1_composite]
,[address1_country]
,[address1_county]
,[address1_fax]
,[address1_latitude]
,[address1_line1]
,[address1_line2]
,[address1_line3]
,[address1_longitude]
,[address1_name]
,[address1_postalcode]
,[address1_postofficebox]
,[address1_primarycontactname]
,[address1_stateorprovince]
,[address1_telephone1]
,[address1_telephone2]
,[address1_telephone3]
,[address1_upszone]
,[address1_utcoffset]
,[address2_addressid]
,[address2_city]
,[address2_composite]
,[address2_country]
,[address2_county]
,[address2_fax]
,[address2_latitude]
,[address2_line1]
,[address2_line2]
,[address2_line3]
,[address2_longitude]
,[address2_name]
,[address2_postalcode]
,[address2_postofficebox]
,[address2_primarycontactname]
,[address2_stateorprovince]
,[address2_telephone1]
,[address2_telephone2]
,[address2_telephone3]
,[address2_upszone]
,[address2_utcoffset]
,[address3_addressid]
,[address3_city]
,[address3_composite]
,[address3_country]
,[address3_county]
,[address3_fax]
,[address3_latitude]
,[address3_line1]
,[address3_line2]
,[address3_line3]
,[address3_longitude]
,[address3_name]
,[address3_postalcode]
,[address3_postofficebox]
,[address3_primarycontactname]
,[address3_stateorprovince]
,[address3_telephone1]
,[address3_telephone2]
,[address3_telephone3]
,[address3_upszone]
,[address3_utcoffset]
,[anniversary]
,[assistantname]
,[assistantphone]
,[bcbi_companyidname]
,[birthdate]
,[business2]
,[businesscard]
,[businesscardattributes]
,[callback]
,[childrensnames]
,[company]
,[contactid]
,[createdbyexternalpartyname]
,[createdbyexternalpartyyominame]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[defaultpricelevelidname]
,[department]
,[description]
,[emailaddress1]
,[emailaddress2]
,[emailaddress3]
,[employeeid]
,[entityimage]
,[entityimage_timestamp]
,[entityimage_url]
,[entityimageid]
,[exchangerate]
,[externaluseridentifier]
,[fax]
,[firstname]
,[ftpsiteurl]
,[fullname]
,[governmentid]
,[home2]
,[importsequencenumber]
,[jobtitle]
,[lastname]
,[lastonholdtime]
,[lastusedincampaign]
,[managername]
,[managerphone]
,[mastercontactidname]
,[mastercontactidyominame]
,[middlename]
,[mobilephone]
,[modifiedbyexternalpartyname]
,[modifiedbyexternalpartyyominame]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[msdyn_contactkpiidname]
,[msdyn_segmentidname]
,[new_arrearssince]
,[new_bankaccountname]
,[new_bsb]
,[new_dateofbirth]
,[new_emergencycontactrelationship1_newname]
,[new_emergencycontactrelationship2_newname]
,[new_irdnumber]
,[new_iwimember]
,[new_officelocationidname]
,[new_recordbaseid]
,[nickname]
,[numberofchildren]
,[onholdtime]
,[originatingleadidname]
,[originatingleadidyominame]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[pager]
,[parentcontactidname]
,[parentcontactidyominame]
,[parentcustomeridname]
,[parentcustomeridtype]
,[parentcustomeridyominame]
,[preferredequipmentidname]
,[preferredserviceidname]
,[preferredsystemuseridname]
,[preferredsystemuseridyominame]
,[processid]
,[salutation]
,[slainvokedidname]
,[slaname]
,[spousesname]
,[stageid]
,[subscriptionid]
,[suffix]
,[teamsfollowed]
,[telephone1]
,[telephone2]
,[telephone3]
,[timespentbymeonemailandmeetings]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[traversedpath]
,[utcconversiontimezonecode]
,[versionnumber]
,[websiteurl]
,[yomifirstname]
,[yomifullname]
,[yomilastname]
,[yomimiddlename]
,[zav_accrisid]
,[zav_address1unit]
,[zav_address2unit]
,[zav_address3cityname]
,[zav_address3regionname]
,[zav_address3unit]
,[zav_age]
,[zav_aka]
,[zav_bankaccount]
,[zav_bankbranch]
,[zav_bankname]
,[zav_briefdetailsifnoegyourpowerofattorney]
,[zav_briefdetailsifyes]
,[zav_briefdetailsifyesmedicalcondition]
,[zav_careof]
,[zav_carvehicleregistrationnumber]
,[zav_centrelinkcrn]
,[zav_chintaroid]
,[zav_city1name]
,[zav_city2name]
,[zav_clientid]
,[zav_clientsupportagencyid]
,[zav_comments]
,[zav_community]
,[zav_contactname]
,[zav_contactyominame]
,[zav_countryname]
,[zav_countrywherebornname]
,[zav_driverslicencenumber]
,[zav_emergencycontactcomment1]
,[zav_emergencycontactcomment2]
,[zav_emergencycontactemail1]
,[zav_emergencycontactemail2]
,[zav_emergencycontactname1]
,[zav_emergencycontactname2]
,[zav_emergencycontactphone1]
,[zav_emergencycontactphone2]
,[zav_emergencycontactrelationship1name]
,[zav_emergencycontactrelationship2name]
,[zav_ethnicityname]
,[zav_householdname]
,[zav_idnumber]
,[zav_initialtenancystartdate]
,[zav_interpreterlanguagename]
,[zav_iwiaffiliationname]
,[zav_mainlanguagename]
,[zav_makeandmodel]
,[zav_msdaltphone]
,[zav_msdbenefitno]
,[zav_msdhomephone]
,[zav_msdmobilephone]
,[zav_msdworkphone]
,[zav_personreferencenumber]
,[zav_petage]
,[zav_petbreed]
,[zav_petname]
,[zav_petregistrationdetails]
,[zav_pettype]
,[zav_postalregionidname]
,[zav_publichousingwaitlist]
,[zav_referralname]
,[zav_referralyominame]
,[zav_regionidname]
,[zav_registrationdate]
,[zav_supportagencyname]
,[zav_supportagencyyominame]
,[zav_winznumber]
,[zav_workfax]
,[zav_zavantidatamaskinglogs]
,[IsDelete]
,[msa_managingpartnerid]
,[msa_managingpartnerid_entitytype]
,[adx_createdbyipaddress]
,[adx_createdbyusername]
,[adx_modifiedbyipaddress]
,[adx_modifiedbyusername]
,[adx_organizationname]
,[adx_timezone]
,[msa_managingpartneridname]
,[msa_managingpartneridyominame]
,[msdyn_disablewebtracking]
,[msdyn_isminor]
,[msdyn_isminorwithparentalconsent]
,[msdyn_portaltermsagreementdate]
,[adx_confirmremovepassword]
,[adx_identity_emailaddress1confirmed]
,[adx_identity_locallogindisabled]
,[adx_identity_lockoutenabled]
,[adx_identity_logonenabled]
,[adx_identity_mobilephoneconfirmed]
,[adx_identity_twofactorenabled]
,[adx_profilealert]
,[adx_profileisanonymous]
,[adx_identity_accessfailedcount]
,[adx_identity_lastsuccessfullogin]
,[adx_identity_lockoutenddate]
,[adx_identity_newpassword]
,[adx_identity_passwordhash]
,[adx_identity_securitystamp]
,[adx_identity_username]
,[adx_preferredlcid]
,[adx_profilealertdate]
,[adx_profilealertinstructions]
,[adx_profilelastactivity]
,[adx_profilemodifiedon]
,[adx_publicprofilecopy]
,[mspp_userpreferredlcid]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[accountrolecode]
,[address1_addresstypecode]
,[address1_freighttermscode]
,[address1_shippingmethodcode]
,[address2_addresstypecode]
,[address2_freighttermscode]
,[address2_shippingmethodcode]
,[address3_addresstypecode]
,[address3_freighttermscode]
,[address3_shippingmethodcode]
,[customersizecode]
,[customertypecode]
,[educationcode]
,[familystatuscode]
,[gendercode]
,[haschildrencode]
,[leadsourcecode]
,[msdyn_decisioninfluencetag]
,[msdyn_orgchangestatus]
,[msft_datastate]
,[paymenttermscode]
,[preferredappointmentdaycode]
,[preferredappointmenttimecode]
,[preferredcontactmethodcode]
,[shippingmethodcode]
,[territorycode]
,[zav_address1state]
,[zav_aremainapplicantsabletosignlegaldocumenos]
,[zav_band]
,[zav_contacttitle]
,[zav_contacttype]
,[zav_cra]
,[zav_disability]
,[zav_doesanymemberofyourhouseholdhaveamedicos]
,[zav_doesanymemberofyourhouseholdhavedisabilos]
,[zav_doyourequirealiveincaros]
,[zav_employment]
,[zav_gender]
,[zav_hearingimpaireddescription]
,[zav_isthereanagenttoactonbehalfofindividual]
,[zav_proficiencyspokenenglish]
,[zav_proficiencywrittenenglish]
,[zav_rentareaoverride]
,[zav_targetgroup]
,[zav_visuallyimpaireddescription]
,[zav_agentfor]
,[zav_otherneedsofthehousehold]
,[zav_secondarysupportneeds]
,[zav_specialneedsofthetenant]
,[zav_supportneeds]
,[creditonhold]
,[donotbulkemail]
,[donotbulkpostalmail]
,[donotemail]
,[donotfax]
,[donotphone]
,[donotpostalmail]
,[donotsendmm]
,[followemail]
,[isautocreate]
,[isbackofficecustomer]
,[isprivate]
,[marketingonly]
,[merged]
,[msdyn_gdproptout]
,[msdyn_isassistantinorgchart]
,[new_arrearsactionflag]
,[new_interpretorrequired]
,[new_nzresident]
,[new_potentialrisktostaff]
,[new_student]
,[participatesinworkflow]
,[zav_applydisabilityallowance]
,[zav_australianresident]
,[zav_carowner]
,[zav_centrelinkincomeauthority]
,[zav_centrepaydeduction]
,[zav_crachangesevor]
,[zav_dhsregistration]
,[zav_donotallowinvitations]
,[zav_donotallownewsletters]
,[zav_driverslicence]
,[zav_identificationother]
,[zav_iwimember]
,[zav_nfa]
,[zav_passport]
,[zav_postaladdresssameasmainaddress]
,[zav_primarytenant]
,[zav_prison]
,[zav_proofofincome]
,[zav_publichousingreg]
,[accountid]
,[accountid_entitytype]
,[bcbi_companyid]
,[bcbi_companyid_entitytype]
,[createdby]
,[createdby_entitytype]
,[createdbyexternalparty]
,[createdbyexternalparty_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[defaultpricelevelid]
,[defaultpricelevelid_entitytype]
,[masterid]
,[masterid_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedbyexternalparty]
,[modifiedbyexternalparty_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[msdyn_contactkpiid]
,[msdyn_contactkpiid_entitytype]
,[msdyn_segmentid]
,[msdyn_segmentid_entitytype]
,[new_emergencycontactrelationship1_new]
,[new_emergencycontactrelationship1_new_entitytype]
,[new_emergencycontactrelationship2_new]
,[new_emergencycontactrelationship2_new_entitytype]
,[new_officelocationid]
,[new_officelocationid_entitytype]
,[originatingleadid]
,[originatingleadid_entitytype]
,[owningbusinessunit]
,[owningbusinessunit_entitytype]
,[owningteam]
,[owningteam_entitytype]
,[owninguser]
,[owninguser_entitytype]
,[parentcontactid]
,[parentcontactid_entitytype]
,[preferredequipmentid]
,[preferredequipmentid_entitytype]
,[preferredserviceid]
,[preferredserviceid_entitytype]
,[preferredsystemuserid]
,[preferredsystemuserid_entitytype]
,[slaid]
,[slaid_entitytype]
,[slainvokedid]
,[slainvokedid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_address3city]
,[zav_address3city_entitytype]
,[zav_address3region]
,[zav_address3region_entitytype]
,[zav_city1]
,[zav_city1_entitytype]
,[zav_city2]
,[zav_city2_entitytype]
,[zav_contact]
,[zav_contact_entitytype]
,[zav_country]
,[zav_country_entitytype]
,[zav_countrywhereborn]
,[zav_countrywhereborn_entitytype]
,[zav_emergencycontactrelationship1]
,[zav_emergencycontactrelationship1_entitytype]
,[zav_emergencycontactrelationship2]
,[zav_emergencycontactrelationship2_entitytype]
,[zav_ethnicity]
,[zav_ethnicity_entitytype]
,[zav_household]
,[zav_household_entitytype]
,[zav_interpreterlanguage]
,[zav_interpreterlanguage_entitytype]
,[zav_iwiaffiliation]
,[zav_iwiaffiliation_entitytype]
,[zav_mainlanguage]
,[zav_mainlanguage_entitytype]
,[zav_postalregionid]
,[zav_postalregionid_entitytype]
,[zav_referral]
,[zav_referral_entitytype]
,[zav_regionid]
,[zav_regionid_entitytype]
,[zav_supportagency]
,[zav_supportagency_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[parentcustomerid]
,[parentcustomerid_entitytype]
,[aging30]
,[aging30_base]
,[aging60]
,[aging60_base]
,[aging90]
,[aging90_base]
,[annualincome]
,[annualincome_base]
,[creditlimit]
,[creditlimit_base]
,[accountidname]
,[accountidyominame]
,[address1_addressid]
,[address1_city]
,[address1_composite]
,[address1_country]
,[address1_county]
,[address1_fax]
,[address1_latitude]
,[address1_line1]
,[address1_line2]
,[address1_line3]
,[address1_longitude]
,[address1_name]
,[address1_postalcode]
,[address1_postofficebox]
,[address1_primarycontactname]
,[address1_stateorprovince]
,[address1_telephone1]
,[address1_telephone2]
,[address1_telephone3]
,[address1_upszone]
,[address1_utcoffset]
,[address2_addressid]
,[address2_city]
,[address2_composite]
,[address2_country]
,[address2_county]
,[address2_fax]
,[address2_latitude]
,[address2_line1]
,[address2_line2]
,[address2_line3]
,[address2_longitude]
,[address2_name]
,[address2_postalcode]
,[address2_postofficebox]
,[address2_primarycontactname]
,[address2_stateorprovince]
,[address2_telephone1]
,[address2_telephone2]
,[address2_telephone3]
,[address2_upszone]
,[address2_utcoffset]
,[address3_addressid]
,[address3_city]
,[address3_composite]
,[address3_country]
,[address3_county]
,[address3_fax]
,[address3_latitude]
,[address3_line1]
,[address3_line2]
,[address3_line3]
,[address3_longitude]
,[address3_name]
,[address3_postalcode]
,[address3_postofficebox]
,[address3_primarycontactname]
,[address3_stateorprovince]
,[address3_telephone1]
,[address3_telephone2]
,[address3_telephone3]
,[address3_upszone]
,[address3_utcoffset]
,[anniversary]
,[assistantname]
,[assistantphone]
,[bcbi_companyidname]
,[birthdate]
,[business2]
,[businesscard]
,[businesscardattributes]
,[callback]
,[childrensnames]
,[company]
,[contactid]
,[createdbyexternalpartyname]
,[createdbyexternalpartyyominame]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[defaultpricelevelidname]
,[department]
,[description]
,[emailaddress1]
,[emailaddress2]
,[emailaddress3]
,[employeeid]
,[entityimage]
,[entityimage_timestamp]
,[entityimage_url]
,[entityimageid]
,[exchangerate]
,[externaluseridentifier]
,[fax]
,[firstname]
,[ftpsiteurl]
,[fullname]
,[governmentid]
,[home2]
,[importsequencenumber]
,[jobtitle]
,[lastname]
,[lastonholdtime]
,[lastusedincampaign]
,[managername]
,[managerphone]
,[mastercontactidname]
,[mastercontactidyominame]
,[middlename]
,[mobilephone]
,[modifiedbyexternalpartyname]
,[modifiedbyexternalpartyyominame]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[msdyn_contactkpiidname]
,[msdyn_segmentidname]
,[new_arrearssince]
,[new_bankaccountname]
,[new_bsb]
,[new_dateofbirth]
,[new_emergencycontactrelationship1_newname]
,[new_emergencycontactrelationship2_newname]
,[new_irdnumber]
,[new_iwimember]
,[new_officelocationidname]
,[new_recordbaseid]
,[nickname]
,[numberofchildren]
,[onholdtime]
,[originatingleadidname]
,[originatingleadidyominame]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[pager]
,[parentcontactidname]
,[parentcontactidyominame]
,[parentcustomeridname]
,[parentcustomeridtype]
,[parentcustomeridyominame]
,[preferredequipmentidname]
,[preferredserviceidname]
,[preferredsystemuseridname]
,[preferredsystemuseridyominame]
,[processid]
,[salutation]
,[slainvokedidname]
,[slaname]
,[spousesname]
,[stageid]
,[subscriptionid]
,[suffix]
,[teamsfollowed]
,[telephone1]
,[telephone2]
,[telephone3]
,[timespentbymeonemailandmeetings]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[traversedpath]
,[utcconversiontimezonecode]
,[versionnumber]
,[websiteurl]
,[yomifirstname]
,[yomifullname]
,[yomilastname]
,[yomimiddlename]
,[zav_accrisid]
,[zav_address1unit]
,[zav_address2unit]
,[zav_address3cityname]
,[zav_address3regionname]
,[zav_address3unit]
,[zav_age]
,[zav_aka]
,[zav_bankaccount]
,[zav_bankbranch]
,[zav_bankname]
,[zav_briefdetailsifnoegyourpowerofattorney]
,[zav_briefdetailsifyes]
,[zav_briefdetailsifyesmedicalcondition]
,[zav_careof]
,[zav_carvehicleregistrationnumber]
,[zav_centrelinkcrn]
,[zav_chintaroid]
,[zav_city1name]
,[zav_city2name]
,[zav_clientid]
,[zav_clientsupportagencyid]
,[zav_comments]
,[zav_community]
,[zav_contactname]
,[zav_contactyominame]
,[zav_countryname]
,[zav_countrywherebornname]
,[zav_driverslicencenumber]
,[zav_emergencycontactcomment1]
,[zav_emergencycontactcomment2]
,[zav_emergencycontactemail1]
,[zav_emergencycontactemail2]
,[zav_emergencycontactname1]
,[zav_emergencycontactname2]
,[zav_emergencycontactphone1]
,[zav_emergencycontactphone2]
,[zav_emergencycontactrelationship1name]
,[zav_emergencycontactrelationship2name]
,[zav_ethnicityname]
,[zav_householdname]
,[zav_idnumber]
,[zav_initialtenancystartdate]
,[zav_interpreterlanguagename]
,[zav_iwiaffiliationname]
,[zav_mainlanguagename]
,[zav_makeandmodel]
,[zav_msdaltphone]
,[zav_msdbenefitno]
,[zav_msdhomephone]
,[zav_msdmobilephone]
,[zav_msdworkphone]
,[zav_personreferencenumber]
,[zav_petage]
,[zav_petbreed]
,[zav_petname]
,[zav_petregistrationdetails]
,[zav_pettype]
,[zav_postalregionidname]
,[zav_publichousingwaitlist]
,[zav_referralname]
,[zav_referralyominame]
,[zav_regionidname]
,[zav_registrationdate]
,[zav_supportagencyname]
,[zav_supportagencyyominame]
,[zav_winznumber]
,[zav_workfax]
,[zav_zavantidatamaskinglogs]
,[IsDelete]
,[msa_managingpartnerid]
,[msa_managingpartnerid_entitytype]
,[adx_createdbyipaddress]
,[adx_createdbyusername]
,[adx_modifiedbyipaddress]
,[adx_modifiedbyusername]
,[adx_organizationname]
,[adx_timezone]
,[msa_managingpartneridname]
,[msa_managingpartneridyominame]
,[msdyn_disablewebtracking]
,[msdyn_isminor]
,[msdyn_isminorwithparentalconsent]
,[msdyn_portaltermsagreementdate]
,[adx_confirmremovepassword]
,[adx_identity_emailaddress1confirmed]
,[adx_identity_locallogindisabled]
,[adx_identity_lockoutenabled]
,[adx_identity_logonenabled]
,[adx_identity_mobilephoneconfirmed]
,[adx_identity_twofactorenabled]
,[adx_profilealert]
,[adx_profileisanonymous]
,[adx_identity_accessfailedcount]
,[adx_identity_lastsuccessfullogin]
,[adx_identity_lockoutenddate]
,[adx_identity_newpassword]
,[adx_identity_passwordhash]
,[adx_identity_securitystamp]
,[adx_identity_username]
,[adx_preferredlcid]
,[adx_profilealertdate]
,[adx_profilealertinstructions]
,[adx_profilelastactivity]
,[adx_profilemodifiedon]
,[adx_publicprofilecopy]
,[mspp_userpreferredlcid]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/contact/*.csv',FORMAT = 'CSV',
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
,[accountrolecode] [bigint]
,[address1_addresstypecode] [bigint]
,[address1_freighttermscode] [bigint]
,[address1_shippingmethodcode] [bigint]
,[address2_addresstypecode] [bigint]
,[address2_freighttermscode] [bigint]
,[address2_shippingmethodcode] [bigint]
,[address3_addresstypecode] [bigint]
,[address3_freighttermscode] [bigint]
,[address3_shippingmethodcode] [bigint]
,[customersizecode] [bigint]
,[customertypecode] [bigint]
,[educationcode] [bigint]
,[familystatuscode] [bigint]
,[gendercode] [bigint]
,[haschildrencode] [bigint]
,[leadsourcecode] [bigint]
,[msdyn_decisioninfluencetag] [bigint]
,[msdyn_orgchangestatus] [bigint]
,[msft_datastate] [bigint]
,[paymenttermscode] [bigint]
,[preferredappointmentdaycode] [bigint]
,[preferredappointmenttimecode] [bigint]
,[preferredcontactmethodcode] [bigint]
,[shippingmethodcode] [bigint]
,[territorycode] [bigint]
,[zav_address1state] [bigint]
,[zav_aremainapplicantsabletosignlegaldocumenos] [bigint]
,[zav_band] [bigint]
,[zav_contacttitle] [bigint]
,[zav_contacttype] [bigint]
,[zav_cra] [bigint]
,[zav_disability] [bigint]
,[zav_doesanymemberofyourhouseholdhaveamedicos] [bigint]
,[zav_doesanymemberofyourhouseholdhavedisabilos] [bigint]
,[zav_doyourequirealiveincaros] [bigint]
,[zav_employment] [bigint]
,[zav_gender] [bigint]
,[zav_hearingimpaireddescription] [bigint]
,[zav_isthereanagenttoactonbehalfofindividual] [bigint]
,[zav_proficiencyspokenenglish] [bigint]
,[zav_proficiencywrittenenglish] [bigint]
,[zav_rentareaoverride] [bigint]
,[zav_targetgroup] [bigint]
,[zav_visuallyimpaireddescription] [bigint]
,[zav_agentfor] [varchar](8000)
,[zav_otherneedsofthehousehold] [varchar](8000)
,[zav_secondarysupportneeds] [varchar](8000)
,[zav_specialneedsofthetenant] [varchar](8000)
,[zav_supportneeds] [varchar](8000)
,[creditonhold] [varchar](6)
,[donotbulkemail] [varchar](6)
,[donotbulkpostalmail] [varchar](6)
,[donotemail] [varchar](6)
,[donotfax] [varchar](6)
,[donotphone] [varchar](6)
,[donotpostalmail] [varchar](6)
,[donotsendmm] [varchar](6)
,[followemail] [varchar](6)
,[isautocreate] [varchar](6)
,[isbackofficecustomer] [varchar](6)
,[isprivate] [varchar](6)
,[marketingonly] [varchar](6)
,[merged] [varchar](6)
,[msdyn_gdproptout] [varchar](6)
,[msdyn_isassistantinorgchart] [varchar](6)
,[new_arrearsactionflag] [varchar](6)
,[new_interpretorrequired] [varchar](6)
,[new_nzresident] [varchar](6)
,[new_potentialrisktostaff] [varchar](6)
,[new_student] [varchar](6)
,[participatesinworkflow] [varchar](6)
,[zav_applydisabilityallowance] [varchar](6)
,[zav_australianresident] [varchar](6)
,[zav_carowner] [varchar](6)
,[zav_centrelinkincomeauthority] [varchar](6)
,[zav_centrepaydeduction] [varchar](6)
,[zav_crachangesevor] [varchar](6)
,[zav_dhsregistration] [varchar](6)
,[zav_donotallowinvitations] [varchar](6)
,[zav_donotallownewsletters] [varchar](6)
,[zav_driverslicence] [varchar](6)
,[zav_identificationother] [varchar](6)
,[zav_iwimember] [varchar](6)
,[zav_nfa] [varchar](6)
,[zav_passport] [varchar](6)
,[zav_postaladdresssameasmainaddress] [varchar](6)
,[zav_primarytenant] [varchar](6)
,[zav_prison] [varchar](6)
,[zav_proofofincome] [varchar](6)
,[zav_publichousingreg] [varchar](6)
,[accountid] [uniqueidentifier]
,[accountid_entitytype] [varchar](256)
,[bcbi_companyid] [uniqueidentifier]
,[bcbi_companyid_entitytype] [varchar](256)
,[createdby] [uniqueidentifier]
,[createdby_entitytype] [varchar](256)
,[createdbyexternalparty] [uniqueidentifier]
,[createdbyexternalparty_entitytype] [varchar](256)
,[createdonbehalfby] [uniqueidentifier]
,[createdonbehalfby_entitytype] [varchar](256)
,[defaultpricelevelid] [uniqueidentifier]
,[defaultpricelevelid_entitytype] [varchar](256)
,[masterid] [uniqueidentifier]
,[masterid_entitytype] [varchar](256)
,[modifiedby] [uniqueidentifier]
,[modifiedby_entitytype] [varchar](256)
,[modifiedbyexternalparty] [uniqueidentifier]
,[modifiedbyexternalparty_entitytype] [varchar](256)
,[modifiedonbehalfby] [uniqueidentifier]
,[modifiedonbehalfby_entitytype] [varchar](256)
,[msdyn_contactkpiid] [uniqueidentifier]
,[msdyn_contactkpiid_entitytype] [varchar](256)
,[msdyn_segmentid] [uniqueidentifier]
,[msdyn_segmentid_entitytype] [varchar](256)
,[new_emergencycontactrelationship1_new] [uniqueidentifier]
,[new_emergencycontactrelationship1_new_entitytype] [varchar](256)
,[new_emergencycontactrelationship2_new] [uniqueidentifier]
,[new_emergencycontactrelationship2_new_entitytype] [varchar](256)
,[new_officelocationid] [uniqueidentifier]
,[new_officelocationid_entitytype] [varchar](256)
,[originatingleadid] [uniqueidentifier]
,[originatingleadid_entitytype] [varchar](256)
,[owningbusinessunit] [uniqueidentifier]
,[owningbusinessunit_entitytype] [varchar](256)
,[owningteam] [uniqueidentifier]
,[owningteam_entitytype] [varchar](256)
,[owninguser] [uniqueidentifier]
,[owninguser_entitytype] [varchar](256)
,[parentcontactid] [uniqueidentifier]
,[parentcontactid_entitytype] [varchar](256)
,[preferredequipmentid] [uniqueidentifier]
,[preferredequipmentid_entitytype] [varchar](256)
,[preferredserviceid] [uniqueidentifier]
,[preferredserviceid_entitytype] [varchar](256)
,[preferredsystemuserid] [uniqueidentifier]
,[preferredsystemuserid_entitytype] [varchar](256)
,[slaid] [uniqueidentifier]
,[slaid_entitytype] [varchar](256)
,[slainvokedid] [uniqueidentifier]
,[slainvokedid_entitytype] [varchar](256)
,[transactioncurrencyid] [uniqueidentifier]
,[transactioncurrencyid_entitytype] [varchar](256)
,[zav_address3city] [uniqueidentifier]
,[zav_address3city_entitytype] [varchar](256)
,[zav_address3region] [uniqueidentifier]
,[zav_address3region_entitytype] [varchar](256)
,[zav_city1] [uniqueidentifier]
,[zav_city1_entitytype] [varchar](256)
,[zav_city2] [uniqueidentifier]
,[zav_city2_entitytype] [varchar](256)
,[zav_contact] [uniqueidentifier]
,[zav_contact_entitytype] [varchar](256)
,[zav_country] [uniqueidentifier]
,[zav_country_entitytype] [varchar](256)
,[zav_countrywhereborn] [uniqueidentifier]
,[zav_countrywhereborn_entitytype] [varchar](256)
,[zav_emergencycontactrelationship1] [uniqueidentifier]
,[zav_emergencycontactrelationship1_entitytype] [varchar](256)
,[zav_emergencycontactrelationship2] [uniqueidentifier]
,[zav_emergencycontactrelationship2_entitytype] [varchar](256)
,[zav_ethnicity] [uniqueidentifier]
,[zav_ethnicity_entitytype] [varchar](256)
,[zav_household] [uniqueidentifier]
,[zav_household_entitytype] [varchar](256)
,[zav_interpreterlanguage] [uniqueidentifier]
,[zav_interpreterlanguage_entitytype] [varchar](256)
,[zav_iwiaffiliation] [uniqueidentifier]
,[zav_iwiaffiliation_entitytype] [varchar](256)
,[zav_mainlanguage] [uniqueidentifier]
,[zav_mainlanguage_entitytype] [varchar](256)
,[zav_postalregionid] [uniqueidentifier]
,[zav_postalregionid_entitytype] [varchar](256)
,[zav_referral] [uniqueidentifier]
,[zav_referral_entitytype] [varchar](256)
,[zav_regionid] [uniqueidentifier]
,[zav_regionid_entitytype] [varchar](256)
,[zav_supportagency] [uniqueidentifier]
,[zav_supportagency_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[parentcustomerid] [uniqueidentifier]
,[parentcustomerid_entitytype] [varchar](256)
,[aging30] [decimal](38,2)
,[aging30_base] [decimal](38,4)
,[aging60] [decimal](38,2)
,[aging60_base] [decimal](38,4)
,[aging90] [decimal](38,2)
,[aging90_base] [decimal](38,4)
,[annualincome] [decimal](38,2)
,[annualincome_base] [decimal](38,4)
,[creditlimit] [decimal](38,2)
,[creditlimit_base] [decimal](38,4)
,[accountidname] [varchar](640)
,[accountidyominame] [varchar](640)
,[address1_addressid] [uniqueidentifier]
,[address1_city] [varchar](320)
,[address1_composite] [varchar](max)
,[address1_country] [varchar](320)
,[address1_county] [varchar](200)
,[address1_fax] [varchar](200)
,[address1_latitude] [float]
,[address1_line1] [varchar](1000)
,[address1_line2] [varchar](1000)
,[address1_line3] [varchar](1000)
,[address1_longitude] [float]
,[address1_name] [varchar](800)
,[address1_postalcode] [varchar](80)
,[address1_postofficebox] [varchar](8000)
,[address1_primarycontactname] [varchar](600)
,[address1_stateorprovince] [varchar](200)
,[address1_telephone1] [varchar](200)
,[address1_telephone2] [varchar](200)
,[address1_telephone3] [varchar](200)
,[address1_upszone] [varchar](16)
,[address1_utcoffset] [bigint]
,[address2_addressid] [uniqueidentifier]
,[address2_city] [varchar](320)
,[address2_composite] [varchar](max)
,[address2_country] [varchar](320)
,[address2_county] [varchar](200)
,[address2_fax] [varchar](200)
,[address2_latitude] [float]
,[address2_line1] [varchar](1000)
,[address2_line2] [varchar](1000)
,[address2_line3] [varchar](1000)
,[address2_longitude] [float]
,[address2_name] [varchar](800)
,[address2_postalcode] [varchar](80)
,[address2_postofficebox] [varchar](80)
,[address2_primarycontactname] [varchar](600)
,[address2_stateorprovince] [varchar](200)
,[address2_telephone1] [varchar](200)
,[address2_telephone2] [varchar](200)
,[address2_telephone3] [varchar](200)
,[address2_upszone] [varchar](16)
,[address2_utcoffset] [bigint]
,[address3_addressid] [uniqueidentifier]
,[address3_city] [varchar](320)
,[address3_composite] [varchar](max)
,[address3_country] [varchar](320)
,[address3_county] [varchar](200)
,[address3_fax] [varchar](200)
,[address3_latitude] [float]
,[address3_line1] [varchar](1000)
,[address3_line2] [varchar](1000)
,[address3_line3] [varchar](1000)
,[address3_longitude] [float]
,[address3_name] [varchar](800)
,[address3_postalcode] [varchar](80)
,[address3_postofficebox] [varchar](80)
,[address3_primarycontactname] [varchar](600)
,[address3_stateorprovince] [varchar](200)
,[address3_telephone1] [varchar](200)
,[address3_telephone2] [varchar](200)
,[address3_telephone3] [varchar](200)
,[address3_upszone] [varchar](16)
,[address3_utcoffset] [bigint]
,[anniversary] [datetime2](7)
,[assistantname] [varchar](400)
,[assistantphone] [varchar](200)
,[bcbi_companyidname] [varchar](144)
,[birthdate] [datetime2](7)
,[business2] [varchar](200)
,[businesscard] [varchar](max)
,[businesscardattributes] [varchar](max)
,[callback] [varchar](200)
,[childrensnames] [varchar](1020)
,[company] [varchar](200)
,[contactid] [uniqueidentifier]
,[createdbyexternalpartyname] [varchar](640)
,[createdbyexternalpartyyominame] [varchar](640)
,[createdbyname] [varchar](640)
,[createdbyyominame] [varchar](640)
,[createdon] [datetimeoffset](7)
,[createdonbehalfbyname] [varchar](640)
,[createdonbehalfbyyominame] [varchar](640)
,[defaultpricelevelidname] [varchar](400)
,[department] [varchar](400)
,[description] [varchar](max)
,[emailaddress1] [varchar](400)
,[emailaddress2] [varchar](400)
,[emailaddress3] [varchar](400)
,[employeeid] [varchar](200)
,[entityimage] [varchar](8000)
,[entityimage_timestamp] [bigint]
,[entityimage_url] [varchar](800)
,[entityimageid] [uniqueidentifier]
,[exchangerate] [decimal](38,12)
,[externaluseridentifier] [varchar](200)
,[fax] [varchar](200)
,[firstname] [varchar](200)
,[ftpsiteurl] [varchar](800)
,[fullname] [varchar](640)
,[governmentid] [varchar](200)
,[home2] [varchar](200)
,[importsequencenumber] [bigint]
,[jobtitle] [varchar](400)
,[lastname] [varchar](200)
,[lastonholdtime] [datetime2](7)
,[lastusedincampaign] [datetime2](7)
,[managername] [varchar](400)
,[managerphone] [varchar](200)
,[mastercontactidname] [varchar](640)
,[mastercontactidyominame] [varchar](640)
,[middlename] [varchar](200)
,[mobilephone] [varchar](200)
,[modifiedbyexternalpartyname] [varchar](640)
,[modifiedbyexternalpartyyominame] [varchar](640)
,[modifiedbyname] [varchar](640)
,[modifiedbyyominame] [varchar](640)
,[modifiedon] [datetime2](7)
,[modifiedonbehalfbyname] [varchar](640)
,[modifiedonbehalfbyyominame] [varchar](640)
,[msdyn_contactkpiidname] [varchar](400)
,[msdyn_segmentidname] [varchar](400)
,[new_arrearssince] [datetime2](7)
,[new_bankaccountname] [varchar](400)
,[new_bsb] [varchar](400)
,[new_dateofbirth] [datetime2](7)
,[new_emergencycontactrelationship1_newname] [varchar](400)
,[new_emergencycontactrelationship2_newname] [varchar](400)
,[new_irdnumber] [varchar](400)
,[new_iwimember] [varchar](400)
,[new_officelocationidname] [varchar](400)
,[new_recordbaseid] [varchar](400)
,[nickname] [varchar](400)
,[numberofchildren] [bigint]
,[onholdtime] [bigint]
,[originatingleadidname] [varchar](640)
,[originatingleadidyominame] [varchar](640)
,[overriddencreatedon] [datetime2](7)
,[owneridname] [varchar](640)
,[owneridtype] [varchar](8000)
,[owneridyominame] [varchar](640)
,[owningbusinessunitname] [varchar](640)
,[pager] [varchar](200)
,[parentcontactidname] [varchar](640)
,[parentcontactidyominame] [varchar](640)
,[parentcustomeridname] [varchar](max)
,[parentcustomeridtype] [varchar](8000)
,[parentcustomeridyominame] [varchar](max)
,[preferredequipmentidname] [varchar](640)
,[preferredserviceidname] [varchar](640)
,[preferredsystemuseridname] [varchar](640)
,[preferredsystemuseridyominame] [varchar](640)
,[processid] [uniqueidentifier]
,[salutation] [varchar](400)
,[slainvokedidname] [varchar](640)
,[slaname] [varchar](400)
,[spousesname] [varchar](400)
,[stageid] [uniqueidentifier]
,[subscriptionid] [uniqueidentifier]
,[suffix] [varchar](40)
,[teamsfollowed] [bigint]
,[telephone1] [varchar](200)
,[telephone2] [varchar](200)
,[telephone3] [varchar](200)
,[timespentbymeonemailandmeetings] [varchar](5000)
,[timezoneruleversionnumber] [bigint]
,[transactioncurrencyidname] [varchar](400)
,[traversedpath] [varchar](5000)
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[websiteurl] [varchar](800)
,[yomifirstname] [varchar](600)
,[yomifullname] [varchar](1800)
,[yomilastname] [varchar](600)
,[yomimiddlename] [varchar](600)
,[zav_accrisid] [varchar](400)
,[zav_address1unit] [varchar](400)
,[zav_address2unit] [varchar](400)
,[zav_address3cityname] [varchar](400)
,[zav_address3regionname] [varchar](400)
,[zav_address3unit] [varchar](400)
,[zav_age] [bigint]
,[zav_aka] [varchar](400)
,[zav_bankaccount] [varchar](400)
,[zav_bankbranch] [varchar](2000)
,[zav_bankname] [varchar](2000)
,[zav_briefdetailsifnoegyourpowerofattorney] [varchar](4000)
,[zav_briefdetailsifyes] [varchar](4000)
,[zav_briefdetailsifyesmedicalcondition] [varchar](4000)
,[zav_careof] [varchar](400)
,[zav_carvehicleregistrationnumber] [varchar](400)
,[zav_centrelinkcrn] [varchar](400)
,[zav_chintaroid] [varchar](400)
,[zav_city1name] [varchar](400)
,[zav_city2name] [varchar](400)
,[zav_clientid] [varchar](400)
,[zav_clientsupportagencyid] [bigint]
,[zav_comments] [varchar](max)
,[zav_community] [varchar](400)
,[zav_contactname] [varchar](640)
,[zav_contactyominame] [varchar](1800)
,[zav_countryname] [varchar](400)
,[zav_countrywherebornname] [varchar](400)
,[zav_driverslicencenumber] [varchar](400)
,[zav_emergencycontactcomment1] [varchar](800)
,[zav_emergencycontactcomment2] [varchar](800)
,[zav_emergencycontactemail1] [varchar](400)
,[zav_emergencycontactemail2] [varchar](400)
,[zav_emergencycontactname1] [varchar](400)
,[zav_emergencycontactname2] [varchar](400)
,[zav_emergencycontactphone1] [varchar](400)
,[zav_emergencycontactphone2] [varchar](400)
,[zav_emergencycontactrelationship1name] [varchar](400)
,[zav_emergencycontactrelationship2name] [varchar](400)
,[zav_ethnicityname] [varchar](400)
,[zav_householdname] [varchar](400)
,[zav_idnumber] [varchar](400)
,[zav_initialtenancystartdate] [datetime2](7)
,[zav_interpreterlanguagename] [varchar](400)
,[zav_iwiaffiliationname] [varchar](400)
,[zav_mainlanguagename] [varchar](400)
,[zav_makeandmodel] [varchar](4000)
,[zav_msdaltphone] [varchar](1020)
,[zav_msdbenefitno] [varchar](64)
,[zav_msdhomephone] [varchar](1020)
,[zav_msdmobilephone] [varchar](1020)
,[zav_msdworkphone] [varchar](1020)
,[zav_personreferencenumber] [varchar](400)
,[zav_petage] [float]
,[zav_petbreed] [varchar](400)
,[zav_petname] [varchar](400)
,[zav_petregistrationdetails] [varchar](400)
,[zav_pettype] [varchar](400)
,[zav_postalregionidname] [varchar](400)
,[zav_publichousingwaitlist] [varchar](400)
,[zav_referralname] [varchar](640)
,[zav_referralyominame] [varchar](640)
,[zav_regionidname] [varchar](400)
,[zav_registrationdate] [datetime2](7)
,[zav_supportagencyname] [varchar](640)
,[zav_supportagencyyominame] [varchar](640)
,[zav_winznumber] [varchar](400)
,[zav_workfax] [varchar](1020)
,[zav_zavantidatamaskinglogs] [varchar](max)
,[IsDelete] [varchar](6)
,[msa_managingpartnerid] [uniqueidentifier]
,[msa_managingpartnerid_entitytype] [varchar](256)
,[adx_createdbyipaddress] [varchar](400)
,[adx_createdbyusername] [varchar](400)
,[adx_modifiedbyipaddress] [varchar](400)
,[adx_modifiedbyusername] [varchar](400)
,[adx_organizationname] [varchar](1000)
,[adx_timezone] [bigint]
,[msa_managingpartneridname] [varchar](640)
,[msa_managingpartneridyominame] [varchar](640)
,[msdyn_disablewebtracking] [varchar](6)
,[msdyn_isminor] [varchar](6)
,[msdyn_isminorwithparentalconsent] [varchar](6)
,[msdyn_portaltermsagreementdate] [datetime2](7)
,[adx_confirmremovepassword] [varchar](6)
,[adx_identity_emailaddress1confirmed] [varchar](6)
,[adx_identity_locallogindisabled] [varchar](6)
,[adx_identity_lockoutenabled] [varchar](6)
,[adx_identity_logonenabled] [varchar](6)
,[adx_identity_mobilephoneconfirmed] [varchar](6)
,[adx_identity_twofactorenabled] [varchar](6)
,[adx_profilealert] [varchar](6)
,[adx_profileisanonymous] [varchar](6)
,[adx_identity_accessfailedcount] [bigint]
,[adx_identity_lastsuccessfullogin] [datetime2](7)
,[adx_identity_lockoutenddate] [datetime2](7)
,[adx_identity_newpassword] [varchar](400)
,[adx_identity_passwordhash] [varchar](512)
,[adx_identity_securitystamp] [varchar](400)
,[adx_identity_username] [varchar](400)
,[adx_preferredlcid] [bigint]
,[adx_profilealertdate] [datetime2](7)
,[adx_profilealertinstructions] [varchar](max)
,[adx_profilelastactivity] [datetime2](7)
,[adx_profilemodifiedon] [datetime2](7)
,[adx_publicprofilecopy] [varchar](max)
,[mspp_userpreferredlcid] [bigint]
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record