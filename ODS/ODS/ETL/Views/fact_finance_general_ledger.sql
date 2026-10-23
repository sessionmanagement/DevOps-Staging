CREATE   view [ETL].[fact_finance_general_ledger]

as

--View			[ETL].[fact_finance_general_ledger]
--Author		Shashi Sharma
--Created		2023/06/23
--Purpose		Move data from ODS to EDW from the BusinessCentral.glEntries, BusinessCentral.dimensionSetEntries 
--				BusinessCentral.dimensionValues
				
--Notes: Call By	EDW Pipeline '30_Load_From_ODS'
--Parameter(s)  None 
--=========================================================================================================
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	---------------
--1.0		 2023/06/23    Shashi Sharma	Initial version
--1.1		 2024/05/10	   Greg Nuthall     Bug fix 7361 EDW Fact Finance General Ledger incorrect Service KEY		
--1.2        2025-08-19    Greg Nuthall	    Replace dimension value name with code on all joins to avoid renamed dimensions
--											Following advice from Finance (Gavin Rigby) all account codes greater than 3000 are 
--											balance sheet items and hence not necessarily associated with a service. They will
--											get a service_id of either 2000001 or 2000002
--1.3        2025-11-17    Greg Nuthall		Add back in blocked services for records where the dimension values changes
--1.4        2026-01-17    Greg Nuthall		Changed to use the blocked dimension where it is valid
--**********************************************************************************************************/

with cte_dimension_values as 
		(Select max(dimensionValueID) as dimensionValueID
		, company_name
		, Code as DimensionValueCode
		, dimensionCode 
		from [BusinessCentral].[dimensionValues]
		where ODSIsCurrent = 1 and blocked = 0
		group by company_name, Code, dimensionCode)

	,cte_blocked_dimension_values as 
		(Select max(dimensionValueID) as dimensionValueID
		, company_name
		, Code as DimensionValueCode
		, dimensionCode 
		from [BusinessCentral].[dimensionValues]
		where ODSIsCurrent = 1 and blocked = 1
		group by company_name, Code, dimensionCode)

