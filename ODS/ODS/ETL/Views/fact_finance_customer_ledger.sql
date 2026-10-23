/****** Object:  View [ETL].[fact_finance_customer_ledger]    Script Date: 16/04/2025 11:13:57 am ******/


		
CREATE     view [ETL].[fact_finance_customer_ledger]
as

--**********************************************************************************************************/
--View			[ETL].[fact_finance_customer_ledger]
--Author		Shashi Sharma
--Created		2023/06/23
--Purpose		Move data from ODS to EDW from the [BusinessCentral].[customerLedgerEntries] and 

--Notes: Call By	EDW Pipeline '30_Load_From_ODS'
--Parameter(s)  None 
--=========================================================================================================
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		 2023/06/23    Shashi Sharma	Initial version
--1.1		 2024/10/29	   Greg Nuthall     Bug fix EDW incorrect Service KEY's
--**********************************************************************************************************/


with cte_dimension_values as 
		(Select max(dimensionValueID) as dimensionValueID
		, Company_Name
		, [name] as DimensionValueName
		, dimensionCode 
		from [BusinessCentral].[dimensionValues]
		where ODSIsCurrent = 1 and blocked = 0
		group by Company_Name, [name], dimensionCode)


select a.Company_Name AS PartitionKey
	,a.entryNo AS RowKey
	,dv2.dimensionValueID as [CUSTOMER]
	,dv1.dimensionValueID as [BUDGET HOLDER]
	,dv3.dimensionValueID as  [CONTRACT]
	,dv4.dimensionValueID as  [DEPARTMENT]
	,dv5.dimensionValueID as  [DISTRICT]
	,dv6.dimensionValueID as  [FUNDER]
	,dv7.dimensionValueID as  [FUNDING AGENCY]
	,dv8.dimensionValueID as  [LOCATE]
	,dv9.dimensionValueID as  [REGION]
	,dv10.dimensionValueID as  [SERVICE NAME]
	,dv12.dimensionValueID as  [VENDOR]

	,a.userID AS [User_ID]
	,a.Amount
	,a.amountLCY AS Amount__LCY_
	,a.balAccountNo AS Bal__Account_No_
	,a.balAccountType AS Bal__Account_Type
	,a.closedByAmount AS Closed_by_Amount
	,a.closedByAmountLCY AS Closed_by_Amount__LCY_
	,a.closedByCurrencyAmount AS Closed_by_Currency_Amount
	,a.closedByCurrencyCode AS Closed_by_Currency_Code
	,a.creditAmount AS Credit_Amount
	,a.creditAmountLCY AS Credit_Amount__LCY_
	,a.customerNo AS Customer_No_
	,a.customerPostingGroup AS Customer_Posting_Group
	,a.debitAmount AS Debit_Amount
	,a.debitAmountLCY AS Debit_Amount__LCY_
	,a.[Description]
	,a.dimensionSetID AS Dimension_Set_ID
	,a.documentDate AS Document_Date
	,a.documentNo AS Document_No_
	,a.documentType  AS Document_Type
	,a.dueDate AS Due_Date
	,a.entryNo AS Entry_No_
	,a.noSeries AS No__Series
	--,a.[Open]
	,CAST([Open] AS int) AS [Open]
	,a.originalAmount AS Original_Amount
	,a.paymentMethodCode AS Payment_Method_Code
	--,a.Payment_Prediction    ---<<<<< missing?
	,a.paymentReference AS Payment_Reference
	,a.postingDate AS Posting_Date
	,a.profitLCY AS Profit__LCY_
	,a.reasonCode AS Reason_Code
	,a.remAmt AS Rem__Amt
	,a.remAmtForWHT AS Rem__Amt_for_WHT
	,a.remainingAmount AS Remaining_Amount
	--,a.Reversed
	,CAST([Reversed] AS int) AS [Reversed]
	,a.reversedEntryNo AS Reversed_Entry_No_
	,a.salesLCY AS Sales__LCY_
	,a.sellToCustomerNo AS Sell_to_Customer_No_
	,a.sourceCode AS Source_Code
	,a.transactionNo AS Transaction_No_
	,a.whtAmount AS WHT_Amount
	--,a.whtPayment AS WHT_Payment
	,CAST([whtPayment] AS int) AS [WHT_Payment]
	,REPLACE(a.Company_Name, '_', ' ') AS __CompanyName
	,a.ODSIsCurrent
	,a.ODSEffectiveFrom
	,a.ODSEffectiveTo
	,a.ODSDMLOperation
	
	from [BusinessCentral].[customerLedgerEntries] as a

	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'BUDGET HOLDER' and ODSIsCurrent = 1) d1 on a.dimensionSetID = d1.dimensionSetID and a.Company_Name = d1.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'CUSTOMER' and ODSIsCurrent = 1) d2 on a.dimensionSetID = d2.dimensionSetID and a.Company_Name = d2.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'CONTRACT' and ODSIsCurrent = 1) d3 on a.dimensionSetID = d3.dimensionSetID and a.Company_Name = d3.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'DEPARTMENT' and ODSIsCurrent = 1) d4 on a.dimensionSetID = d4.dimensionSetID and a.Company_Name = d4.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'DISTRICT' and ODSIsCurrent = 1) d5 on a.dimensionSetID = d5.dimensionSetID and a.Company_Name = d5.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'FUNDER' and ODSIsCurrent = 1) d6 on a.dimensionSetID = d6.dimensionSetID and a.Company_Name = d6.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'FUNDING AGENCY' and ODSIsCurrent = 1) d7 on a.dimensionSetID = d7.dimensionSetID and a.Company_Name = d7.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'LOCATE' and ODSIsCurrent = 1) d8 on a.dimensionSetID = d8.dimensionSetID and a.Company_Name = d8.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'REGION' and ODSIsCurrent = 1) d9 on a.dimensionSetID = d9.dimensionSetID and a.Company_Name = d9.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'SERVICE NAME' and ODSIsCurrent = 1) d10 on a.dimensionSetID = d10.dimensionSetID and a.Company_Name = d10.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'SERVICE TYPE ' and ODSIsCurrent = 1) d11 on a.dimensionSetID = d11.dimensionSetID and a.Company_Name = d11.Company_Name 
	left join (Select dimensionSetID, Company_Name, dimensionCode, dimensionValueName from BusinessCentral.dimensionSetEntries 
	where dimensionCode = 'VENDOR' and ODSIsCurrent = 1) d12 on a.dimensionSetID = d12.dimensionSetID and a.Company_Name = d12.Company_Name 

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

	where a.ODSIsCurrent = 1