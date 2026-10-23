CREATE VIEW [Zavanti].[vw_zav_doaapprovalrequest]
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
,[zav_endorse]
,[zav_reject]
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
,[zav_assignto]
,[zav_assignto_entitytype]
,[zav_doasetting]
,[zav_doasetting_entitytype]
,[zav_endorsedby]
,[zav_endorsedby_entitytype]
,[zav_originalassignto]
,[zav_originalassignto_entitytype]
,[zav_rejectedby]
,[zav_rejectedby_entitytype]
,[zav_submittedby]
,[zav_submittedby_entitytype]
,[zav_transferrequestrentadj]
,[zav_transferrequestrentadj_entitytype]
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
,[zav_approvalstatus]
,[zav_assigntoname]
,[zav_assigntoyominame]
,[zav_doasettingname]
,[zav_endorsedbyname]
,[zav_endorsedbyyominame]
,[zav_endorseddate]
,[zav_originalassigntoname]
,[zav_originalassigntoyominame]
,[zav_rejectedbyname]
,[zav_rejectedbyyominame]
,[zav_rejecteddate]
,[zav_rejectreason]
,[zav_submittedbyname]
,[zav_submittedbyyominame]
,[zav_submitteddate]
,[zav_transferrequestrentadjname]
,[IsDelete]
,[zav_requestid]
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
,[zav_endorse]
,[zav_reject]
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
,[zav_assignto]
,[zav_assignto_entitytype]
,[zav_doasetting]
,[zav_doasetting_entitytype]
,[zav_endorsedby]
,[zav_endorsedby_entitytype]
,[zav_originalassignto]
,[zav_originalassignto_entitytype]
,[zav_rejectedby]
,[zav_rejectedby_entitytype]
,[zav_submittedby]
,[zav_submittedby_entitytype]
,[zav_transferrequestrentadj]
,[zav_transferrequestrentadj_entitytype]
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
,[zav_approvalstatus]
,[zav_assigntoname]
,[zav_assigntoyominame]
,[zav_doasettingname]
,[zav_endorsedbyname]
,[zav_endorsedbyyominame]
,[zav_endorseddate]
,[zav_originalassigntoname]
,[zav_originalassigntoyominame]
,[zav_rejectedbyname]
,[zav_rejectedbyyominame]
,[zav_rejecteddate]
,[zav_rejectreason]
,[zav_submittedbyname]
,[zav_submittedbyyominame]
,[zav_submitteddate]
,[zav_transferrequestrentadjname]
,[IsDelete]
,[zav_requestid]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_doaapprovalrequest/*.csv',FORMAT = 'CSV',
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
,[zav_endorse] [varchar](6)
,[zav_reject] [varchar](6)
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
,[zav_assignto] [uniqueidentifier]
,[zav_assignto_entitytype] [varchar](256)
,[zav_doasetting] [uniqueidentifier]
,[zav_doasetting_entitytype] [varchar](256)
,[zav_endorsedby] [uniqueidentifier]
,[zav_endorsedby_entitytype] [varchar](256)
,[zav_originalassignto] [uniqueidentifier]
,[zav_originalassignto_entitytype] [varchar](256)
,[zav_rejectedby] [uniqueidentifier]
,[zav_rejectedby_entitytype] [varchar](256)
,[zav_submittedby] [uniqueidentifier]
,[zav_submittedby_entitytype] [varchar](256)
,[zav_transferrequestrentadj] [uniqueidentifier]
,[zav_transferrequestrentadj_entitytype] [varchar](256)
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
,[zav_approvalstatus] [varchar](2000)
,[zav_assigntoname] [varchar](1026)
,[zav_assigntoyominame] [varchar](1026)
,[zav_doasettingname] [varchar](400)
,[zav_endorsedbyname] [varchar](1026)
,[zav_endorsedbyyominame] [varchar](1026)
,[zav_endorseddate] [datetime2](7)
,[zav_originalassigntoname] [varchar](1026)
,[zav_originalassigntoyominame] [varchar](1026)
,[zav_rejectedbyname] [varchar](1026)
,[zav_rejectedbyyominame] [varchar](1026)
,[zav_rejecteddate] [datetime2](7)
,[zav_rejectreason] [varchar](max)
,[zav_submittedbyname] [varchar](1026)
,[zav_submittedbyyominame] [varchar](1026)
,[zav_submitteddate] [datetime2](7)
,[zav_transferrequestrentadjname] [varchar](400)
,[IsDelete] [varchar](6)
,[zav_requestid] [varchar](36)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record