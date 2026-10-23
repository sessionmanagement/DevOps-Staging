
CREATE   VIEW [kpi].[fact_kpi_current] AS 

/**********************************************************************************************************
 KPI FACT	View fact_kpi
 Author		Manish Singh
 Created	03-02-2025	
 Purpose	This View will join data from ds_kpi_snapshot_whānau_current,ds_kpi_snapshot_kaimahi_current and ds_kpi_snapshot_Property_current	
	
 Notes: Ensure data types match when adding new views to allow seamless union with the parent view.
 =========================================================================================================

 REVISIONS:
 Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
 1.0		03-02-2025    Manish Singh		 This master view consolidates data from all KAIMAHI-related individual measures. 
 1.1        14-02-2025    Manish Singh		 Removed columns which can be derived from dim_kpi
 1.2        14-02-2025    Manish Singh		 Adding Default values for keys not specified data 
 2.0        04-03-2025    Manish Singh		 Added client and Property measures in flow
 2.1		13-03-2025	  Greg Nuthall		 Added referral measures flow
 2.2		21-03-2025	  Greg Nuthall	     Added new id fields removed batch reduced size of fields where possible
 3.0		27-03-2025	  Greg Nuthall		 Added service_id
 3.1	    23-04-2025	  Greg Nuthall		 Added service measures flow
 3.2        22-07-2025    Greg Nuthall       Added kpi_id 
 4.0		07-08-2025	  Greg Nuthall		 Added tenancy-specific columns and logic

 **********************************************************************************************************/

-- Existing Kaimahi measures
SELECT 1000000 + [kpi_snapshot_kaimahi_id] AS fact_kpi_id
	  ,[dim_kpi_key]
      ,[dim_company_key]
      ,[dim_employee_key]
      ,-9 AS [dim_client_key]
	  ,-9 as [dim_client_referral_key]
      ,-9 AS dim_property_key
	  ,-9 AS dim_property_tenancy_key  -- NEW COLUMN
	  ,[dim_service_key]
	  ,kpi_id
	  ,service_id
	  ,employee_id
	  ,-9 as client_id
	  ,-9 as client_referral_id
	  ,null as property_id
	  ,null as property_tenancy_id     -- NEW COLUMN
	  ,[entity_key]
      ,[kpi_value]
      ,[user_friendly_score_explanation]
      ,[kpi_status]
      ,[snapshot_date]

  FROM [kpi].[ds_snapshot_kaimahi_current]
  
  UNION ALL

-- Existing Client measures  
  SELECT 2000000 + [kpi_snapshot_client_id] AS fact_kpi_id
	  ,[dim_kpi_key]
      ,[dim_company_key]
      ,-9 AS [dim_employee_key]
      ,[dim_client_key]
	  ,-9 as [dim_client_referral_key]
	  ,-9 AS dim_property_key
	  ,-9 AS dim_property_tenancy_key  -- NEW COLUMN
	  ,[dim_service_key]
	  ,kpi_id
	  ,service_id
	  ,-9 as employee_id
	  ,client_id
	  ,-9 as client_referral_id
	  ,null as property_id
	  ,null as property_tenancy_id     -- NEW COLUMN
	  ,[entity_key]
      ,[kpi_value]
      ,[user_friendly_score_explanation]
      ,[kpi_status]
      ,[snapshot_date]
     
  FROM [kpi].[ds_snapshot_client_current]

  UNION ALL

-- Existing Property measures
  SELECT 3000000 + [kpi_snapshot_property_id] AS fact_kpi_id
	  ,[dim_kpi_key]
      ,[dim_company_key]
      ,-9 AS [dim_employee_key]
      ,-9 AS [dim_client_key]
      ,-9 as [dim_client_referral_key]
	  ,[dim_property_key]
	  ,-9 AS dim_property_tenancy_key  -- NEW COLUMN
	  ,[dim_service_key]
	  ,kpi_id
	  ,service_id
	  ,-9 as employee_id
	  ,-9 as client_id
	  ,-9 as client_referral_id
	  ,[property_id]
	  ,null as property_tenancy_id     -- NEW COLUMN
	  ,[entity_key]
      ,[kpi_value]
      ,[user_friendly_score_explanation]
      ,[kpi_status]
      ,[snapshot_date]
      
  FROM [kpi].[ds_snapshot_property_current]

  UNION ALL
  
-- Existing Referral measures
  SELECT 4000000 + [kpi_snapshot_referral_id] AS fact_kpi_id
	  ,[dim_kpi_key]
      ,[dim_company_key]
      ,-9 AS [dim_employee_key]
      ,-9 AS [dim_client_key]
	  ,[dim_client_referral_key]
	  ,-9 as dim_property_key
	  ,-9 AS dim_property_tenancy_key  -- NEW COLUMN
      ,[dim_service_key]
	  ,kpi_id
	  ,service_id
	  ,-9 as employee_id
	  ,-9 as client_id
	  ,client_referral_id
	  ,null as property_id
	  ,null as property_tenancy_id     -- NEW COLUMN
	  ,[entity_key]
      ,[kpi_value]
      ,[user_friendly_score_explanation]
      ,[kpi_status]
      ,[snapshot_date]
      
  FROM [kpi].[ds_snapshot_referral_current]

  UNION ALL
  
-- Existing Service measures
   SELECT 5000000 + [kpi_snapshot_service_id] AS fact_kpi_id
	  ,[dim_kpi_key]
      ,[dim_company_key]
      ,-9 as [dim_employee_key]
      ,-9 as [dim_client_key]
	  ,-9 as [dim_client_referral_key]
	  ,-9 as dim_property_key
	  ,-9 AS dim_property_tenancy_key  -- NEW COLUMN
      ,[dim_service_key]
	  ,kpi_id
	  ,service_id
	  ,-9 as employee_id
	  ,-9 as client_id
	  ,-9 as client_referral_id
	  ,null as property_id
	  ,null as property_tenancy_id     -- NEW COLUMN
	  ,[entity_key]
      ,[kpi_value]
      ,[user_friendly_score_explanation]
      ,[kpi_status]
      ,[snapshot_date]
      
  FROM [kpi].[ds_snapshot_service_current]

  UNION ALL
  
-- NEW: Tenancy measures
   SELECT 6000000 + [kpi_snapshot_tenancy_id] AS fact_kpi_id
	  ,[dim_kpi_key]
      ,[dim_company_key]
      ,-9 as [dim_employee_key]
      ,-9 as [dim_client_key]
	  ,-9 as [dim_client_referral_key]
	  ,-9 as dim_property_key
	  ,[dim_property_tenancy_key]      -- NEW: Use actual tenancy key
      ,[dim_service_key]
	  ,kpi_id
	  ,service_id
	  ,-9 as employee_id
	  ,-9 as client_id
	  ,-9 as client_referral_id
	  ,null as property_id
	  ,[property_tenancy_id]           -- NEW: Use actual tenancy id
	  ,[entity_key]
      ,[kpi_value]
      ,[user_friendly_score_explanation]
      ,[kpi_status]
      ,[snapshot_date]
      
  FROM [kpi].[ds_snapshot_tenancy_current];