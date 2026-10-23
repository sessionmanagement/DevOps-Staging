
--View			[ETL].[fact_finance_vendor_ledger]
--Author		Shashi Sharma
--Created		2023/06/23
--Purpose		Move data from ODS to EDW from the [BusinessCentral].[vendorLedgerEntries] and 

				
--Notes: Call By	EDW Pipeline '30_Load_From_ODS'
--Parameter(s)  None 
--=========================================================================================================
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		 2023/06/23    Shashi Sharma	Initial version
--1.1		 2024/05/10	   Greg Nuthall    Bug fix 7587 EDW Fact Finance Vendor Ledger incorrect Service KEY		

--**********************************************************************************************************/

Create   VIEW [ETL].[fact_finance_vendor_ledger]
AS

with cte_dimension_values as 
		(Select max(dimensionValueID) as dimensionValueID
		, Company_Name
		, [name] as DimensionValueName
		, dimensionCode 
		from [BusinessCentral].[dimensionValues]
		where ODSIsCurrent = 1 and blocked = 0
		group by Company_Name, [name], dimensionCode)


SELECT VL.Company_Name AS PartitionKey
	,VL.entryNo AS RowKey
	,dv1.dimensionValueID as [BUDGET HOLDER]
	,dv2.dimensionValueID as [CUSTOMER]
	,dv3.dimensionValueID as  [CONTRACT]
	,dv4.dimensionValueID as  [DEPARTMENT]
	,dv5.dimensionValueID as  [DISTRICT]
	,dv6.dimensionValueID as  [FUNDER]
	,dv7.dimensionValueID as  [FUNDING AGENCY]
	,dv8.dimensionValueID as  [LOCATE]
	,dv9.dimensionValueID as  [REGION]
	,dv10.dimensionValueID as  [SERVICE NAME]
	,dv11.dimensionValueID as  [SERVICE TYPE]
	,dv12.dimensionValueID as  [VENDOR]
	,VL.Amount
	,VL.amountLCY AS Amount__LCY_
	,VL.balAccountNo AS Bal__Account_No_
	,VL.balAccountType AS Bal__Account_Type
	,VL.buyFromVendorNo AS Buy_from_Vendor_No_
	,VL.closedByAmount AS Closed_by_Amount
	,VL.closedByAmountLCY AS Closed_by_Amount__LCY_
	,VL.closedByCurrencyAmount AS Closed_by_Currency_Amount
	,VL.closedByEntryNo AS Closed_by_Entry_No_
	,VL.creditAmount AS Credit_Amount
	,VL.creditAmountLCY AS Credit_Amount__LCY_
	,VL.description AS [Description]
	,VL.dimensionSetID AS Dimension_Set_ID
	,VL.documentDate AS Document_Date
	,VL.documentNo AS Document_No_
	,VL.documentType AS Document_Type
	,VL.dueDate AS Due_Date
	,VL.externalDocumentNo AS External_Document_No_
	,VL.globalDimension1Code AS Global_Dimension_1_Code
	,VL.noSeries AS No__Series
	--,VL.[open] AS [Open]
	,CAST([Open] AS int) AS [Open]
	,VL.originalAmount AS Original_Amount
	,VL.originalAmtLCY AS Original_Amt___LCY_
	,VL.paymentMethodCode AS Payment_Method_Code
	,VL.postingDate AS Posting_Date
	,VL.purchaseLCY AS Purchase__LCY_
	,VL.remAmt AS Rem__Amt
	,VL.remAmtForWHT AS Rem__Amt_for_WHT
	,VL.sourceCode AS Source_Code
	,VL.userID AS [User_ID]
	,VL.vendorName AS Vendor_Name
	,VL.vendorNo AS Vendor_No_
	,REPLACE(VL.Company_Name, '_', ' ') AS __CompanyName
	,VL.ODSIsCurrent
	,VL.ODSEffectiveFrom
	,VL.ODSEffectiveTo
	,VL.ODSDMLOperation
