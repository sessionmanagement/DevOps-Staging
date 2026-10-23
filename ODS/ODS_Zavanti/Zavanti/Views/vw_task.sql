CREATE VIEW [Zavanti].[vw_task]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[msft_datastate]
,[prioritycode]
,[zav_actiontask]
,[zav_tasklevel]
,[zav_tasktype]
,[isbilled]
,[isregularactivity]
,[isworkflowcreated]
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
,[serviceid]
,[serviceid_entitytype]
,[slaid]
,[slaid_entitytype]
,[slainvokedid]
,[slainvokedid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[activityadditionalparams]
,[activityid]
,[activitytypecode]
,[actualdurationminutes]
,[actualend]
,[actualstart]
,[category]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[crmtaskassigneduniqueid]
,[description]
,[exchangerate]
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
,[percentcomplete]
,[processid]
,[regardingobjectidname]
,[regardingobjectidyominame]
,[regardingobjecttypecode]
,[scheduleddurationminutes]
,[scheduledend]
,[scheduledstart]
,[serviceidname]
,[slainvokedidname]
,[slaname]
,[sortdate]
,[stageid]
,[subcategory]
,[subject]
,[subscriptionid]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[traversedpath]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_chintaroid]
,[zav_date]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[msft_datastate]
,[prioritycode]
,[zav_actiontask]
,[zav_tasklevel]
,[zav_tasktype]
,[isbilled]
,[isregularactivity]
,[isworkflowcreated]
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
,[serviceid]
,[serviceid_entitytype]
,[slaid]
,[slaid_entitytype]
,[slainvokedid]
,[slainvokedid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[activityadditionalparams]
,[activityid]
,[activitytypecode]
,[actualdurationminutes]
,[actualend]
,[actualstart]
,[category]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[crmtaskassigneduniqueid]
,[description]
,[exchangerate]
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
,[percentcomplete]
,[processid]
,[regardingobjectidname]
,[regardingobjectidyominame]
,[regardingobjecttypecode]
,[scheduleddurationminutes]
,[scheduledend]
,[scheduledstart]
,[serviceidname]
,[slainvokedidname]
,[slaname]
,[sortdate]
,[stageid]
,[subcategory]
,[subject]
,[subscriptionid]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[traversedpath]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_chintaroid]
,[zav_date]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/task/*.csv',FORMAT = 'CSV',
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
,[msft_datastate] [bigint]
,[prioritycode] [bigint]
,[zav_actiontask] [bigint]
,[zav_tasklevel] [bigint]
,[zav_tasktype] [bigint]
,[isbilled] [varchar](6)
,[isregularactivity] [varchar](6)
,[isworkflowcreated] [varchar](6)
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
,[serviceid] [uniqueidentifier]
,[serviceid_entitytype] [varchar](256)
,[slaid] [uniqueidentifier]
,[slaid_entitytype] [varchar](256)
,[slainvokedid] [uniqueidentifier]
,[slainvokedid_entitytype] [varchar](256)
,[transactioncurrencyid] [uniqueidentifier]
,[transactioncurrencyid_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[activityadditionalparams] [varchar](max)
,[activityid] [uniqueidentifier]
,[activitytypecode] [varchar](8000)
,[actualdurationminutes] [bigint]
,[actualend] [datetime2](7)
,[actualstart] [datetime2](7)
,[category] [varchar](1000)
,[createdbyname] [varchar](640)
,[createdbyyominame] [varchar](640)
,[createdon] [datetimeoffset](7)
,[createdonbehalfbyname] [varchar](640)
,[createdonbehalfbyyominame] [varchar](640)
,[crmtaskassigneduniqueid] [uniqueidentifier]
,[description] [varchar](max)
,[exchangerate] [decimal](38,12)
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
,[percentcomplete] [bigint]
,[processid] [uniqueidentifier]
,[regardingobjectidname] [varchar](max)
,[regardingobjectidyominame] [varchar](max)
,[regardingobjecttypecode] [varchar](8000)
,[scheduleddurationminutes] [bigint]
,[scheduledend] [datetime2](7)
,[scheduledstart] [datetime2](7)
,[serviceidname] [varchar](640)
,[slainvokedidname] [varchar](640)
,[slaname] [varchar](400)
,[sortdate] [datetime2](7)
,[stageid] [uniqueidentifier]
,[subcategory] [varchar](1000)
,[subject] [varchar](3200)
,[subscriptionid] [uniqueidentifier]
,[timezoneruleversionnumber] [bigint]
,[transactioncurrencyidname] [varchar](400)
,[traversedpath] [varchar](5000)
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[zav_chintaroid] [varchar](400)
,[zav_date] [datetime2](7)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record