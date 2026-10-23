CREATE VIEW [Zavanti].[vw_zav_propertycharge]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_propertycontracttransactionstatus]
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
,[zav_monthlypaymentperiod]
,[zav_monthlypaymentperiod_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_propertytransactiontype]
,[zav_propertytransactiontype_entitytype]
,[zav_provideragreement]
,[zav_provideragreement_entitytype]
,[zav_transitionalhousingprogram]
,[zav_transitionalhousingprogram_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_amount]
,[zav_amount_base]
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
,[zav_enddate]
,[zav_invoicedate]
,[zav_monthlypaymentperiodname]
,[zav_name]
,[zav_propertychargeid]
,[zav_propertyname]
,[zav_propertytransactiontypename]
,[zav_provideragreementname]
,[zav_startdate]
,[zav_transactionnumber]
,[zav_transitionalhousingprogramname]
,[zav_unavailabledays]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_propertycontracttransactionstatus]
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
,[zav_monthlypaymentperiod]
,[zav_monthlypaymentperiod_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_propertytransactiontype]
,[zav_propertytransactiontype_entitytype]
,[zav_provideragreement]
,[zav_provideragreement_entitytype]
,[zav_transitionalhousingprogram]
,[zav_transitionalhousingprogram_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_amount]
,[zav_amount_base]
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
,[zav_enddate]
,[zav_invoicedate]
,[zav_monthlypaymentperiodname]
,[zav_name]
,[zav_propertychargeid]
,[zav_propertyname]
,[zav_propertytransactiontypename]
,[zav_provideragreementname]
,[zav_startdate]
,[zav_transactionnumber]
,[zav_transitionalhousingprogramname]
,[zav_unavailabledays]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_propertycharge/*.csv',FORMAT = 'CSV',
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
,[zav_propertycontracttransactionstatus] [bigint]
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
,[zav_monthlypaymentperiod] [uniqueidentifier]
,[zav_monthlypaymentperiod_entitytype] [varchar](256)
,[zav_property] [uniqueidentifier]
,[zav_property_entitytype] [varchar](256)
,[zav_propertytransactiontype] [uniqueidentifier]
,[zav_propertytransactiontype_entitytype] [varchar](256)
,[zav_provideragreement] [uniqueidentifier]
,[zav_provideragreement_entitytype] [varchar](256)
,[zav_transitionalhousingprogram] [uniqueidentifier]
,[zav_transitionalhousingprogram_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[zav_amount] [decimal](38,4)
,[zav_amount_base] [decimal](38,4)
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
,[zav_enddate] [datetime2](7)
,[zav_invoicedate] [datetime2](7)
,[zav_monthlypaymentperiodname] [varchar](400)
,[zav_name] [varchar](400)
,[zav_propertychargeid] [uniqueidentifier]
,[zav_propertyname] [varchar](400)
,[zav_propertytransactiontypename] [varchar](400)
,[zav_provideragreementname] [varchar](400)
,[zav_startdate] [datetime2](7)
,[zav_transactionnumber] [varchar](80)
,[zav_transitionalhousingprogramname] [varchar](1200)
,[zav_unavailabledays] [bigint]
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record