FROM [BusinessCentral].[vendorLedgerEntries] VL

	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'BUDGET HOLDER' and ODSIsCurrent = 1) d1 on VL.dimensionSetID = d1.dimensionSetID and VL.Company_Name = d1.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'CUSTOMER' and ODSIsCurrent = 1) d2 on VL.dimensionSetID = d2.dimensionSetID and VL.Company_Name = d2.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'CONTRACT' and ODSIsCurrent = 1) d3 on VL.dimensionSetID = d3.dimensionSetID and VL.Company_Name = d3.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'DEPARTMENT' and ODSIsCurrent = 1) d4 on VL.dimensionSetID = d4.dimensionSetID and VL.Company_Name = d4.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'DISTRICT' and ODSIsCurrent = 1) d5 on VL.dimensionSetID = d5.dimensionSetID and VL.Company_Name = d5.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'FUNDER' and ODSIsCurrent = 1) d6 on VL.dimensionSetID = d6.dimensionSetID and VL.Company_Name = d6.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'FUNDING AGENCY' and ODSIsCurrent = 1) d7 on VL.dimensionSetID = d7.dimensionSetID and VL.Company_Name = d7.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'LOCATE' and ODSIsCurrent = 1) d8 on VL.dimensionSetID = d8.dimensionSetID and VL.Company_Name = d8.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'REGION' and ODSIsCurrent = 1) d9 on VL.dimensionSetID = d9.dimensionSetID and VL.Company_Name = d9.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'SERVICE NAME' and ODSIsCurrent = 1) d10 on VL.dimensionSetID = d10.dimensionSetID and VL.Company_Name = d10.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'SERVICE TYPE ' and ODSIsCurrent = 1) d11 on VL.dimensionSetID = d11.dimensionSetID and VL.Company_Name = d11.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'VENDOR' and ODSIsCurrent = 1) d12 on VL.dimensionSetID = d12.dimensionSetID and VL.Company_Name = d12.Company_Name 

	left join cte_dimension_values dv1 on d1.Company_Name = dv1.Company_Name and d1.dimensionCode = dv1.dimensionCode and d1.dimensionValueName = dv1.DimensionValueName
	left join cte_dimension_values dv2 on d2.Company_Name = dv2.Company_Name and d2.dimensionCode = dv2.dimensionCode and d2.dimensionValueName = dv2.DimensionValueName
	left join cte_dimension_values dv3 on d3.Company_Name = dv3.Company_Name and d3.dimensionCode = dv3.dimensionCode and d3.dimensionValueName = dv3.DimensionValueName
	left join cte_dimension_values dv4 on d4.Company_Name = dv4.Company_Name and d4.dimensionCode = dv4.dimensionCode and d4.dimensionValueName = dv4.DimensionValueName
	left join cte_dimension_values dv5 on d5.Company_Name = dv5.Company_Name and d5.dimensionCode = dv5.dimensionCode and d5.dimensionValueName = dv5.DimensionValueName
	left join cte_dimension_values dv6 on d6.Company_Name = dv6.Company_Name and d6.dimensionCode = dv6.dimensionCode and d6.dimensionValueName = dv6.DimensionValueName
	left join cte_dimension_values dv7 on d7.Company_Name = dv7.Company_Name and d7.dimensionCode = dv7.dimensionCode and d7.dimensionValueName = dv7.DimensionValueName
	left join cte_dimension_values dv8 on d8.Company_Name = dv8.Company_Name and d8.dimensionCode = dv8.dimensionCode and d8.dimensionValueName = dv8.DimensionValueName
	left join cte_dimension_values dv9 on d9.Company_Name = dv9.Company_Name and d9.dimensionCode = dv9.dimensionCode and d9.dimensionValueName = dv9.DimensionValueName
	left join cte_dimension_values dv10 on d10.Company_Name = dv10.Company_Name and d10.dimensionCode = dv10.dimensionCode and d10.dimensionValueName = dv10.DimensionValueName
	left join cte_dimension_values dv11 on d11.Company_Name = dv11.Company_Name and d11.dimensionCode = dv11.dimensionCode and d11.dimensionValueName = dv11.DimensionValueName
	left join cte_dimension_values dv12 on d12.Company_Name = dv12.Company_Name and d12.dimensionCode = dv12.dimensionCode and d12.dimensionValueName = dv12.DimensionValueName


	WHERE VL.ODSIsCurrent = 1