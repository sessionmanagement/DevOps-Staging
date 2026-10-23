
CREATE PROC [staging].[insert_staging_dim_client_absence]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_client_absence]
PURPOSE:  move rows from edw landing table to the staging table 

Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-08-05    Greg Nuthall		Initial version
****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_client_absence]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_client_absence] (
	 [company_id] 
	,[dim_client_unique_key] 
	,[client_id] 
	,[client_absence_approved_by_funder_flag] 
	,[client_absence_start_date_time] 
	,[client_absence_end_date_time] 
	,[client_absence_type] 
	,[client_absence_reason_id] 
	,[client_absence_reason])

SELECT
	 [company_id] 
	,[dim_client_unique_key] 
	,[client_id] 
	,[client_absence_approved_by_funder_flag] 
	,[client_absence_start_date_time] 
	,[client_absence_end_date_time] 
	,[client_absence_type] 
	,[client_absence_reason_id] 
	,[client_absence_reason] 
from [Landing].[edw_dim_client_absence]