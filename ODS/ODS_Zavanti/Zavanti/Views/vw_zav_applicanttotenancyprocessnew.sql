CREATE VIEW [Zavanti].[vw_zav_applicanttotenancyprocessnew]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[msft_datastate]
,[activestageid]
,[activestageid_entitytype]
,[bpf_leadid]
,[bpf_leadid_entitytype]
,[bpf_opportunityid]
,[bpf_opportunityid_entitytype]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[organizationid]
,[organizationid_entitytype]
,[processid]
,[processid_entitytype]
,[activestageidname]
,[activestagestartedon]
,[bpf_duration]
,[bpf_leadidname]
,[bpf_leadidyominame]
,[bpf_name]
,[bpf_opportunityidname]
,[businessprocessflowinstanceid]
,[completedon]
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
,[organizationidname]
,[overriddencreatedon]
,[processidname]
,[timezoneruleversionnumber]
,[traversedpath]
,[utcconversiontimezonecode]
,[versionnumber]
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
,[activestageid]
,[activestageid_entitytype]
,[bpf_leadid]
,[bpf_leadid_entitytype]
,[bpf_opportunityid]
,[bpf_opportunityid_entitytype]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[organizationid]
,[organizationid_entitytype]
,[processid]
,[processid_entitytype]
,[activestageidname]
,[activestagestartedon]
,[bpf_duration]
,[bpf_leadidname]
,[bpf_leadidyominame]
,[bpf_name]
,[bpf_opportunityidname]
,[businessprocessflowinstanceid]
,[completedon]
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
,[organizationidname]
,[overriddencreatedon]
,[processidname]
,[timezoneruleversionnumber]
,[traversedpath]
,[utcconversiontimezonecode]
,[versionnumber]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_applicanttotenancyprocessnew/*.csv',FORMAT = 'CSV',
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
,[activestageid] [uniqueidentifier]
,[activestageid_entitytype] [varchar](256)
,[bpf_leadid] [uniqueidentifier]
,[bpf_leadid_entitytype] [varchar](256)
,[bpf_opportunityid] [uniqueidentifier]
,[bpf_opportunityid_entitytype] [varchar](256)
,[createdby] [uniqueidentifier]
,[createdby_entitytype] [varchar](256)
,[createdonbehalfby] [uniqueidentifier]
,[createdonbehalfby_entitytype] [varchar](256)
,[modifiedby] [uniqueidentifier]
,[modifiedby_entitytype] [varchar](256)
,[modifiedonbehalfby] [uniqueidentifier]
,[modifiedonbehalfby_entitytype] [varchar](256)
,[organizationid] [uniqueidentifier]
,[organizationid_entitytype] [varchar](256)
,[processid] [uniqueidentifier]
,[processid_entitytype] [varchar](256)
,[activestageidname] [varchar](400)
,[activestagestartedon] [datetime2](7)
,[bpf_duration] [bigint]
,[bpf_leadidname] [varchar](640)
,[bpf_leadidyominame] [varchar](1800)
,[bpf_name] [varchar](400)
,[bpf_opportunityidname] [varchar](1200)
,[businessprocessflowinstanceid] [uniqueidentifier]
,[completedon] [datetime2](7)
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
,[organizationidname] [varchar](640)
,[overriddencreatedon] [datetime2](7)
,[processidname] [varchar](400)
,[timezoneruleversionnumber] [bigint]
,[traversedpath] [varchar](5000)
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record