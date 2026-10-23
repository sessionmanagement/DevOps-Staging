CREATE   procedure [staging].[insert_staging_fact_employee_qualification]

    AS

    /***************************************************************************
    NAME:     [staging].[insert_staging_fact_employee_qualification]
    PURPOSE:  Used to build the edw.fact_employee_qualification table

    REVISIONS:
    Version	 Date		   Author			Description
    -------	 ------------  ---------------	--------------------------
    1.0		 2025-07-27    Greg Nuthall		Initial version
    1.1      2025-08-04    Greg Nuthall    Fixed duplicate records issue caused by multiple service codes
    											(e.g., ''HAVEN CAFÉ'' vs ''HAVEN CAFE'') by prioritizing active services
    											(is_inactive = 0) and handling character variations
    1.2      2026-09-18    Malhar Badheka  Added employee_qualification_requirement_flag
    ****************************************************************************/

    begin

    --  clear the staging table before loading
    	TRUNCATE TABLE [Staging].[ODSETLfact_employee_qualification]

    -- insert data from landing table into staging table
    	INSERT INTO [Staging].[ODSETLfact_employee_qualification] 
    	([qualification_instance_id] 
    	,[dim_employee_key]
    	,[dim_service_key]
    	,[dim_company_key]
    	,[dim_employee_qualification_library_key]
    	,[dim_employee_qualification_type_key]
    	,[expiry_date] 
    	,[issue_date] 
    	,[issuing_organisation] 
    	,[notes] 
    	,[employee_id] 
    	,[service_name] 
    	,[company_name]
    	,[person_link] 
    	,[qualification_status] 
    	,[employee_qualification_library_id] 
    	,[employee_qualification_requirement_flag]
    	,[employee_qualification_type_id] 
    	,[qualification_library_item_link] 
    	,[registration_number] 
    	)

    	select
    		 lq.[qualification_instance_id]
    		,isnull(em.[dim_employee_key],case when isnull(lq.employee_id,0) = 0 then 0 else -1 end) as dim_employee_key
    		,isnull(ds.[dim_service_key],case when isnull(lq.[service_name],'') = '' then 0 else -1 end) as dim_service_key
    		,isnull(cmp.[dim_company_key],case when isnull(lq.[company_name],'') = '' then 0 else -1 end) as dim_company_key
    		,isnull(qul.[dim_employee_qualification_library_key]
    					, case 
    						when isnull(lq.employee_qualification_library_id,'') = '' then 0 
    						else -1 
    					end) as dim_employee_qualification_library_key
    		,isnull(qt.[dim_employee_qualification_type_key]
    					,case 
    						when isnull(lq.employee_qualification_type_id,'') = '' then 0 
    						else -1 
    					 end) as dim_employee_qualification_type_key
    		,lq.[expiry_date]
    		,lq.[issue_date]
    		,lq.[issuing_organisation]
    		,lq.[notes]
    		,lq.[employee_id]
    		,isnull(slk.output_value,lq.[service_name]) as [service_name]
    		,isnull(clk.output_Value,lq.[company_name]) as company_name
    		,lq.[person_link]
    		,lq.[qualification_status]
    		,lq.[employee_qualification_library_id]
    		,lq.[employee_qualification_requirement_flag]
    		,lq.[employee_qualification_type_id]
    		,lq.[qualification_library_item_link]
    		,lq.[registration_number]

    	from [Landing].[edw_fact_employee_qualification] lq

    	left outer join edw.dim_employee em 
    		on lq.employee_id = em.employee_id 
    		and em.DWHIsCurrent = 1 
    	left outer join reference.edw_lookup clk 
    			on lq.[company_name] = Cast(clk.Input_Value as nvarchar(200))
    			and clk.Category = 'dim_employee.employee_company_name'
    	left outer join reference.edw_lookup slk 
    			on lq.[service_name] = Cast(slk.Input_Value as nvarchar(200))
    			and slk.Category = 'dim_service.service_code'
    	-- Fixed service join to handle duplicate service codes with character variations
    	-- Prioritizes active services (is_inactive = 0) and handles accented characters
    	left outer join (
    		SELECT * 
    		FROM (
    			SELECT 
    				dim_service_key, 
    				service_code, 
    				[service_name], 
    				company_name,
    				is_inactive,
    				ROW_NUMBER() OVER (
    					PARTITION BY REPLACE(service_code, 'É', 'E'), [service_name], company_name  
    					ORDER BY is_inactive ASC  -- Active services (0) come first
    				) as row_rank
    			FROM [edw].[dim_service] s 
    			WHERE DWHIsCurrent = 1
    		) ranked_services
    		WHERE row_rank = 1  -- Only take the highest priority service (active over inactive)
    	) as ds
    		on isnull(slk.output_value,lq.[service_name])=ds.[service_name] 
    		and isnull(clk.Output_Value,lq.[company_name])=ds.[company_name]
    		
    	left outer join edw.dim_company cmp
    			on isnull(clk.Output_Value,lq.[company_name])=cmp.[company_name]
    			and cmp.DWHIsCurrent = 1
    	left outer join edw.dim_employee_qualification_library qul
    		on lq.employee_qualification_library_id = qul.employee_qualification_library_id 
    		and qul.DWHIsCurrent = 1
    	left outer join edw.dim_employee_qualification_type qt
    		on lq.employee_qualification_type_id = qt.employee_qualification_type_id 
    		and qt.DWHIsCurrent = 1

    end