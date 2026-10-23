CREATE VIEW [Zavanti].[vw_email]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[correlationmethod]
,[deliveryprioritycode]
,[emailreminderstatus]
,[emailremindertype]
,[msft_datastate]
,[notifications]
,[prioritycode]
,[compressed]
,[deliveryreceiptrequested]
,[directioncode]
,[followemailuserpreference]
,[isbilled]
,[isemailfollowed]
,[isemailreminderset]
,[isregularactivity]
,[isworkflowcreated]
,[msdyn_copilotengaged]
,[readreceiptrequested]
,[acceptingentityid]
,[acceptingentityid_entitytype]
,[correlatedactivityid]
,[correlatedactivityid_entitytype]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[emailsender]
,[emailsender_entitytype]
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
,[parentactivityid]
,[parentactivityid_entitytype]
,[receivingmailboxid]
,[receivingmailboxid_entitytype]
,[regardingobjectid]
,[regardingobjectid_entitytype]
,[sendermailboxid]
,[sendermailboxid_entitytype]
,[sendersaccount]
,[sendersaccount_entitytype]
,[serviceid]
,[serviceid_entitytype]
,[slaid]
,[slaid_entitytype]
,[slainvokedid]
,[slainvokedid_entitytype]
,[templateid]
,[templateid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[bcc]
,[cc]
,[from]
,[to]
,[acceptingentityidname]
,[acceptingentitytypecode]
,[activityadditionalparams]
,[activityid]
,[activitytypecode]
,[actualdurationminutes]
,[actualend]
,[actualstart]
,[attachmentcount]
,[attachmentopencount]
,[baseconversationindexhash]
,[category]
,[conversationindex]
,[conversationtrackingid]
,[correlatedactivityidname]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[delayedemailsendtime]
,[deliveryattempts]
,[description]
,[descriptionblobid]
,[descriptionblobid_name]
,[emailreminderexpirytime]
,[emailremindertext]
,[emailsendername]
,[emailsenderobjecttypecode]
,[emailsenderyominame]
,[emailtrackingid]
,[exchangerate]
,[importsequencenumber]
,[inreplyto]
,[internetmessageheaders]
,[isunsafe]
,[lastonholdtime]
,[lastopenedtime]
,[linksclickedcount]
,[messageid]
,[messageiddupcheck]
,[mimetype]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[msdyn_recipientlist]
,[onholdtime]
,[opencount]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[parentactivityidname]
,[postponeemailprocessinguntil]
,[processid]
,[receivingmailboxidname]
,[regardingobjectidname]
,[regardingobjectidyominame]
,[regardingobjecttypecode]
,[reminderactioncardid]
,[replycount]
,[reservedforinternaluse]
,[safedescription]
,[scheduleddurationminutes]
,[scheduledend]
,[scheduledstart]
,[sender]
,[sendermailboxidname]
,[sendersaccountname]
,[sendersaccountobjecttypecode]
,[sendersaccountyominame]
,[senton]
,[serviceidname]
,[slainvokedidname]
,[slaname]
,[sortdate]
,[stageid]
,[subcategory]
,[subject]
,[submittedby]
,[templateidname]
,[timezoneruleversionnumber]
,[torecipients]
,[trackingtoken]
,[transactioncurrencyidname]
,[traversedpath]
,[utcconversiontimezonecode]
,[versionnumber]
,[IsDelete]
,[related]
,[correlatedsubjectchanged]
,[issafedescriptiontruncated]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[correlationmethod]
,[deliveryprioritycode]
,[emailreminderstatus]
,[emailremindertype]
,[msft_datastate]
,[notifications]
,[prioritycode]
,[compressed]
,[deliveryreceiptrequested]
,[directioncode]
,[followemailuserpreference]
,[isbilled]
,[isemailfollowed]
,[isemailreminderset]
,[isregularactivity]
,[isworkflowcreated]
,[msdyn_copilotengaged]
,[readreceiptrequested]
,[acceptingentityid]
,[acceptingentityid_entitytype]
,[correlatedactivityid]
,[correlatedactivityid_entitytype]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[emailsender]
,[emailsender_entitytype]
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
,[parentactivityid]
,[parentactivityid_entitytype]
,[receivingmailboxid]
,[receivingmailboxid_entitytype]
,[regardingobjectid]
,[regardingobjectid_entitytype]
,[sendermailboxid]
,[sendermailboxid_entitytype]
,[sendersaccount]
,[sendersaccount_entitytype]
,[serviceid]
,[serviceid_entitytype]
,[slaid]
,[slaid_entitytype]
,[slainvokedid]
,[slainvokedid_entitytype]
,[templateid]
,[templateid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[bcc]
,[cc]
,[from]
,[to]
,[acceptingentityidname]
,[acceptingentitytypecode]
,[activityadditionalparams]
,[activityid]
,[activitytypecode]
,[actualdurationminutes]
,[actualend]
,[actualstart]
,[attachmentcount]
,[attachmentopencount]
,[baseconversationindexhash]
,[category]
,[conversationindex]
,[conversationtrackingid]
,[correlatedactivityidname]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[delayedemailsendtime]
,[deliveryattempts]
,[description]
,[descriptionblobid]
,[descriptionblobid_name]
,[emailreminderexpirytime]
,[emailremindertext]
,[emailsendername]
,[emailsenderobjecttypecode]
,[emailsenderyominame]
,[emailtrackingid]
,[exchangerate]
,[importsequencenumber]
,[inreplyto]
,[internetmessageheaders]
,[isunsafe]
,[lastonholdtime]
,[lastopenedtime]
,[linksclickedcount]
,[messageid]
,[messageiddupcheck]
,[mimetype]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[msdyn_recipientlist]
,[onholdtime]
,[opencount]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[parentactivityidname]
,[postponeemailprocessinguntil]
,[processid]
,[receivingmailboxidname]
,[regardingobjectidname]
,[regardingobjectidyominame]
,[regardingobjecttypecode]
,[reminderactioncardid]
,[replycount]
,[reservedforinternaluse]
,[safedescription]
,[scheduleddurationminutes]
,[scheduledend]
,[scheduledstart]
,[sender]
,[sendermailboxidname]
,[sendersaccountname]
,[sendersaccountobjecttypecode]
,[sendersaccountyominame]
,[senton]
,[serviceidname]
,[slainvokedidname]
,[slaname]
,[sortdate]
,[stageid]
,[subcategory]
,[subject]
,[submittedby]
,[templateidname]
,[timezoneruleversionnumber]
,[torecipients]
,[trackingtoken]
,[transactioncurrencyidname]
,[traversedpath]
,[utcconversiontimezonecode]
,[versionnumber]
,[IsDelete]
,[related]
,[correlatedsubjectchanged]
,[issafedescriptiontruncated]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/email/*.csv',FORMAT = 'CSV',
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
,[correlationmethod] [bigint]
,[deliveryprioritycode] [bigint]
,[emailreminderstatus] [bigint]
,[emailremindertype] [bigint]
,[msft_datastate] [bigint]
,[notifications] [bigint]
,[prioritycode] [bigint]
,[compressed] [varchar](6)
,[deliveryreceiptrequested] [varchar](6)
,[directioncode] [varchar](6)
,[followemailuserpreference] [varchar](6)
,[isbilled] [varchar](6)
,[isemailfollowed] [varchar](6)
,[isemailreminderset] [varchar](6)
,[isregularactivity] [varchar](6)
,[isworkflowcreated] [varchar](6)
,[msdyn_copilotengaged] [varchar](6)
,[readreceiptrequested] [varchar](6)
,[acceptingentityid] [uniqueidentifier]
,[acceptingentityid_entitytype] [varchar](256)
,[correlatedactivityid] [uniqueidentifier]
,[correlatedactivityid_entitytype] [varchar](256)
,[createdby] [uniqueidentifier]
,[createdby_entitytype] [varchar](256)
,[createdonbehalfby] [uniqueidentifier]
,[createdonbehalfby_entitytype] [varchar](256)
,[emailsender] [uniqueidentifier]
,[emailsender_entitytype] [varchar](256)
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
,[parentactivityid] [uniqueidentifier]
,[parentactivityid_entitytype] [varchar](256)
,[receivingmailboxid] [uniqueidentifier]
,[receivingmailboxid_entitytype] [varchar](256)
,[regardingobjectid] [uniqueidentifier]
,[regardingobjectid_entitytype] [varchar](256)
,[sendermailboxid] [uniqueidentifier]
,[sendermailboxid_entitytype] [varchar](256)
,[sendersaccount] [uniqueidentifier]
,[sendersaccount_entitytype] [varchar](256)
,[serviceid] [uniqueidentifier]
,[serviceid_entitytype] [varchar](256)
,[slaid] [uniqueidentifier]
,[slaid_entitytype] [varchar](256)
,[slainvokedid] [uniqueidentifier]
,[slainvokedid_entitytype] [varchar](256)
,[templateid] [uniqueidentifier]
,[templateid_entitytype] [varchar](256)
,[transactioncurrencyid] [uniqueidentifier]
,[transactioncurrencyid_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[bcc] [uniqueidentifier]
,[cc] [uniqueidentifier]
,[from] [uniqueidentifier]
,[to] [uniqueidentifier]
,[acceptingentityidname] [varchar](max)
,[acceptingentitytypecode] [varchar](8000)
,[activityadditionalparams] [varchar](max)
,[activityid] [uniqueidentifier]
,[activitytypecode] [varchar](8000)
,[actualdurationminutes] [bigint]
,[actualend] [datetime2](7)
,[actualstart] [datetime2](7)
,[attachmentcount] [bigint]
,[attachmentopencount] [bigint]
,[baseconversationindexhash] [bigint]
,[category] [varchar](1000)
,[conversationindex] [varchar](max)
,[conversationtrackingid] [uniqueidentifier]
,[correlatedactivityidname] [varchar](3200)
,[createdbyname] [varchar](640)
,[createdbyyominame] [varchar](640)
,[createdon] [datetimeoffset](7)
,[createdonbehalfbyname] [varchar](640)
,[createdonbehalfbyyominame] [varchar](640)
,[delayedemailsendtime] [datetime2](7)
,[deliveryattempts] [bigint]
,[description] [varchar](max)
,[descriptionblobid] [varchar](8000)
,[descriptionblobid_name] [varchar](800)
,[emailreminderexpirytime] [datetime2](7)
,[emailremindertext] [varchar](5000)
,[emailsendername] [varchar](max)
,[emailsenderobjecttypecode] [varchar](8000)
,[emailsenderyominame] [varchar](max)
,[emailtrackingid] [uniqueidentifier]
,[exchangerate] [decimal](38,12)
,[importsequencenumber] [bigint]
,[inreplyto] [varchar](1280)
,[internetmessageheaders] [varchar](2000)
,[isunsafe] [bigint]
,[lastonholdtime] [datetime2](7)
,[lastopenedtime] [datetime2](7)
,[linksclickedcount] [bigint]
,[messageid] [varchar](1280)
,[messageiddupcheck] [uniqueidentifier]
,[mimetype] [varchar](1024)
,[modifiedbyname] [varchar](640)
,[modifiedbyyominame] [varchar](640)
,[modifiedon] [datetime2](7)
,[modifiedonbehalfbyname] [varchar](640)
,[modifiedonbehalfbyyominame] [varchar](640)
,[msdyn_recipientlist] [varchar](max)
,[onholdtime] [bigint]
,[opencount] [bigint]
,[overriddencreatedon] [datetime2](7)
,[owneridname] [varchar](640)
,[owneridtype] [varchar](8000)
,[owneridyominame] [varchar](640)
,[owningbusinessunitname] [varchar](640)
,[parentactivityidname] [varchar](max)
,[postponeemailprocessinguntil] [datetime2](7)
,[processid] [uniqueidentifier]
,[receivingmailboxidname] [varchar](800)
,[regardingobjectidname] [varchar](max)
,[regardingobjectidyominame] [varchar](max)
,[regardingobjecttypecode] [varchar](8000)
,[reminderactioncardid] [uniqueidentifier]
,[replycount] [bigint]
,[reservedforinternaluse] [varchar](max)
,[safedescription] [varchar](max)
,[scheduleddurationminutes] [bigint]
,[scheduledend] [datetime2](7)
,[scheduledstart] [datetime2](7)
,[sender] [varchar](1000)
,[sendermailboxidname] [varchar](400)
,[sendersaccountname] [varchar](max)
,[sendersaccountobjecttypecode] [varchar](8000)
,[sendersaccountyominame] [varchar](max)
,[senton] [datetime2](7)
,[serviceidname] [varchar](640)
,[slainvokedidname] [varchar](640)
,[slaname] [varchar](400)
,[sortdate] [datetime2](7)
,[stageid] [uniqueidentifier]
,[subcategory] [varchar](1000)
,[subject] [varchar](3200)
,[submittedby] [varchar](1000)
,[templateidname] [varchar](400)
,[timezoneruleversionnumber] [bigint]
,[torecipients] [varchar](2000)
,[trackingtoken] [varchar](200)
,[transactioncurrencyidname] [varchar](400)
,[traversedpath] [varchar](5000)
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[IsDelete] [varchar](6)
,[related] [uniqueidentifier]
,[correlatedsubjectchanged] [varchar](6)
,[issafedescriptiontruncated] [bigint]
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record