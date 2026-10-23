




CREATE PROC [staging].[insert_staging_dim_client_activity_breakdown_type]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_client_activity_breakdown_type]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 ?			   ?				Initial version
1.1		 2023-08-07	   Glenn McLeod		Updated to use table Framework table names 
1.11	 2023-08-21	   Glenn McLeod		Rename source tables
1.12	 2023-08-24	   Glenn McLeod		Updated table/column names
1.2		 2023-09-25	   Glenn McLeod		Renamed destination column from [dim_company_key] to [company_id]

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_client_activity_breakdown_type]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_client_activity_breakdown_type] (
	   [client_activity_breakdown_type_id]
      ,[dim_client_activity_breakdown_type_unique_key]
      ,[company_id]
      ,[team_configuration_name]
      ,[client_activity_breakdown_type_code]
      ,[client_activity_breakdown_type_name]
      ,[client_parent_activity_breakdown_type]
      ,[client_parent_activity_breakdown_type_name]
	)
   SELECT 
      [client_activity_breakdown_type_id]
	  ,cast([client_activity_breakdown_type_id] as nvarchar) +'_'+ cast([company_key] as nvarchar)
	  ,[company_key]
      ,[team_configuration_name]
      ,[client_activity_breakdown_type_code]
      ,[client_activity_breakdown_type_name]
      ,[client_parent_activity_breakdown_type]
      ,[client_parent_activity_breakdown_type_name]
  FROM [landing].[edw_dim_client_activity_breakdown_type]