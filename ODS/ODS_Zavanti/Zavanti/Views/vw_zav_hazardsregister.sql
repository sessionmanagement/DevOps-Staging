CREATE VIEW [Zavanti].[vw_zav_hazardsregister]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_asbestosremoved]
,[zav_asbestosstatus]
,[zav_classification]
,[zav_condition]
,[zav_hazardstatus]
,[zav_risklevel]
,[zav_type]
,[zav_location]
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
,[zav_hazardname]
,[zav_hazardname_entitytype]
,[zav_identifiedby]
,[zav_identifiedby_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_testedby]
,[zav_testedby_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[crba8_comments]
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
,[zav_chintaroid]
,[zav_dateidentied]
,[zav_hazardnamename]
,[zav_hazardsregisterid]
,[zav_identifiedbyname]
,[zav_identifiedbyyominame]
,[zav_name]
,[zav_propertyname]
,[zav_removaldate]
,[zav_testdate]
,[zav_testedbyname]
,[zav_testedbyyominame]
,[zav_testresult]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_asbestosremoved]
,[zav_asbestosstatus]
,[zav_classification]
,[zav_condition]
,[zav_hazardstatus]
,[zav_risklevel]
,[zav_type]
,[zav_location]
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
,[zav_hazardname]
,[zav_hazardname_entitytype]
,[zav_identifiedby]
,[zav_identifiedby_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_testedby]
,[zav_testedby_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[crba8_comments]
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
,[zav_chintaroid]
,[zav_dateidentied]
,[zav_hazardnamename]
,[zav_hazardsregisterid]
,[zav_identifiedbyname]
,[zav_identifiedbyyominame]
,[zav_name]
,[zav_propertyname]
,[zav_removaldate]
,[zav_testdate]
,[zav_testedbyname]
,[zav_testedbyyominame]
,[zav_testresult]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_hazardsregister/*.csv',FORMAT = 'CSV',
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
,[zav_asbestosremoved] [bigint]
,[zav_asbestosstatus] [bigint]
,[zav_classification] [bigint]
,[zav_condition] [bigint]
,[zav_hazardstatus] [bigint]
,[zav_risklevel] [bigint]
,[zav_type] [bigint]
,[zav_location] [varchar](8000)
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
,[zav_hazardname] [uniqueidentifier]
,[zav_hazardname_entitytype] [varchar](256)
,[zav_identifiedby] [uniqueidentifier]
,[zav_identifiedby_entitytype] [varchar](256)
,[zav_property] [uniqueidentifier]
,[zav_property_entitytype] [varchar](256)
,[zav_testedby] [uniqueidentifier]
,[zav_testedby_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[crba8_comments] [varchar](3600)
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
,[zav_chintaroid] [varchar](400)
,[zav_dateidentied] [datetime2](7)
,[zav_hazardnamename] [varchar](400)
,[zav_hazardsregisterid] [uniqueidentifier]
,[zav_identifiedbyname] [varchar](1026)
,[zav_identifiedbyyominame] [varchar](1026)
,[zav_name] [varchar](800)
,[zav_propertyname] [varchar](400)
,[zav_removaldate] [datetime2](7)
,[zav_testdate] [datetime2](7)
,[zav_testedbyname] [varchar](1026)
,[zav_testedbyyominame] [varchar](1026)
,[zav_testresult] [varchar](800)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record