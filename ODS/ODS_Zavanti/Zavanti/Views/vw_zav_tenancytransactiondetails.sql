CREATE VIEW [Zavanti].[vw_zav_tenancytransactiondetails]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_accounttype]
,[zav_paymenttype]
,[zav_rent]
,[zav_transaction]
,[new_issynchronizedtobc]
,[new_runningbalancesync]
,[new_suspenseaccount]
,[zav_balancecalculation]
,[zav_entitymismatch]
,[zav_fromzavantiimport]
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
,[zav_arrearsarrangement]
,[zav_arrearsarrangement_entitytype]
,[zav_importpayment]
,[zav_importpayment_entitytype]
,[zav_importwaterchargeid]
,[zav_importwaterchargeid_entitytype]
,[zav_rentgenerationbatch]
,[zav_rentgenerationbatch_entitytype]
,[zav_tenancy]
,[zav_tenancy_entitytype]
,[zav_transactiontype]
,[zav_transactiontype_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[new_balancenonrent]
,[new_balancenonrent_base]
,[new_balancerent]
,[new_balancerent_base]
,[new_balancetotal]
,[new_balancetotal_base]
,[new_lessconcession]
,[new_lessconcession_base]
,[new_pred_0383512c_7ecd_49a2_aa8f_e5ed328d0a7d]
,[new_pred_0383512c_7ecd_49a2_aa8f_e5ed328d0a7d_base]
,[new_specialmeterreadingcost]
,[new_specialmeterreadingcost_base]
,[new_totalbalances]
,[new_totalbalances_base]
,[new_totalcharge]
,[new_totalcharge_base]
,[new_waterusecost1]
,[new_waterusecost1_base]
,[new_waterusecost2]
,[new_waterusecost2_base]
,[new_waterusecost3]
,[new_waterusecost3_base]
,[new_wateruserate1]
,[new_wateruserate1_base]
,[new_wateruserate2]
,[new_wateruserate2_base]
,[new_wateruserate3]
,[new_wateruserate3_base]
,[zav_amount]
,[zav_amount_base]
,[zav_amountdue]
,[zav_amountdue_base]
,[zav_amountspaidinadvance]
,[zav_amountspaidinadvance_base]
,[zav_chargeforthisperiod]
,[zav_chargeforthisperiod_base]
,[zav_closingbalance]
,[zav_closingbalance_base]
,[zav_openingbalance]
,[zav_openingbalance_base]
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
,[new_meterreadingfrom]
,[new_meterreadingfromkl]
,[new_meterreadingto]
,[new_meterreadingtokl]
,[new_netmeterreadingkl]
,[new_receiptnumber]
,[new_transactiontypecode]
,[new_waterusedesc1]
,[new_waterusedesc2]
,[new_waterusedesc3]
,[new_waterusekl1]
,[new_waterusekl2]
,[new_waterusekl3]
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
,[zav_arrearsarrangementname]
,[zav_bcentryno]
,[zav_chintaroid]
,[zav_comments]
,[zav_date]
,[zav_dummyorder]
,[zav_importcomments]
,[zav_importpaymentname]
,[zav_importwaterchargeidname]
,[zav_name]
,[zav_numberofdays]
,[zav_propertyreferencenumber]
,[zav_receiptnumber]
,[zav_rentfromdate]
,[zav_rentgenerationbatchname]
,[zav_rentpaidto]
,[zav_renttodate]
,[zav_subtransactionname]
,[zav_tenancyasatdate]
,[zav_tenancyname]
,[zav_tenancytransactiondetailsid]
,[zav_transactiontypename]
,[zav_zavantiimportuniquecode]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_accounttype]
,[zav_paymenttype]
,[zav_rent]
,[zav_transaction]
,[new_issynchronizedtobc]
,[new_runningbalancesync]
,[new_suspenseaccount]
,[zav_balancecalculation]
,[zav_entitymismatch]
,[zav_fromzavantiimport]
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
,[zav_arrearsarrangement]
,[zav_arrearsarrangement_entitytype]
,[zav_importpayment]
,[zav_importpayment_entitytype]
,[zav_importwaterchargeid]
,[zav_importwaterchargeid_entitytype]
,[zav_rentgenerationbatch]
,[zav_rentgenerationbatch_entitytype]
,[zav_tenancy]
,[zav_tenancy_entitytype]
,[zav_transactiontype]
,[zav_transactiontype_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[new_balancenonrent]
,[new_balancenonrent_base]
,[new_balancerent]
,[new_balancerent_base]
,[new_balancetotal]
,[new_balancetotal_base]
,[new_lessconcession]
,[new_lessconcession_base]
,[new_pred_0383512c_7ecd_49a2_aa8f_e5ed328d0a7d]
,[new_pred_0383512c_7ecd_49a2_aa8f_e5ed328d0a7d_base]
,[new_specialmeterreadingcost]
,[new_specialmeterreadingcost_base]
,[new_totalbalances]
,[new_totalbalances_base]
,[new_totalcharge]
,[new_totalcharge_base]
,[new_waterusecost1]
,[new_waterusecost1_base]
,[new_waterusecost2]
,[new_waterusecost2_base]
,[new_waterusecost3]
,[new_waterusecost3_base]
,[new_wateruserate1]
,[new_wateruserate1_base]
,[new_wateruserate2]
,[new_wateruserate2_base]
,[new_wateruserate3]
,[new_wateruserate3_base]
,[zav_amount]
,[zav_amount_base]
,[zav_amountdue]
,[zav_amountdue_base]
,[zav_amountspaidinadvance]
,[zav_amountspaidinadvance_base]
,[zav_chargeforthisperiod]
,[zav_chargeforthisperiod_base]
,[zav_closingbalance]
,[zav_closingbalance_base]
,[zav_openingbalance]
,[zav_openingbalance_base]
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
,[new_meterreadingfrom]
,[new_meterreadingfromkl]
,[new_meterreadingto]
,[new_meterreadingtokl]
,[new_netmeterreadingkl]
,[new_receiptnumber]
,[new_transactiontypecode]
,[new_waterusedesc1]
,[new_waterusedesc2]
,[new_waterusedesc3]
,[new_waterusekl1]
,[new_waterusekl2]
,[new_waterusekl3]
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
,[zav_arrearsarrangementname]
,[zav_bcentryno]
,[zav_chintaroid]
,[zav_comments]
,[zav_date]
,[zav_dummyorder]
,[zav_importcomments]
,[zav_importpaymentname]
,[zav_importwaterchargeidname]
,[zav_name]
,[zav_numberofdays]
,[zav_propertyreferencenumber]
,[zav_receiptnumber]
,[zav_rentfromdate]
,[zav_rentgenerationbatchname]
,[zav_rentpaidto]
,[zav_renttodate]
,[zav_subtransactionname]
,[zav_tenancyasatdate]
,[zav_tenancyname]
,[zav_tenancytransactiondetailsid]
,[zav_transactiontypename]
,[zav_zavantiimportuniquecode]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_tenancytransactiondetails/*.csv',FORMAT = 'CSV',
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
,[zav_accounttype] [bigint]
,[zav_paymenttype] [bigint]
,[zav_rent] [bigint]
,[zav_transaction] [bigint]
,[new_issynchronizedtobc] [varchar](6)
,[new_runningbalancesync] [varchar](6)
,[new_suspenseaccount] [varchar](6)
,[zav_balancecalculation] [varchar](6)
,[zav_entitymismatch] [varchar](6)
,[zav_fromzavantiimport] [varchar](6)
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
,[zav_arrearsarrangement] [uniqueidentifier]
,[zav_arrearsarrangement_entitytype] [varchar](256)
,[zav_importpayment] [uniqueidentifier]
,[zav_importpayment_entitytype] [varchar](256)
,[zav_importwaterchargeid] [uniqueidentifier]
,[zav_importwaterchargeid_entitytype] [varchar](256)
,[zav_rentgenerationbatch] [uniqueidentifier]
,[zav_rentgenerationbatch_entitytype] [varchar](256)
,[zav_tenancy] [uniqueidentifier]
,[zav_tenancy_entitytype] [varchar](256)
,[zav_transactiontype] [uniqueidentifier]
,[zav_transactiontype_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[new_balancenonrent] [decimal](38,2)
,[new_balancenonrent_base] [decimal](38,2)
,[new_balancerent] [decimal](38,2)
,[new_balancerent_base] [decimal](38,2)
,[new_balancetotal] [decimal](38,2)
,[new_balancetotal_base] [decimal](38,2)
,[new_lessconcession] [decimal](38,4)
,[new_lessconcession_base] [decimal](38,4)
,[new_pred_0383512c_7ecd_49a2_aa8f_e5ed328d0a7d] [decimal](38,2)
,[new_pred_0383512c_7ecd_49a2_aa8f_e5ed328d0a7d_base] [decimal](38,2)
,[new_specialmeterreadingcost] [decimal](38,4)
,[new_specialmeterreadingcost_base] [decimal](38,4)
,[new_totalbalances] [decimal](38,4)
,[new_totalbalances_base] [decimal](38,4)
,[new_totalcharge] [decimal](38,4)
,[new_totalcharge_base] [decimal](38,4)
,[new_waterusecost1] [decimal](38,4)
,[new_waterusecost1_base] [decimal](38,4)
,[new_waterusecost2] [decimal](38,4)
,[new_waterusecost2_base] [decimal](38,4)
,[new_waterusecost3] [decimal](38,4)
,[new_waterusecost3_base] [decimal](38,4)
,[new_wateruserate1] [decimal](38,4)
,[new_wateruserate1_base] [decimal](38,4)
,[new_wateruserate2] [decimal](38,4)
,[new_wateruserate2_base] [decimal](38,4)
,[new_wateruserate3] [decimal](38,4)
,[new_wateruserate3_base] [decimal](38,4)
,[zav_amount] [decimal](38,4)
,[zav_amount_base] [decimal](38,4)
,[zav_amountdue] [decimal](38,4)
,[zav_amountdue_base] [decimal](38,4)
,[zav_amountspaidinadvance] [decimal](38,4)
,[zav_amountspaidinadvance_base] [decimal](38,4)
,[zav_chargeforthisperiod] [decimal](38,4)
,[zav_chargeforthisperiod_base] [decimal](38,4)
,[zav_closingbalance] [decimal](38,4)
,[zav_closingbalance_base] [decimal](38,4)
,[zav_openingbalance] [decimal](38,4)
,[zav_openingbalance_base] [decimal](38,4)
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
,[new_meterreadingfrom] [datetime2](7)
,[new_meterreadingfromkl] [bigint]
,[new_meterreadingto] [datetime2](7)
,[new_meterreadingtokl] [bigint]
,[new_netmeterreadingkl] [bigint]
,[new_receiptnumber] [bigint]
,[new_transactiontypecode] [varchar](400)
,[new_waterusedesc1] [varchar](400)
,[new_waterusedesc2] [varchar](400)
,[new_waterusedesc3] [varchar](400)
,[new_waterusekl1] [decimal](38,2)
,[new_waterusekl2] [decimal](38,2)
,[new_waterusekl3] [decimal](38,2)
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
,[zav_arrearsarrangementname] [varchar](400)
,[zav_bcentryno] [varchar](400)
,[zav_chintaroid] [varchar](400)
,[zav_comments] [varchar](max)
,[zav_date] [datetime2](7)
,[zav_dummyorder] [bigint]
,[zav_importcomments] [varchar](max)
,[zav_importpaymentname] [varchar](400)
,[zav_importwaterchargeidname] [varchar](400)
,[zav_name] [varchar](1200)
,[zav_numberofdays] [bigint]
,[zav_propertyreferencenumber] [varchar](400)
,[zav_receiptnumber] [varchar](400)
,[zav_rentfromdate] [datetime2](7)
,[zav_rentgenerationbatchname] [varchar](400)
,[zav_rentpaidto] [datetime2](7)
,[zav_renttodate] [datetime2](7)
,[zav_subtransactionname] [varchar](400)
,[zav_tenancyasatdate] [datetime2](7)
,[zav_tenancyname] [varchar](1200)
,[zav_tenancytransactiondetailsid] [uniqueidentifier]
,[zav_transactiontypename] [varchar](1200)
,[zav_zavantiimportuniquecode] [varchar](800)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record