CREATE VIEW [Zavanti].[vw_customeraddress]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[addresstypecode]
,[freighttermscode]
,[msft_datastate]
,[shippingmethodcode]
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
,[owninguser]
,[owninguser_entitytype]
,[parentid]
,[parentid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[addressnumber]
,[city]
,[composite]
,[country]
,[county]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[customeraddressid]
,[exchangerate]
,[fax]
,[importsequencenumber]
,[latitude]
,[line1]
,[line2]
,[line3]
,[longitude]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[name]
,[objecttypecode]
,[overriddencreatedon]
,[owneridtype]
,[parentidtypecode]
,[postalcode]
,[postofficebox]
,[primarycontactname]
,[stateorprovince]
,[telephone1]
,[telephone2]
,[telephone3]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[upszone]
,[utcconversiontimezonecode]
,[utcoffset]
,[versionnumber]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[addresstypecode]
,[freighttermscode]
,[msft_datastate]
,[shippingmethodcode]
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
,[owninguser]
,[owninguser_entitytype]
,[parentid]
,[parentid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[addressnumber]
,[city]
,[composite]
,[country]
,[county]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[customeraddressid]
,[exchangerate]
,[fax]
,[importsequencenumber]
,[latitude]
,[line1]
,[line2]
,[line3]
,[longitude]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[name]
,[objecttypecode]
,[overriddencreatedon]
,[owneridtype]
,[parentidtypecode]
,[postalcode]
,[postofficebox]
,[primarycontactname]
,[stateorprovince]
,[telephone1]
,[telephone2]
,[telephone3]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[upszone]
,[utcconversiontimezonecode]
,[utcoffset]
,[versionnumber]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/customeraddress/*.csv',FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
) 
WITH
(
[Id] [uniqueidentifier]
,[SinkCreatedOn] [datetime2](7)
,[SinkModifiedOn] [datetime2](7)
,[addresstypecode] [bigint]
,[freighttermscode] [bigint]
,[msft_datastate] [bigint]
,[shippingmethodcode] [bigint]
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
,[owninguser] [uniqueidentifier]
,[owninguser_entitytype] [varchar](256)
,[parentid] [uniqueidentifier]
,[parentid_entitytype] [varchar](256)
,[transactioncurrencyid] [uniqueidentifier]
,[transactioncurrencyid_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[addressnumber] [bigint]
,[city] [varchar](max)
,[composite] [varchar](max)
,[country] [varchar](max)
,[county] [varchar](max)
,[createdbyname] [varchar](640)
,[createdbyyominame] [varchar](640)
,[createdon] [datetimeoffset](7)
,[createdonbehalfbyname] [varchar](640)
,[createdonbehalfbyyominame] [varchar](640)
,[customeraddressid] [uniqueidentifier]
,[exchangerate] [decimal](38,12)
,[fax] [varchar](200)
,[importsequencenumber] [bigint]
,[latitude] [float]
,[line1] [varchar](max)
,[line2] [varchar](max)
,[line3] [varchar](max)
,[longitude] [float]
,[modifiedbyname] [varchar](640)
,[modifiedbyyominame] [varchar](640)
,[modifiedon] [datetime2](7)
,[modifiedonbehalfbyname] [varchar](640)
,[modifiedonbehalfbyyominame] [varchar](640)
,[name] [varchar](800)
,[objecttypecode] [varchar](8000)
,[overriddencreatedon] [datetime2](7)
,[owneridtype] [varchar](8000)
,[parentidtypecode] [varchar](8000)
,[postalcode] [varchar](max)
,[postofficebox] [varchar](max)
,[primarycontactname] [varchar](600)
,[stateorprovince] [varchar](max)
,[telephone1] [varchar](200)
,[telephone2] [varchar](200)
,[telephone3] [varchar](200)
,[timezoneruleversionnumber] [bigint]
,[transactioncurrencyidname] [varchar](400)
,[upszone] [varchar](16)
,[utcconversiontimezonecode] [bigint]
,[utcoffset] [bigint]
,[versionnumber] [bigint]
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record