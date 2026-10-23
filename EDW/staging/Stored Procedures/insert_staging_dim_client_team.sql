


CREATE PROC [staging].[insert_staging_dim_client_team]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_client_team]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		?			  ?						Initial creation of stored procedure
1.1		2023-08-07	  Glenn McLeod			Updated to use table Framework table names 
1.11	2023-08-22	  Glenn McLeod			Rename source tables
1.12	2023-08-25	  Glenn McLeod			Updated table/column names
1.2		2023-09-25	  Glenn McLeod			Renamed destination column from [dim_company_key] to [company_id]
1.21	2024-03-04	  Glenn McLeod			User Story 7207: added client_team_primhd_exclusion_flag
1.22	2024-10-21	  Greg Nuthall			User Story 9148: added client team area
2.1		2024-10-25	  Greg Nuthall			Bug 9203: Change the unique key to only include team_id and company name
2.2		2025-11-17	  Pankaj Bhatt			Added parent area
****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_client_team]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_client_team] (
	   [company_id]
      ,[dim_client_team_unique_key]
      ,[service_id]
      ,[client_team_id]
      ,[client_team_name]
      ,[client_team_description]
      ,[client_team_function]
      ,[client_team_is_accommodation_based]
      ,[dim_client_team_start_date]
      ,[dim_client_team_end_date]
      ,[client_team_bed_number]
      ,[client_team_is_allocated_support]
      ,[client_team_is_employment_team]
      ,[client_team_status]
	  ,[client_team_primhd_exclusion_flag]
	  ,[client_team_area]
      ,[client_team_parent_area]
      ,[client_team_grand_parent_area]
   )
   select
	   src.[company_key]
	  ,Cast(src.[team_id] as nvarchar)+'_'+ CAST(src.[company_key] as varchar)
	  ,src.[service_id]
      ,src.[team_id]
      ,src.[team_name]
      ,src.[team_description]
      ,src.[team_function]
      ,src.[team_is_accommodation_based]
      ,src.[dim_team_start_date_key]
      ,src.[dim_team_end_date_key]
      ,src.[team_bed_number]
      ,src.[team_is_allocated_support]
      ,src.[team_is_employment_team]
      ,src.[team_status]
	  ,src.[client_team_primhd_exclusion_flag]
	  ,src.client_team_area
      ,src.[client_team_parent_area]
      ,src.[client_team_grand_parent_area]
from [Landing].[edw_dim_client_team] as src