
CREATE    VIEW [ETL].[fact_employee_leave]
AS

/**********************************************************************************************************
 View		[ETL].[fact_employee_leave]
 Author		????
 Created	2024/01/19
 Purpose	Used to build the edw.fact_employee_leave table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		2024/01/19		?????			Initial version
--1.1		2024/05/06		Greg Nuthall	Uses first and last name to get the correct employee_number when it doesn't match datapay e.code
--1.2		2025/03/06		Greg Nuthall	Changed to use standard hours per week to get the number of hours per week. Did not change 8 hours as a standard day 
--1.3		2025-04-14	    Greg Nuthall	Added CTE to avoid datapay duplicate employees 
--1.4       2026-09-29      Greg Nuthall	Link to intelliHR jobs to get business units since datapay is not up to date only use it as a reserve
**************************************************************************************************************/

With intelliHR_employee_lookup as (
				Select max(employeeNumber) as employeeNumber
				, primaryEmailAddress_email
				, firstName, lastName 
				from [IntelliHR].[people]
				where ODSIsCurrent = 1
				group by primaryEmailAddress_email
				,firstName
				,lastName)

,non_duplicated_datapay_employees as (
		Select e.* 
		from [Datapay].[employees] e
		inner join [IntelliHR].[people] p on code = p.employeeNumber and p.ODSIsCurrent = 1
		where isnull(email_address,'XXXX') in (select isnull(email_address ,'XXQQ')
												from [Datapay].[employees] e
												where e.ODSIsCurrent = 1
												group by email_address
												having Count(*)>=2)
		and e.ODSIsCurrent = 1

		union all 
		Select e.* 
		from [Datapay].[employees] e
		where isnull(email_address,'XXXX') not in (select isnull(email_address,'XXQQ')
													from [Datapay].[employees] e
													where e.ODSIsCurrent = 1
													group by email_address
													having Count(*)>=2)
		and e.ODSIsCurrent = 1)




SELECT
	a.company_datapay_key AS [datapay_company_id]
	,a.employee_number AS employee_id
	,a.leave_type_id -- used to link to dim_leave_type
	,CAST(CONCAT(a.[ethnicity_level1]  
	,+ ' | ' + a.[ethnicity_level2]
	,+ ' | ' + a.[ethnicity_level3] 
	,+ ' | ' + a.[ethnicity_level4] 
	,+ ' | ' + a.[ethnicity_level5] ) AS nvarchar(4000))AS [dim_ethnicity_id] -- used to link to dim_ethnicity
	,FORMAT(a.effective_date,'yyyyMMdd') AS employee_leave_effective_date_key
	,FORMAT(a.anniversary,'yyyyMMdd') AS employee_leave_anniversary_date_key
	,a.business_unit_name -- link to dim_business_unit_hierarchy
	,a.unit AS employee_leave_unit
	,a.entitlement AS employee_leave_entitlement
	,a.accrual AS employee_leave_accrual
	,a.taken AS employee_leave_taken
	,a.balance AS employee_leave_balance
	
	
	--Use the employee standard hours per week as the number of hours per week or 40 if it does not exisit
	--Can no longer standardise all units to hours (cannot assume 8 hours a day/40 hours a week)

	,CASE a.unit
		when 'Weeks'
			THEN a.entitlement * case when isnull(standard_hours_per_week_value,0) = 0 then 40 else standard_hours_per_week_value end
		when 'Days'
			THEN a.entitlement * 8
		when 'Hours'
			then a.entitlement
		ELSE a.entitlement
		END AS employee_leave_entitlement_hours
	
	,CASE a.unit
		WHEN 'Weeks'
			THEN a.accrual * case when isnull(standard_hours_per_week_value,0) = 0 then 40 else standard_hours_per_week_value end
		WHEN 'Days'
			THEN a.accrual * 8
		ELSE a.accrual
		END AS employee_leave_accrual_hours
	
	,CASE a.unit
		WHEN 'Weeks'
			THEN a.taken * case when isnull(standard_hours_per_week_value,0) = 0 then 40 else standard_hours_per_week_value end
		WHEN 'Days'
			THEN a.taken * 8
		ELSE a.taken
		END AS employee_leave_taken_hours
	
	,CASE a.unit
		WHEN 'Weeks'
			THEN a.balance * case when isnull(standard_hours_per_week_value,0) = 0 then 40 else standard_hours_per_week_value end
		WHEN 'Days'
			THEN a.balance * 8
		ELSE a.balance
		END AS employee_leave_balance_hours
	
	,CASE a.unit
		WHEN 'Weeks'
			THEN a.next_entitlement * case when isnull(standard_hours_per_week_value,0) = 0 then 40 else standard_hours_per_week_value end
		WHEN 'Days'
			THEN a.next_entitlement * 8
		ELSE a.next_entitlement
		END AS employee_leave_next_entitlement_hours

