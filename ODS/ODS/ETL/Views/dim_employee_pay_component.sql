
create   view [ETL].[dim_employee_pay_component]

as

/**********************************************************************************************************
 View		[ETL].[dim_employee_pay_component]
 Author		Pankaj Bhatt
 Created	2026-02-04
 Purpose	Used to build the edw.dim_employee_pay_component table
 
 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2026-02-04		Pankaj Bhatt	Initial version
--1.1		 2026-04-15		Pankaj Bhatt	Updated logic to get component details 
--1.2        2026-09-28     Greg Nuthall    Removed 'inactive' duplicate
**************************************************************************************************************/

WITH 
-- logic from the components table
Components_Master AS (
    SELECT DISTINCT
        com.code AS pay_component_code,
        com.name AS pay_component_name,
        com.category AS pay_component_category,
        co.code AS company_code
    FROM [Datapay].[components] com
    LEFT OUTER JOIN [Datapay].[companies] co
        ON com.company_id = co.company_id
    where com.name not like '%inactive%'
),
-- logic from the pay_run_report table
PayRun_Components AS (
    SELECT DISTINCT
        prr.pay_components_code AS pay_component_code,
        prr.pay_components_name AS pay_component_name,
        prr.pay_components_category_name AS pay_component_category,
        COALESCE(co.code,6154) AS company_code -- dev has nulls, added for defensive coding and default to Emerge Aotearoa Limited
    FROM [Datapay].[pay_run_report] prr
    LEFT OUTER JOIN [Datapay].[pay_runs] pr
        ON prr.pay_run_id = pr.pay_run_id
        AND pr.ODSIsCurrent = 1
    LEFT OUTER JOIN [Datapay].[pay_groups] pg
        ON pr.pay_group_id = pg.paygroup_id
    LEFT OUTER JOIN [Datapay].[companies] co
        ON pg.company_id = co.company_id
    where prr.pay_components_name not like '%inactive%'
)
SELECT 
    -- Prioritize component details, fall back to pay run report details
     CAST(COALESCE(cm.pay_component_code, pr.pay_component_code) AS nvarchar(50)) AS pay_component_code,
     CAST(COALESCE(cm.pay_component_name, pr.pay_component_name) AS nvarchar(100)) AS pay_component_name,
     CAST(COALESCE(cm.pay_component_category, pr.pay_component_category) AS nvarchar(50)) AS pay_component_category,
     COALESCE(cm.company_code, pr.company_code) AS company_code
FROM Components_Master cm
full outer join PayRun_Components pr 
    ON cm.pay_component_code = pr.pay_component_code 
    AND cm.company_code = pr.company_code