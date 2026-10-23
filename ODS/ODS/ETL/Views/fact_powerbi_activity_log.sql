
	create view [ETL].[fact_powerbi_activity_log] AS
		select 
		 al.[activityeventid] as powerbi_activity_log_internal_id
		,al.activity
		,cast(al.issuccess as bit) as is_success
		,case 
			when al.itemname = '' and al.activity = 'postcomment' then al.artifactname
			else replace(al.itemname, '.pbix', '')
			end as item_name
		,case 
			when al.activity like '%report%' then 'report'
			when al.activity like '%subscription%' then 'report'
			when al.activity like '%import%' then 'report'
			when al.activity like '%exportartifact%' then 'report'
			when al.activity like '%usagemetrics%' then 'report'
			when al.activity like '%dashboard%' then 'dashboard'
			when al.activity like '%exporttile%' then 'dashboard'
			when al.activity like '%app%' then 'app'
			when al.activity like '%gateway%' then 'gateway'
			when al.activity like '%dataset%' then 'dataset'
			when al.activity like '%scheduledrefresh%' then 'dataset'
			when al.activity like '%datasource%' then 'datasource'
			when al.activity like '%dataflow%' then 'datasource'
			when al.activity like '%capacity%' then 'capacity'
			when al.activity like '%workspace%' then 'workspace'
			when al.activity like '%group%' then 'workspace'
			when al.activity like '%folder%' then 'workspace'
			else 'other'
			end as item_type
		,al.usertype
		,al.userid
		,al.clientip
		,al.useragent
		,al.distributionmethod
		,al.consumptionmethod
		,al.workspaceid as bkworkspaceid
		,al.workspacename
		,al.reportid as bkreportid
		,al.reportname
		,al.folderdisplayname
		,al.importsource
		,al.importtype
		,al.importdisplayname
		,al.dataconnectivitymode
		,al.datasetid as bkdatasetid
		,al.datasetname
		,al.refreshtype
		,al.gatewayid as bkgatewayclusterid
		--,al.gatewayname 
		,'' as gatewayclustername
		,'' as gatewayclustertype
		,al.artifactid as bkartifactid
		,al.artifactname
		,al.capacityname
		,'' as capacityusers
		,'' as capacitystate
		,al.exportedartifactexporttype
		,al.[exportedartifactartifacttype] as exportedartifacttype
		,al.artifactname as auditedartifactname
		,'' as auditedartifactitemtype
		,'' as otherdatasetnames
		,'' as otherdatasourcetypes
		,'' as otherdatasourceconnectiondetails
		,'' as sharingrecipientemails
		,'' as sharingresharepermissions
		,'' as subscribeerecipientemails
		,'' as subscribeerecipientnames,
		convert( nchar(8),[creationtime], 112 ) as createdatekey,
		 convert(varchar, [creationtime], 8) as createtimekey

		
	from    [powerbi].[activityevents] al
	where useragent not like 'powerbiserviceinventory%'