FROM (
	SELECT
		e.[id]
		,isnull(isnull(isnull(p.employeeNumber, p2.employeeNumber), e.code),-1) as employee_number
		--,e.code AS employee_number
		,isnull(e.company_id,-1) AS company_datapay_key
		--,c.name AS leave_type_company_name  
		,isnull(j.[businessUnit_name],cs.level3_code)  AS business_unit_name
		
		--,cs.level3_code AS business_unit_name
		,isnull(lb.leave_type_id,-1) as leave_type_id
		,CAST(lb.[effective_date] AS DATE) AS [effective_date]
		,ISNULL(lb.[unit], 'Hours') AS unit -- default to Hours if no value is avilable
		,lb.[entitlement]
		,lb.[accrual]
		,lb.[taken]
		,lb.[balance]
		,CAST(lb.[anniversary] AS DATE) AS anniversary
		,lb.[next_entitlement]
		,e.[standard_hours_per_week_value]
		,e.[standard_days_per_week_value]
		--,lt.[name] AS leave_type
		--,peth.definition_value_label AS primary_ethnicity_id
		,COALESCE(ethgroup.definition_value_label1,peth.definition_value_label) AS [ethnicity_level1] -- only use single select if multi select is empty
		,ethgroup.definition_value_label2 AS [ethnicity_level2]
		,ethgroup.definition_value_label3 AS [ethnicity_level3]
		,ethgroup.definition_value_label4 AS [ethnicity_level4]
		,ethgroup.definition_value_label5 AS [ethnicity_level5]

	FROM [Datapay].[leave_balances] lb
	LEFT JOIN non_duplicated_datapay_employees e ON lb.employee_id = e.id
		AND e.ODSIsCurrent = 1 and e.ODSDMLOperation <> 'D'
	LEFT JOIN [DataPay].[cost_structures] cs ON e.home_cost_box_value = cs.level3_cost_box_id
		AND cs.ODSIsCurrent = 1
	LEFT JOIN [Datapay].[leave_types] lt ON lb.leave_type_id = lt.leave_type_id
		AND e.company_id = lt.company_id
		AND lt.ODSIsCurrent = 1
	LEFT JOIN [DataPay].[companies] c ON lt.[company_id] = c.company_id
		AND c.odsiscurrent = 1
	LEFT JOIN [IntelliHR].[people] p ON e.code = p.employeeNumber
		AND p.ODSIsCurrent = 1
	LEFT JOIN intelliHR_employee_lookup p2 ON upper(trim(e.email_address)) = upper(trim(p2.primaryEmailAddress_email)) 
		and upper(trim(e.first_name)) = upper(trim(p2.firstName)) and upper(trim(e.last_name)) = upper(trim(p2.lastName))
	
	left join (Select max(isnull([businessUnit_name],'ZZZZZ')) as [businessUnit_name], person_employeeNumber 
				from IntelliHR.jobs 
				where ODSIsCurrent = 1 and isPrimaryJob = 1
				group by person_employeeNumber) j on isnull(isnull(isnull(p.employeeNumber, p2.employeeNumber), e.code),-1) = j.person_employeeNumber


	LEFT JOIN [IntelliHR].[people_custom_fields] peth ON p.people_id = peth.people_id
		AND definition_name LIKE 'Identified Ethnicity'
		AND definition_type = 'SINGLE_SELECT'
		AND peth.[ODSIsCurrent] = 1
	LEFT JOIN (
		SELECT people_id
			,definition_value_label1
			,definition_value_label2
			,definition_value_label3
			,definition_value_label4
			,definition_value_label5
		FROM (
			SELECT
				p.people_id
				,'definition_value_label' + CAST(ROW_NUMBER() OVER (
						PARTITION BY ethgroup.people_id ORDER BY (
								SELECT ordinal
								)
						) AS VARCHAR(10)) AS columnName
				,value AS definition_value_label
			FROM [IntelliHR].[people_custom_fields] ethgroup
			LEFT JOIN [IntelliHR].[people] p ON ethgroup.people_id = p.people_id
				AND p.ODSIsCurrent = 1
			CROSS APPLY STRING_SPLIT(REPLACE(REPLACE(REPLACE(definition_value_label, '"', ''), '[', ''), ']', ''), ',',1)
			WHERE 1 = 1
				--AND ethgroup.definition_id = '6ec5d520-e43e-4806-950c-a1793b87cace' -- code for Ethnicity grouping
				AND ethgroup.[ODSIsCurrent] = 1
				AND ethgroup.definition_value_label IS NOT NULL
				AND definition_name LIKE 'Ethnicity%'
				AND definition_type = 'MULTI_SELECT'
			) AS SourceTable
		PIVOT(MAX(definition_value_label) FOR columnName IN (
					definition_value_label1
					,definition_value_label2
					,definition_value_label3
					,definition_value_label4
					,definition_value_label5
					)) AS PivotTable
		) AS ethgroup ON p.people_id = ethgroup.people_id
	WHERE lb.ODSIsCurrent = 1
	) AS a
	where a.employee_number <> -1
	and a.company_datapay_key <> '-1'