SELECT GL.company_name AS PartitionKey
	,GL.entryNo AS RowKey
	,dv1.dimensionValueID as [BUDGET HOLDER]
	,dv2.dimensionValueID as [CUSTOMER]
	,dv3.dimensionValueID as [CONTRACT]
	,dv4.dimensionValueID as [DEPARTMENT]
	,dv5.dimensionValueID as [DISTRICT]
	,dv6.dimensionValueID as [FUNDER]
	,dv7.dimensionValueID as [FUNDING AGENCY]
	,dv8.dimensionValueID as [LOCATE]
	,dv9.dimensionValueID as [REGION]
	--,case 
	--	when isnull(isnull(dv10.dimensionValueID,d10.dimensionValueID),-999) >= 1 then 
	--		isnull(dv10.dimensionValueID,d10.dimensionValueID)   --We found the service_id 
	--	when isnull(isnull(dv10.dimensionValueID,d10.dimensionValueID),-999) = -999 and gLAccountNo >= 3000 then
	--		2000001 --we didn't find the service id but it has an account code >= 3000 --> Fixed code for balance sheet services 
	--	when isnull(dv10.dimensionValueID,d10.dimensionValueID) = 0 then
	--		2000002 --There is no dimensionSetID to look up so no service_id fixed code for service_id 
	--	else -2  --there should be a service_id so it is invalid source data 
	--end as [SERVICE NAME]
	
	,case 
		when isnull(isnull(isnull(dv10.dimensionValueID,dv30.dimensionValueID),d10.dimensionValueID),-999) >= 1 then 
			isnull(isnull(dv10.dimensionValueID,dv30.dimensionValueID),d10.dimensionValueID)   --We found the service_id 
		when isnull(isnull(isnull(isnull(dv10.dimensionValueID,dv30.dimensionValueID),d10.dimensionValueID),-999),-999) = -999 and gLAccountNo >= 3000 then
			2000001 --we didn't find the service id but it has an account code >= 3000 --> Fixed code for balance sheet services 
		when isnull(isnull(dv10.dimensionValueID,dv30.dimensionValueID),d10.dimensionValueID) = 0 then
			2000002 --There is no dimensionSetID to look up so no service_id fixed code for service_id 
		else -2  --there should be a service_id so it is invalid source data 
	end as [SERVICE NAME]
	
	--,isnull(dv10.dimensionValueID,d10.dimensionValueID) as  [SERVICE NAME]
	,dv11.dimensionValueID as  [SERVICE TYPE]
	,dv12.dimensionValueID as  [VENDOR]
	
	,GL.[userID] AS User_ID
	,GL.transactionNo AS Transaction_No_
	,GL.description AS Description
	,GL.documentNo AS Document_No_
	,GL.gLAccountNo AS G_L_Account_No_
	,GL.sourceNo AS Source_No_
	,GL.noSeries AS No__Series
	,GL.sourceCode AS Source_Code
	,GL.sourceType AS Source_Type
	,GL.documentType AS Document_Type
	,GL.genPostingType AS Gen__Posting_Type
	,GL.gLAccountName AS G_L_Account_Name
	,GL.genBusPostingGroup AS Gen__Bus__Posting_Group
	,GL.genProdPostingGroup AS Gen__Prod__Posting_Group
	,GL.globalDimension1Code AS Global_Dimension_1_Code
	--,GL.systemCreatedEntry AS System_Created_Entry
	,CAST(GL.systemCreatedEntry AS int) AS System_Created_Entry
	,REPLACE(GL.company_name, '_', ' ') AS [__CompanyName]
	,GL.postingDate AS Posting_Date
	,GL.documentDate AS Document_Date
	,GL.lastModifiedDateTime AS Last_Modified_DateTime
	,GL.Amount
	,GL.creditAmount AS Credit_Amount
	,GL.debitAmount AS Debit_Amount
	,GL.ODSIsCurrent
	,GL.ODSEffectiveFrom
	,GL.ODSEffectiveTo
	,GL.ODSDMLOperation

	FROM [BusinessCentral].[glEntries] GL
	left join (Select dimensionSetID, company_name, dimensionCode, dimensionValueCode, dimensionValueID from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'BUDGET HOLDER' and ODSIsCurrent = 1) d1 on gl.dimensionSetID = d1.dimensionSetID and gl.company_name = d1.company_name 
	left join (Select dimensionSetID, company_name, dimensionCode, dimensionValueCode, dimensionValueID from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'CUSTOMER' and ODSIsCurrent = 1) d2 on gl.dimensionSetID = d2.dimensionSetID and gl.company_name = d2.company_name 
	left join (Select dimensionSetID, company_name, dimensionCode, dimensionValueCode, dimensionValueID from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'CONTRACT' and ODSIsCurrent = 1) d3 on gl.dimensionSetID = d3.dimensionSetID and gl.company_name = d3.company_name 
	left join (Select dimensionSetID, company_name, dimensionCode, dimensionValueCode, dimensionValueID from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'DEPARTMENT' and ODSIsCurrent = 1) d4 on gl.dimensionSetID = d4.dimensionSetID and gl.company_name = d4.company_name 
	left join (Select dimensionSetID, company_name, dimensionCode, dimensionValueCode, dimensionValueID from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'DISTRICT' and ODSIsCurrent = 1) d5 on gl.dimensionSetID = d5.dimensionSetID and gl.company_name = d5.company_name 
	left join (Select dimensionSetID, company_name, dimensionCode, dimensionValueCode, dimensionValueID from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'FUNDER' and ODSIsCurrent = 1) d6 on gl.dimensionSetID = d6.dimensionSetID and gl.company_name = d6.company_name 
	left join (Select dimensionSetID, company_name, dimensionCode, dimensionValueCode, dimensionValueID from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'FUNDING AGENCY' and ODSIsCurrent = 1) d7 on gl.dimensionSetID = d7.dimensionSetID and gl.company_name = d7.company_name 
	left join (Select dimensionSetID, company_name, dimensionCode, dimensionValueCode, dimensionValueID from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'LOCATE' and ODSIsCurrent = 1) d8 on gl.dimensionSetID = d8.dimensionSetID and gl.company_name = d8.company_name 
	left join (Select dimensionSetID, company_name, dimensionCode, dimensionValueCode, dimensionValueID from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'REGION' and ODSIsCurrent = 1) d9 on gl.dimensionSetID = d9.dimensionSetID and gl.company_name = d9.company_name 
	left join (Select dimensionSetID, company_name, dimensionCode, dimensionValueCode, dimensionValueName, dimensionValueID from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'SERVICE NAME' and ODSIsCurrent = 1) d10 on gl.dimensionSetID = d10.dimensionSetID and gl.company_name = d10.company_name 
	left join (Select dimensionSetID, company_name, dimensionCode, dimensionValueCode, dimensionValueID from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'SERVICE TYPE ' and ODSIsCurrent = 1) d11 on gl.dimensionSetID = d11.dimensionSetID and gl.company_name = d11.company_name 
	left join (Select dimensionSetID, company_name, dimensionCode, dimensionValueCode, dimensionValueID from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'VENDOR' and ODSIsCurrent = 1) d12 on gl.dimensionSetID = d12.dimensionSetID and gl.company_name = d12.company_name 

	left join cte_dimension_values dv1 on d1.company_name = dv1.company_name and d1.dimensionCode = dv1.dimensionCode and d1.dimensionValueCode = dv1.dimensionValueCode
	left join cte_dimension_values dv2 on d2.company_name = dv2.company_name and d2.dimensionCode = dv2.dimensionCode and d2.dimensionValueCode = dv2.dimensionValueCode
	left join cte_dimension_values dv3 on d3.company_name = dv3.company_name and d3.dimensionCode = dv3.dimensionCode and d3.dimensionValueCode = dv3.dimensionValueCode
	left join cte_dimension_values dv4 on d4.company_name = dv4.company_name and d4.dimensionCode = dv4.dimensionCode and d4.dimensionValueCode = dv4.dimensionValueCode
	left join cte_dimension_values dv5 on d5.company_name = dv5.company_name and d5.dimensionCode = dv5.dimensionCode and d5.dimensionValueCode = dv5.dimensionValueCode
	left join cte_dimension_values dv6 on d6.company_name = dv6.company_name and d6.dimensionCode = dv6.dimensionCode and d6.dimensionValueCode = dv6.dimensionValueCode
	left join cte_dimension_values dv7 on d7.company_name = dv7.company_name and d7.dimensionCode = dv7.dimensionCode and d7.dimensionValueCode = dv7.dimensionValueCode
	left join cte_dimension_values dv8 on d8.company_name = dv8.company_name and d8.dimensionCode = dv8.dimensionCode and d8.dimensionValueCode = dv8.dimensionValueCode
	left join cte_dimension_values dv9 on d9.company_name = dv9.company_name and d9.dimensionCode = dv9.dimensionCode and d9.dimensionValueCode = dv9.dimensionValueCode
	left join cte_dimension_values dv10 on d10.company_name = dv10.company_name and d10.dimensionCode = dv10.dimensionCode and d10.dimensionValueCode = dv10.dimensionValueCode
	left join cte_dimension_values dv11 on d11.company_name = dv11.company_name and d11.dimensionCode = dv11.dimensionCode and d11.dimensionValueCode = dv11.dimensionValueCode
	left join cte_dimension_values dv12 on d12.company_name = dv12.company_name and d12.dimensionCode = dv12.dimensionCode and d12.dimensionValueCode = dv12.dimensionValueCode

	left join cte_blocked_dimension_values dv30 on d10.company_name = dv30.company_name and d10.dimensionCode = dv30.dimensionCode and d10.dimensionValueCode = dv30.dimensionValueCode

	WHERE gl.ODSIsCurrent = 1