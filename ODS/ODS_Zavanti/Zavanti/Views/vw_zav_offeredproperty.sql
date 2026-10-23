CREATE VIEW [Zavanti].[vw_zav_offeredproperty]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_abletoliveindependently]
,[zav_abletomanagetenancyresponsibilities]
,[zav_firwithneighbourhood]
,[zav_housingneedishigh]
,[zav_ifviewingoutcomeisnoenterreason]
,[zav_involvementofsupportpersonorwhanau]
,[zav_offeroutcome]
,[zav_viewingoutcomes]
,[zav_withdrawalreason]
,[zav_offerrefusalreasons]
,[zav_viewingoutcomeisnoenterreason]
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
,[zav_applicationid]
,[zav_applicationid_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_propertyacceptedinapplication]
,[zav_propertyacceptedinapplication_entitytype]
,[zav_voidchecklist]
,[zav_voidchecklist_entitytype]
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
,[zav_applicationidname]
,[zav_applicationidyominame]
,[zav_comments]
,[zav_dateoffercommunicated]
,[zav_dateviewingarranged]
,[zav_name]
,[zav_offeraccepteddate]
,[zav_offeredpropertyid]
,[zav_propertyacceptedinapplicationname]
,[zav_propertyacceptedinapplicationyominame]
,[zav_propertyname]
,[zav_reasonforrefusal]
,[zav_voidchecklistname]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_abletoliveindependently]
,[zav_abletomanagetenancyresponsibilities]
,[zav_firwithneighbourhood]
,[zav_housingneedishigh]
,[zav_ifviewingoutcomeisnoenterreason]
,[zav_involvementofsupportpersonorwhanau]
,[zav_offeroutcome]
,[zav_viewingoutcomes]
,[zav_withdrawalreason]
,[zav_offerrefusalreasons]
,[zav_viewingoutcomeisnoenterreason]
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
,[zav_applicationid]
,[zav_applicationid_entitytype]
,[zav_property]
,[zav_property_entitytype]
,[zav_propertyacceptedinapplication]
,[zav_propertyacceptedinapplication_entitytype]
,[zav_voidchecklist]
,[zav_voidchecklist_entitytype]
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
,[zav_applicationidname]
,[zav_applicationidyominame]
,[zav_comments]
,[zav_dateoffercommunicated]
,[zav_dateviewingarranged]
,[zav_name]
,[zav_offeraccepteddate]
,[zav_offeredpropertyid]
,[zav_propertyacceptedinapplicationname]
,[zav_propertyacceptedinapplicationyominame]
,[zav_propertyname]
,[zav_reasonforrefusal]
,[zav_voidchecklistname]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_offeredproperty/*.csv',FORMAT = 'CSV',
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
,[zav_abletoliveindependently] [bigint]
,[zav_abletomanagetenancyresponsibilities] [bigint]
,[zav_firwithneighbourhood] [bigint]
,[zav_housingneedishigh] [bigint]
,[zav_ifviewingoutcomeisnoenterreason] [bigint]
,[zav_involvementofsupportpersonorwhanau] [bigint]
,[zav_offeroutcome] [bigint]
,[zav_viewingoutcomes] [bigint]
,[zav_withdrawalreason] [bigint]
,[zav_offerrefusalreasons] [varchar](8000)
,[zav_viewingoutcomeisnoenterreason] [varchar](8000)
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
,[zav_applicationid] [uniqueidentifier]
,[zav_applicationid_entitytype] [varchar](256)
,[zav_property] [uniqueidentifier]
,[zav_property_entitytype] [varchar](256)
,[zav_propertyacceptedinapplication] [uniqueidentifier]
,[zav_propertyacceptedinapplication_entitytype] [varchar](256)
,[zav_voidchecklist] [uniqueidentifier]
,[zav_voidchecklist_entitytype] [varchar](256)
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
,[zav_applicationidname] [varchar](640)
,[zav_applicationidyominame] [varchar](1800)
,[zav_comments] [varchar](max)
,[zav_dateoffercommunicated] [datetime2](7)
,[zav_dateviewingarranged] [datetime2](7)
,[zav_name] [varchar](400)
,[zav_offeraccepteddate] [datetime2](7)
,[zav_offeredpropertyid] [uniqueidentifier]
,[zav_propertyacceptedinapplicationname] [varchar](640)
,[zav_propertyacceptedinapplicationyominame] [varchar](1800)
,[zav_propertyname] [varchar](400)
,[zav_reasonforrefusal] [varchar](400)
,[zav_voidchecklistname] [varchar](400)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record