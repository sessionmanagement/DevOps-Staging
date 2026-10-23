CREATE VIEW [Zavanti].[vw_zav_noticetoremedy]
AS
SELECT [Id]
	,[SinkCreatedOn]
	,[SinkModifiedOn]
	,[statecode]
	,[statuscode]
	,[zav_servicedelivery]
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
	,[zav_case]
	,[zav_case_entitytype]
	,[zav_noticesentby]
	,[zav_noticesentby_entitytype]
	,[zav_noticetoremedyuploadedby]
	,[zav_noticetoremedyuploadedby_entitytype]
	,[zav_tenancy]
	,[zav_tenancy_entitytype]
	,[zav_tenancybreach]
	,[zav_tenancybreach_entitytype]
	,[ownerid]
	,[ownerid_entitytype]
	,[createdbyname]
	,[createdbyyominame]
	,[createdon]
	,[createdonbehalfbyname]
	,[createdonbehalfbyyominame]
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
	,[utcconversiontimezonecode]
	,[versionnumber]
	,[zav_anyotherrelevantinformation]
	,[zav_casename]
	,[zav_enddate]
	,[zav_name]
	,[zav_notes]
	,[zav_noticesentbyname]
	,[zav_noticesentbyyominame]
	,[zav_noticetoremedyid]
	,[zav_noticetoremedyuploadedbyname]
	,[zav_noticetoremedyuploadedbyyominame]
	,[zav_noticetoremedyuploadeddate]
	,[zav_notkepttoyourtenancyresponsibilities]
	,[zav_originalenddate]
	,[zav_remedythesituationbydoingthefollowing]
	,[zav_startdate]
	,[zav_tenancybreachname]
	,[zav_tenancyname]
	,[zav_theantisocialbehaviourthatwasreportedtous]
	,[zav_thebehaviouroccurredatbetween]
	,[zav_thebehaviourwaslocated]
	,[zav_thepeopleengagedinthebehaviourwere]
	,[IsDelete]
FROM (
	SELECT [Id]
		,[SinkCreatedOn]
		,[SinkModifiedOn]
		,[statecode]
		,[statuscode]
		,[zav_servicedelivery]
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
		,[zav_case]
		,[zav_case_entitytype]
		,[zav_noticesentby]
		,[zav_noticesentby_entitytype]
		,[zav_noticetoremedyuploadedby]
		,[zav_noticetoremedyuploadedby_entitytype]
		,[zav_tenancy]
		,[zav_tenancy_entitytype]
		,[zav_tenancybreach]
		,[zav_tenancybreach_entitytype]
		,[ownerid]
		,[ownerid_entitytype]
		,[createdbyname]
		,[createdbyyominame]
		,[createdon]
		,[createdonbehalfbyname]
		,[createdonbehalfbyyominame]
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
		,[utcconversiontimezonecode]
		,[versionnumber]
		,[zav_anyotherrelevantinformation]
		,[zav_casename]
		,[zav_enddate]
		,[zav_name]
		,[zav_notes]
		,[zav_noticesentbyname]
		,[zav_noticesentbyyominame]
		,[zav_noticetoremedyid]
		,[zav_noticetoremedyuploadedbyname]
		,[zav_noticetoremedyuploadedbyyominame]
		,[zav_noticetoremedyuploadeddate]
		,[zav_notkepttoyourtenancyresponsibilities]
		,[zav_originalenddate]
		,[zav_remedythesituationbydoingthefollowing]
		,[zav_startdate]
		,[zav_tenancybreachname]
		,[zav_tenancyname]
		,[zav_theantisocialbehaviourthatwasreportedtous]
		,[zav_thebehaviouroccurredatbetween]
		,[zav_thebehaviourwaslocated]
		,[zav_thepeopleengagedinthebehaviourwere]
		,[IsDelete]
		,ROW_NUMBER() OVER (
			PARTITION BY id ORDER BY [SinkModifiedOn] DESC
			) AS row_num
	-- used to identify latest record   
	FROM OPENROWSET(BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_noticetoremedy/*.csv', FORMAT = 'CSV', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 1) WITH (
			[Id] [uniqueidentifier]
			,[SinkCreatedOn] [datetime2](7)
			,[SinkModifiedOn] [datetime2](7)
			,[statecode] [bigint]
			,[statuscode] [bigint]
			,[zav_servicedelivery] [bigint]
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
			,[zav_case] [uniqueidentifier]
			,[zav_case_entitytype] [varchar](256)
			,[zav_noticesentby] [uniqueidentifier]
			,[zav_noticesentby_entitytype] [varchar](256)
			,[zav_noticetoremedyuploadedby] [uniqueidentifier]
			,[zav_noticetoremedyuploadedby_entitytype] [varchar](256)
			,[zav_tenancy] [uniqueidentifier]
			,[zav_tenancy_entitytype] [varchar](256)
			,[zav_tenancybreach] [uniqueidentifier]
			,[zav_tenancybreach_entitytype] [varchar](256)
			,[ownerid] [uniqueidentifier]
			,[ownerid_entitytype] [varchar](256)
			,[createdbyname] [varchar](1026)
			,[createdbyyominame] [varchar](1026)
			,[createdon] [datetimeoffset](7)
			,[createdonbehalfbyname] [varchar](1026)
			,[createdonbehalfbyyominame] [varchar](1026)
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
			,[utcconversiontimezonecode] [bigint]
			,[versionnumber] [bigint]
			,[zav_anyotherrelevantinformation] [varchar](max)
			,[zav_casename] [varchar](800)
			,[zav_enddate] [datetime2](7)
			,[zav_name] [varchar](400)
			,[zav_notes] [varchar](max)
			,[zav_noticesentbyname] [varchar](1026)
			,[zav_noticesentbyyominame] [varchar](1026)
			,[zav_noticetoremedyid] [uniqueidentifier]
			,[zav_noticetoremedyuploadedbyname] [varchar](1026)
			,[zav_noticetoremedyuploadedbyyominame] [varchar](1026)
			,[zav_noticetoremedyuploadeddate] [datetime2](7)
			,[zav_notkepttoyourtenancyresponsibilities] [varchar](max)
			,[zav_originalenddate] [datetime2](7)
			,[zav_remedythesituationbydoingthefollowing] [varchar](max)
			,[zav_startdate] [datetime2](7)
			,[zav_tenancybreachname] [varchar](400)
			,[zav_tenancyname] [varchar](1600)
			,[zav_theantisocialbehaviourthatwasreportedtous] [varchar](max)
			,[zav_thebehaviouroccurredatbetween] [varchar](max)
			,[zav_thebehaviourwaslocated] [varchar](max)
			,[zav_thepeopleengagedinthebehaviourwere] [varchar](max)
			,[IsDelete] [varchar](6)
			) AS d
	) AS [data]
WHERE row_num = 1
	-- return only latest record  GO  