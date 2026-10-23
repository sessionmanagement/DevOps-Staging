CREATE VIEW [Zavanti].[vw_businessunit]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[address1_addresstypecode]
,[address1_shippingmethodcode]
,[address2_addresstypecode]
,[address2_shippingmethodcode]
,[isdisabled]
,[workflowsuspended]
,[calendarid]
,[calendarid_entitytype]
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
,[parentbusinessunitid]
,[parentbusinessunitid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[address1_addressid]
,[address1_city]
,[address1_country]
,[address1_county]
,[address1_fax]
,[address1_latitude]
,[address1_line1]
,[address1_line2]
,[address1_line3]
,[address1_longitude]
,[address1_name]
,[address1_postalcode]
,[address1_postofficebox]
,[address1_stateorprovince]
,[address1_telephone1]
,[address1_telephone2]
,[address1_telephone3]
,[address1_upszone]
,[address1_utcoffset]
,[address2_addressid]
,[address2_city]
,[address2_country]
,[address2_county]
,[address2_fax]
,[address2_latitude]
,[address2_line1]
,[address2_line2]
,[address2_line3]
,[address2_longitude]
,[address2_name]
,[address2_postalcode]
,[address2_postofficebox]
,[address2_stateorprovince]
,[address2_telephone1]
,[address2_telephone2]
,[address2_telephone3]
,[address2_upszone]
,[address2_utcoffset]
,[businessunitid]
,[costcenter]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[creditlimit]
,[description]
,[disabledreason]
,[divisionname]
,[emailaddress]
,[exchangerate]
,[fileasname]
,[ftpsiteurl]
,[importsequencenumber]
,[inheritancemask]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[name]
,[organizationidname]
,[overriddencreatedon]
,[parentbusinessunitidname]
,[picture]
,[stockexchange]
,[tickersymbol]
,[transactioncurrencyidname]
,[usergroupid]
,[utcoffset]
,[versionnumber]
,[websiteurl]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[address1_addresstypecode]
,[address1_shippingmethodcode]
,[address2_addresstypecode]
,[address2_shippingmethodcode]
,[isdisabled]
,[workflowsuspended]
,[calendarid]
,[calendarid_entitytype]
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
,[parentbusinessunitid]
,[parentbusinessunitid_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[address1_addressid]
,[address1_city]
,[address1_country]
,[address1_county]
,[address1_fax]
,[address1_latitude]
,[address1_line1]
,[address1_line2]
,[address1_line3]
,[address1_longitude]
,[address1_name]
,[address1_postalcode]
,[address1_postofficebox]
,[address1_stateorprovince]
,[address1_telephone1]
,[address1_telephone2]
,[address1_telephone3]
,[address1_upszone]
,[address1_utcoffset]
,[address2_addressid]
,[address2_city]
,[address2_country]
,[address2_county]
,[address2_fax]
,[address2_latitude]
,[address2_line1]
,[address2_line2]
,[address2_line3]
,[address2_longitude]
,[address2_name]
,[address2_postalcode]
,[address2_postofficebox]
,[address2_stateorprovince]
,[address2_telephone1]
,[address2_telephone2]
,[address2_telephone3]
,[address2_upszone]
,[address2_utcoffset]
,[businessunitid]
,[costcenter]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[creditlimit]
,[description]
,[disabledreason]
,[divisionname]
,[emailaddress]
,[exchangerate]
,[fileasname]
,[ftpsiteurl]
,[importsequencenumber]
,[inheritancemask]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[name]
,[organizationidname]
,[overriddencreatedon]
,[parentbusinessunitidname]
,[picture]
,[stockexchange]
,[tickersymbol]
,[transactioncurrencyidname]
,[usergroupid]
,[utcoffset]
,[versionnumber]
,[websiteurl]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/businessunit/*.csv',FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
) 
WITH
(
[Id] [uniqueidentifier]
,[SinkCreatedOn] [datetime2](7)
,[SinkModifiedOn] [datetime2](7)
,[address1_addresstypecode] [bigint]
,[address1_shippingmethodcode] [bigint]
,[address2_addresstypecode] [bigint]
,[address2_shippingmethodcode] [bigint]
,[isdisabled] [varchar](6)
,[workflowsuspended] [varchar](6)
,[calendarid] [uniqueidentifier]
,[calendarid_entitytype] [varchar](256)
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
,[parentbusinessunitid] [uniqueidentifier]
,[parentbusinessunitid_entitytype] [varchar](256)
,[transactioncurrencyid] [uniqueidentifier]
,[transactioncurrencyid_entitytype] [varchar](256)
,[address1_addressid] [uniqueidentifier]
,[address1_city] [varchar](320)
,[address1_country] [varchar](320)
,[address1_county] [varchar](200)
,[address1_fax] [varchar](200)
,[address1_latitude] [float]
,[address1_line1] [varchar](1000)
,[address1_line2] [varchar](1000)
,[address1_line3] [varchar](1000)
,[address1_longitude] [float]
,[address1_name] [varchar](800)
,[address1_postalcode] [varchar](80)
,[address1_postofficebox] [varchar](80)
,[address1_stateorprovince] [varchar](200)
,[address1_telephone1] [varchar](200)
,[address1_telephone2] [varchar](200)
,[address1_telephone3] [varchar](200)
,[address1_upszone] [varchar](16)
,[address1_utcoffset] [bigint]
,[address2_addressid] [uniqueidentifier]
,[address2_city] [varchar](320)
,[address2_country] [varchar](320)
,[address2_county] [varchar](200)
,[address2_fax] [varchar](200)
,[address2_latitude] [float]
,[address2_line1] [varchar](1000)
,[address2_line2] [varchar](1000)
,[address2_line3] [varchar](1000)
,[address2_longitude] [float]
,[address2_name] [varchar](800)
,[address2_postalcode] [varchar](80)
,[address2_postofficebox] [varchar](80)
,[address2_stateorprovince] [varchar](200)
,[address2_telephone1] [varchar](200)
,[address2_telephone2] [varchar](200)
,[address2_telephone3] [varchar](200)
,[address2_upszone] [varchar](16)
,[address2_utcoffset] [bigint]
,[businessunitid] [uniqueidentifier]
,[costcenter] [varchar](400)
,[createdbyname] [varchar](640)
,[createdbyyominame] [varchar](640)
,[createdon] [datetimeoffset](7)
,[createdonbehalfbyname] [varchar](640)
,[createdonbehalfbyyominame] [varchar](640)
,[creditlimit] [float]
,[description] [varchar](max)
,[disabledreason] [varchar](2000)
,[divisionname] [varchar](400)
,[emailaddress] [varchar](400)
,[exchangerate] [decimal](38,12)
,[fileasname] [varchar](400)
,[ftpsiteurl] [varchar](800)
,[importsequencenumber] [bigint]
,[inheritancemask] [bigint]
,[modifiedbyname] [varchar](640)
,[modifiedbyyominame] [varchar](640)
,[modifiedon] [datetime2](7)
,[modifiedonbehalfbyname] [varchar](640)
,[modifiedonbehalfbyyominame] [varchar](640)
,[name] [varchar](640)
,[organizationidname] [varchar](640)
,[overriddencreatedon] [datetime2](7)
,[parentbusinessunitidname] [varchar](640)
,[picture] [varchar](max)
,[stockexchange] [varchar](80)
,[tickersymbol] [varchar](40)
,[transactioncurrencyidname] [varchar](400)
,[usergroupid] [uniqueidentifier]
,[utcoffset] [bigint]
,[versionnumber] [bigint]
,[websiteurl] [varchar](800)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record