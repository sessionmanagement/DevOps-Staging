CREATE VIEW [Zavanti].[vw_zav_propertyrentupdates]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_accounttype]
,[zav_eligibleforsubsidy]
,[zav_isimportedfromcsv]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[new_renteligibility]
,[new_renteligibility_entitytype]
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
,[zav_tenancy]
,[zav_tenancy_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[new_irrs]
,[new_irrs_base]
,[new_nrasweeklyrent]
,[new_nrasweeklyrent_base]
,[new_topuppayment]
,[new_topuppayment_base]
,[zav_agreedrent]
,[zav_agreedrent_base]
,[zav_atomarketrent]
,[zav_atomarketrent_base]
,[zav_cra]
,[zav_cra_base]
,[zav_managementfee]
,[zav_managementfee_base]
,[zav_marketrent]
,[zav_marketrent_base]
,[zav_nonrent]
,[zav_nonrent_base]
,[zav_rent]
,[zav_rent_base]
,[zav_servicefee]
,[zav_servicefee_base]
,[zav_utilitiesfee]
,[zav_utilitiesfee_base]
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
,[new_renteligibilityname]
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
,[zav_propertyname]
,[zav_propertyrentupdatesid]
,[zav_startdate]
,[zav_tags]
,[zav_tenancyname]
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
,[zav_eligibleforsubsidy]
,[zav_isimportedfromcsv]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[new_renteligibility]
,[new_renteligibility_entitytype]
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
,[zav_tenancy]
,[zav_tenancy_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[new_irrs]
,[new_irrs_base]
,[new_nrasweeklyrent]
,[new_nrasweeklyrent_base]
,[new_topuppayment]
,[new_topuppayment_base]
,[zav_agreedrent]
,[zav_agreedrent_base]
,[zav_atomarketrent]
,[zav_atomarketrent_base]
,[zav_cra]
,[zav_cra_base]
,[zav_managementfee]
,[zav_managementfee_base]
,[zav_marketrent]
,[zav_marketrent_base]
,[zav_nonrent]
,[zav_nonrent_base]
,[zav_rent]
,[zav_rent_base]
,[zav_servicefee]
,[zav_servicefee_base]
,[zav_utilitiesfee]
,[zav_utilitiesfee_base]
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
,[new_renteligibilityname]
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
,[zav_propertyname]
,[zav_propertyrentupdatesid]
,[zav_startdate]
,[zav_tags]
,[zav_tenancyname]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_propertyrentupdates/*.csv',FORMAT = 'CSV',
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
,[zav_eligibleforsubsidy] [varchar](6)
,[zav_isimportedfromcsv] [varchar](6)
,[createdby] [uniqueidentifier]
,[createdby_entitytype] [varchar](256)
,[createdonbehalfby] [uniqueidentifier]
,[createdonbehalfby_entitytype] [varchar](256)
,[modifiedby] [uniqueidentifier]
,[modifiedby_entitytype] [varchar](256)
,[modifiedonbehalfby] [uniqueidentifier]
,[modifiedonbehalfby_entitytype] [varchar](256)
,[new_renteligibility] [uniqueidentifier]
,[new_renteligibility_entitytype] [varchar](256)
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
,[zav_tenancy] [uniqueidentifier]
,[zav_tenancy_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[new_irrs] [decimal](38,2)
,[new_irrs_base] [decimal](38,2)
,[new_nrasweeklyrent] [decimal](38,2)
,[new_nrasweeklyrent_base] [decimal](38,2)
,[new_topuppayment] [decimal](38,2)
,[new_topuppayment_base] [decimal](38,2)
,[zav_agreedrent] [decimal](38,4)
,[zav_agreedrent_base] [decimal](38,4)
,[zav_atomarketrent] [decimal](38,4)
,[zav_atomarketrent_base] [decimal](38,4)
,[zav_cra] [decimal](38,4)
,[zav_cra_base] [decimal](38,4)
,[zav_managementfee] [decimal](38,4)
,[zav_managementfee_base] [decimal](38,4)
,[zav_marketrent] [decimal](38,4)
,[zav_marketrent_base] [decimal](38,4)
,[zav_nonrent] [decimal](38,4)
,[zav_nonrent_base] [decimal](38,4)
,[zav_rent] [decimal](38,4)
,[zav_rent_base] [decimal](38,4)
,[zav_servicefee] [decimal](38,4)
,[zav_servicefee_base] [decimal](38,4)
,[zav_utilitiesfee] [decimal](38,4)
,[zav_utilitiesfee_base] [decimal](38,4)
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
,[new_renteligibilityname] [varchar](400)
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
,[zav_propertyname] [varchar](400)
,[zav_propertyrentupdatesid] [uniqueidentifier]
,[zav_startdate] [datetime2](7)
,[zav_tags] [varchar](1200)
,[zav_tenancyname] [varchar](1200)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record