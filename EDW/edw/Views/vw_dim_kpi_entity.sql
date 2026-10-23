

CREATE VIEW [edw].[vw_dim_kpi_entity] AS 

/*View created by Mike Ryan*/

WITH CurrentServices AS (
    SELECT service_id
    FROM [edw].[vw_dim_service]
    WHERE DWHIsCurrent = 1
    AND DWHDMLOperation <> 'D'
),

-- Define the hierarchy of business units
hierarchy_cte AS (
    SELECT 
        business_unit_hierarchy_level1_name AS parent,
        business_unit_hierarchy_level2_name AS child,
        'Business Unit' AS type
    FROM [edw].[vw_dim_business_unit_hierarchy]
    WHERE [DWHDMLOperation] <> 'D'
        AND [dim_business_unit_hierarchy_key] > 0
        AND business_unit_hierarchy_level2_name IS NOT NULL

    UNION ALL
    
    SELECT 
        business_unit_hierarchy_level2_name AS parent,
        business_unit_hierarchy_level3_name AS child,
        'Business Unit' AS type
    FROM [edw].[vw_dim_business_unit_hierarchy]
    WHERE [DWHDMLOperation] <> 'D'
        AND [dim_business_unit_hierarchy_key] > 0
        AND business_unit_hierarchy_level3_name IS NOT NULL
    
    UNION ALL
    
    SELECT 
        business_unit_hierarchy_level3_name AS parent,
        business_unit_hierarchy_level4_name AS child,
        'Business Unit' AS type
    FROM [edw].[vw_dim_business_unit_hierarchy]
    WHERE [DWHDMLOperation] <> 'D'
        AND [dim_business_unit_hierarchy_key] > 0
        AND business_unit_hierarchy_level4_name IS NOT NULL
    
    UNION ALL
    
    SELECT 
        business_unit_hierarchy_level4_name AS parent,
        business_unit_hierarchy_level5_name AS child,
        'Business Unit' AS type
    FROM [edw].[vw_dim_business_unit_hierarchy]
    WHERE [DWHDMLOperation] <> 'D'
        AND [dim_business_unit_hierarchy_key] > 0
        AND business_unit_hierarchy_level5_name IS NOT NULL
    
    UNION ALL
    
    SELECT 
        business_unit_hierarchy_level5_name AS parent,
        business_unit_hierarchy_level6_name AS child,
        'Business Unit' AS type
    FROM [edw].[vw_dim_business_unit_hierarchy]
    WHERE [DWHDMLOperation] <> 'D'
        AND [dim_business_unit_hierarchy_key] > 0
        AND business_unit_hierarchy_level6_name IS NOT NULL
    
    UNION ALL
    
    SELECT 
        business_unit_hierarchy_level6_name AS parent,
        business_unit_hierarchy_level7_name AS child,
        'Business Unit' AS type
    FROM [edw].[vw_dim_business_unit_hierarchy]
    WHERE [DWHDMLOperation] <> 'D'
        AND [dim_business_unit_hierarchy_key] > 0
        AND business_unit_hierarchy_level7_name IS NOT NULL
    
    UNION ALL
    
    SELECT 
        business_unit_hierarchy_level7_name AS parent,
        business_unit_name AS child,
        'Business Unit' AS type
    FROM [edw].[vw_dim_business_unit_hierarchy]
    WHERE [DWHDMLOperation] <> 'D'
        AND [dim_business_unit_hierarchy_key] > 0
        AND business_unit_name IS NOT NULL
),

Business_Hierarchy_CTE AS (
    SELECT DISTINCT 
        h.parent AS [Parent BU],
        h.child AS [Child BU],
        ps.service_id AS [Parent Dim Service Key],
        cs.service_id AS [Child Dim Service Key],
        type AS Type
    FROM hierarchy_cte h
    LEFT JOIN [edw].[vw_dim_service] ps ON h.parent = ps.[service_name]
    LEFT JOIN [edw].[vw_dim_service] cs ON h.child = cs.[service_name]
    WHERE h.parent <> h.child
        AND (ps.[DWHIsCurrent] = 1 OR ps.[DWHIsCurrent] IS NULL)
        AND (cs.[DWHIsCurrent] = 1 OR cs.[DWHIsCurrent] IS NULL)
)

SELECT DISTINCT
    [Child BU] AS EntityName,
    CONCAT('BU', [Parent Dim Service Key]) AS ParentEntityKey,
    CONCAT('BU', [Child Dim Service Key]) AS EntityKey,
    Type
FROM Business_Hierarchy_CTE
WHERE [Parent BU] <> 'Previous Business Unit/s'

UNION ALL

SELECT DISTINCT
    business_unit_hierarchy_level1_name AS EntityName,
    NULL AS ParentEntityKey,
    CONCAT('BU', cs.service_id) AS EntityKey,
    'Business Unit' AS Type
FROM [edw].[vw_dim_business_unit_hierarchy] buh
LEFT JOIN [edw].[vw_dim_service] cs ON buh.business_unit_hierarchy_level1_name = cs.[service_name]
WHERE buh.[DWHDMLOperation] <> 'D'
    AND [dim_business_unit_hierarchy_key] > 0
    AND business_unit_hierarchy_level1_name IS NOT NULL
    AND (cs.[DWHIsCurrent] = 1)

UNION ALL

SELECT DISTINCT
    employee_displayname AS EntityName,
    CONCAT('BU', cs.service_id) AS ParentEntityKey,
    CONCAT('K', employee_id) AS EntityKey,
    'Kaimahi' AS Type
FROM (
    SELECT DISTINCT
        COALESCE(
            employee_people_leader_business_unit_name_level_9,
            employee_people_leader_business_unit_name_level_8,
            employee_people_leader_business_unit_name_level_7,
            employee_people_leader_business_unit_name_level_6,
            employee_people_leader_business_unit_name_level_5,
            employee_people_leader_business_unit_name_level_4,
            employee_people_leader_business_unit_name_level_3,
            employee_people_leader_business_unit_name_level_2,
            employee_people_leader_business_unit_name_level_1
        ) AS last_non_null,
        deh.employee_displayname,
        deh.employee_id
    FROM [edw].[vw_dim_employee_hierarchy] deh
    INNER JOIN [edw].[vw_dim_employee] de ON deh.employee_id = de.employee_id
    WHERE 
        de.employee_employment_status IN ('Current Staff', 'Exiting Staff')
        AND deh.DWHDMLOperation <> 'D'
        AND deh.DWHIsCurrent = 1
        AND deh.dim_employee_key > 0
        AND de.DWHDMLOperation <> 'D'
        AND de.DWHIsCurrent = 1
        AND de.dim_employee_key > 0
) AS EmployeeHierarchy
INNER JOIN [edw].[vw_dim_service] cs ON EmployeeHierarchy.last_non_null = cs.[service_name]
WHERE cs.[DWHIsCurrent] = 1