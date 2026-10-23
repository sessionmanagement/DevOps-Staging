/****** Object:  View [edw].[vw_current_properties]    ******/

---SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

CREATE VIEW [edw].[vw_current_properties] AS 

/**********************************************************************************************************
 KPI View:  
 Author  :    Mike Ryan (original)
 Modified by: Timi Boddington
 Created :    
 Purpose  :  
 User Story :
  
 Notes: View created on EDW tables
 =========================================================================================================

 REVISIONS:
 Version   Date       Author          Description
-------  ------------  ------------------  --------------------------
 1.0       
 **********/

SELECT
ds.dim_company_key,
coalesce(ds.dim_service_key, ds2.dim_service_key) as dim_service_key,
dp.dim_property_key,
dp.property_id,
dp.property_program,
dp.property_sub_program,
coalesce(ds.service_name, ds2.service_name) as bc_service_name,
CASE WHEN [property_current_tenancy] IS NULL THEN 0 ELSE 1 END AS currently_tenanted_flag
FROM
[edw].[vw_dim_property] dp
LEFT JOIN [edw].[vw_dim_service] ds
--ON dp.property_bc_service_name = ds.service_name 
--====changes to
ON dp.property_contract_bc_service_code = ds.service_code 
AND ds.DWHIsCurrent = 1 AND ds.DWHDMLOperation <> 'D'

left join edw.vw_dim_service ds2 
ON dp.property_bc_service_code = ds2.service_code
and ds2.DWHIsCurrent = 1 and ds2.DWHDMLOperation <> 'd'
--=============

WHERE
	dp.DWHIsCurrent = 1
	AND dp.DWHDMLOperation <> 'D'
	AND dp.dim_property_key > 0
	AND dp.property_statecode = 'Active'