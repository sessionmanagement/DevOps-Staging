
CREATE PROC [staging].[insert_staging_dim_property_breach_type]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_property_breach_type]
PURPOSE:  

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-07-20    Greg Nuthall		Initial version
****************************************************************************/

--  clear the staging table before loading
truncate table [Staging].[ODSETLdim_property_breach_type]

-- insert data from landing table into staging table
insert into [Staging].[ODSETLdim_property_breach_type] (
	 [breach_type_id] 
	,[breach_type] 
	)

select
	 [breach_type_id] 
	,[breach_type] 
from [Landing].[edw_dim_property_breach_type]