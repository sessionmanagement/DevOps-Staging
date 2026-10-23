CREATE PROC [staging].[insert_staging_fact_webexpenses]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_webexpenses]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-12-16    Malhar Badheka	Initial version
2.0		 2025-12-16	   Malhar Badheka	dim_keys added
2.1		 2026-01-19	   Malhar Badheka	de2.DWHIsCurrent =1 added 
2.2		 2026-01-20	   Malhar Badheka	Added CTE for employee deduplication with priority logic 
2.3		 2026-06-02	   Malhar Badheka	improve logic to eliminate -1 dim_keys and reference table for not matched employee  
2.4		 2026-06-22	   Malhar Badheka	added outerapply for matching name record, this should not add duplicate record when matching against name        

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_webexpenses] ;


WITH employee_email as (

	SELECT [employee_primary_email_address],
		   [dim_employee_key],
           [employee_first_name],
		   [employee_last_name],
           [employee_id],
        ROW_NUMBER() OVER (   PARTITION BY de.employee_primary_email_address
            ORDER BY 
                CASE WHEN de.DWHSourceSystem = 'IntelliHR.people' THEN 1 ELSE 2 END,  -- IntelliHR first
                CASE 
                    WHEN de.employee_employment_status = 'Current Staff' THEN 1
                    WHEN de.employee_employment_status = 'Past Staff' THEN 2
                    ELSE 3
                END,
                de.dim_employee_key DESC  -- Most recent record if all else equal
        ) AS rn
    FROM edw.dim_employee de
	    WHERE de.DWHIsCurrent = 1         AND de.DWHDMLOperation <> 'D'
			AND de.employee_primary_email_address IS NOT NULL  -- Exclude NULL emails
			
)
-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_webexpenses] (
     [expense_key] 
    ,[dim_webexpense_key]
    ,[claim_number] 
    ,[dim_claimant_employee_key]
    ,[user_id] 
    ,[expense_date] 
    ,[expense_date_key] 
    ,[posted_on] 
    ,[posted_on_key] 
    ,[upload_date] 
    ,[upload_date_key] 
    ,[amount] 
    ,[base_amount] 
    ,[exchange_rate] 
    ,[billing_amount] 
    ,[cc_exchange_rate] 
    ,[dim_approver_employee_key] 
	)
SELECT
	 fweb.[expense_key] 
	,isnull(dweb.[dim_webexpense_key], CASE WHEN fweb.expense_key IS NOT NULL THEN -1 ELSE 0 END) AS dim_webexpense_key
	,fweb.[claim_number] 
	,COALESCE(de1.[dim_employee_key],ref_lup.[dim_employee_key],de3_name.[dim_employee_key], CASE WHEN fweb.claimant_login IS NOT NULL THEN -1 ELSE 0 END) AS dim_claimant_employee_key
	,fweb.[user_id] 
	,[expense_date] 
	,[expense_date_key] 
	,[posted_on] 
	,[posted_on_key] 
	,[upload_date] 
	,[upload_date_key] 
	,[amount] 
	,[base_amount] 
	,[exchange_rate] 
	,[billing_amount] 
	,[cc_exchange_rate] 
	,isnull(de2.[dim_employee_key], CASE WHEN fweb.Approver_login IS NOT NULL THEN -1 ELSE 0 END) AS dim_approver_employee_key
from [Landing].[edw_fact_webexpenses] fweb
left outer join edw.dim_webexpense dweb on dweb.expense_key = fweb.expense_key and dweb.[DWHIsCurrent] =1
left outer join employee_email de1 on lower(de1.employee_primary_email_address) = lower(fweb.claimant_login) and de1.rn =1
left outer join employee_email de2 on lower(de2.employee_primary_email_address) = lower(fweb.[Approver_login]) and de2.rn=1
left outer join ( SELECT ee.[dim_employee_key],rlook.[Input_Value] FROM [reference].[EDW_Lookup] rlook LEFT JOIN employee_email ee on ee.employee_id = TRY_CAST(rlook.Output_Value as INT) and ee.rn =1) AS ref_lup
	 on dweb.claimant_name = ref_lup.Input_Value
outer apply (
    select top 1 ee.dim_employee_key
    from employee_email ee
    where ee.rn = 1
      and lower(ltrim(rtrim(concat(ee.employee_first_name, ' ', ee.employee_last_name))))
          = lower(ltrim(rtrim(dweb.claimant_name)))
    order by ee.dim_employee_key desc
) de3_name 