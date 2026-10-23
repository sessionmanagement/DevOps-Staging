create   view [Zavanti].[vw_zav_arrearsarrangement]
as
select [Id]
	,[SinkCreatedOn]
	,[SinkModifiedOn]
	,[statecode]
	,[statuscode]
	,[zav_arrangementtype]
	,[zav_calculatedbasedon]
	,[zav_frequency]
	,[zav_activatearrearsarrangement]
	,[zav_paymentplannotadheredto]
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
	,[zav_tenancybreach]
	,[zav_tenancybreach_entitytype]
	,[zav_tenancyid]
	,[zav_tenancyid_entitytype]
	,[zav_tenancytransactiontype]
	,[zav_tenancytransactiontype_entitytype]
	,[ownerid]
	,[ownerid_entitytype]
	,[crba8_managedarrears]
	,[crba8_managedarrears_base]
	,[zav_amount]
	,[zav_amount_base]
	,[zav_balanceamount]
	,[zav_balanceamount_base]
	,[zav_managedarrears]
	,[zav_managedarrears_base]
	,[zav_nonrentbalance]
	,[zav_nonrentbalance_base]
	,[zav_rentbalance]
	,[zav_rentbalance_base]
	,[zav_totalarrears]
	,[zav_totalarrears_base]
	,[zav_totalbalance]
	,[zav_totalbalance_base]
	,[zav_unmanagedarrears]
	,[zav_unmanagedarrears_base]
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
	,[new_comments]
	,[overriddencreatedon]
	,[owneridname]
	,[owneridtype]
	,[owneridyominame]
	,[owningbusinessunitname]
	,[timezoneruleversionnumber]
	,[transactioncurrencyidname]
	,[utcconversiontimezonecode]
	,[versionnumber]
	,[zav_arrangementreferencenumber]
	,[zav_arrearsarrangementid]
	,[zav_comments]
	,[zav_enddate]
	,[zav_firstpaymentstartdate]
	,[zav_name]
	,[zav_priority]
	,[zav_startdate]
	,[zav_tenancybreachname]
	,[zav_tenancyidname]
	,[zav_tenancytransactiontypename]
	,[IsDelete]
