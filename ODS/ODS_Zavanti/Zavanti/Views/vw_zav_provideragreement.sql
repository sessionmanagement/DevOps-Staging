CREATE VIEW [Zavanti].[vw_zav_provideragreement]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_agreementstatus]
,[zav_advancearrears]
,[zav_isstatuschanged]
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
,[zav_parentagreement]
,[zav_parentagreement_entitytype]
,[zav_program]
,[zav_program_entitytype]
,[zav_providername]
,[zav_providername_entitytype]
,[zav_subprogram]
,[zav_subprogram_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[crba8_noofpropertiescalc]
,[crba8_noofpropertiescalc_date]
,[crba8_noofpropertiescalc_state]
,[crba8_noofpropertiesuser]
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
,[zav_contractname]
,[zav_contractnumber]
,[zav_enddate]
,[zav_name]
,[zav_parentagreementname]
,[zav_programname]
,[zav_provideragreementid]
,[zav_provideragreementnumber]
,[zav_providernamename]
,[zav_providernameyominame]
,[zav_startdate]
,[zav_subprogramname]
,[zav_variationno]
,[zav_variationnumber]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[zav_agreementstatus]
,[zav_advancearrears]
,[zav_isstatuschanged]
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
,[zav_parentagreement]
,[zav_parentagreement_entitytype]
,[zav_program]
,[zav_program_entitytype]
,[zav_providername]
,[zav_providername_entitytype]
,[zav_subprogram]
,[zav_subprogram_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[crba8_noofpropertiescalc]
,[crba8_noofpropertiescalc_date]
,[crba8_noofpropertiescalc_state]
,[crba8_noofpropertiesuser]
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
,[zav_contractname]
,[zav_contractnumber]
,[zav_enddate]
,[zav_name]
,[zav_parentagreementname]
,[zav_programname]
,[zav_provideragreementid]
,[zav_provideragreementnumber]
,[zav_providernamename]
,[zav_providernameyominame]
,[zav_startdate]
,[zav_subprogramname]
,[zav_variationno]
,[zav_variationnumber]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_provideragreement/*.csv',FORMAT = 'CSV',
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
,[zav_agreementstatus] [bigint]
,[zav_advancearrears] [varchar](6)
,[zav_isstatuschanged] [varchar](6)
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
,[zav_parentagreement] [uniqueidentifier]
,[zav_parentagreement_entitytype] [varchar](256)
,[zav_program] [uniqueidentifier]
,[zav_program_entitytype] [varchar](256)
,[zav_providername] [uniqueidentifier]
,[zav_providername_entitytype] [varchar](256)
,[zav_subprogram] [uniqueidentifier]
,[zav_subprogram_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[crba8_noofpropertiescalc] [bigint]
,[crba8_noofpropertiescalc_date] [datetime2](7)
,[crba8_noofpropertiescalc_state] [bigint]
,[crba8_noofpropertiesuser] [bigint]
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
,[zav_contractname] [varchar](400)
,[zav_contractnumber] [varchar](400)
,[zav_enddate] [datetime2](7)
,[zav_name] [varchar](400)
,[zav_parentagreementname] [varchar](400)
,[zav_programname] [varchar](400)
,[zav_provideragreementid] [uniqueidentifier]
,[zav_provideragreementnumber] [varchar](400)
,[zav_providernamename] [varchar](640)
,[zav_providernameyominame] [varchar](640)
,[zav_startdate] [datetime2](7)
,[zav_subprogramname] [varchar](400)
,[zav_variationno] [varchar](400)
,[zav_variationnumber] [bigint]
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record