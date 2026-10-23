-- Created by Copilot in SSMS - review carefully before executing

CREATE VIEW [ETL].[fact_employee_hours_worked]
/**********************************************************************************************************
Revisions:
Version   Date          Author              Description
-------   ------------  ------------------  --------------------------
1.0       2024-02-11    Manish Singh        Initial creation of stored procedure
2.0       2024-03-17    Manish Singh        Changed format of time column to join new dimTime table 
3.0       2024-05-09    Manish Singh        Include change in [ETL].[reference_intelliHR_person_ethnicity] to this view
3.1       2024-11-05    Greg Nuthall        Changed the timesheet_entry_pay_interpretation_time_categories table to be grouped to avoid
                                            duplicate rows. Cannot use ODSDMLOperation <> 'D' because it removes 1000's of rows
3.2       2025-01-21    Greg Nuthall        End time was start_time, changed to the correct end time
3.3       2025-01-23    Greg Nuthall        Added new column employee role
3.4       2025-05-25    Manish Singh        Add a filter condition to exclude deleted records
3.5       2025-05-29    Greg Nuthall        Timesheet_entry_pay_interpretation_time_categories has many records 
                                            with No DWHIsCurrent to ensure it loads correctly union these rows
                                            back in. Done in conjunction with change to the procedure 
                                            UpdateEmpLivetimesheet_entry_pay_interpretation_time_categories
3.6       2025-09-18    Greg Nuthall        Added filters to exclude Agency, Test, and Road records from fact table
3.7       2025-12-02    Greg Nuthall        Changed pay interpretation to get soft 'D' records and ignore old records for older pay records
**********************************************************************************************************/

AS

--Just get the latest record grouped by timesheet_entry_pay_interpretation_id, time_category_id using ODSEffectiveTo
WITH PayInterpretationTimeCategories AS (
    
    SELECT 
        tc.timesheet_entry_pay_interpretation_id, 
        tc.time_category_id,
        tc.duration 
    FROM 
        [EmpLive].[timesheet_entry_pay_interpretation_time_categories] tc 
        inner join (select t.timesheet_entry_pay_interpretation_id, 
                    t.time_category_id,
                    --t.duration,
                    Max(ODSEffectiveTo) as MaxODSEffectiveTo
                    from [EmpLive].[timesheet_entry_pay_interpretation_time_categories] t 
                    where t.ODSDMLOperation <> 'D'  --t.ODSIsCurrent = 0 AND 
                    group by t.timesheet_entry_pay_interpretation_id, 
                    t.time_category_id
                    --,t.duration
                    ) LastRecord 
            on tc.timesheet_entry_pay_interpretation_id = LastRecord.timesheet_entry_pay_interpretation_id 
            and tc.time_category_id = LastRecord.time_category_id
            --and tc.duration = LastRecord.duration
            and tc.ODSEffectiveTo = LastRecord.MaxODSEffectiveTo

    WHERE 
        tc.ODSDMLOperation <> 'D'  --tc.ODSIsCurrent = 0 AND 
    
    GROUP BY 
        tc.timesheet_entry_pay_interpretation_id, 
        tc.time_category_id,
        tc.duration 
),
CompanyNames AS (
    SELECT 
        id,
        TRIM(RIGHT([name], LEN([name]) - CHARINDEX('-', REPLACE([name], '–', '-')))) AS company_name
    FROM 
        [EmpLive].[entities] ent
    WHERE 
        ent.[ODSIsCurrent] = 1
)
SELECT 
    tse.id AS time_sheet_entry_id, 
    comp.company_name AS [fact_hours_worked_company_name], 
    tc.id AS [fact_hours_worked_payroll_category_id], 
    e.[reference_number] AS [fact_hours_worked_employee_number], 
    tc.name AS [fact_hours_worked_leave_type_name], 
    tse.service_name_id AS [fact_hours_worked_emplive_service_id], 
    ethgroup.concatenatedEthnicity AS [fact_hours_worked_concatenated_ethnicity_id], 
    pitc.duration AS [fact_hours_worked_total_duration],
    tse.[approval_status] AS [fact_hours_worked_approval_status],
    CAST(FORMAT(CONVERT(DATE, tse.start_date), 'yyyyMMdd') AS INT) AS [fact_hours_worked_concatenated_shift_start_date_id],
    CAST(FORMAT(CONVERT(DATE, tse.end_date), 'yyyyMMdd') AS INT) AS [fact_hours_worked_concatenated_shift_end_date_id],
    CAST(tse.start_time AS TIME(0)) AS [fact_hours_worked_concatenated_shift_start_time_id],
    CAST(tse.end_time AS TIME(0)) AS [fact_hours_worked_concatenated_shift_end_time_id],
    r.name AS fact_hours_worked_role
FROM 
    [EmpLive].[time_sheets_entries] tse
    INNER JOIN [EmpLive].[service_names] sn 
        ON tse.[service_name_id] = sn.id AND sn.[ODSIsCurrent] = 1
    INNER JOIN [EmpLive].[services] s 
        ON sn.service_id = s.id AND s.[ODSIsCurrent] = 1
    INNER JOIN [EmpLive].[entities] ent 
        ON s.[entity_id] = ent.id AND ent.[ODSIsCurrent] = 1
    INNER JOIN [EmpLive].[employees] e 
        ON tse.employee_id = e.id AND e.[ODSIsCurrent] = 1
    LEFT JOIN [EmpLive].[roles] r 
        ON tse.role_id = r.id AND r.[ODSIsCurrent] = 1
    INNER JOIN PayInterpretationTimeCategories pitc 
        ON pitc.[timesheet_entry_pay_interpretation_id] = tse.pay_interpretation_id
    INNER JOIN [EmpLive].[time_categories] tc 
        ON tc.id = pitc.time_category_id AND tc.ODSIsCurrent = 1
    LEFT JOIN [ETL].[reference_intelliHR_person_ethnicity] ethgroup 
        ON CAST(ethgroup.employeeNumber AS NVARCHAR(20)) = e.[reference_number]
    LEFT JOIN CompanyNames comp 
        ON comp.id = ent.id
WHERE 
    tse.[ODSIsCurrent] = 1
    and e.first_name <> 'Agency'
    and e.last_name <> 'Test'
    and e.first_name <> 'Road';