
CREATE PROC staging.insert_staging_fact_property_rent_charges

AS
/***************************************************************************
NAME:     staging.insert_staging_fact_property_rent_charges
PURPOSE:  Provide market rent history in the datawarehouse

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-11-10    Greg Nuthall		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE Staging.ODSETLfact_property_rent_charges

-- insert data from landing table into staging table
INSERT INTO Staging.ODSETLfact_property_rent_charges (
	 rent_charge_id 
	,dim_property_key
	,dim_employee_key
	,dim_company_key
	,rent_charge_name 
	,property_id 
	,property_name 
	,provider_name 
	,company_name 
	,agreed_rent 
	,market_rent 
	,supplement_amount 
	,[start_date]
	,end_date 
	,employee_name 
	,employee_id 
	)
SELECT
	 r.rent_charge_id 
	,case 
		when isnull(r.property_name,'') = '' then 0 
		when isnull(p.dim_property_key,0) = 0 then -1
		else p.dim_property_key
	end as dim_property_key
	,case 
		when isnull(e.employee_primary_email_address,'') = '' then 0 
		when isnull(e.dim_employee_key,0) = 0 then -1
		else e.dim_employee_key
	end as dim_employee_key
	,case 
		when isnull(r.company_name,'') = '' then 0 
		when isnull(c.dim_company_key,0) = 0 then -1
		else c.dim_company_key
	end as dim_company_key

	,r.rent_charge_name 
	,r.property_id 
	,r.property_name 
	,r.provider_name 
	,r.company_name 
	,r.agreed_rent 
	,r.market_rent 
	,r.supplement_amount 
	,r.[start_date] 
	,r.end_date 
	,r.employee_name 
	,case 
		when isnull(e.employee_primary_email_address,'') = '' then 0 
		when isnull(e.employee_id,0) = 0 then -1
		else e.employee_id
	end as employee_id
from landing.edw_fact_property_rent_charges r
left outer join edw.dim_employee e 
	on r.employee_email = e.employee_primary_email_address and e.DWHIsCurrent = 1
left outer join reference.EDW_Lookup cl 
	on r.company_name = cl.Input_Value and cl.Category like '%company%'
left outer join edw.dim_company c 
	on isnull(cl.output_value,r.company_name) = c.company_name
left outer join edw.dim_property p
	on r.property_id = p.property_id and p.DWHIsCurrent = 1