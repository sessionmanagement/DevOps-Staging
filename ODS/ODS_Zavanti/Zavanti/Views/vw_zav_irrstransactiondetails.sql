CREATE VIEW [Zavanti].[vw_zav_irrstransactiondetails]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_propertystatus]
,[zav_rent]
,[zav_transaction]
,[zav_voidstatus]
,[new_issynchronizedtobc]
,[zav_balancecalculation]
,[zav_runningbalancesync]
,[zav_verified]
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
,[zav_irrsgenerationbatch]
,[zav_irrsgenerationbatch_entitytype]
,[zav_paymentperiod]
,[zav_paymentperiod_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_provideragreement]
,[zav_provideragreement_entitytype]
,[zav_tenancy]
,[zav_tenancy_entitytype]
,[zav_tenancyrentupdate]
,[zav_tenancyrentupdate_entitytype]
,[zav_transactiontype]
,[zav_transactiontype_entitytype]
,[zav_transactiontypeid]
,[zav_transactiontypeid_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_agreedrent]
,[zav_agreedrent_base]
,[zav_amount]
,[zav_amount_base]
,[zav_balancetotal]
,[zav_balancetotal_base]
,[zav_closingbalance]
,[zav_closingbalance_base]
,[zav_irr]
,[zav_irr_base]
,[zav_irrpaymentperiod]
,[zav_irrpaymentperiod_base]
,[zav_irrs]
,[zav_irrs_base]
,[zav_irrsweekly]
,[zav_irrsweekly_base]
,[zav_marketrent]
,[zav_marketrent_base]
,[zav_marketrentweekly]
,[zav_marketrentweekly_base]
,[zav_openingbalance]
,[zav_openingbalance_base]
,[zav_operatingsupplementos]
,[zav_operatingsupplementos_base]
,[zav_osweekly]
,[zav_osweekly_base]
,[zav_tmpopaymentperiod]
,[zav_tmpopaymentperiod_base]
,[zav_tmpoweekly]
,[zav_tmpoweekly_base]
,[zav_totalagreedrentoverperiod]
,[zav_totalagreedrentoverperiod_base]
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
,[new_receiptnumber]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_accountreferenceno]
,[zav_additionalcomments]
,[zav_bcentryno]
,[zav_comments]
,[zav_date]
,[zav_enddate]
,[zav_irrsfromdate]
,[zav_irrsgenerationbatchname]
,[zav_irrstodate]
,[zav_irrstransactiondetailsid]
,[zav_name]
,[zav_noofdaysinpaymentperiod]
,[zav_paymentperiodname]
,[zav_propertyname]
,[zav_provideragreementname]
,[zav_receiptnumber]
,[zav_startdate]
,[zav_tenancyname]
,[zav_tenancyrentupdatename]
,[zav_transactionnumber]
,[zav_transactiontypecode]
,[zav_transactiontypeidname]
,[zav_transactiontypename]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_propertystatus]
,[zav_rent]
,[zav_transaction]
,[zav_voidstatus]
,[new_issynchronizedtobc]
,[zav_balancecalculation]
,[zav_runningbalancesync]
,[zav_verified]
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
,[zav_irrsgenerationbatch]
,[zav_irrsgenerationbatch_entitytype]
,[zav_paymentperiod]
,[zav_paymentperiod_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_provideragreement]
,[zav_provideragreement_entitytype]
,[zav_tenancy]
,[zav_tenancy_entitytype]
,[zav_tenancyrentupdate]
,[zav_tenancyrentupdate_entitytype]
,[zav_transactiontype]
,[zav_transactiontype_entitytype]
,[zav_transactiontypeid]
,[zav_transactiontypeid_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_agreedrent]
,[zav_agreedrent_base]
,[zav_amount]
,[zav_amount_base]
,[zav_balancetotal]
,[zav_balancetotal_base]
,[zav_closingbalance]
,[zav_closingbalance_base]
,[zav_irr]
,[zav_irr_base]
,[zav_irrpaymentperiod]
,[zav_irrpaymentperiod_base]
,[zav_irrs]
,[zav_irrs_base]
,[zav_irrsweekly]
,[zav_irrsweekly_base]
,[zav_marketrent]
,[zav_marketrent_base]
,[zav_marketrentweekly]
,[zav_marketrentweekly_base]
,[zav_openingbalance]
,[zav_openingbalance_base]
,[zav_operatingsupplementos]
,[zav_operatingsupplementos_base]
,[zav_osweekly]
,[zav_osweekly_base]
,[zav_tmpopaymentperiod]
,[zav_tmpopaymentperiod_base]
,[zav_tmpoweekly]
,[zav_tmpoweekly_base]
,[zav_totalagreedrentoverperiod]
,[zav_totalagreedrentoverperiod_base]
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
,[new_receiptnumber]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_accountreferenceno]
,[zav_additionalcomments]
,[zav_bcentryno]
,[zav_comments]
,[zav_date]
,[zav_enddate]
,[zav_irrsfromdate]
,[zav_irrsgenerationbatchname]
,[zav_irrstodate]
,[zav_irrstransactiondetailsid]
,[zav_name]
,[zav_noofdaysinpaymentperiod]
,[zav_paymentperiodname]
,[zav_propertyname]
,[zav_provideragreementname]
,[zav_receiptnumber]
,[zav_startdate]
,[zav_tenancyname]
,[zav_tenancyrentupdatename]
,[zav_transactionnumber]
,[zav_transactiontypecode]
,[zav_transactiontypeidname]
,[zav_transactiontypename]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_irrstransactiondetails/*.csv',FORMAT = 'CSV',
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
,[zav_propertystatus] [bigint]
,[zav_rent] [bigint]
,[zav_transaction] [bigint]
,[zav_voidstatus] [bigint]
,[new_issynchronizedtobc] [varchar](6)
,[zav_balancecalculation] [varchar](6)
,[zav_runningbalancesync] [varchar](6)
,[zav_verified] [varchar](6)
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
,[zav_irrsgenerationbatch] [uniqueidentifier]
,[zav_irrsgenerationbatch_entitytype] [varchar](256)
,[zav_paymentperiod] [uniqueidentifier]
,[zav_paymentperiod_entitytype] [varchar](256)
,[zav_property] [uniqueidentifier]
,[zav_property_entitytype] [varchar](256)
,[zav_provideragreement] [uniqueidentifier]
,[zav_provideragreement_entitytype] [varchar](256)
,[zav_tenancy] [uniqueidentifier]
,[zav_tenancy_entitytype] [varchar](256)
,[zav_tenancyrentupdate] [uniqueidentifier]
,[zav_tenancyrentupdate_entitytype] [varchar](256)
,[zav_transactiontype] [uniqueidentifier]
,[zav_transactiontype_entitytype] [varchar](256)
,[zav_transactiontypeid] [uniqueidentifier]
,[zav_transactiontypeid_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[zav_agreedrent] [decimal](38,4)
,[zav_agreedrent_base] [decimal](38,4)
,[zav_amount] [decimal](38,4)
,[zav_amount_base] [decimal](38,4)
,[zav_balancetotal] [decimal](38,2)
,[zav_balancetotal_base] [decimal](38,2)
,[zav_closingbalance] [decimal](38,4)
,[zav_closingbalance_base] [decimal](38,4)
,[zav_irr] [decimal](38,4)
,[zav_irr_base] [decimal](38,4)
,[zav_irrpaymentperiod] [decimal](38,4)
,[zav_irrpaymentperiod_base] [decimal](38,4)
,[zav_irrs] [decimal](38,4)
,[zav_irrs_base] [decimal](38,4)
,[zav_irrsweekly] [decimal](38,4)
,[zav_irrsweekly_base] [decimal](38,4)
,[zav_marketrent] [decimal](38,4)
,[zav_marketrent_base] [decimal](38,4)
,[zav_marketrentweekly] [decimal](38,4)
,[zav_marketrentweekly_base] [decimal](38,4)
,[zav_openingbalance] [decimal](38,4)
,[zav_openingbalance_base] [decimal](38,4)
,[zav_operatingsupplementos] [decimal](38,4)
,[zav_operatingsupplementos_base] [decimal](38,4)
,[zav_osweekly] [decimal](38,4)
,[zav_osweekly_base] [decimal](38,4)
,[zav_tmpopaymentperiod] [decimal](38,4)
,[zav_tmpopaymentperiod_base] [decimal](38,4)
,[zav_tmpoweekly] [decimal](38,4)
,[zav_tmpoweekly_base] [decimal](38,4)
,[zav_totalagreedrentoverperiod] [decimal](38,4)
,[zav_totalagreedrentoverperiod_base] [decimal](38,4)
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
,[new_receiptnumber] [bigint]
,[overriddencreatedon] [datetime2](7)
,[owneridname] [varchar](640)
,[owneridtype] [varchar](8000)
,[owneridyominame] [varchar](640)
,[owningbusinessunitname] [varchar](640)
,[timezoneruleversionnumber] [bigint]
,[transactioncurrencyidname] [varchar](400)
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[zav_accountreferenceno] [bigint]
,[zav_additionalcomments] [varchar](max)
,[zav_bcentryno] [varchar](400)
,[zav_comments] [varchar](max)
,[zav_date] [datetime2](7)
,[zav_enddate] [datetime2](7)
,[zav_irrsfromdate] [datetime2](7)
,[zav_irrsgenerationbatchname] [varchar](400)
,[zav_irrstodate] [datetime2](7)
,[zav_irrstransactiondetailsid] [uniqueidentifier]
,[zav_name] [varchar](1200)
,[zav_noofdaysinpaymentperiod] [bigint]
,[zav_paymentperiodname] [varchar](400)
,[zav_propertyname] [varchar](400)
,[zav_provideragreementname] [varchar](400)
,[zav_receiptnumber] [varchar](400)
,[zav_startdate] [datetime2](7)
,[zav_tenancyname] [varchar](1200)
,[zav_tenancyrentupdatename] [varchar](400)
,[zav_transactionnumber] [varchar](400)
,[zav_transactiontypecode] [varchar](400)
,[zav_transactiontypeidname] [varchar](400)
,[zav_transactiontypename] [varchar](1200)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record