FROM (
			SELECT [Id]
			,[SinkCreatedOn]
			,[SinkModifiedOn]
			,[statecode]
			,[statuscode]
			,[zav_arrangementtype]
			,[zav_calculatedbasedon]
			,[zav_frequency]
			,[zav_activatearrearsarrangement]
			,[zav_paymentplannotadheredto]
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
			,[zav_tenancybreach]
			,[zav_tenancybreach_entitytype]
			,[zav_tenancyid]
			,[zav_tenancyid_entitytype]
			,[zav_tenancytransactiontype]
			,[zav_tenancytransactiontype_entitytype]
			,[ownerid]
			,[ownerid_entitytype]
			,[crba8_managedarrears]
			,[crba8_managedarrears_base]
			,[zav_amount]
			,[zav_amount_base]
			,[zav_balanceamount]
			,[zav_balanceamount_base]
			,[zav_managedarrears]
			,[zav_managedarrears_base]
			,[zav_nonrentbalance]
			,[zav_nonrentbalance_base]
			,[zav_rentbalance]
			,[zav_rentbalance_base]
			,[zav_totalarrears]
			,[zav_totalarrears_base]
			,[zav_totalbalance]
			,[zav_totalbalance_base]
			,[zav_unmanagedarrears]
			,[zav_unmanagedarrears_base]
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
			,[new_comments]
			,[overriddencreatedon]
			,[owneridname]
			,[owneridtype]
			,[owneridyominame]
			,[owningbusinessunitname]
			,[timezoneruleversionnumber]
			,[transactioncurrencyidname]
			,[utcconversiontimezonecode]
			,[versionnumber]
			,[zav_arrangementreferencenumber]
			,[zav_arrearsarrangementid]
			,[zav_comments]
			,[zav_enddate]
			,[zav_firstpaymentstartdate]
			,[zav_name]
			,[zav_priority]
			,[zav_startdate]
			,[zav_tenancybreachname]
			,[zav_tenancyidname]
			,[zav_tenancytransactiontypename]
			,[IsDelete]
		,ROW_NUMBER() OVER (
			PARTITION BY id ORDER BY [SinkModifiedOn] DESC
			) AS row_num -- used to identify latest record   
	FROM OPENROWSET(BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_arrearsarrangement/*.csv', FORMAT = 'CSV', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 1) WITH (
			[Id] [uniqueidentifier]
			,[SinkCreatedOn] [datetime2](7)
			,[SinkModifiedOn] [datetime2](7)
			,[statecode] [bigint]
			,[statuscode] [bigint]
			,[zav_arrangementtype] [int]
			,[zav_calculatedbasedon] [int]
			,[zav_frequency] [int]
			,[zav_activatearrearsarrangement] [varchar](6)
			,[zav_paymentplannotadheredto] [varchar](6)
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
			,[zav_tenancybreach] [uniqueidentifier]
			,[zav_tenancybreach_entitytype] [varchar](256)
			,[zav_tenancyid] [uniqueidentifier]
			,[zav_tenancyid_entitytype] [varchar](256)
			,[zav_tenancytransactiontype] [uniqueidentifier]
			,[zav_tenancytransactiontype_entitytype] [varchar](256)
			,[ownerid] [uniqueidentifier]
			,[ownerid_entitytype] [varchar](256)
			,[crba8_managedarrears] [decimal](38, 2)
			,[crba8_managedarrears_base] [decimal](38, 2)
			,[zav_amount] [decimal](38, 4)
			,[zav_amount_base] [decimal](38, 4)
			,[zav_balanceamount] [decimal](38, 4)
			,[zav_balanceamount_base] [decimal](38, 4)
			,[zav_managedarrears] [decimal](38, 2)
			,[zav_managedarrears_base] [decimal](38, 2)
			,[zav_nonrentbalance] [decimal](38, 2)
			,[zav_nonrentbalance_base] [decimal](38, 2)
			,[zav_rentbalance] [decimal](38, 2)
			,[zav_rentbalance_base] [decimal](38, 2)
			,[zav_totalarrears] [decimal](38, 4)
			,[zav_totalarrears_base] [decimal](38, 4)
			,[zav_totalbalance] [decimal](38, 2)
			,[zav_totalbalance_base] [decimal](38, 2)
			,[zav_unmanagedarrears] [decimal](38, 2)
			,[zav_unmanagedarrears_base] [decimal](38, 2)
			,[createdbyname] [varchar](1026)
			,[createdbyyominame] [varchar](1026)
			,[createdon] [datetimeoffset](7)
			,[createdonbehalfbyname] [varchar](1026)
			,[createdonbehalfbyyominame] [varchar](1026)
			,[exchangerate] [decimal](38, 10)
			,[importsequencenumber] [bigint]
			,[modifiedbyname] [varchar](1026)
			,[modifiedbyyominame] [varchar](1026)
			,[modifiedon] [datetime2](7)
			,[modifiedonbehalfbyname] [varchar](1026)
			,[modifiedonbehalfbyyominame] [varchar](1026)
			,[new_comments] [varchar](max)
			,[overriddencreatedon] [datetime2](7)
			,[owneridname] [varchar](640)
			,[owneridtype] [varchar](8000)
			,[owneridyominame] [varchar](640)
			,[owningbusinessunitname] [varchar](640)
			,[timezoneruleversionnumber] [bigint]
			,[transactioncurrencyidname] [varchar](400)
			,[utcconversiontimezonecode] [bigint]
			,[versionnumber] [bigint]
			,[zav_arrangementreferencenumber] [varchar](400)
			,[zav_arrearsarrangementid] [uniqueidentifier]
			,[zav_comments] [varchar](max)
			,[zav_enddate] [datetime2](7)
			,[zav_firstpaymentstartdate] [datetime2](7)
			,[zav_name] [varchar](400)
			,[zav_priority] [bigint]
			,[zav_startdate] [datetime2](7)
			,[zav_tenancybreachname] [varchar](400)
			,[zav_tenancyidname] [varchar](1600)
			,[zav_tenancytransactiontypename] [varchar](1200)
			,[IsDelete] [varchar](6)
			) AS d
	) AS [data]
WHERE row_num = 1 -- return only latest record  GO  