CREATE VIEW [Zavanti].[vw_zav_webexpenses]
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
,[organizationid]
,[organizationid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_worktask]
,[zav_worktask_entitytype]
,[zav_invoicevalue]
,[zav_invoicevalue_base]
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
,[organizationidname]
,[overriddencreatedon]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_invoicedate]
,[zav_invoiceno]
,[zav_link]
,[zav_name]
,[zav_poworkorderno]
,[zav_webexpensesid]
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
,[organizationid]
,[organizationid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_worktask]
,[zav_worktask_entitytype]
,[zav_invoicevalue]
,[zav_invoicevalue_base]
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
,[organizationidname]
,[overriddencreatedon]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_invoicedate]
,[zav_invoiceno]
,[zav_link]
,[zav_name]
,[zav_poworkorderno]
,[zav_webexpensesid]
,[zav_worktaskname]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_webexpenses/*.csv',FORMAT = 'CSV',
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
,[organizationid] [uniqueidentifier]
,[organizationid_entitytype] [varchar](256)
,[transactioncurrencyid] [uniqueidentifier]
,[transactioncurrencyid_entitytype] [varchar](256)
,[zav_worktask] [uniqueidentifier]
,[zav_worktask_entitytype] [varchar](256)
,[zav_invoicevalue] [decimal](38,0)
,[zav_invoicevalue_base] [decimal](38,0)
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
,[organizationidname] [varchar](640)
,[overriddencreatedon] [datetime2](7)
,[timezoneruleversionnumber] [bigint]
,[transactioncurrencyidname] [varchar](400)
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[zav_invoicedate] [datetime2](7)
,[zav_invoiceno] [varchar](60)
,[zav_link] [varchar](3600)
,[zav_name] [varchar](1200)
,[zav_poworkorderno] [varchar](40)
,[zav_webexpensesid] [uniqueidentifier]
,[zav_worktaskname] [varchar](400)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record