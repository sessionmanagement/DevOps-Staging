CREATE VIEW [Zavanti].[vw_zav_household]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_amendmentreason]
,[zav_householdstatus]
,[zav_isitajoininrequest]
,[zav_previousamendmentreason]
,[zav_amendment]
,[zav_confirmamendment]
,[zav_deadofprimaryvacatedtenancy]
,[zav_isvision]
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
,[zav_additionalmember]
,[zav_additionalmember_entitytype]
,[zav_applicant]
,[zav_applicant_entitytype]
,[zav_householdmember]
,[zav_householdmember_entitytype]
,[zav_tenancy]
,[zav_tenancy_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_rentsharetotal]
,[zav_rentsharetotal_base]
,[zav_totalincomeofthehousehold]
,[zav_totalincomeofthehousehold_base]
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
,[zav_actualdateforwhenagreementreached]
,[zav_addedmembers]
,[zav_additionalmembername]
,[zav_additionalmemberyominame]
,[zav_applicantname]
,[zav_applicantyominame]
,[zav_applicationid]
,[zav_dateofamendment]
,[zav_hhid]
,[zav_householdid]
,[zav_householdmemberamended]
,[zav_householdmembername]
,[zav_name]
,[zav_namedhhmembers]
,[zav_nameofhouseholdmembers]
,[zav_numberofhouseholdmembers]
,[zav_removedmembers]
,[zav_rentsharetotal_date]
,[zav_rentsharetotal_state]
,[zav_revision]
,[zav_targetdateforreachingagreementwithnextof]
,[zav_tenancyid]
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
,[zav_amendmentreason]
,[zav_householdstatus]
,[zav_isitajoininrequest]
,[zav_previousamendmentreason]
,[zav_amendment]
,[zav_confirmamendment]
,[zav_deadofprimaryvacatedtenancy]
,[zav_isvision]
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
,[zav_additionalmember]
,[zav_additionalmember_entitytype]
,[zav_applicant]
,[zav_applicant_entitytype]
,[zav_householdmember]
,[zav_householdmember_entitytype]
,[zav_tenancy]
,[zav_tenancy_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_rentsharetotal]
,[zav_rentsharetotal_base]
,[zav_totalincomeofthehousehold]
,[zav_totalincomeofthehousehold_base]
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
,[zav_actualdateforwhenagreementreached]
,[zav_addedmembers]
,[zav_additionalmembername]
,[zav_additionalmemberyominame]
,[zav_applicantname]
,[zav_applicantyominame]
,[zav_applicationid]
,[zav_dateofamendment]
,[zav_hhid]
,[zav_householdid]
,[zav_householdmemberamended]
,[zav_householdmembername]
,[zav_name]
,[zav_namedhhmembers]
,[zav_nameofhouseholdmembers]
,[zav_numberofhouseholdmembers]
,[zav_removedmembers]
,[zav_rentsharetotal_date]
,[zav_rentsharetotal_state]
,[zav_revision]
,[zav_targetdateforreachingagreementwithnextof]
,[zav_tenancyid]
,[zav_tenancyname]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_household/*.csv',FORMAT = 'CSV',
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
,[zav_amendmentreason] [bigint]
,[zav_householdstatus] [bigint]
,[zav_isitajoininrequest] [bigint]
,[zav_previousamendmentreason] [bigint]
,[zav_amendment] [varchar](6)
,[zav_confirmamendment] [varchar](6)
,[zav_deadofprimaryvacatedtenancy] [varchar](6)
,[zav_isvision] [varchar](6)
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
,[zav_additionalmember] [uniqueidentifier]
,[zav_additionalmember_entitytype] [varchar](256)
,[zav_applicant] [uniqueidentifier]
,[zav_applicant_entitytype] [varchar](256)
,[zav_householdmember] [uniqueidentifier]
,[zav_householdmember_entitytype] [varchar](256)
,[zav_tenancy] [uniqueidentifier]
,[zav_tenancy_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[zav_rentsharetotal] [decimal](38,2)
,[zav_rentsharetotal_base] [decimal](38,2)
,[zav_totalincomeofthehousehold] [decimal](38,4)
,[zav_totalincomeofthehousehold_base] [decimal](38,4)
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
,[zav_actualdateforwhenagreementreached] [datetime2](7)
,[zav_addedmembers] [varchar](4000)
,[zav_additionalmembername] [varchar](640)
,[zav_additionalmemberyominame] [varchar](1800)
,[zav_applicantname] [varchar](640)
,[zav_applicantyominame] [varchar](1800)
,[zav_applicationid] [varchar](400)
,[zav_dateofamendment] [datetime2](7)
,[zav_hhid] [varchar](400)
,[zav_householdid] [uniqueidentifier]
,[zav_householdmemberamended] [varchar](max)
,[zav_householdmembername] [varchar](400)
,[zav_name] [varchar](400)
,[zav_namedhhmembers] [varchar](max)
,[zav_nameofhouseholdmembers] [varchar](max)
,[zav_numberofhouseholdmembers] [bigint]
,[zav_removedmembers] [varchar](4000)
,[zav_rentsharetotal_date] [datetime2](7)
,[zav_rentsharetotal_state] [bigint]
,[zav_revision] [bigint]
,[zav_targetdateforreachingagreementwithnextof] [datetime2](7)
,[zav_tenancyid] [varchar](400)
,[zav_tenancyname] [varchar](1200)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record