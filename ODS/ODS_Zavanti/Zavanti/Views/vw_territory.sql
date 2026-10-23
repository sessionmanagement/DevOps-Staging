CREATE VIEW [Zavanti].[vw_territory]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[managerid]
,[managerid_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[organizationid]
,[organizationid_entitytype]
,[parentterritoryid]
,[parentterritoryid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_postalregion]
,[zav_postalregion_entitytype]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[description]
,[entityimage]
,[entityimage_timestamp]
,[entityimage_url]
,[entityimageid]
,[exchangerate]
,[importsequencenumber]
,[manageridname]
,[manageridyominame]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[name]
,[organizationidname]
,[overriddencreatedon]
,[parentterritoryidname]
,[territoryid]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_island]
,[zav_postalregionname]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[managerid]
,[managerid_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[organizationid]
,[organizationid_entitytype]
,[parentterritoryid]
,[parentterritoryid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_postalregion]
,[zav_postalregion_entitytype]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[description]
,[entityimage]
,[entityimage_timestamp]
,[entityimage_url]
,[entityimageid]
,[exchangerate]
,[importsequencenumber]
,[manageridname]
,[manageridyominame]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[name]
,[organizationidname]
,[overriddencreatedon]
,[parentterritoryidname]
,[territoryid]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_island]
,[zav_postalregionname]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/territory/*.csv',FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
) 
WITH
(
[Id] [uniqueidentifier]
,[SinkCreatedOn] [datetime2](7)
,[SinkModifiedOn] [datetime2](7)
,[createdby] [uniqueidentifier]
,[createdby_entitytype] [varchar](256)
,[createdonbehalfby] [uniqueidentifier]
,[createdonbehalfby_entitytype] [varchar](256)
,[managerid] [uniqueidentifier]
,[managerid_entitytype] [varchar](256)
,[modifiedby] [uniqueidentifier]
,[modifiedby_entitytype] [varchar](256)
,[modifiedonbehalfby] [uniqueidentifier]
,[modifiedonbehalfby_entitytype] [varchar](256)
,[organizationid] [uniqueidentifier]
,[organizationid_entitytype] [varchar](256)
,[parentterritoryid] [uniqueidentifier]
,[parentterritoryid_entitytype] [varchar](256)
,[transactioncurrencyid] [uniqueidentifier]
,[transactioncurrencyid_entitytype] [varchar](256)
,[zav_postalregion] [uniqueidentifier]
,[zav_postalregion_entitytype] [varchar](256)
,[createdbyname] [varchar](640)
,[createdbyyominame] [varchar](640)
,[createdon] [datetimeoffset](7)
,[createdonbehalfbyname] [varchar](640)
,[createdonbehalfbyyominame] [varchar](640)
,[description] [varchar](max)
,[entityimage] [varchar](8000)
,[entityimage_timestamp] [bigint]
,[entityimage_url] [varchar](800)
,[entityimageid] [uniqueidentifier]
,[exchangerate] [decimal](38,12)
,[importsequencenumber] [bigint]
,[manageridname] [varchar](640)
,[manageridyominame] [varchar](640)
,[modifiedbyname] [varchar](640)
,[modifiedbyyominame] [varchar](640)
,[modifiedon] [datetime2](7)
,[modifiedonbehalfbyname] [varchar](640)
,[modifiedonbehalfbyyominame] [varchar](640)
,[name] [varchar](800)
,[organizationidname] [varchar](640)
,[overriddencreatedon] [datetime2](7)
,[parentterritoryidname] [varchar](800)
,[territoryid] [uniqueidentifier]
,[timezoneruleversionnumber] [bigint]
,[transactioncurrencyidname] [varchar](400)
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[zav_island] [varchar](400)
,[zav_postalregionname] [varchar](400)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record