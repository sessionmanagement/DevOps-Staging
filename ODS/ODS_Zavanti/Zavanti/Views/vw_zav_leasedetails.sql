CREATE VIEW [Zavanti].[vw_zav_leasedetails]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[msft_datastate]
,[zav_agreementtype]
,[zav_frequency]
,[zav_isthelandlordchargeamountgstexclusive]
,[zav_leasetype]
,[zav_rentleasepaymentday]
,[zav_rightofrenewal]
,[crba8_bankdepositconfirmationuploadedtosharepoint]
,[zav_landlordagreementloadedtosharepoint]
,[zav_periodic]
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
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_contract]
,[zav_contract_entitytype]
,[zav_cortsignatory]
,[zav_cortsignatory_entitytype]
,[zav_leasetypecode]
,[zav_leasetypecode_entitytype]
,[zav_legalownerid]
,[zav_legalownerid_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_propertyownercontact]
,[zav_propertyownercontact_entitytype]
,[zav_tenancyid]
,[zav_tenancyid_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[crba8_landlordannualchargeamount]
,[crba8_landlordannualchargeamount_base]
,[new_landlordleasechargeamount]
,[new_landlordleasechargeamount_base]
,[zav_bondamount]
,[zav_bondamount_base]
,[zav_bondtotal]
,[zav_bondtotal_base]
,[zav_landlordmonthlychargeamount]
,[zav_landlordmonthlychargeamount_base]
,[crba8_bankautomaticpaymentnumber]
,[crba8_rentreviewdatelast]
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
,[new_tenancyname]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_bondcomments]
,[zav_bondtotal_date]
,[zav_bondtotal_state]
,[zav_comments]
,[zav_contractname]
,[zav_cortsignatoryname]
,[zav_cortsignatoryyominame]
,[zav_datelodged]
,[zav_dateofnextrightofrenewal]
,[zav_expectedhandbackdate]
,[zav_fromdate]
,[zav_leasedetailsid]
,[zav_leasetypecodename]
,[zav_legalowneridname]
,[zav_legalowneridyominame]
,[zav_name]
,[zav_nextrentleasereviewdate]
,[zav_propertyname]
,[zav_propertyownercontactname]
,[zav_propertyownercontactyominame]
,[zav_propertyreferenceno]
,[zav_rentleasepaymentreference]
,[zav_tenancyidname]
,[zav_tenancyservicesreferencenumber]
,[zav_term]
,[zav_todate]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[msft_datastate]
,[zav_agreementtype]
,[zav_frequency]
,[zav_isthelandlordchargeamountgstexclusive]
,[zav_leasetype]
,[zav_rentleasepaymentday]
,[zav_rightofrenewal]
,[crba8_bankdepositconfirmationuploadedtosharepoint]
,[zav_landlordagreementloadedtosharepoint]
,[zav_periodic]
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
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_contract]
,[zav_contract_entitytype]
,[zav_cortsignatory]
,[zav_cortsignatory_entitytype]
,[zav_leasetypecode]
,[zav_leasetypecode_entitytype]
,[zav_legalownerid]
,[zav_legalownerid_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_propertyownercontact]
,[zav_propertyownercontact_entitytype]
,[zav_tenancyid]
,[zav_tenancyid_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[crba8_landlordannualchargeamount]
,[crba8_landlordannualchargeamount_base]
,[new_landlordleasechargeamount]
,[new_landlordleasechargeamount_base]
,[zav_bondamount]
,[zav_bondamount_base]
,[zav_bondtotal]
,[zav_bondtotal_base]
,[zav_landlordmonthlychargeamount]
,[zav_landlordmonthlychargeamount_base]
,[crba8_bankautomaticpaymentnumber]
,[crba8_rentreviewdatelast]
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
,[new_tenancyname]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_bondcomments]
,[zav_bondtotal_date]
,[zav_bondtotal_state]
,[zav_comments]
,[zav_contractname]
,[zav_cortsignatoryname]
,[zav_cortsignatoryyominame]
,[zav_datelodged]
,[zav_dateofnextrightofrenewal]
,[zav_expectedhandbackdate]
,[zav_fromdate]
,[zav_leasedetailsid]
,[zav_leasetypecodename]
,[zav_legalowneridname]
,[zav_legalowneridyominame]
,[zav_name]
,[zav_nextrentleasereviewdate]
,[zav_propertyname]
,[zav_propertyownercontactname]
,[zav_propertyownercontactyominame]
,[zav_propertyreferenceno]
,[zav_rentleasepaymentreference]
,[zav_tenancyidname]
,[zav_tenancyservicesreferencenumber]
,[zav_term]
,[zav_todate]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_leasedetails/*.csv',FORMAT = 'CSV',
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
,[msft_datastate] [bigint]
,[zav_agreementtype] [bigint]
,[zav_frequency] [bigint]
,[zav_isthelandlordchargeamountgstexclusive] [bigint]
,[zav_leasetype] [bigint]
,[zav_rentleasepaymentday] [bigint]
,[zav_rightofrenewal] [bigint]
,[crba8_bankdepositconfirmationuploadedtosharepoint] [varchar](6)
,[zav_landlordagreementloadedtosharepoint] [varchar](6)
,[zav_periodic] [varchar](6)
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
,[transactioncurrencyid] [uniqueidentifier]
,[transactioncurrencyid_entitytype] [varchar](256)
,[zav_contract] [uniqueidentifier]
,[zav_contract_entitytype] [varchar](256)
,[zav_cortsignatory] [uniqueidentifier]
,[zav_cortsignatory_entitytype] [varchar](256)
,[zav_leasetypecode] [uniqueidentifier]
,[zav_leasetypecode_entitytype] [varchar](256)
,[zav_legalownerid] [uniqueidentifier]
,[zav_legalownerid_entitytype] [varchar](256)
,[zav_property] [uniqueidentifier]
,[zav_property_entitytype] [varchar](256)
,[zav_propertyownercontact] [uniqueidentifier]
,[zav_propertyownercontact_entitytype] [varchar](256)
,[zav_tenancyid] [uniqueidentifier]
,[zav_tenancyid_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[crba8_landlordannualchargeamount] [decimal](38,4)
,[crba8_landlordannualchargeamount_base] [decimal](38,4)
,[new_landlordleasechargeamount] [decimal](38,4)
,[new_landlordleasechargeamount_base] [decimal](38,4)
,[zav_bondamount] [decimal](38,2)
,[zav_bondamount_base] [decimal](38,2)
,[zav_bondtotal] [decimal](38,2)
,[zav_bondtotal_base] [decimal](38,2)
,[zav_landlordmonthlychargeamount] [decimal](38,4)
,[zav_landlordmonthlychargeamount_base] [decimal](38,4)
,[crba8_bankautomaticpaymentnumber] [varchar](76)
,[crba8_rentreviewdatelast] [datetime2](7)
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
,[new_tenancyname] [varchar](800)
,[overriddencreatedon] [datetime2](7)
,[owneridname] [varchar](640)
,[owneridtype] [varchar](8000)
,[owneridyominame] [varchar](640)
,[owningbusinessunitname] [varchar](640)
,[timezoneruleversionnumber] [bigint]
,[transactioncurrencyidname] [varchar](400)
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[zav_bondcomments] [varchar](max)
,[zav_bondtotal_date] [datetime2](7)
,[zav_bondtotal_state] [bigint]
,[zav_comments] [varchar](max)
,[zav_contractname] [varchar](200)
,[zav_cortsignatoryname] [varchar](640)
,[zav_cortsignatoryyominame] [varchar](1800)
,[zav_datelodged] [datetime2](7)
,[zav_dateofnextrightofrenewal] [datetime2](7)
,[zav_expectedhandbackdate] [datetime2](7)
,[zav_fromdate] [datetime2](7)
,[zav_leasedetailsid] [uniqueidentifier]
,[zav_leasetypecodename] [varchar](200)
,[zav_legalowneridname] [varchar](640)
,[zav_legalowneridyominame] [varchar](640)
,[zav_name] [varchar](400)
,[zav_nextrentleasereviewdate] [datetime2](7)
,[zav_propertyname] [varchar](400)
,[zav_propertyownercontactname] [varchar](640)
,[zav_propertyownercontactyominame] [varchar](1800)
,[zav_propertyreferenceno] [varchar](400)
,[zav_rentleasepaymentreference] [varchar](1020)
,[zav_tenancyidname] [varchar](1200)
,[zav_tenancyservicesreferencenumber] [varchar](400)
,[zav_term] [float]
,[zav_todate] [datetime2](7)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record