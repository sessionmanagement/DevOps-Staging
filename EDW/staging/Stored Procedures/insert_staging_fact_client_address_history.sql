




CREATE PROC [staging].[insert_staging_fact_client_address_history]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_client_address_history]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-08-09    ?				Initial version
1.11	 2023-08-29	   Glenn McLeod		Updated table/column names
1.2		 2023-09-25	   Glenn McLeod		Renamed destination column from [dim_company_key] to [company_id]

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_client_address_history]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_client_address_history] (
	   [client_id]
      ,[client_address_id]
      ,[company_id]
	  ,[fact_client_address_history_unique_key]
      ,[client_address_name]
      ,[client_address_line1]
      ,[client_address_line2]
      ,[client_address_line3]
      ,[client_address_suburb]
      ,[client_address_town_or_city]
      ,[client_address_post_code]
      ,[client_address_created_date_key]
      ,[client_address_start_date_key]
      ,[client_address_end_date_key]
      ,[client_address_is_postal_flag]
      ,[client_address_is_primary_flag]
   )
   select
	   src.[client_id]
      ,src.[client_address_id]
      ,[company_key]
	  ,cast(src.client_address_id as nvarchar) +'_'+cast(src.[company_key] as nvarchar)
      ,src.[client_address_name]
      ,src.[client_address_line1]
      ,src.[client_address_line2]
      ,src.[client_address_line3]
      ,src.[client_address_suburb]
      ,src.[client_address_town_or_city]
      ,LEFT(src.[client_address_post_code],4)
      ,src.[client_address_created_date]
      ,src.[client_address_start_date]
      ,src.[client_address_end_date]
      ,src.[client_address_is_postal_indicator]
      ,src.[client_address_is_primary_indicator]
from [Landing].[edw_fact_client_address_history] as src