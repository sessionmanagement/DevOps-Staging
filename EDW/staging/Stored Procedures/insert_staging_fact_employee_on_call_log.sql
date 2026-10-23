
CREATE PROC [staging].[insert_staging_fact_employee_on_call_log]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_employee_on_call_log]

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-08-11    Greg Nuthall		Initial version
1.1      2026-09-02    Greg Nuthall     Changed dates to NZT
****************************************************************************/


create table #employee_current
    (employee_id      INT           NOT NULL
    ,dim_employee_key INT           NOT NULL
    ,email_address    NVARCHAR(120) NOT NULL
    ,employee_name    NVARCHAR(80)  NOT NULL);

;WITH ranked_employee AS
(
    SELECT
         e.employee_id
        ,e.dim_employee_key
        ,e.employee_primary_email_address AS email_address
        ,e.employee_name
        ,ROW_NUMBER() OVER (
            PARTITION BY e.employee_primary_email_address
            ORDER BY
                 CASE WHEN e.DWHDMLOperation <> 'D' THEN 0 ELSE 1 END  -- prefer active over deleted
                ,e.DWHEffectiveFrom DESC                                -- most recent record wins ties
                ,e.dim_employee_key DESC                                -- deterministic final tiebreak
         ) AS row_num
    FROM edw.dim_employee e
    WHERE e.DWHIsCurrent = 1
      AND e.employee_primary_email_address IS NOT NULL
      AND LTRIM(RTRIM(e.employee_primary_email_address)) <> ''
)
INSERT INTO #employee_current (employee_id, dim_employee_key, email_address, employee_name)
SELECT employee_id, dim_employee_key, email_address, employee_name
FROM ranked_employee
WHERE row_num = 1;

-- Fail fast instead of silently fanning out joins if a duplicate ever slips through again
CREATE UNIQUE CLUSTERED INDEX IX_employee_current_email ON #employee_current(email_address);

CREATE INDEX IX_employee_current_employee_name ON #employee_current(employee_name);


--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_employee_on_call_log]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_employee_on_call_log] (
	  
	  [dim_region_key]
      ,[dim_service_key]
      ,[dim_employee_key]
	  ,[dim_employee_escalated_to_key]
      ,[dim_employee_on_call_key]
      ,[dim_call_date_key]
      ,[on_call_id]
      ,[call_date_time]
      ,[region_id]
      ,[region_original_name]
      ,[service_id]
      ,[service_original_name]
      ,[category_id]
      ,[category_name]
      ,[call_received_from]
      ,[extra_time]
      ,[incident_report_required]
      ,[escalated_to_another_tier]
      ,[employee_escalated_to_id]
      ,[shift_covered]
      ,[hours_covered]
      ,[event_status]
      ,[employee_on_call_id]
      ,[travel_time]
      ,[over_96_hours]
      ,[shift_covered_kaimahi]
      ,[created_date_time]
      ,[call_duration]
	)
SELECT
	
	case when isnull(l.region_name,'') = '' then 0 else isnull(rg.dim_region_key,-1) end as dim_region_key
	,case when isnull(l.[service_name],'') = '' then 0 else isnull(svc.dim_service_key,-1) end as dim_service_key
	,case when isnull([created_by],'') = '' then 0 else isnull(em.dim_employee_key,-1) end as dim_employee_key
	,case when isnull(escalated_to_id,0) = 0 then 0 else isnull(isnull(ee.dim_employee_key,eeid.dim_employee_key),-1) end as dim_employee_escalated_to_key
	,case when isnull(on_call_staff_member_id,0) = 0 then 0 else isnull(oce.dim_employee_key,-1) end as dim_employee_on_call_key
	,case when isnull(call_date_time,'1900-01-01') = '1900-01-01' then 0 else CAST(CONVERT(char(8), call_date_time, 112) AS int) end as dim_call_date_key
    --,[on_call_staff_member_email] 
	,[on_call_id] 
	,cast([call_date_time] AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS datetime2(7))  as call_date_time
    --,[call_date_time] 
	,l.[region_id] 
	,l.[region_name] 
	,isnull(svc.service_id,0) as service_id
	,l.[service_name] 
	,[category_id] 
	,[category_name] 
	,[call_received_from] 
	,[extra_time] 
	,[incident_report_required] 
	,[escalated_to_another_tier] 
	,[escalated_to_id] 
	,[shift_covered] 
	,[hours_covered] 
	,[event_status] 
	,[on_call_staff_member_id] 
	,[travel_time] 
	,[over_96_hours] 
	,[shift_covered_kaimahi] 
	--,[created_by] 
	--[created_date_time] 
    ,cast(created_date_time AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS datetime2(7))  as created_date_time
    ,[call_duration]
from [Landing].[edw_fact_employee_on_call_log] l

--lookup on call employee 
left outer join reference.EDW_Lookup elk on l.[created_by]  = elk.Input_Value and elk.Category = 'on_call.employee_name'
left outer join #employee_current em on ISNULL(elk.output_value,l.[created_by] ) = em.employee_name 

--lookup escalated to employee
left outer join reference.EDW_Lookup eelk on l.[escalated_to_email] = eelk.Input_Value and eelk.Category = 'on_call.employee_email'
left outer join #employee_current ee on ISNULL(eelk.output_value,l.[escalated_to_email]) = ee.email_address 

--lookup escalated to id
left outer join reference.EDW_Lookup elid on l.[escalated_to_id] = elid.Input_Value and elid.Category = 'on_call.employee_id'
left outer join #employee_current eeid on ISNULL(elid.output_value,l.[escalated_to_email]) = eeid.email_address 

--lookup on call employee 
left outer join reference.EDW_Lookup ocelk on l.[on_call_staff_member_email]  = ocelk.Input_Value and ocelk.Category = 'on_call.employee_email'
left outer join #employee_current oce on ISNULL(ocelk.output_value,l.[on_call_staff_member_email] ) = oce.email_address 

--Lookup region
left outer join reference.EDW_Lookup rgn on l.[region_name] = rgn.Input_Value and rgn.Category = 'dim_region'
left outer join edw.dim_region rg on ISNULL(rgn.output_value,l.[region_name]) = rg.region_code and rg.DWHIsCurrent = 1 and rg.region_company_name = 'Emerge Aotearoa Limited'

--Lookup service
left outer join reference.EDW_Lookup svl on l.[service_name] = svl.Input_Value and svl.Category = 'on_call.service_name'
left outer join edw.dim_service svc on ISNULL(svl.output_value,l.[service_name]) = svc.[service_name] and svc.DWHIsCurrent = 1 and svc.company_name = 'Emerge Aotearoa Limited'