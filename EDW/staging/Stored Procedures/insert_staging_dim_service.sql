

CREATE PROC [staging].[insert_staging_dim_service]

AS
/**************************************************************************************
NAME:     [staging].[insert_staging_dim_service]
PURPOSE:  

 Notes: Call By	EDW Pipeline '30_Load_From_ODS'

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 ?			   ?				Initial version
1.1		2023-08-07	  Glenn McLeod		Updated to use table Framework table names 
1.11	2023-08-28	  Glenn McLeod		Updated table/column names
1.12	2023-09-15	  Glenn McLeod		Fixed dim_service_unique_key truncation issue
1.13	2024-03-12	  Manish Singh		Adding is inactive column in flow
1.14	2024-07-08	  Greg Nuthall		Modified last change date to be minute rounded to avoid new records being created
1.15    2025-07-16    Manish Singh      Added latitude and longitude colmns
1.2     2026-10-20    Greg Nuthall      Added O4S fields
***************************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_service]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_service] (
	   [service_id]
      ,[dim_service_unique_key]
      ,[service_code]
      ,[service_name]
      ,[intellihr_service_id]
      ,[datapay_service_id]
      ,[service_type_code]
      ,[service_type_name]
      ,[department_code]
      ,[department_name]
      ,[district_code]
      ,[district_name]
      ,[region_code]
      ,[region_name]
      ,[location_code]
      ,[location_name]
      ,[finance_funder_code]
      ,[finance_funder_name]
      ,[finance_funding_agency_code]
      ,[finance_funding_agency_name]
      ,[finance_budget_holder_code]
      ,[finance_budget_holder_name]
      ,[finance_contract_code]
      ,[finance_contract_name]
      ,[company_name]
      ,[service_last_modified_date_time]
      ,is_inactive
      ,latitude
	  ,longitude
      ,[Functional_Capability]
	  ,[Functional_Group]
	  ,[Business_Unit] 
	  ,[Business_Sub_Unit] 
	  ,[Portfolio]
	  ,[Service_Grouping] 
   )
   select distinct
	   src.[service_id]
	 -- ,Cast(src.[rowkey] as nvarchar)+'_'+Cast(src.[service_id] as nvarchar)+'_'+Cast(src.[company] as nvarchar)
	  ,Cast(src.[rowkey] as nvarchar(200))+'_'+Cast(src.[service_id] as nvarchar(200))+'_'+Cast(src.[company] as nvarchar(200))
      ,src.[service_code]
      ,src.[service_name]
      ,src.[intellihr_service_id]
      ,src.[datapay_service_id]
      ,src.[service_type_code]
      ,src.[service_type_name]
      ,src.[department_code]
      ,src.[department_name]
      ,src.[district_code]
      ,src.[district_name]
      ,src.[region_code]
      ,src.[region_name]
      ,src.[location_code]
      ,src.[location_name]
      ,src.[funder_code]
      ,src.[funder_name]
      ,src.[funding_agency_code]
      ,src.[funding_agency_name]
      ,src.[budget_holder_code]
      ,src.[budget_holder_name]
      ,src.[contract_code]
      ,src.[contract_name]
      ,src.[company]
	  ,dateadd(mi, datediff(mi, 0, dateadd(s, 30, src.last_modified_date_time)), 0) as last_modified_date_time
		--,src.[last_modified_date_time]
	  ,src.is_inactive
      ,src.latitude
	  ,src.longitude
      ,isnull(o4.Lvl2_Functional_Capability,o42.Lvl2_Functional_Capability) as Functional_Capability 
      ,isnull(o4.Lvl3_Functional_Group,o42.Lvl3_Functional_Group) as Functional_Group 
      ,isnull(o4.Lvl4_Business_Unit,o42.Lvl4_Business_Unit) as Business_Unit
      ,isnull(o4.Lvl5_Business_Sub_Unit,o42.Lvl5_Business_Sub_Unit) as Business_Sub_Unit 
      ,isnull(o4.Lvl6_Portfolio,o42.Lvl6_Portfolio) as Portfolio 
      ,isnull(o4.Lvl7_Service_Grouping,o42.Lvl7_Service_Grouping) as Service_Grouping 
from [Landing].[edw_dim_service] as src
left outer join reference.edw_04S_structure o4 on src.service_name = o4.Lvl8_Service 
left outer join reference.edw_04S_structure o42 on src.service_code = o42.Dimension_Service and src.company = o42.Dimension_Entity