CREATE VIEW [Zavanti].[vw_zav_rentadjustmentrequest]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_creditordebit]
,[zav_primarytenantconsent]
,[zav_reasonforadjustment]
,[zav_reasonforrefund]
,[zav_requesttype]
,[zav_secondarytenantconsent]
,[zav_approve]
,[zav_reject]
,[zav_sendforapproval]
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
,[zav_approvedby]
,[zav_approvedby_entitytype]
,[zav_doasetting]
,[zav_doasetting_entitytype]
,[zav_housingofficer]
,[zav_housingofficer_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_rejectedby]
,[zav_rejectedby_entitytype]
,[zav_tenancyrentupdate]
,[zav_tenancyrentupdate_entitytype]
,[zav_tenant]
,[zav_tenant_entitytype]
,[zav_transactiontype]
,[zav_transactiontype_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_amounttoberefunded]
,[zav_amounttoberefunded_base]
,[zav_currentweeklyrent]
,[zav_currentweeklyrent_base]
,[zav_difference]
,[zav_difference_base]
,[zav_newweeklyrent]
,[zav_newweeklyrent_base]
,[zav_totalamounttobeadjusted]
,[zav_totalamounttobeadjusted_base]
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
,[zav_approvedbyname]
,[zav_approvedbyyominame]
,[zav_closedatdate]
,[zav_comments]
,[zav_dateadjustmentends]
,[zav_dateadjustmentstarts]
,[zav_dateapproved]
,[zav_daterejected]
,[zav_daterequestedbycustomer]
,[zav_doasettingname]
,[zav_housingofficername]
,[zav_housingofficeryominame]
,[zav_name]
,[zav_propertyname]
,[zav_rejectedbyname]
,[zav_rejectedbyyominame]
,[zav_rentadjustmentrequestid]
,[zav_tenancyrentupdatename]
,[zav_tenantname]
,[zav_totalnumberofdays]
,[zav_transactionid]
,[zav_transactiontypename]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_creditordebit]
,[zav_primarytenantconsent]
,[zav_reasonforadjustment]
,[zav_reasonforrefund]
,[zav_requesttype]
,[zav_secondarytenantconsent]
,[zav_approve]
,[zav_reject]
,[zav_sendforapproval]
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
,[zav_approvedby]
,[zav_approvedby_entitytype]
,[zav_doasetting]
,[zav_doasetting_entitytype]
,[zav_housingofficer]
,[zav_housingofficer_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_rejectedby]
,[zav_rejectedby_entitytype]
,[zav_tenancyrentupdate]
,[zav_tenancyrentupdate_entitytype]
,[zav_tenant]
,[zav_tenant_entitytype]
,[zav_transactiontype]
,[zav_transactiontype_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_amounttoberefunded]
,[zav_amounttoberefunded_base]
,[zav_currentweeklyrent]
,[zav_currentweeklyrent_base]
,[zav_difference]
,[zav_difference_base]
,[zav_newweeklyrent]
,[zav_newweeklyrent_base]
,[zav_totalamounttobeadjusted]
,[zav_totalamounttobeadjusted_base]
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
,[zav_approvedbyname]
,[zav_approvedbyyominame]
,[zav_closedatdate]
,[zav_comments]
,[zav_dateadjustmentends]
,[zav_dateadjustmentstarts]
,[zav_dateapproved]
,[zav_daterejected]
,[zav_daterequestedbycustomer]
,[zav_doasettingname]
,[zav_housingofficername]
,[zav_housingofficeryominame]
,[zav_name]
,[zav_propertyname]
,[zav_rejectedbyname]
,[zav_rejectedbyyominame]
,[zav_rentadjustmentrequestid]
,[zav_tenancyrentupdatename]
,[zav_tenantname]
,[zav_totalnumberofdays]
,[zav_transactionid]
,[zav_transactiontypename]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_rentadjustmentrequest/*.csv',FORMAT = 'CSV',
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
,[zav_creditordebit] [bigint]
,[zav_primarytenantconsent] [bigint]
,[zav_reasonforadjustment] [bigint]
,[zav_reasonforrefund] [bigint]
,[zav_requesttype] [bigint]
,[zav_secondarytenantconsent] [bigint]
,[zav_approve] [varchar](6)
,[zav_reject] [varchar](6)
,[zav_sendforapproval] [varchar](6)
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
,[zav_approvedby] [uniqueidentifier]
,[zav_approvedby_entitytype] [varchar](256)
,[zav_doasetting] [uniqueidentifier]
,[zav_doasetting_entitytype] [varchar](256)
,[zav_housingofficer] [uniqueidentifier]
,[zav_housingofficer_entitytype] [varchar](256)
,[zav_property] [uniqueidentifier]
,[zav_property_entitytype] [varchar](256)
,[zav_rejectedby] [uniqueidentifier]
,[zav_rejectedby_entitytype] [varchar](256)
,[zav_tenancyrentupdate] [uniqueidentifier]
,[zav_tenancyrentupdate_entitytype] [varchar](256)
,[zav_tenant] [uniqueidentifier]
,[zav_tenant_entitytype] [varchar](256)
,[zav_transactiontype] [uniqueidentifier]
,[zav_transactiontype_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[zav_amounttoberefunded] [decimal](38,4)
,[zav_amounttoberefunded_base] [decimal](38,4)
,[zav_currentweeklyrent] [decimal](38,4)
,[zav_currentweeklyrent_base] [decimal](38,4)
,[zav_difference] [decimal](38,4)
,[zav_difference_base] [decimal](38,4)
,[zav_newweeklyrent] [decimal](38,4)
,[zav_newweeklyrent_base] [decimal](38,4)
,[zav_totalamounttobeadjusted] [decimal](38,4)
,[zav_totalamounttobeadjusted_base] [decimal](38,4)
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
,[zav_approvedbyname] [varchar](1026)
,[zav_approvedbyyominame] [varchar](1026)
,[zav_closedatdate] [datetime2](7)
,[zav_comments] [varchar](max)
,[zav_dateadjustmentends] [datetime2](7)
,[zav_dateadjustmentstarts] [datetime2](7)
,[zav_dateapproved] [datetime2](7)
,[zav_daterejected] [datetime2](7)
,[zav_daterequestedbycustomer] [datetime2](7)
,[zav_doasettingname] [varchar](400)
,[zav_housingofficername] [varchar](1026)
,[zav_housingofficeryominame] [varchar](1026)
,[zav_name] [varchar](2000)
,[zav_propertyname] [varchar](400)
,[zav_rejectedbyname] [varchar](1026)
,[zav_rejectedbyyominame] [varchar](1026)
,[zav_rentadjustmentrequestid] [uniqueidentifier]
,[zav_tenancyrentupdatename] [varchar](400)
,[zav_tenantname] [varchar](1200)
,[zav_totalnumberofdays] [bigint]
,[zav_transactionid] [varchar](400)
,[zav_transactiontypename] [varchar](1200)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record