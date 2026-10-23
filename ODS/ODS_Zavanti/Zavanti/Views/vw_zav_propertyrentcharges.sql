CREATE VIEW [Zavanti].[vw_zav_propertyrentcharges]
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
	,[zav_property]
	,[zav_property_entitytype]
	,[zav_provideragreement]
	,[zav_provideragreement_entitytype]
	,[ownerid]
	,[ownerid_entitytype]
	,[zav_agreedrent]
	,[zav_agreedrent_base]
	,[zav_marketrent]
	,[zav_marketrent_base]
	,[zav_operatingsupplementamount]
	,[zav_operatingsupplementamount_base]
	,[zav_tenancymanagementpropertyoverhead]
	,[zav_tenancymanagementpropertyoverhead_base]
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
	,[zav_chintaroid]
	,[zav_comments]
	,[zav_enddate]
	,[zav_name]
	,[zav_operatingsupplementpercent]
	,[zav_propertyname]
	,[zav_propertyrentchargesid]
	,[zav_provideragreementname]
	,[zav_startdate]
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
		,[zav_property]
		,[zav_property_entitytype]
		,[zav_provideragreement]
		,[zav_provideragreement_entitytype]
		,[ownerid]
		,[ownerid_entitytype]
		,[zav_agreedrent]
		,[zav_agreedrent_base]
		,[zav_marketrent]
		,[zav_marketrent_base]
		,[zav_operatingsupplementamount]
		,[zav_operatingsupplementamount_base]
		,[zav_tenancymanagementpropertyoverhead]
		,[zav_tenancymanagementpropertyoverhead_base]
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
		,[zav_chintaroid]
		,[zav_comments]
		,[zav_enddate]
		,[zav_name]
		,[zav_operatingsupplementpercent]
		,[zav_propertyname]
		,[zav_propertyrentchargesid]
		,[zav_provideragreementname]
		,[zav_startdate]
		,[IsDelete]
		,ROW_NUMBER() OVER (
			PARTITION BY id ORDER BY [SinkModifiedOn] DESC
			) AS row_num -- used to identify latest record  
	FROM OPENROWSET(BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_propertyrentcharges/*.csv', FORMAT = 'CSV', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 1) WITH (
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
			,[zav_property] [uniqueidentifier]
			,[zav_property_entitytype] [varchar](256)
			,[zav_provideragreement] [uniqueidentifier]
			,[zav_provideragreement_entitytype] [varchar](256)
			,[ownerid] [uniqueidentifier]
			,[ownerid_entitytype] [varchar](256)
			,[zav_agreedrent] [decimal](38, 4)
			,[zav_agreedrent_base] [decimal](38, 4)
			,[zav_marketrent] [decimal](38, 4)
			,[zav_marketrent_base] [decimal](38, 4)
			,[zav_operatingsupplementamount] [decimal](38, 4)
			,[zav_operatingsupplementamount_base] [decimal](38, 4)
			,[zav_tenancymanagementpropertyoverhead] [decimal](38, 4)
			,[zav_tenancymanagementpropertyoverhead_base] [decimal](38, 4)
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
			,[zav_chintaroid] [varchar](400)
			,[zav_comments] [varchar](max)
			,[zav_enddate] [datetime2](7)
			,[zav_name] [varchar](400)
			,[zav_operatingsupplementpercent] [float]
			,[zav_propertyname] [varchar](400)
			,[zav_propertyrentchargesid] [uniqueidentifier]
			,[zav_provideragreementname] [varchar](400)
			,[zav_startdate] [datetime2](7)
			,[IsDelete] [varchar](6)
			) AS d
	) AS [data]
WHERE row_num = 1 -- return only latest record  GO  