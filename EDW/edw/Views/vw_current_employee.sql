
create view [edw].[vw_current_employee] as 
WITH EmployeeMaster AS (
    SELECT 
        cs.dim_service_key,
		cs.dim_company_key,
        de.dim_employee_key,
        de.employee_id
    FROM 
        [edw].[vw_dim_employee_hierarchy] deh
        INNER JOIN [edw].[vw_dim_employee] de ON deh.employee_id = de.employee_id
        INNER JOIN [edw].[vw_dim_service] cs ON COALESCE(
            deh.employee_people_leader_business_unit_name_level_9,
            deh.employee_people_leader_business_unit_name_level_8,
            deh.employee_people_leader_business_unit_name_level_7,
            deh.employee_people_leader_business_unit_name_level_6,
            deh.employee_people_leader_business_unit_name_level_5,
            deh.employee_people_leader_business_unit_name_level_4,
            deh.employee_people_leader_business_unit_name_level_3,
            deh.employee_people_leader_business_unit_name_level_2,
            deh.employee_people_leader_business_unit_name_level_1
        ) = cs.service_name
    WHERE 
        deh.DWHDMLOperation <> 'D'
        AND deh.DWHIsCurrent = 1
        AND deh.dim_employee_key > 0
        AND de.DWHDMLOperation <> 'D'
        AND de.DWHIsCurrent = 1
        AND de.dim_employee_key > 0
        AND de.employee_employment_status IN ('Current Staff', 'Exiting Staff')
        AND cs.DWHDMLOperation <> 'D'
        AND cs.DWHIsCurrent = 1
)

SELECT 
    em.dim_company_key,em.dim_service_key,em.dim_employee_key,em.employee_id,
    CASE 
        WHEN COUNT(em.dim_company_key) OVER (PARTITION BY em.dim_employee_key) > 1 
        THEN 1 ELSE 0 
    END AS employee_has_multiple_company_or_service
FROM EmployeeMaster em
--ORDER BY dim_employee_key