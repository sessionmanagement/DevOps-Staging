
CREATE VIEW [Zavanti].[vw_account]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[accountcategorycode]
,[accountclassificationcode]
,[accountratingcode]
,[address1_addresstypecode]
,[address1_freighttermscode]
,[address1_shippingmethodcode]
,[address2_addresstypecode]
,[address2_freighttermscode]
,[address2_shippingmethodcode]
,[businesstypecode]
,[customersizecode]
,[customertypecode]
,[industrycode]
,[msft_datastate]
,[ownershipcode]
,[paymenttermscode]
,[preferredappointmentdaycode]
,[preferredappointmenttimecode]
,[preferredcontactmethodcode]
,[shippingmethodcode]
,[territorycode]
,[zav_kpmmaintenancetype]
,[zav_paymentmethod]
,[zav_supportservice]
,[creditonhold]
,[donotbulkemail]
,[donotbulkpostalmail]
,[donotemail]
,[donotfax]
,[donotphone]
,[donotpostalmail]
,[donotsendmm]
,[followemail]
,[isprivate]
,[marketingonly]
,[merged]
,[msdyn_gdproptout]
,[new_approved]
,[participatesinworkflow]
,[zav_isclient]
,[zav_postalcodesameasmainaddress]
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
,[msa_managingpartnerid]
,[msa_managingpartnerid_entitytype]
,[msdyn_accountkpiid]
,[msdyn_accountkpiid_entitytype]
,[msdyn_salesaccelerationinsightid]
,[msdyn_salesaccelerationinsightid_entitytype]
,[msdyn_segmentid]
,[msdyn_segmentid_entitytype]
,[new_postalregion]
,[new_postalregion_entitytype]
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
,[preferredequipmentid]
,[preferredequipmentid_entitytype]
,[preferredserviceid]
,[preferredserviceid_entitytype]
,[preferredsystemuserid]
,[preferredsystemuserid_entitytype]
,[primarycontactid]
,[primarycontactid_entitytype]
,[slaid]
,[slaid_entitytype]
,[slainvokedid]
,[slainvokedid_entitytype]
,[territoryid]
,[territoryid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_addressregionid]
,[zav_addressregionid_entitytype]
,[zav_city]
,[zav_city_entitytype]
,[zav_defaultpricelist]
,[zav_defaultpricelist_entitytype]
,[zav_postaladdresscity]
,[zav_postaladdresscity_entitytype]
,[zav_region]
,[zav_region_entitytype]
,[zav_tradetype]
,[zav_tradetype_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[aging30]
,[aging30_base]
,[aging60]
,[aging60_base]
,[aging90]
,[aging90_base]
,[creditlimit]
,[creditlimit_base]
,[marketcap]
,[marketcap_base]
,[openrevenue]
,[openrevenue_base]
,[revenue]
,[revenue_base]
,[accountid]
,[accountnumber]
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
,[adx_createdbyipaddress]
,[adx_createdbyusername]
,[adx_modifiedbyipaddress]
,[adx_modifiedbyusername]
,[bcbi_companyidname]
,[createdbyexternalpartyname]
,[createdbyexternalpartyyominame]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[defaultpricelevelidname]
,[description]
,[emailaddress1]
,[emailaddress2]
,[emailaddress3]
,[entityimage]
,[entityimage_timestamp]
,[entityimage_url]
,[entityimageid]
,[exchangerate]
,[fax]
,[ftpsiteurl]
,[importsequencenumber]
,[lastonholdtime]
,[lastusedincampaign]
,[masteraccountidname]
,[masteraccountidyominame]
,[modifiedbyexternalpartyname]
,[modifiedbyexternalpartyyominame]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[msa_managingpartneridname]
,[msa_managingpartneridyominame]
,[msdyn_accountkpiidname]
,[msdyn_salesaccelerationinsightidname]
,[msdyn_segmentidname]
,[name]
,[new_compliance]
,[new_password]
,[new_postalregionname]
,[numberofemployees]
,[onholdtime]
,[opendeals]
,[opendeals_date]
,[opendeals_state]
,[openrevenue_date]
,[openrevenue_state]
,[originatingleadidname]
,[originatingleadidyominame]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[parentaccountidname]
,[parentaccountidyominame]
,[preferredequipmentidname]
,[preferredserviceidname]
,[preferredsystemuseridname]
,[preferredsystemuseridyominame]
,[primarycontactidname]
,[primarycontactidyominame]
,[primarysatoriid]
,[primarytwitterid]
,[processid]
,[sharesoutstanding]
,[sic]
,[slainvokedidname]
,[slaname]
,[stageid]
,[stockexchange]
,[teamsfollowed]
,[telephone1]
,[telephone2]
,[telephone3]
,[territoryidname]
,[tickersymbol]
,[timespentbymeonemailandmeetings]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[traversedpath]
,[utcconversiontimezonecode]
,[versionnumber]
,[websiteurl]
,[yominame]
,[zav_accountnumber]
,[zav_address1unit]
,[zav_address2unit]
,[zav_addressregionidname]
,[zav_bankname]
,[zav_bpaybillercode]
,[zav_bsb]
,[zav_chintaroid]
,[zav_cityname]
,[zav_companyid]
,[zav_defaultpricelistname]
,[zav_no]
,[zav_nzbnnumber]
,[zav_postaladdresscityname]
,[zav_regionname]
,[zav_serviceprovidedbythesupportagency]
,[zav_supplierid]
,[zav_tradetypename]
,[zav_tradetypes]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[accountcategorycode]
,[accountclassificationcode]
,[accountratingcode]
,[address1_addresstypecode]
,[address1_freighttermscode]
,[address1_shippingmethodcode]
,[address2_addresstypecode]
,[address2_freighttermscode]
,[address2_shippingmethodcode]
,[businesstypecode]
,[customersizecode]
,[customertypecode]
,[industrycode]
,[msft_datastate]
,[ownershipcode]
,[paymenttermscode]
,[preferredappointmentdaycode]
,[preferredappointmenttimecode]
,[preferredcontactmethodcode]
,[shippingmethodcode]
,[territorycode]
,[zav_kpmmaintenancetype]
,[zav_paymentmethod]
,[zav_supportservice]
,[creditonhold]
,[donotbulkemail]
,[donotbulkpostalmail]
,[donotemail]
,[donotfax]
,[donotphone]
,[donotpostalmail]
,[donotsendmm]
,[followemail]
,[isprivate]
,[marketingonly]
,[merged]
,[msdyn_gdproptout]
,[new_approved]
,[participatesinworkflow]
,[zav_isclient]
,[zav_postalcodesameasmainaddress]
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
,[msa_managingpartnerid]
,[msa_managingpartnerid_entitytype]
,[msdyn_accountkpiid]
,[msdyn_accountkpiid_entitytype]
,[msdyn_salesaccelerationinsightid]
,[msdyn_salesaccelerationinsightid_entitytype]
,[msdyn_segmentid]
,[msdyn_segmentid_entitytype]
,[new_postalregion]
,[new_postalregion_entitytype]
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
,[preferredequipmentid]
,[preferredequipmentid_entitytype]
,[preferredserviceid]
,[preferredserviceid_entitytype]
,[preferredsystemuserid]
,[preferredsystemuserid_entitytype]
,[primarycontactid]
,[primarycontactid_entitytype]
,[slaid]
,[slaid_entitytype]
,[slainvokedid]
,[slainvokedid_entitytype]
,[territoryid]
,[territoryid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_addressregionid]
,[zav_addressregionid_entitytype]
,[zav_city]
,[zav_city_entitytype]
,[zav_defaultpricelist]
,[zav_defaultpricelist_entitytype]
,[zav_postaladdresscity]
,[zav_postaladdresscity_entitytype]
,[zav_region]
,[zav_region_entitytype]
,[zav_tradetype]
,[zav_tradetype_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[aging30]
,[aging30_base]
,[aging60]
,[aging60_base]
,[aging90]
,[aging90_base]
,[creditlimit]
,[creditlimit_base]
,[marketcap]
,[marketcap_base]
,[openrevenue]
,[openrevenue_base]
,[revenue]
,[revenue_base]
,[accountid]
,[accountnumber]
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
,[adx_createdbyipaddress]
,[adx_createdbyusername]
,[adx_modifiedbyipaddress]
,[adx_modifiedbyusername]
,[bcbi_companyidname]
,[createdbyexternalpartyname]
,[createdbyexternalpartyyominame]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[defaultpricelevelidname]
,[description]
,[emailaddress1]
,[emailaddress2]
,[emailaddress3]
,[entityimage]
,[entityimage_timestamp]
,[entityimage_url]
,[entityimageid]
,[exchangerate]
,[fax]
,[ftpsiteurl]
,[importsequencenumber]
,[lastonholdtime]
,[lastusedincampaign]
,[masteraccountidname]
,[masteraccountidyominame]
,[modifiedbyexternalpartyname]
,[modifiedbyexternalpartyyominame]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[msa_managingpartneridname]
,[msa_managingpartneridyominame]
,[msdyn_accountkpiidname]
,[msdyn_salesaccelerationinsightidname]
,[msdyn_segmentidname]
,[name]
,[new_compliance]
,[new_password]
,[new_postalregionname]
,[numberofemployees]
,[onholdtime]
,[opendeals]
,[opendeals_date]
,[opendeals_state]
,[openrevenue_date]
,[openrevenue_state]
,[originatingleadidname]
,[originatingleadidyominame]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[parentaccountidname]
,[parentaccountidyominame]
,[preferredequipmentidname]
,[preferredserviceidname]
,[preferredsystemuseridname]
,[preferredsystemuseridyominame]
,[primarycontactidname]
,[primarycontactidyominame]
,[primarysatoriid]
,[primarytwitterid]
,[processid]
,[sharesoutstanding]
,[sic]
,[slainvokedidname]
,[slaname]
,[stageid]
,[stockexchange]
,[teamsfollowed]
,[telephone1]
,[telephone2]
,[telephone3]
,[territoryidname]
,[tickersymbol]
,[timespentbymeonemailandmeetings]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[traversedpath]
,[utcconversiontimezonecode]
,[versionnumber]
,[websiteurl]
,[yominame]
,[zav_accountnumber]
,[zav_address1unit]
,[zav_address2unit]
,[zav_addressregionidname]
,[zav_bankname]
,[zav_bpaybillercode]
,[zav_bsb]
,[zav_chintaroid]
,[zav_cityname]
,[zav_companyid]
,[zav_defaultpricelistname]
,[zav_no]
,[zav_nzbnnumber]
,[zav_postaladdresscityname]
,[zav_regionname]
,[zav_serviceprovidedbythesupportagency]
,[zav_supplierid]
,[zav_tradetypename]
,[zav_tradetypes]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/account/*.csv',FORMAT = 'CSV',
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
,[accountcategorycode] [bigint]
,[accountclassificationcode] [bigint]
,[accountratingcode] [bigint]
,[address1_addresstypecode] [bigint]
,[address1_freighttermscode] [bigint]
,[address1_shippingmethodcode] [bigint]
,[address2_addresstypecode] [bigint]
,[address2_freighttermscode] [bigint]
,[address2_shippingmethodcode] [bigint]
,[businesstypecode] [bigint]
,[customersizecode] [bigint]
,[customertypecode] [bigint]
,[industrycode] [bigint]
,[msft_datastate] [bigint]
,[ownershipcode] [bigint]
,[paymenttermscode] [bigint]
,[preferredappointmentdaycode] [bigint]
,[preferredappointmenttimecode] [bigint]
,[preferredcontactmethodcode] [bigint]
,[shippingmethodcode] [bigint]
,[territorycode] [bigint]
,[zav_kpmmaintenancetype] [bigint]
,[zav_paymentmethod] [bigint]
,[zav_supportservice] [varchar](8000)
,[creditonhold] [varchar](6)
,[donotbulkemail] [varchar](6)
,[donotbulkpostalmail] [varchar](6)
,[donotemail] [varchar](6)
,[donotfax] [varchar](6)
,[donotphone] [varchar](6)
,[donotpostalmail] [varchar](6)
,[donotsendmm] [varchar](6)
,[followemail] [varchar](6)
,[isprivate] [varchar](6)
,[marketingonly] [varchar](6)
,[merged] [varchar](6)
,[msdyn_gdproptout] [varchar](6)
,[new_approved] [varchar](6)
,[participatesinworkflow] [varchar](6)
,[zav_isclient] [varchar](6)
,[zav_postalcodesameasmainaddress] [varchar](6)
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
,[msa_managingpartnerid] [uniqueidentifier]
,[msa_managingpartnerid_entitytype] [varchar](256)
,[msdyn_accountkpiid] [uniqueidentifier]
,[msdyn_accountkpiid_entitytype] [varchar](256)
,[msdyn_salesaccelerationinsightid] [uniqueidentifier]
,[msdyn_salesaccelerationinsightid_entitytype] [varchar](256)
,[msdyn_segmentid] [uniqueidentifier]
,[msdyn_segmentid_entitytype] [varchar](256)
,[new_postalregion] [uniqueidentifier]
,[new_postalregion_entitytype] [varchar](256)
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
,[preferredequipmentid] [uniqueidentifier]
,[preferredequipmentid_entitytype] [varchar](256)
,[preferredserviceid] [uniqueidentifier]
,[preferredserviceid_entitytype] [varchar](256)
,[preferredsystemuserid] [uniqueidentifier]
,[preferredsystemuserid_entitytype] [varchar](256)
,[primarycontactid] [uniqueidentifier]
,[primarycontactid_entitytype] [varchar](256)
,[slaid] [uniqueidentifier]
,[slaid_entitytype] [varchar](256)
,[slainvokedid] [uniqueidentifier]
,[slainvokedid_entitytype] [varchar](256)
,[territoryid] [uniqueidentifier]
,[territoryid_entitytype] [varchar](256)
,[transactioncurrencyid] [uniqueidentifier]
,[transactioncurrencyid_entitytype] [varchar](256)
,[zav_addressregionid] [uniqueidentifier]
,[zav_addressregionid_entitytype] [varchar](256)
,[zav_city] [uniqueidentifier]
,[zav_city_entitytype] [varchar](256)
,[zav_defaultpricelist] [uniqueidentifier]
,[zav_defaultpricelist_entitytype] [varchar](256)
,[zav_postaladdresscity] [uniqueidentifier]
,[zav_postaladdresscity_entitytype] [varchar](256)
,[zav_region] [uniqueidentifier]
,[zav_region_entitytype] [varchar](256)
,[zav_tradetype] [uniqueidentifier]
,[zav_tradetype_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[aging30] [decimal](38,2)
,[aging30_base] [decimal](38,4)
,[aging60] [decimal](38,2)
,[aging60_base] [decimal](38,4)
,[aging90] [decimal](38,2)
,[aging90_base] [decimal](38,4)
,[creditlimit] [decimal](38,2)
,[creditlimit_base] [decimal](38,4)
,[marketcap] [decimal](38,2)
,[marketcap_base] [decimal](38,4)
,[openrevenue] [decimal](38,2)
,[openrevenue_base] [decimal](38,2)
,[revenue] [decimal](38,2)
,[revenue_base] [decimal](38,4)
,[accountid] [uniqueidentifier]
,[accountnumber] [varchar](80)
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
,[address1_postofficebox] [varchar](80)
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
,[adx_createdbyipaddress] [varchar](400)
,[adx_createdbyusername] [varchar](400)
,[adx_modifiedbyipaddress] [varchar](400)
,[adx_modifiedbyusername] [varchar](400)
,[bcbi_companyidname] [varchar](144)
,[createdbyexternalpartyname] [varchar](640)
,[createdbyexternalpartyyominame] [varchar](640)
,[createdbyname] [varchar](640)
,[createdbyyominame] [varchar](640)
,[createdon] [datetimeoffset](7)
,[createdonbehalfbyname] [varchar](640)
,[createdonbehalfbyyominame] [varchar](640)
,[defaultpricelevelidname] [varchar](400)
,[description] [varchar](max)
,[emailaddress1] [varchar](400)
,[emailaddress2] [varchar](400)
,[emailaddress3] [varchar](400)
,[entityimage] [varchar](8000)
,[entityimage_timestamp] [bigint]
,[entityimage_url] [varchar](800)
,[entityimageid] [uniqueidentifier]
,[exchangerate] [decimal](38,12)
,[fax] [varchar](200)
,[ftpsiteurl] [varchar](800)
,[importsequencenumber] [bigint]
,[lastonholdtime] [datetime2](7)
,[lastusedincampaign] [datetime2](7)
,[masteraccountidname] [varchar](640)
,[masteraccountidyominame] [varchar](640)
,[modifiedbyexternalpartyname] [varchar](640)
,[modifiedbyexternalpartyyominame] [varchar](640)
,[modifiedbyname] [varchar](640)
,[modifiedbyyominame] [varchar](640)
,[modifiedon] [datetime2](7)
,[modifiedonbehalfbyname] [varchar](640)
,[modifiedonbehalfbyyominame] [varchar](640)
,[msa_managingpartneridname] [varchar](640)
,[msa_managingpartneridyominame] [varchar](640)
,[msdyn_accountkpiidname] [varchar](400)
,[msdyn_salesaccelerationinsightidname] [varchar](400)
,[msdyn_segmentidname] [varchar](400)
,[name] [varchar](640)
,[new_compliance] [varchar](max)
,[new_password] [varchar](1024)
,[new_postalregionname] [varchar](400)
,[numberofemployees] [bigint]
,[onholdtime] [bigint]
,[opendeals] [bigint]
,[opendeals_date] [datetime2](7)
,[opendeals_state] [bigint]
,[openrevenue_date] [datetime2](7)
,[openrevenue_state] [bigint]
,[originatingleadidname] [varchar](640)
,[originatingleadidyominame] [varchar](640)
,[overriddencreatedon] [datetime2](7)
,[owneridname] [varchar](640)
,[owneridtype] [varchar](8000)
,[owneridyominame] [varchar](640)
,[owningbusinessunitname] [varchar](640)
,[parentaccountidname] [varchar](640)
,[parentaccountidyominame] [varchar](640)
,[preferredequipmentidname] [varchar](640)
,[preferredserviceidname] [varchar](640)
,[preferredsystemuseridname] [varchar](640)
,[preferredsystemuseridyominame] [varchar](640)
,[primarycontactidname] [varchar](640)
,[primarycontactidyominame] [varchar](640)
,[primarysatoriid] [varchar](800)
,[primarytwitterid] [varchar](512)
,[processid] [uniqueidentifier]
,[sharesoutstanding] [bigint]
,[sic] [varchar](80)
,[slainvokedidname] [varchar](640)
,[slaname] [varchar](400)
,[stageid] [uniqueidentifier]
,[stockexchange] [varchar](80)
,[teamsfollowed] [bigint]
,[telephone1] [varchar](200)
,[telephone2] [varchar](200)
,[telephone3] [varchar](200)
,[territoryidname] [varchar](800)
,[tickersymbol] [varchar](80)
,[timespentbymeonemailandmeetings] [varchar](5000)
,[timezoneruleversionnumber] [bigint]
,[transactioncurrencyidname] [varchar](400)
,[traversedpath] [varchar](5000)
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[websiteurl] [varchar](800)
,[yominame] [varchar](640)
,[zav_accountnumber] [varchar](400)
,[zav_address1unit] [varchar](400)
,[zav_address2unit] [varchar](400)
,[zav_addressregionidname] [varchar](400)
,[zav_bankname] [varchar](400)
,[zav_bpaybillercode] [varchar](400)
,[zav_bsb] [varchar](40)
,[zav_chintaroid] [varchar](400)
,[zav_cityname] [varchar](400)
,[zav_companyid] [varchar](400)
,[zav_defaultpricelistname] [varchar](400)
,[zav_no] [varchar](80)
,[zav_nzbnnumber] [varchar](52)
,[zav_postaladdresscityname] [varchar](400)
,[zav_regionname] [varchar](400)
,[zav_serviceprovidedbythesupportagency] [varchar](800)
,[zav_supplierid] [varchar](400)
,[zav_tradetypename] [varchar](400)
,[zav_tradetypes] [varchar](max)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record