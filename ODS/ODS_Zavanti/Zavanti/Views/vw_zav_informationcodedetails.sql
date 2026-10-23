CREATE VIEW [Zavanti].[vw_zav_informationcodedetails]
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
,[new_client]
,[new_client_entitytype]
,[owningbusinessunit]
,[owningbusinessunit_entitytype]
,[owningteam]
,[owningteam_entitytype]
,[owninguser]
,[owninguser_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_informationcode]
,[zav_informationcode_entitytype]
,[zav_locationname]
,[zav_locationname_entitytype]
,[zav_serviceagreement]
,[zav_serviceagreement_entitytype]
,[zav_worktask]
,[zav_worktask_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_icodeamount]
,[zav_icodeamount_base]
,[zav_totalcappedamount]
,[zav_totalcappedamount_base]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[exchangerate]
,[importsequencenumber]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[new_clientname]
,[new_clientyominame]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_comments]
,[zav_icode]
,[zav_informationcodedetailsid]
,[zav_informationcodename]
,[zav_locationcode]
,[zav_locationnamename]
,[zav_name]
,[zav_serviceagreementname]
,[zav_totalcappedamount_date]
,[zav_totalcappedamount_state]
,[zav_worktaskname]
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
,[new_client]
,[new_client_entitytype]
,[owningbusinessunit]
,[owningbusinessunit_entitytype]
,[owningteam]
,[owningteam_entitytype]
,[owninguser]
,[owninguser_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_informationcode]
,[zav_informationcode_entitytype]
,[zav_locationname]
,[zav_locationname_entitytype]
,[zav_serviceagreement]
,[zav_serviceagreement_entitytype]
,[zav_worktask]
,[zav_worktask_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_icodeamount]
,[zav_icodeamount_base]
,[zav_totalcappedamount]
,[zav_totalcappedamount_base]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[exchangerate]
,[importsequencenumber]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[new_clientname]
,[new_clientyominame]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_comments]
,[zav_icode]
,[zav_informationcodedetailsid]
,[zav_informationcodename]
,[zav_locationcode]
,[zav_locationnamename]
,[zav_name]
,[zav_serviceagreementname]
,[zav_totalcappedamount_date]
,[zav_totalcappedamount_state]
,[zav_worktaskname]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_informationcodedetails/*.csv',FORMAT = 'CSV',
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
,[new_client] [uniqueidentifier]
,[new_client_entitytype] [varchar](256)
,[owningbusinessunit] [uniqueidentifier]
,[owningbusinessunit_entitytype] [varchar](256)
,[owningteam] [uniqueidentifier]
,[owningteam_entitytype] [varchar](256)
,[owninguser] [uniqueidentifier]
,[owninguser_entitytype] [varchar](256)
,[transactioncurrencyid] [uniqueidentifier]
,[transactioncurrencyid_entitytype] [varchar](256)
,[zav_informationcode] [uniqueidentifier]
,[zav_informationcode_entitytype] [varchar](256)
,[zav_locationname] [uniqueidentifier]
,[zav_locationname_entitytype] [varchar](256)
,[zav_serviceagreement] [uniqueidentifier]
,[zav_serviceagreement_entitytype] [varchar](256)
,[zav_worktask] [uniqueidentifier]
,[zav_worktask_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[zav_icodeamount] [decimal](38,0)
,[zav_icodeamount_base] [decimal](38,0)
,[zav_totalcappedamount] [decimal](38,0)
,[zav_totalcappedamount_base] [decimal](38,0)
,[createdbyname] [varchar](1026)
,[createdbyyominame] [varchar](1026)
,[createdon] [datetimeoffset](7)
,[createdonbehalfbyname] [varchar](1026)
,[createdonbehalfbyyominame] [varchar](1026)
,[exchangerate] [decimal](38,10)
,[importsequencenumber] [bigint]
,[modifiedbyname] [varchar](1026)
,[modifiedbyyominame] [varchar](1026)
,[modifiedon] [datetime2](7)
,[modifiedonbehalfbyname] [varchar](1026)
,[modifiedonbehalfbyyominame] [varchar](1026)
,[new_clientname] [varchar](640)
,[new_clientyominame] [varchar](1800)
,[overriddencreatedon] [datetime2](7)
,[owneridname] [varchar](640)
,[owneridtype] [varchar](8000)
,[owneridyominame] [varchar](640)
,[owningbusinessunitname] [varchar](640)
,[timezoneruleversionnumber] [bigint]
,[transactioncurrencyidname] [varchar](400)
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[zav_comments] [varchar](max)
,[zav_icode] [varchar](420)
,[zav_informationcodedetailsid] [uniqueidentifier]
,[zav_informationcodename] [varchar](420)
,[zav_locationcode] [varchar](400)
,[zav_locationnamename] [varchar](400)
,[zav_name] [varchar](1200)
,[zav_serviceagreementname] [varchar](400)
,[zav_totalcappedamount_date] [datetime2](7)
,[zav_totalcappedamount_state] [bigint]
,[zav_worktaskname] [varchar](400)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record