CREATE VIEW [Zavanti].[vw_zav_insurancepolicycover]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_insurancetype]
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
,[zav_insuranceholder]
,[zav_insuranceholder_entitytype]
,[zav_insuranceprovidername]
,[zav_insuranceprovidername_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[crba8_methexcess]
,[crba8_methexcess_base]
,[zav_claimsexcessarrangementforthepolicy]
,[zav_claimsexcessarrangementforthepolicy_base]
,[zav_commonareaexcess]
,[zav_commonareaexcess_base]
,[zav_generalexcess]
,[zav_generalexcess_base]
,[zav_glasswindowsexcess]
,[zav_glasswindowsexcess_base]
,[zav_insuredamount]
,[zav_insuredamount_base]
,[zav_otherexcess]
,[zav_otherexcess_base]
,[zav_waterdamageexcess]
,[zav_waterdamageexcess_base]
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
,[zav_insuranceholdername]
,[zav_insuranceholderyominame]
,[zav_insurancepolicycoverid]
,[zav_insuranceprovidernamename]
,[zav_insuranceprovidernameyominame]
,[zav_name]
,[zav_otherdetailscomments]
,[zav_providercoverenddate]
,[zav_providercoverstartdate]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_insurancetype]
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
,[zav_insuranceholder]
,[zav_insuranceholder_entitytype]
,[zav_insuranceprovidername]
,[zav_insuranceprovidername_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[crba8_methexcess]
,[crba8_methexcess_base]
,[zav_claimsexcessarrangementforthepolicy]
,[zav_claimsexcessarrangementforthepolicy_base]
,[zav_commonareaexcess]
,[zav_commonareaexcess_base]
,[zav_generalexcess]
,[zav_generalexcess_base]
,[zav_glasswindowsexcess]
,[zav_glasswindowsexcess_base]
,[zav_insuredamount]
,[zav_insuredamount_base]
,[zav_otherexcess]
,[zav_otherexcess_base]
,[zav_waterdamageexcess]
,[zav_waterdamageexcess_base]
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
,[zav_insuranceholdername]
,[zav_insuranceholderyominame]
,[zav_insurancepolicycoverid]
,[zav_insuranceprovidernamename]
,[zav_insuranceprovidernameyominame]
,[zav_name]
,[zav_otherdetailscomments]
,[zav_providercoverenddate]
,[zav_providercoverstartdate]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_insurancepolicycover/*.csv',FORMAT = 'CSV',
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
,[zav_insurancetype] [bigint]
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
,[zav_insuranceholder] [uniqueidentifier]
,[zav_insuranceholder_entitytype] [varchar](256)
,[zav_insuranceprovidername] [uniqueidentifier]
,[zav_insuranceprovidername_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[crba8_methexcess] [decimal](38,0)
,[crba8_methexcess_base] [decimal](38,0)
,[zav_claimsexcessarrangementforthepolicy] [decimal](38,4)
,[zav_claimsexcessarrangementforthepolicy_base] [decimal](38,4)
,[zav_commonareaexcess] [decimal](38,4)
,[zav_commonareaexcess_base] [decimal](38,4)
,[zav_generalexcess] [decimal](38,4)
,[zav_generalexcess_base] [decimal](38,4)
,[zav_glasswindowsexcess] [decimal](38,4)
,[zav_glasswindowsexcess_base] [decimal](38,4)
,[zav_insuredamount] [decimal](38,4)
,[zav_insuredamount_base] [decimal](38,4)
,[zav_otherexcess] [decimal](38,4)
,[zav_otherexcess_base] [decimal](38,4)
,[zav_waterdamageexcess] [decimal](38,4)
,[zav_waterdamageexcess_base] [decimal](38,4)
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
,[zav_insuranceholdername] [varchar](640)
,[zav_insuranceholderyominame] [varchar](1800)
,[zav_insurancepolicycoverid] [uniqueidentifier]
,[zav_insuranceprovidernamename] [varchar](640)
,[zav_insuranceprovidernameyominame] [varchar](640)
,[zav_name] [varchar](400)
,[zav_otherdetailscomments] [varchar](max)
,[zav_providercoverenddate] [datetime2](7)
,[zav_providercoverstartdate] [datetime2](7)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record