CREATE VIEW [Zavanti].[vw_systemuser]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[accessmode]
,[address1_addresstypecode]
,[address1_shippingmethodcode]
,[address2_addresstypecode]
,[address2_shippingmethodcode]
,[azurestate]
,[caltype]
,[deletedstate]
,[emailrouteraccessapproval]
,[incomingemaildeliverymethod]
,[invitestatuscode]
,[msdyn_agentType]
,[msdyn_botprovider]
,[msdyn_usertype]
,[outgoingemaildeliverymethod]
,[preferredaddresscode]
,[preferredemailcode]
,[preferredphonecode]
,[defaultfilterspopulated]
,[displayinserviceviews]
,[isactivedirectoryuser]
,[isdisabled]
,[isemailaddressapprovedbyo365admin]
,[isintegrationuser]
,[islicensed]
,[issyncwithdirectory]
,[msdyn_gdproptout]
,[msdyn_isexpertenabledforswarm]
,[setupuser]
,[zav_allowastenancymanager]
,[zav_propertyuser]
,[businessunitid]
,[businessunitid_entitytype]
,[calendarid]
,[calendarid_entitytype]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[defaultmailbox]
,[defaultmailbox_entitytype]
,[mobileofflineprofileid]
,[mobileofflineprofileid_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[msdyn_defaultpresenceiduser]
,[msdyn_defaultpresenceiduser_entitytype]
,[parentsystemuserid]
,[parentsystemuserid_entitytype]
,[positionid]
,[positionid_entitytype]
,[queueid]
,[queueid_entitytype]
,[siteid]
,[siteid_entitytype]
,[territoryid]
,[territoryid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[activedirectoryguid]
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
,[address2_stateorprovince]
,[address2_telephone1]
,[address2_telephone2]
,[address2_telephone3]
,[address2_upszone]
,[address2_utcoffset]
,[applicationid]
,[applicationiduri]
,[azureactivedirectoryobjectid]
,[azuredeletedon]
,[businessunitidname]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[defaultmailboxname]
,[defaultodbfoldername]
,[disabledreason]
,[domainname]
,[employeeid]
,[entityimage]
,[entityimage_timestamp]
,[entityimage_url]
,[entityimageid]
,[exchangerate]
,[firstname]
,[fullname]
,[governmentid]
,[homephone]
,[identityid]
,[importsequencenumber]
,[internalemailaddress]
,[jobtitle]
,[lastname]
,[latestupdatetime]
,[middlename]
,[mobilealertemail]
,[mobileofflineprofileidname]
,[mobilephone]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[msdyn_botapplicationid]
,[msdyn_botdescription]
,[msdyn_botendpoint]
,[msdyn_bothandle]
,[msdyn_botsecretkeys]
,[msdyn_capacity]
,[msdyn_defaultpresenceidusername]
,[msdyn_gridwrappercontrolfield]
,[msdyn_owningenvironmentid]
,[nickname]
,[organizationid]
,[organizationidname]
,[overriddencreatedon]
,[parentsystemuseridname]
,[parentsystemuseridyominame]
,[passporthi]
,[passportlo]
,[personalemailaddress]
,[photourl]
,[positionidname]
,[processid]
,[queueidname]
,[salutation]
,[sharepointemailaddress]
,[siteidname]
,[skills]
,[stageid]
,[systemuserid]
,[territoryidname]
,[timezoneruleversionnumber]
,[title]
,[transactioncurrencyidname]
,[traversedpath]
,[userlicensetype]
,[userpuid]
,[utcconversiontimezonecode]
,[versionnumber]
,[windowsliveid]
,[yammeremailaddress]
,[yammeruserid]
,[yomifirstname]
,[yomifullname]
,[yomilastname]
,[yomimiddlename]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[accessmode]
,[address1_addresstypecode]
,[address1_shippingmethodcode]
,[address2_addresstypecode]
,[address2_shippingmethodcode]
,[azurestate]
,[caltype]
,[deletedstate]
,[emailrouteraccessapproval]
,[incomingemaildeliverymethod]
,[invitestatuscode]
,[msdyn_agentType]
,[msdyn_botprovider]
,[msdyn_usertype]
,[outgoingemaildeliverymethod]
,[preferredaddresscode]
,[preferredemailcode]
,[preferredphonecode]
,[defaultfilterspopulated]
,[displayinserviceviews]
,[isactivedirectoryuser]
,[isdisabled]
,[isemailaddressapprovedbyo365admin]
,[isintegrationuser]
,[islicensed]
,[issyncwithdirectory]
,[msdyn_gdproptout]
,[msdyn_isexpertenabledforswarm]
,[setupuser]
,[zav_allowastenancymanager]
,[zav_propertyuser]
,[businessunitid]
,[businessunitid_entitytype]
,[calendarid]
,[calendarid_entitytype]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[defaultmailbox]
,[defaultmailbox_entitytype]
,[mobileofflineprofileid]
,[mobileofflineprofileid_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[msdyn_defaultpresenceiduser]
,[msdyn_defaultpresenceiduser_entitytype]
,[parentsystemuserid]
,[parentsystemuserid_entitytype]
,[positionid]
,[positionid_entitytype]
,[queueid]
,[queueid_entitytype]
,[siteid]
,[siteid_entitytype]
,[territoryid]
,[territoryid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[activedirectoryguid]
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
,[address2_stateorprovince]
,[address2_telephone1]
,[address2_telephone2]
,[address2_telephone3]
,[address2_upszone]
,[address2_utcoffset]
,[applicationid]
,[applicationiduri]
,[azureactivedirectoryobjectid]
,[azuredeletedon]
,[businessunitidname]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[defaultmailboxname]
,[defaultodbfoldername]
,[disabledreason]
,[domainname]
,[employeeid]
,[entityimage]
,[entityimage_timestamp]
,[entityimage_url]
,[entityimageid]
,[exchangerate]
,[firstname]
,[fullname]
,[governmentid]
,[homephone]
,[identityid]
,[importsequencenumber]
,[internalemailaddress]
,[jobtitle]
,[lastname]
,[latestupdatetime]
,[middlename]
,[mobilealertemail]
,[mobileofflineprofileidname]
,[mobilephone]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[msdyn_botapplicationid]
,[msdyn_botdescription]
,[msdyn_botendpoint]
,[msdyn_bothandle]
,[msdyn_botsecretkeys]
,[msdyn_capacity]
,[msdyn_defaultpresenceidusername]
,[msdyn_gridwrappercontrolfield]
,[msdyn_owningenvironmentid]
,[nickname]
,[organizationid]
,[organizationidname]
,[overriddencreatedon]
,[parentsystemuseridname]
,[parentsystemuseridyominame]
,[passporthi]
,[passportlo]
,[personalemailaddress]
,[photourl]
,[positionidname]
,[processid]
,[queueidname]
,[salutation]
,[sharepointemailaddress]
,[siteidname]
,[skills]
,[stageid]
,[systemuserid]
,[territoryidname]
,[timezoneruleversionnumber]
,[title]
,[transactioncurrencyidname]
,[traversedpath]
,[userlicensetype]
,[userpuid]
,[utcconversiontimezonecode]
,[versionnumber]
,[windowsliveid]
,[yammeremailaddress]
,[yammeruserid]
,[yomifirstname]
,[yomifullname]
,[yomilastname]
,[yomimiddlename]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/systemuser/*.csv',FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
) 
WITH
(
[Id] [uniqueidentifier]
,[SinkCreatedOn] [datetime2](7)
,[SinkModifiedOn] [datetime2](7)
,[accessmode] [bigint]
,[address1_addresstypecode] [bigint]
,[address1_shippingmethodcode] [bigint]
,[address2_addresstypecode] [bigint]
,[address2_shippingmethodcode] [bigint]
,[azurestate] [bigint]
,[caltype] [bigint]
,[deletedstate] [bigint]
,[emailrouteraccessapproval] [bigint]
,[incomingemaildeliverymethod] [bigint]
,[invitestatuscode] [bigint]
,[msdyn_agentType] [bigint]
,[msdyn_botprovider] [bigint]
,[msdyn_usertype] [bigint]
,[outgoingemaildeliverymethod] [bigint]
,[preferredaddresscode] [bigint]
,[preferredemailcode] [bigint]
,[preferredphonecode] [bigint]
,[defaultfilterspopulated] [varchar](6)
,[displayinserviceviews] [varchar](6)
,[isactivedirectoryuser] [varchar](6)
,[isdisabled] [varchar](6)
,[isemailaddressapprovedbyo365admin] [varchar](6)
,[isintegrationuser] [varchar](6)
,[islicensed] [varchar](6)
,[issyncwithdirectory] [varchar](6)
,[msdyn_gdproptout] [varchar](6)
,[msdyn_isexpertenabledforswarm] [varchar](6)
,[setupuser] [varchar](6)
,[zav_allowastenancymanager] [varchar](6)
,[zav_propertyuser] [varchar](6)
,[businessunitid] [uniqueidentifier]
,[businessunitid_entitytype] [varchar](256)
,[calendarid] [uniqueidentifier]
,[calendarid_entitytype] [varchar](256)
,[createdby] [uniqueidentifier]
,[createdby_entitytype] [varchar](256)
,[createdonbehalfby] [uniqueidentifier]
,[createdonbehalfby_entitytype] [varchar](256)
,[defaultmailbox] [uniqueidentifier]
,[defaultmailbox_entitytype] [varchar](256)
,[mobileofflineprofileid] [uniqueidentifier]
,[mobileofflineprofileid_entitytype] [varchar](256)
,[modifiedby] [uniqueidentifier]
,[modifiedby_entitytype] [varchar](256)
,[modifiedonbehalfby] [uniqueidentifier]
,[modifiedonbehalfby_entitytype] [varchar](256)
,[msdyn_defaultpresenceiduser] [uniqueidentifier]
,[msdyn_defaultpresenceiduser_entitytype] [varchar](256)
,[parentsystemuserid] [uniqueidentifier]
,[parentsystemuserid_entitytype] [varchar](256)
,[positionid] [uniqueidentifier]
,[positionid_entitytype] [varchar](256)
,[queueid] [uniqueidentifier]
,[queueid_entitytype] [varchar](256)
,[siteid] [uniqueidentifier]
,[siteid_entitytype] [varchar](256)
,[territoryid] [uniqueidentifier]
,[territoryid_entitytype] [varchar](256)
,[transactioncurrencyid] [uniqueidentifier]
,[transactioncurrencyid_entitytype] [varchar](256)
,[activedirectoryguid] [uniqueidentifier]
,[address1_addressid] [uniqueidentifier]
,[address1_city] [varchar](512)
,[address1_composite] [varchar](max)
,[address1_country] [varchar](512)
,[address1_county] [varchar](512)
,[address1_fax] [varchar](256)
,[address1_latitude] [float]
,[address1_line1] [varchar](4096)
,[address1_line2] [varchar](4096)
,[address1_line3] [varchar](4096)
,[address1_longitude] [float]
,[address1_name] [varchar](800)
,[address1_postalcode] [varchar](160)
,[address1_postofficebox] [varchar](160)
,[address1_stateorprovince] [varchar](512)
,[address1_telephone1] [varchar](256)
,[address1_telephone2] [varchar](200)
,[address1_telephone3] [varchar](200)
,[address1_upszone] [varchar](16)
,[address1_utcoffset] [bigint]
,[address2_addressid] [uniqueidentifier]
,[address2_city] [varchar](512)
,[address2_composite] [varchar](max)
,[address2_country] [varchar](512)
,[address2_county] [varchar](512)
,[address2_fax] [varchar](200)
,[address2_latitude] [float]
,[address2_line1] [varchar](4096)
,[address2_line2] [varchar](4096)
,[address2_line3] [varchar](4096)
,[address2_longitude] [float]
,[address2_name] [varchar](800)
,[address2_postalcode] [varchar](160)
,[address2_postofficebox] [varchar](160)
,[address2_stateorprovince] [varchar](512)
,[address2_telephone1] [varchar](200)
,[address2_telephone2] [varchar](200)
,[address2_telephone3] [varchar](200)
,[address2_upszone] [varchar](16)
,[address2_utcoffset] [bigint]
,[applicationid] [uniqueidentifier]
,[applicationiduri] [varchar](4096)
,[azureactivedirectoryobjectid] [uniqueidentifier]
,[azuredeletedon] [datetime2](7)
,[businessunitidname] [varchar](640)
,[createdbyname] [varchar](1026)
,[createdbyyominame] [varchar](1026)
,[createdon] [datetimeoffset](7)
,[createdonbehalfbyname] [varchar](1026)
,[createdonbehalfbyyominame] [varchar](1026)
,[defaultmailboxname] [varchar](400)
,[defaultodbfoldername] [varchar](800)
,[disabledreason] [varchar](2000)
,[domainname] [varchar](4096)
,[employeeid] [varchar](400)
,[entityimage] [varchar](8000)
,[entityimage_timestamp] [bigint]
,[entityimage_url] [varchar](800)
,[entityimageid] [uniqueidentifier]
,[exchangerate] [decimal](38,12)
,[firstname] [varchar](1024)
,[fullname] [varchar](1026)
,[governmentid] [varchar](400)
,[homephone] [varchar](200)
,[identityid] [bigint]
,[importsequencenumber] [bigint]
,[internalemailaddress] [varchar](400)
,[jobtitle] [varchar](400)
,[lastname] [varchar](512)
,[latestupdatetime] [datetime2](7)
,[middlename] [varchar](200)
,[mobilealertemail] [varchar](400)
,[mobileofflineprofileidname] [varchar](400)
,[mobilephone] [varchar](256)
,[modifiedbyname] [varchar](1026)
,[modifiedbyyominame] [varchar](1026)
,[modifiedon] [datetime2](7)
,[modifiedonbehalfbyname] [varchar](1026)
,[modifiedonbehalfbyyominame] [varchar](1026)
,[msdyn_botapplicationid] [varchar](400)
,[msdyn_botdescription] [varchar](max)
,[msdyn_botendpoint] [varchar](400)
,[msdyn_bothandle] [varchar](400)
,[msdyn_botsecretkeys] [varchar](400)
,[msdyn_capacity] [bigint]
,[msdyn_defaultpresenceidusername] [varchar](400)
,[msdyn_gridwrappercontrolfield] [varchar](8000)
,[msdyn_owningenvironmentid] [varchar](2000)
,[nickname] [varchar](200)
,[organizationid] [uniqueidentifier]
,[organizationidname] [varchar](640)
,[overriddencreatedon] [datetime2](7)
,[parentsystemuseridname] [varchar](1026)
,[parentsystemuseridyominame] [varchar](1026)
,[passporthi] [bigint]
,[passportlo] [bigint]
,[personalemailaddress] [varchar](400)
,[photourl] [varchar](800)
,[positionidname] [varchar](400)
,[processid] [uniqueidentifier]
,[queueidname] [varchar](800)
,[salutation] [varchar](80)
,[sharepointemailaddress] [varchar](4096)
,[siteidname] [varchar](640)
,[skills] [varchar](400)
,[stageid] [uniqueidentifier]
,[systemuserid] [uniqueidentifier]
,[territoryidname] [varchar](800)
,[timezoneruleversionnumber] [bigint]
,[title] [varchar](512)
,[transactioncurrencyidname] [varchar](400)
,[traversedpath] [varchar](5000)
,[userlicensetype] [bigint]
,[userpuid] [varchar](512)
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[windowsliveid] [varchar](4096)
,[yammeremailaddress] [varchar](400)
,[yammeruserid] [varchar](256)
,[yomifirstname] [varchar](512)
,[yomifullname] [varchar](1026)
,[yomilastname] [varchar](512)
,[yomimiddlename] [varchar](200)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record