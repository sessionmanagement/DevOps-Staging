CREATE VIEW [Zavanti].[vw_zav_irrbalance]
AS
SELECT [Id]
	,[SinkCreatedOn]
	,[SinkModifiedOn]
	,[statecode]
	,[statuscode]
	,[zav_arrearsadvance]
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
	,[zav_tenancy]
	,[zav_tenancy_entitytype]
	,[ownerid]
	,[ownerid_entitytype]
	,[zav_balanceasat]
	,[zav_balanceasat_base]
	,[zav_daysinhand]
	,[zav_daysinhand_base]
	,[zav_debitamountinadvance]
	,[zav_debitamountinadvance_base]
	,[zav_sumoftransactions]
	,[zav_sumoftransactions_base]
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
	,[zav_asatdate]
	,[zav_days]
	,[zav_debitdaysinadvance]
	,[zav_irrbalanceid]
	,[zav_name]
	,[zav_rentpaidto]
	,[zav_tenancyname]
	,[IsDelete]
FROM (
	SELECT [Id]
		,[SinkCreatedOn]
		,[SinkModifiedOn]
		,[statecode]
		,[statuscode]
		,[zav_arrearsadvance]
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
		,[zav_tenancy]
		,[zav_tenancy_entitytype]
		,[ownerid]
		,[ownerid_entitytype]
		,[zav_balanceasat]
		,[zav_balanceasat_base]
		,[zav_daysinhand]
		,[zav_daysinhand_base]
		,[zav_debitamountinadvance]
		,[zav_debitamountinadvance_base]
		,[zav_sumoftransactions]
		,[zav_sumoftransactions_base]
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
		,[zav_asatdate]
		,[zav_days]
		,[zav_debitdaysinadvance]
		,[zav_irrbalanceid]
		,[zav_name]
		,[zav_rentpaidto]
		,[zav_tenancyname]
		,[IsDelete]
		,ROW_NUMBER() OVER (
			PARTITION BY id ORDER BY [SinkModifiedOn] DESC
			) AS row_num -- used to identify latest record  
	FROM OPENROWSET(BULK 'https://sttestaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_irrbalance/*.csv', FORMAT = 'CSV', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 1) WITH (
			[Id] [uniqueidentifier]
			,[SinkCreatedOn] [datetime2](7)
			,[SinkModifiedOn] [datetime2](7)
			,[statecode] [bigint]
			,[statuscode] [bigint]
			,[zav_arrearsadvance] [bigint]
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
			,[zav_tenancy] [uniqueidentifier]
			,[zav_tenancy_entitytype] [varchar](256)
			,[ownerid] [uniqueidentifier]
			,[ownerid_entitytype] [varchar](256)
			,[zav_balanceasat] [decimal](38, 4)
			,[zav_balanceasat_base] [decimal](38, 4)
			,[zav_daysinhand] [decimal](38, 4)
			,[zav_daysinhand_base] [decimal](38, 4)
			,[zav_debitamountinadvance] [decimal](38, 4)
			,[zav_debitamountinadvance_base] [decimal](38, 4)
			,[zav_sumoftransactions] [decimal](38, 4)
			,[zav_sumoftransactions_base] [decimal](38, 4)
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
			,[overriddencreatedon] [datetime2](7)
			,[owneridname] [varchar](640)
			,[owneridtype] [varchar](8000)
			,[owneridyominame] [varchar](640)
			,[owningbusinessunitname] [varchar](640)
			,[timezoneruleversionnumber] [bigint]
			,[transactioncurrencyidname] [varchar](400)
			,[utcconversiontimezonecode] [bigint]
			,[versionnumber] [bigint]
			,[zav_asatdate] [datetime2](7)
			,[zav_days] [bigint]
			,[zav_debitdaysinadvance] [bigint]
			,[zav_irrbalanceid] [uniqueidentifier]
			,[zav_name] [varchar](400)
			,[zav_rentpaidto] [datetime2](7)
			,[zav_tenancyname] [varchar](1600)
			,[IsDelete] [varchar](6)
			) AS d
	) AS [data]
WHERE row_num = 1 -- return only latest record  GO  