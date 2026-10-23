CREATE VIEW [Zavanti].[vw_zav_tribunalorder]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
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
,[zav_tenancybreach]
,[zav_tenancybreach_entitytype]
,[zav_tribunaloutcome]
,[zav_tribunaloutcome_entitytype]
,[zav_tribunaloutcomereason]
,[zav_tribunaloutcomereason_entitytype]
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
,[zav_casename]
,[zav_enddate]
,[zav_name]
,[zav_notes]
,[zav_startdate]
,[zav_tenancybreachname]
,[zav_tribunalorderid]
,[zav_tribunaloutcomename]
,[zav_tribunaloutcomereasonname]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
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
,[zav_tenancybreach]
,[zav_tenancybreach_entitytype]
,[zav_tribunaloutcome]
,[zav_tribunaloutcome_entitytype]
,[zav_tribunaloutcomereason]
,[zav_tribunaloutcomereason_entitytype]
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
,[zav_casename]
,[zav_enddate]
,[zav_name]
,[zav_notes]
,[zav_startdate]
,[zav_tenancybreachname]
,[zav_tribunalorderid]
,[zav_tribunaloutcomename]
,[zav_tribunaloutcomereasonname]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_tribunalorder/*.csv',FORMAT = 'CSV',
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
,[zav_tenancybreach] [uniqueidentifier]
,[zav_tenancybreach_entitytype] [varchar](256)
,[zav_tribunaloutcome] [uniqueidentifier]
,[zav_tribunaloutcome_entitytype] [varchar](256)
,[zav_tribunaloutcomereason] [uniqueidentifier]
,[zav_tribunaloutcomereason_entitytype] [varchar](256)
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
,[zav_casename] [varchar](800)
,[zav_enddate] [datetime2](7)
,[zav_name] [varchar](400)
,[zav_notes] [varchar](max)
,[zav_startdate] [datetime2](7)
,[zav_tenancybreachname] [varchar](400)
,[zav_tribunalorderid] [uniqueidentifier]
,[zav_tribunaloutcomename] [varchar](400)
,[zav_tribunaloutcomereasonname] [varchar](400)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record