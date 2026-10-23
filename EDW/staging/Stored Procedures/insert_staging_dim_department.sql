

CREATE PROC [staging].[insert_staging_dim_department]

AS
/***************************************************************************
NAME:     [staging].[ODSETLdim_department]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-08-03    ?				Initial version
1.01	 2023-08-25	  Glenn McLeod		Updated table/column names

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_department]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_department] (
	  [department_dimension_value_id]
	, [department_code]
	, [department_name]
	, [department_company_name]
	, [department_last_modified_date_time]
	, [DWHDMLOperation]
	, [DWHIsCurrent]
	, [DWHEffectiveFrom]
	, [DWHEffectiveTo]
	)
SELECT
	 [Dimension_Value_ID] 
	,[Code] 
	,[Name] 
	,[__CompanyName] 
	,[Last_Modified_Date_Time] 
	,[ODSDMLOperation] 
	,[ODSIsCurrent] 
	,[ODSEffectiveFrom] 
	,[ODSEffectiveTo] 
from [Landing].[edw_dim_department]