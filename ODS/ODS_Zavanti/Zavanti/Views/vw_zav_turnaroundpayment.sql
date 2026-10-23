CREATE VIEW [Zavanti].[vw_zav_turnaroundpayment]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_issynctobc]
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
,[zav_paymentperiod]
,[zav_paymentperiod_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_transactiontype]
,[zav_transactiontype_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_agreedrent]
,[zav_agreedrent_base]
,[zav_irrssubsidydaily]
,[zav_irrssubsidydaily_base]
,[zav_irrssubsidyforturnaroundpaymentperiod]
,[zav_irrssubsidyforturnaroundpaymentperiod_base]
,[zav_marketrent]
,[zav_marketrent_base]
,[zav_operatingsupplementamount]
,[zav_operatingsupplementamount_base]
,[zav_operatingsupplementos]
,[zav_operatingsupplementos_base]
,[zav_osweekly]
,[zav_osweekly_base]
,[zav_tmpopaymentperiod]
,[zav_tmpopaymentperiod_base]
,[zav_tmpoweekly]
,[zav_tmpoweekly_base]
,[zav_totalagreedrentclaimedoverperiod]
,[zav_totalagreedrentclaimedoverperiod_base]
,[zav_totalinvoiceforpaymentperiodirrsosotmtp]
,[zav_totalinvoiceforpaymentperiodirrsosotmtp_base]
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
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_bcentryno]
,[zav_comments]
,[zav_enddate]
,[zav_glcode]
,[zav_name]
,[zav_paymentperiodname]
,[zav_propertyname]
,[zav_startdate]
,[zav_totalnumberofdays]
,[zav_transactionnumber]
,[zav_transactiontypename]
,[zav_turnaroundpaymentid]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_issynctobc]
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
,[zav_paymentperiod]
,[zav_paymentperiod_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_transactiontype]
,[zav_transactiontype_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_agreedrent]
,[zav_agreedrent_base]
,[zav_irrssubsidydaily]
,[zav_irrssubsidydaily_base]
,[zav_irrssubsidyforturnaroundpaymentperiod]
,[zav_irrssubsidyforturnaroundpaymentperiod_base]
,[zav_marketrent]
,[zav_marketrent_base]
,[zav_operatingsupplementamount]
,[zav_operatingsupplementamount_base]
,[zav_operatingsupplementos]
,[zav_operatingsupplementos_base]
,[zav_osweekly]
,[zav_osweekly_base]
,[zav_tmpopaymentperiod]
,[zav_tmpopaymentperiod_base]
,[zav_tmpoweekly]
,[zav_tmpoweekly_base]
,[zav_totalagreedrentclaimedoverperiod]
,[zav_totalagreedrentclaimedoverperiod_base]
,[zav_totalinvoiceforpaymentperiodirrsosotmtp]
,[zav_totalinvoiceforpaymentperiodirrsosotmtp_base]
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
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_bcentryno]
,[zav_comments]
,[zav_enddate]
,[zav_glcode]
,[zav_name]
,[zav_paymentperiodname]
,[zav_propertyname]
,[zav_startdate]
,[zav_totalnumberofdays]
,[zav_transactionnumber]
,[zav_transactiontypename]
,[zav_turnaroundpaymentid]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_turnaroundpayment/*.csv',FORMAT = 'CSV',
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
,[zav_issynctobc] [varchar](6)
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
,[zav_paymentperiod] [uniqueidentifier]
,[zav_paymentperiod_entitytype] [varchar](256)
,[zav_property] [uniqueidentifier]
,[zav_property_entitytype] [varchar](256)
,[zav_transactiontype] [uniqueidentifier]
,[zav_transactiontype_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[zav_agreedrent] [decimal](38,4)
,[zav_agreedrent_base] [decimal](38,4)
,[zav_irrssubsidydaily] [decimal](38,4)
,[zav_irrssubsidydaily_base] [decimal](38,4)
,[zav_irrssubsidyforturnaroundpaymentperiod] [decimal](38,4)
,[zav_irrssubsidyforturnaroundpaymentperiod_base] [decimal](38,4)
,[zav_marketrent] [decimal](38,4)
,[zav_marketrent_base] [decimal](38,4)
,[zav_operatingsupplementamount] [decimal](38,4)
,[zav_operatingsupplementamount_base] [decimal](38,4)
,[zav_operatingsupplementos] [decimal](38,4)
,[zav_operatingsupplementos_base] [decimal](38,4)
,[zav_osweekly] [decimal](38,4)
,[zav_osweekly_base] [decimal](38,4)
,[zav_tmpopaymentperiod] [decimal](38,4)
,[zav_tmpopaymentperiod_base] [decimal](38,4)
,[zav_tmpoweekly] [decimal](38,4)
,[zav_tmpoweekly_base] [decimal](38,4)
,[zav_totalagreedrentclaimedoverperiod] [decimal](38,4)
,[zav_totalagreedrentclaimedoverperiod_base] [decimal](38,4)
,[zav_totalinvoiceforpaymentperiodirrsosotmtp] [decimal](38,4)
,[zav_totalinvoiceforpaymentperiodirrsosotmtp_base] [decimal](38,4)
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
,[overriddencreatedon] [datetime2](7)
,[owneridname] [varchar](640)
,[owneridtype] [varchar](8000)
,[owneridyominame] [varchar](640)
,[owningbusinessunitname] [varchar](640)
,[timezoneruleversionnumber] [bigint]
,[transactioncurrencyidname] [varchar](400)
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[zav_bcentryno] [varchar](400)
,[zav_comments] [varchar](max)
,[zav_enddate] [datetime2](7)
,[zav_glcode] [varchar](400)
,[zav_name] [varchar](1200)
,[zav_paymentperiodname] [varchar](400)
,[zav_propertyname] [varchar](400)
,[zav_startdate] [datetime2](7)
,[zav_totalnumberofdays] [bigint]
,[zav_transactionnumber] [varchar](400)
,[zav_transactiontypename] [varchar](400)
,[zav_turnaroundpaymentid] [uniqueidentifier]
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record