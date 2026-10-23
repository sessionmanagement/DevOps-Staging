CREATE VIEW [Zavanti].[vw_zav_arrearsarrangementstransactions]
AS
SELECT [Id]
	,[SinkCreatedOn]
	,[SinkModifiedOn]
	,[statecode]
	,[statuscode]
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
	,[zav_arrearsarrangementid]
	,[zav_arrearsarrangementid_entitytype]
	,[zav_tenancy]
	,[zav_tenancy_entitytype]
	,[zav_tenancytransactiondetail]
	,[zav_tenancytransactiondetail_entitytype]
	,[ownerid]
	,[ownerid_entitytype]
	,[zav_arrearamount]
	,[zav_arrearamount_base]
	,[zav_paid]
	,[zav_paid_base]
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
	,[zav_arrearsarrangementidname]
	,[zav_arrearsarrangementstransactionsid]
	,[zav_date]
	,[zav_description]
	,[zav_name]
	,[zav_tenancyname]
	,[zav_tenancytransactiondetailname]
	,[zav_transactionnumber]
	,[IsDelete]
FROM (
	SELECT [Id]
		,[SinkCreatedOn]
		,[SinkModifiedOn]
		,[statecode]
		,[statuscode]
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
		,[zav_arrearsarrangementid]
		,[zav_arrearsarrangementid_entitytype]
		,[zav_tenancy]
		,[zav_tenancy_entitytype]
		,[zav_tenancytransactiondetail]
		,[zav_tenancytransactiondetail_entitytype]
		,[ownerid]
		,[ownerid_entitytype]
		,[zav_arrearamount]
		,[zav_arrearamount_base]
		,[zav_paid]
		,[zav_paid_base]
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
		,[zav_arrearsarrangementidname]
		,[zav_arrearsarrangementstransactionsid]
		,[zav_date]
		,[zav_description]
		,[zav_name]
		,[zav_tenancyname]
		,[zav_tenancytransactiondetailname]
		,[zav_transactionnumber]
		,[IsDelete]
		,ROW_NUMBER() OVER (
			PARTITION BY id ORDER BY [SinkModifiedOn] DESC
			) AS row_num -- used to identify latest record
	FROM OPENROWSET(BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_arrearsarrangementstransactions/*.csv', FORMAT = 'CSV', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 1) WITH (
			[Id] [uniqueidentifier]
			,[SinkCreatedOn] [datetime2](7)
			,[SinkModifiedOn] [datetime2](7)
			,[statecode] [bigint]
			,[statuscode] [bigint]
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
			,[zav_arrearsarrangementid] [uniqueidentifier]
			,[zav_arrearsarrangementid_entitytype] [varchar](256)
			,[zav_tenancy] [uniqueidentifier]
			,[zav_tenancy_entitytype] [varchar](256)
			,[zav_tenancytransactiondetail] [uniqueidentifier]
			,[zav_tenancytransactiondetail_entitytype] [varchar](256)
			,[ownerid] [uniqueidentifier]
			,[ownerid_entitytype] [varchar](256)
			,[zav_arrearamount] [decimal](38, 4)
			,[zav_arrearamount_base] [decimal](38, 4)
			,[zav_paid] [decimal](38, 4)
			,[zav_paid_base] [decimal](38, 4)
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
			,[zav_arrearsarrangementidname] [varchar](400)
			,[zav_arrearsarrangementstransactionsid] [uniqueidentifier]
			,[zav_date] [datetime2](7)
			,[zav_description] [varchar](8000)
			,[zav_name] [varchar](1600)
			,[zav_tenancyname] [varchar](1600)
			,[zav_tenancytransactiondetailname] [varchar](1200)
			,[zav_transactionnumber] [varchar](400)
			,[IsDelete] [varchar](6)
			) AS d
	) AS [data]
WHERE row_num = 1 -- return only latest record  GO  