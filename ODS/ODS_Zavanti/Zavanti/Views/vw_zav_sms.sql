CREATE VIEW [Zavanti].[vw_zav_sms]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[community]
,[deliveryprioritycode]
,[instancetypecode]
,[msft_datastate]
,[prioritycode]
,[isbilled]
,[ismapiprivate]
,[isregularactivity]
,[isworkflowcreated]
,[leftvoicemail]
,[zav_direction]
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
,[regardingobjectid]
,[regardingobjectid_entitytype]
,[sendermailboxid]
,[sendermailboxid_entitytype]
,[serviceid]
,[serviceid_entitytype]
,[slaid]
,[slaid_entitytype]
,[slainvokedid]
,[slainvokedid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_account]
,[zav_account_entitytype]
,[zav_contact]
,[zav_contact_entitytype]
,[zav_incomingsms]
,[zav_incomingsms_entitytype]
,[zav_lead]
,[zav_lead_entitytype]
,[zav_opportunity]
,[zav_opportunity_entitytype]
,[zav_outgoingsms]
,[zav_outgoingsms_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[bcc]
,[cc]
,[customers]
,[from]
,[optionalattendees]
,[organizer]
,[partners]
,[requiredattendees]
,[resources]
,[to]
,[activityadditionalparams]
,[activityid]
,[activitytypecode]
,[actualdurationminutes]
,[actualend]
,[actualstart]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[deliverylastattemptedon]
,[description]
,[exchangeitemid]
,[exchangerate]
,[exchangeweblink]
,[importsequencenumber]
,[lastonholdtime]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[onholdtime]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[postponeactivityprocessinguntil]
,[processid]
,[regardingobjectidname]
,[regardingobjectidyominame]
,[regardingobjecttypecode]
,[scheduleddurationminutes]
,[scheduledend]
,[scheduledstart]
,[sendermailboxidname]
,[senton]
,[seriesid]
,[serviceidname]
,[slainvokedidname]
,[slaname]
,[sortdate]
,[stageid]
,[subject]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[traversedpath]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_accountname]
,[zav_accountyominame]
,[zav_contactname]
,[zav_contactyominame]
,[zav_error]
,[zav_incomingsmsname]
,[zav_leadname]
,[zav_leadyominame]
,[zav_opportunityname]
,[zav_outgoingid]
,[zav_outgoingsmsname]
,[zav_phonenumber]
,[zav_sid]
,[zav_smsmessage]
,[zav_smsrequest]
,[zav_smsstatuscallbackrequest]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[community]
,[deliveryprioritycode]
,[instancetypecode]
,[msft_datastate]
,[prioritycode]
,[isbilled]
,[ismapiprivate]
,[isregularactivity]
,[isworkflowcreated]
,[leftvoicemail]
,[zav_direction]
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
,[regardingobjectid]
,[regardingobjectid_entitytype]
,[sendermailboxid]
,[sendermailboxid_entitytype]
,[serviceid]
,[serviceid_entitytype]
,[slaid]
,[slaid_entitytype]
,[slainvokedid]
,[slainvokedid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_account]
,[zav_account_entitytype]
,[zav_contact]
,[zav_contact_entitytype]
,[zav_incomingsms]
,[zav_incomingsms_entitytype]
,[zav_lead]
,[zav_lead_entitytype]
,[zav_opportunity]
,[zav_opportunity_entitytype]
,[zav_outgoingsms]
,[zav_outgoingsms_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[bcc]
,[cc]
,[customers]
,[from]
,[optionalattendees]
,[organizer]
,[partners]
,[requiredattendees]
,[resources]
,[to]
,[activityadditionalparams]
,[activityid]
,[activitytypecode]
,[actualdurationminutes]
,[actualend]
,[actualstart]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[deliverylastattemptedon]
,[description]
,[exchangeitemid]
,[exchangerate]
,[exchangeweblink]
,[importsequencenumber]
,[lastonholdtime]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[onholdtime]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[postponeactivityprocessinguntil]
,[processid]
,[regardingobjectidname]
,[regardingobjectidyominame]
,[regardingobjecttypecode]
,[scheduleddurationminutes]
,[scheduledend]
,[scheduledstart]
,[sendermailboxidname]
,[senton]
,[seriesid]
,[serviceidname]
,[slainvokedidname]
,[slaname]
,[sortdate]
,[stageid]
,[subject]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[traversedpath]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_accountname]
,[zav_accountyominame]
,[zav_contactname]
,[zav_contactyominame]
,[zav_error]
,[zav_incomingsmsname]
,[zav_leadname]
,[zav_leadyominame]
,[zav_opportunityname]
,[zav_outgoingid]
,[zav_outgoingsmsname]
,[zav_phonenumber]
,[zav_sid]
,[zav_smsmessage]
,[zav_smsrequest]
,[zav_smsstatuscallbackrequest]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_sms/*.csv',FORMAT = 'CSV',
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
,[community] [bigint]
,[deliveryprioritycode] [bigint]
,[instancetypecode] [bigint]
,[msft_datastate] [bigint]
,[prioritycode] [bigint]
,[isbilled] [varchar](6)
,[ismapiprivate] [varchar](6)
,[isregularactivity] [varchar](6)
,[isworkflowcreated] [varchar](6)
,[leftvoicemail] [varchar](6)
,[zav_direction] [varchar](6)
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
,[regardingobjectid] [uniqueidentifier]
,[regardingobjectid_entitytype] [varchar](256)
,[sendermailboxid] [uniqueidentifier]
,[sendermailboxid_entitytype] [varchar](256)
,[serviceid] [uniqueidentifier]
,[serviceid_entitytype] [varchar](256)
,[slaid] [uniqueidentifier]
,[slaid_entitytype] [varchar](256)
,[slainvokedid] [uniqueidentifier]
,[slainvokedid_entitytype] [varchar](256)
,[transactioncurrencyid] [uniqueidentifier]
,[transactioncurrencyid_entitytype] [varchar](256)
,[zav_account] [uniqueidentifier]
,[zav_account_entitytype] [varchar](256)
,[zav_contact] [uniqueidentifier]
,[zav_contact_entitytype] [varchar](256)
,[zav_incomingsms] [uniqueidentifier]
,[zav_incomingsms_entitytype] [varchar](256)
,[zav_lead] [uniqueidentifier]
,[zav_lead_entitytype] [varchar](256)
,[zav_opportunity] [uniqueidentifier]
,[zav_opportunity_entitytype] [varchar](256)
,[zav_outgoingsms] [uniqueidentifier]
,[zav_outgoingsms_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[bcc] [uniqueidentifier]
,[cc] [uniqueidentifier]
,[customers] [uniqueidentifier]
,[from] [uniqueidentifier]
,[optionalattendees] [uniqueidentifier]
,[organizer] [uniqueidentifier]
,[partners] [uniqueidentifier]
,[requiredattendees] [uniqueidentifier]
,[resources] [uniqueidentifier]
,[to] [uniqueidentifier]
,[activityadditionalparams] [varchar](max)
,[activityid] [uniqueidentifier]
,[activitytypecode] [varchar](8000)
,[actualdurationminutes] [bigint]
,[actualend] [datetime2](7)
,[actualstart] [datetime2](7)
,[createdbyname] [varchar](640)
,[createdbyyominame] [varchar](640)
,[createdon] [datetimeoffset](7)
,[createdonbehalfbyname] [varchar](640)
,[createdonbehalfbyyominame] [varchar](640)
,[deliverylastattemptedon] [datetime2](7)
,[description] [varchar](max)
,[exchangeitemid] [varchar](800)
,[exchangerate] [decimal](38,12)
,[exchangeweblink] [varchar](5000)
,[importsequencenumber] [bigint]
,[lastonholdtime] [datetime2](7)
,[modifiedbyname] [varchar](640)
,[modifiedbyyominame] [varchar](640)
,[modifiedon] [datetime2](7)
,[modifiedonbehalfbyname] [varchar](640)
,[modifiedonbehalfbyyominame] [varchar](640)
,[onholdtime] [bigint]
,[overriddencreatedon] [datetime2](7)
,[owneridname] [varchar](640)
,[owneridtype] [varchar](8000)
,[owneridyominame] [varchar](640)
,[owningbusinessunitname] [varchar](640)
,[postponeactivityprocessinguntil] [datetime2](7)
,[processid] [uniqueidentifier]
,[regardingobjectidname] [varchar](max)
,[regardingobjectidyominame] [varchar](max)
,[regardingobjecttypecode] [varchar](8000)
,[scheduleddurationminutes] [bigint]
,[scheduledend] [datetime2](7)
,[scheduledstart] [datetime2](7)
,[sendermailboxidname] [varchar](400)
,[senton] [datetime2](7)
,[seriesid] [uniqueidentifier]
,[serviceidname] [varchar](640)
,[slainvokedidname] [varchar](640)
,[slaname] [varchar](400)
,[sortdate] [datetime2](7)
,[stageid] [uniqueidentifier]
,[subject] [varchar](3200)
,[timezoneruleversionnumber] [bigint]
,[transactioncurrencyidname] [varchar](400)
,[traversedpath] [varchar](5000)
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[zav_accountname] [varchar](640)
,[zav_accountyominame] [varchar](640)
,[zav_contactname] [varchar](640)
,[zav_contactyominame] [varchar](1800)
,[zav_error] [varchar](max)
,[zav_incomingsmsname] [varchar](3200)
,[zav_leadname] [varchar](640)
,[zav_leadyominame] [varchar](1800)
,[zav_opportunityname] [varchar](1200)
,[zav_outgoingid] [varchar](400)
,[zav_outgoingsmsname] [varchar](3200)
,[zav_phonenumber] [varchar](400)
,[zav_sid] [varchar](400)
,[zav_smsmessage] [varchar](max)
,[zav_smsrequest] [varchar](max)
,[zav_smsstatuscallbackrequest] [varchar](max)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record