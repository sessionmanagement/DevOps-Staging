





--DROP PROCEDURE [edw].[Updateedwfact_employee_remuneration26062025]

/**********************************************************************************************************
Procedure	edw.[Updateedwfact_employee_remuneration]
Author		Manish Singh
Created		2024/01/15
Purpose		Move data from landing.fact_employee_remuneratioralr table into
			staging.mployee_remuneratio table
				
Notes: Call By	EDW Pipeline '30_Load_From_ODS'
Parameter(s)  None 
=========================================================================================================
REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		2024/01/15     Manish Singh	Initial version
2.0     2024-02-13	   Manish Singh	        Added location and ethnicity information
3.0		2024/02/19		Manish singh	    Drop columns from edw tables for which we have dim keys
4.0		2024/02/21		Manish Singh		Adjust SP logic to accomodate update record
4.1     2024/05/30      Greg Nuthall		Modified source join to dim_service to include company name
4.2		2025/01/20      Greg Nuthall		Added all id's into the update and insert queries
4.3	    2025/04/15      Greg Nuthall	    Changed hardcoded -1 to 0	
4.4     2025/06/27      Manish Singh		Adding missing columns in update part of query
4.5     2025/07/09      Manish Singh        Adding missing business key coulmns in except statement
5.0     2026/03/13      Pankaj Bhatt        Updated to include location key from IntelliHR data
	
**********************************************************************************************************/

CREATE procedure [edw].[Updateedwfact_employee_remuneration] 
	@pBatchID int, 
	@pIndexRebuildThreshold int,
	@pOutputParamsAsDataset int = 0,
	@pErrorRecords int = null OUTPUT, 
	@pInsertRecords int = null OUTPUT, 
	@pUpdateRecords int = null OUTPUT, 
	@pDeleteRecords int = null OUTPUT,
	@pCompleted int = null OUTPUT,
	@pTargetRecords int = null OUTPUT,
	@pErrorMessage varchar(MAX) = null OUTPUT
as begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = '[ETL].[fact_employee_remuneration]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	declare @SystemEffectiveFrom datetime = @systemCurrentDate;
	declare @SystemEffectiveTo datetime = dateadd(second,-1,@SystemEffectiveFrom);
	declare @SystemDefaultEffectiveFrom datetime = '1 January 1900';
	declare @SystemDefaultEffectiveTo datetime = '31 December 2999 23:59:59';

	-- Do not run if there are no records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_employee_remuneration];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_employee_remuneration];

		-- Select success details
		select
			 @pErrorRecords = 0
			,@pInsertRecords = 0
			,@pUpdateRecords = 0
			,@pDeleteRecords = 0
			,@pCompleted = 1
			,@pTargetRecords = @targetRecords	

		if (@pOutputParamsAsDataset = 1)
		begin
			-- Select return parameters as a dataset
			select @pErrorRecords	as ErrorRecords,
					@pInsertRecords as InsertRecords,
					@pUpdateRecords as UpdateRecords,
					@pDeleteRecords as DeleteRecords,
					@pCompleted		as Completed,
					@targetRecords	as TargetRecords,
					@pErrorMessage as ErrorMessage;
		end;

		return;
	end;

	if( object_id( 'tempdb..#SummaryOfChanges') is not null ) drop table #SummaryOfChanges;
	create table #SummaryOfChanges
	(	
		 [fact_employee_remuneration_job_key] nvarchar(360) not null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[fact_employee_remuneration]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_employee_remuneration]
			(
            [dim_Company_Key]
           ,[dim_Location_Key]
           ,[dim_employee_key]
           ,[dim_service_key]
           ,[dim_ethnicity_key]
           --,[dim_ethnicity_secondary_key]
           --,[dim_ethnicity_tertiary_key]
           ,[dim_role_hierarchy_key]
           ,[dim_people_hierarchy_key]
           ,[dim_payroll_categories_key]
           ,[dim_job_start_date_key]
           ,[dim_job_end_date_key]
           ,[dim_position_start_date_key]
           ,[dim_position_end_date_key]
           ,[fact_employee_remuneration_job_key]
           ,[fact_employee_remuneration_employee_Number]
           ,[fact_employee_remuneration_businessEntity_id]
           ,[fact_employee_remuneration_businessUnit_id]
           ,[fact_employee_remuneration_location_id]
           ,[fact_employee_remuneration_recruitment_cost]
           ,[fact_employee_remuneration_recruitment_currency]
           ,[fact_employee_remuneration_recruitment_source_name]
           ,[fact_employee_remuneration_pay_grade_name]
           ,[fact_employee_remuneration_pay_grade_code]
           ,[fact_employee_remuneration_establishment_name]
           ,[fact_employee_remuneration_schedule_type]
           ,[fact_employee_remuneration_schedule_currency]
           ,[fact_employee_remuneration_schedule_hours_per_cycle]
           ,[fact_employee_remuneration_schedule_pay_cycle]
           ,[fact_employee_remuneration_schedule_annual_package]
           ,[fact_employee_remuneration_schedule_hourly_package]
           ,[fact_employee_remuneration_schedule_base_annual_salary]
           ,[fact_employee_remuneration_schedule_base_hourly_rate]
           ,[fact_employee_remuneration_schedule_currency_conversion_occurred]
           ,[fact_employee_remuneration_schedule_employment_condition_name]
           ,[fact_employee_remuneration_job_title]
           ,[fact_employee_remuneration_job_status]
           ,[fact_employee_remuneration_position_StartDate]
           ,[fact_employee_remuneration_Position]
           ,[fact_employee_remuneration_fte]
           ,[fact_employee_remuneration_work_type]
           ,[fact_employee_remuneration_work_class]
           ,[fact_employee_remuneration_primary_job_indicator]
           ,[fact_employee_remuneration_company_StartDate]
           ,[fact_employee_remuneration_company_EndDate]
           ,[fact_employee_remuneration_end_date_confirmed_indicator]
           ,[fact_employee_remuneration_turnover_type]
           ,[fact_employee_remuneration_turnover_reason]
           ,[fact_employee_remuneration_created_at]
           ,[fact_employee_remuneration_maori_indicator]
           ,[fact_employee_remuneration_pasifika_indicator]
				,[DWHSourceSystem]
				,[DWHBatchId]
				,[DWHDMLOperation]
				,[DWHIsCurrent]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
						)
			select
				isnull(dc.dim_company_key,CASE WHEN SRC.fact_employee_remuneration_businessEntity_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_company_key
				,isnull(dl.dim_location_key,CASE WHEN SRC.[fact_employee_remuneration_location_id] IS NOT NULL THEN -1 ELSE 0 END) AS  [dim_Location_Key] 
				,isnull(de.dim_employee_key,CASE WHEN SRC.fact_employee_remuneration_employee_Number IS NOT NULL THEN -1 ELSE 0 END) AS [dim_employee_key] 
				,isnull(ds.dim_service_key,case when src.fact_employee_remuneration_businessUnit_id is not null then -1 else 0 end) as [dim_service_key] 
				,isnull(de1.dim_ethnicity_key,case when src.fact_employee_remuneration_concatenated_ethnicity_id is not null then -1 else 0 end) as dim_ethnicity_key 
				--,isnull(de2.dim_ethnicity_key,case when src.fact_employee_remuneration_secondary_ethnicity_id is not null then -1 else 0 end) as dim_ethnicity_secondary_key 
				--,isnull(de3.dim_ethnicity_key,case when src.fact_employee_remuneration_tertiary_ethnicity_id is not null then -1 else 0 end) as dim_ethnicity_tertiary_key 
				,0 [dim_role_hierarchy_key] 
				,isnull(deh.dim_employee_hierarchy_key,case when src.fact_employee_remuneration_employee_Number is not null then -1 else 0 end) as dim_people_hierarchy_key 
				,0 as [dim_payroll_categories_key] 
				,isnull(dim_job_start_date.dim_date_key,19000101) as [dim_job_start_date_key] 
				,isnull(dim_job_end_date.dim_date_key,29991231) as dim_job_end_date_key 
				,isnull(dim_position_start_date.dim_date_key,19000101) as   dim_position_start_date_key
				,CASE WHEN dim_position_end_date.dim_date_key is null or dim_position_end_date.dim_date_key=19000101 then 29991231 else dim_position_end_date.dim_date_key end as dim_position_end_date_key
				, src.[fact_employee_remuneration_job_key]
      ,src.[fact_employee_remuneration_employee_Number]
      ,src.[fact_employee_remuneration_businessEntity_id]
      ,src.[fact_employee_remuneration_businessUnit_id]
      ,src.[fact_employee_remuneration_location_id]
      ,src.[fact_employee_remuneration_recruitment_cost]
      ,src.[fact_employee_remuneration_recruitment_currency]
      ,src.[fact_employee_remuneration_recruitment_source_name]
      ,src.[fact_employee_remuneration_pay_grade_name]
      ,src.[fact_employee_remuneration_pay_grade_code]
      ,src.[fact_employee_remuneration_establishment_name]
      ,src.[fact_employee_remuneration_schedule_type]
      ,src.[fact_employee_remuneration_schedule_currency]
      ,src.[fact_employee_remuneration_schedule_hours_per_cycle]
      ,src.[fact_employee_remuneration_schedule_pay_cycle]
      ,src.[fact_employee_remuneration_schedule_annual_package]
      ,src.[fact_employee_remuneration_schedule_hourly_package]
      ,src.[fact_employee_remuneration_schedule_base_annual_salary]
      ,src.[fact_employee_remuneration_schedule_base_hourly_rate]
      ,src.[fact_employee_remuneration_schedule_currency_conversion_occurred]
      ,src.[fact_employee_remuneration_schedule_employment_condition_name]
      ,src.[fact_employee_remuneration_job_title]
      ,src.[fact_employee_remuneration_job_status]
      ,src.[fact_employee_remuneration_position_StartDate]
      ,src.[fact_employee_remuneration_Position]
      ,src.[fact_employee_remuneration_fte]
      ,src.[fact_employee_remuneration_work_type]
      ,src.[fact_employee_remuneration_work_class]
      ,src.[fact_employee_remuneration_primary_job_indicator]
      ,src.[fact_employee_remuneration_company_StartDate]
      ,src.[fact_employee_remuneration_company_EndDate]
      ,src.[fact_employee_remuneration_end_date_confirmed_indicator]
      ,src.[fact_employee_remuneration_turnover_type]
      ,src.[fact_employee_remuneration_turnover_reason]
      ,src.[fact_employee_remuneration_created_at]
      ,case when de1.ethnicity_group='Maori'  then 1 else 0 end as  [fact_employee_remuneration_maori_indicator]
      ,case when de1.ethnicity_group='Pasifika'  then 1 else 0 end as  [fact_employee_remuneration_pasifika_indicator]
				,@SourceSystem as [DWHSourceSystem]
				,@BatchID as [DWHBatchId]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SystemEffectiveFrom as [DWHEffectiveFrom]
				,@SystemDefaultEffectiveTo as [DWHEffectiveTo]
			  --,@systemCurrentDate as [DWHModifiedOn]
			from [Staging].[ODSETLfact_employee_remuneration] as src
						LEFT OUTER JOIN  [edw].[dim_company] AS dc
              on src.fact_employee_remuneration_businessEntity_id=dc.dim_company_intellihr_key and dc.DWHIsCurrent=1
			  left outer join edw.dim_employee as de
			  on src.fact_employee_remuneration_employee_Number=de.employee_id and de.DWHIsCurrent=1
			  left outer join edw.dim_service as ds 
			  --on src.fact_employee_remuneration_businessUnit_id=ds.intellihr_service_id and ds.DWHIsCurrent=1  old join without company
			  on src.fact_employee_remuneration_businessUnit_id=ds.intellihr_service_id and dc.company_name = ds.company_name and ds.DWHIsCurrent=1
			  left outer join edw.dim_ethnicity as de1 
			  on src.[fact_employee_remuneration_concatenated_ethnicity_id]=de1.dim_ethnicity_id  -- or src.fact_employee_remuneration_primary_ethnicity_id=de1.[ethnicity_level1] or src.fact_employee_remuneration_primary_ethnicity_id=de1.[ethnicity_level2]
			  left outer join (select intelliHR_location_id,max(dim_location_key) as dim_location_key from  edw.dim_location_new where DWHIsCurrent=1
                                group by intelliHR_location_id) as dl 
			  on src.[fact_employee_remuneration_location_id]=dl.intelliHR_location_id 
			 
			 --left outer join  edw.dim_ethnicity as de2 
			  --on src.fact_employee_remuneration_secondary_ethnicity_id=replace(de2.dim_ethnicity_id,'|','') --or src.fact_employee_remuneration_secondary_ethnicity_id=de2.[ethnicity_level1] or src.fact_employee_remuneration_secondary_ethnicity_id=de1.[ethnicity_level2]
			  --   left outer join  edw.dim_ethnicity as de3 
				 --  on src.fact_employee_remuneration_tertiary_ethnicity_id=replace(de3.dim_ethnicity_id,'|','') --or src.fact_employee_remuneration_tertiary_ethnicity_id=de3.[ethnicity_level1] or src.fact_employee_remuneration_tertiary_ethnicity_id=de3.[ethnicity_level2]
			  			   			   left outer join [edw].[dim_employee_hierarchy] as deh
			   on src.fact_employee_remuneration_employee_Number=deh.employee_id and deh.DWHIsCurrent=1
			   left outer join edw.dim_date as dim_job_start_date 
			   on cast(src.fact_employee_remuneration_position_StartDate as date)=cast(dim_job_start_date.calendar_date as date)
			   			   left outer join edw.dim_date as dim_job_end_date 
			   on cast(src.fact_employee_remuneration_company_EndDate as date)=cast(dim_job_end_date.calendar_date as date)
			   			   			   left outer join edw.dim_date as  dim_position_start_date 
			   on cast(src.fact_employee_remuneration_position_StartDate as date)=cast( dim_position_start_date.calendar_date as date)
			   			   			   			   left outer join edw.dim_date as  dim_position_end_date 
			   on cast(src.fact_employee_remuneration_Position as date)=cast( dim_position_end_date.calendar_date as date)
			
					
			;
		end else begin
			merge into [edw].[fact_employee_remuneration] as trg
			using 
			(
				select
				isnull(dc.dim_company_key,CASE WHEN SRC.fact_employee_remuneration_businessEntity_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_company_key
				,isnull(dl.dim_location_key,CASE WHEN SRC.[fact_employee_remuneration_location_id] IS NOT NULL THEN -1 ELSE 0 END) AS  [dim_Location_Key] 
				,isnull(de.dim_employee_key,CASE WHEN SRC.fact_employee_remuneration_employee_Number IS NOT NULL THEN -1 ELSE 0 END) AS [dim_employee_key] 
				,isnull(ds.dim_service_key,case when src.fact_employee_remuneration_businessUnit_id is not null then -1 else 0 end) as [dim_service_key] 
				,isnull(de1.dim_ethnicity_key,case when src.fact_employee_remuneration_concatenated_ethnicity_id is not null then -1 else 0 end) as dim_ethnicity_key 
				--,isnull(de2.dim_ethnicity_key,case when src.fact_employee_remuneration_secondary_ethnicity_id is not null then -1 else 0 end) as dim_ethnicity_secondary_key 
				--,isnull(de3.dim_ethnicity_key,case when src.fact_employee_remuneration_tertiary_ethnicity_id is not null then -1 else 0 end) as dim_ethnicity_tertiary_key 
				,0 [dim_role_hierarchy_key] 
				,isnull(deh.dim_employee_hierarchy_key,case when src.fact_employee_remuneration_employee_Number is not null then -1 else 0 end) as dim_people_hierarchy_key 
				,0 as [dim_payroll_categories_key] 
				,isnull(dim_job_start_date.dim_date_key,19000101) as [dim_job_start_date_key] 
				,isnull(dim_job_end_date.dim_date_key,29991231) as dim_job_end_date_key 
				,isnull(dim_position_start_date.dim_date_key,19000101) as   dim_position_start_date_key
				,CASE WHEN dim_position_end_date.dim_date_key is null or dim_position_end_date.dim_date_key=19000101 then 29991231 else dim_position_end_date.dim_date_key end as dim_position_end_date_key
				, src.[fact_employee_remuneration_job_key]
      ,src.[fact_employee_remuneration_employee_Number]
      ,src.[fact_employee_remuneration_businessEntity_id]
      ,src.[fact_employee_remuneration_businessUnit_id]
      ,src.[fact_employee_remuneration_location_id]
      ,src.[fact_employee_remuneration_recruitment_cost]
      ,src.[fact_employee_remuneration_recruitment_currency]
      ,src.[fact_employee_remuneration_recruitment_source_name]
      ,src.[fact_employee_remuneration_pay_grade_name]
      ,src.[fact_employee_remuneration_pay_grade_code]
      ,src.[fact_employee_remuneration_establishment_name]
      ,src.[fact_employee_remuneration_schedule_type]
      ,src.[fact_employee_remuneration_schedule_currency]
      ,src.[fact_employee_remuneration_schedule_hours_per_cycle]
      ,src.[fact_employee_remuneration_schedule_pay_cycle]
      ,src.[fact_employee_remuneration_schedule_annual_package]
      ,src.[fact_employee_remuneration_schedule_hourly_package]
      ,src.[fact_employee_remuneration_schedule_base_annual_salary]
      ,src.[fact_employee_remuneration_schedule_base_hourly_rate]
      ,src.[fact_employee_remuneration_schedule_currency_conversion_occurred]
      ,src.[fact_employee_remuneration_schedule_employment_condition_name]
      ,src.[fact_employee_remuneration_job_title]
      ,src.[fact_employee_remuneration_job_status]
      ,src.[fact_employee_remuneration_position_StartDate]
      ,src.[fact_employee_remuneration_Position]
      ,src.[fact_employee_remuneration_fte]
      ,src.[fact_employee_remuneration_work_type]
      ,src.[fact_employee_remuneration_work_class]
      ,src.[fact_employee_remuneration_primary_job_indicator]
      ,src.[fact_employee_remuneration_company_StartDate]
      ,src.[fact_employee_remuneration_company_EndDate]
      ,src.[fact_employee_remuneration_end_date_confirmed_indicator]
      ,src.[fact_employee_remuneration_turnover_type]
      ,src.[fact_employee_remuneration_turnover_reason]
      ,src.[fact_employee_remuneration_created_at]
      ,case when de1.ethnicity_group='Maori'  then 1 else 0 end as  [fact_employee_remuneration_maori_indicator]
      ,case when de1.ethnicity_group='Pasifika'  then 1 else 0 end as  [fact_employee_remuneration_pasifika_indicator]	
	  	,@SourceSystem as [DWHSourceSystem]
	  ,@BatchID as [DWHBatchId]
	  ,'I' as [DWHDMLOperation]
	  	,1 as [DWHIsCurrent]
				,@SystemEffectiveFrom as [DWHEffectiveFrom]
				,@SystemDefaultEffectiveTo as [DWHEffectiveTo]
				
			
			
			from [Staging].[ODSETLfact_employee_remuneration] as src
						LEFT OUTER JOIN  [edw].[dim_company] AS dc
              on src.fact_employee_remuneration_businessEntity_id=dc.dim_company_intellihr_key and dc.DWHIsCurrent=1
			  left outer join edw.dim_employee as de
			  on src.fact_employee_remuneration_employee_Number=de.employee_id and de.DWHIsCurrent=1
			  left outer join edw.dim_service as ds 
			  --on src.fact_employee_remuneration_businessUnit_id=ds.intellihr_service_id  and ds.DWHIsCurrent=1
			  on src.fact_employee_remuneration_businessUnit_id=ds.intellihr_service_id and dc.company_name = ds.company_name and ds.DWHIsCurrent=1
			  left outer join edw.dim_ethnicity as de1 
			  on src.[fact_employee_remuneration_concatenated_ethnicity_id]=de1.dim_ethnicity_id  -- or src.fact_employee_remuneration_primary_ethnicity_id=de1.[ethnicity_level1] or src.fact_employee_remuneration_primary_ethnicity_id=de1.[ethnicity_level2]
			  left outer join    (select intelliHR_location_id,max(dim_location_key) as dim_location_key from  edw.dim_location_new where DWHIsCurrent=1
                                group by intelliHR_location_id) as dl  
			  on src.[fact_employee_remuneration_location_id]=dl.intelliHR_location_id
			  				
			 --left outer join  edw.dim_ethnicity as de2 
			  --on src.fact_employee_remuneration_secondary_ethnicity_id=replace(de2.dim_ethnicity_id,'|','') --or src.fact_employee_remuneration_secondary_ethnicity_id=de2.[ethnicity_level1] or src.fact_employee_remuneration_secondary_ethnicity_id=de1.[ethnicity_level2]
			  --   left outer join  edw.dim_ethnicity as de3 
				 --  on src.fact_employee_remuneration_tertiary_ethnicity_id=replace(de3.dim_ethnicity_id,'|','') --or src.fact_employee_remuneration_tertiary_ethnicity_id=de3.[ethnicity_level1] or src.fact_employee_remuneration_tertiary_ethnicity_id=de3.[ethnicity_level2]
			  			   			   left outer join [edw].[dim_employee_hierarchy] as deh
			   on src.fact_employee_remuneration_employee_Number=deh.employee_id and deh.DWHIsCurrent=1
			   left outer join edw.dim_date as dim_job_start_date 
			   on cast(src.fact_employee_remuneration_position_StartDate as date)=cast(dim_job_start_date.calendar_date as date)
			   			   left outer join edw.dim_date as dim_job_end_date 
			   on cast(src.fact_employee_remuneration_company_EndDate as date)=cast(dim_job_end_date.calendar_date as date)
			   			   			   left outer join edw.dim_date as  dim_position_start_date 
			   on cast(src.fact_employee_remuneration_position_StartDate as date)=cast( dim_position_start_date.calendar_date as date)
			   			   			   			   left outer join edw.dim_date as  dim_position_end_date 
			   on cast(src.fact_employee_remuneration_Position as date)=cast( dim_position_end_date.calendar_date as date)
			
			) as src on (src.[fact_employee_remuneration_job_key] = trg.[fact_employee_remuneration_job_key] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)
			       and trg.DWHiscurrent=1
			-- Retire existing records
			when matched and exists 
			( 
				select src.dim_location_key, src.[fact_employee_remuneration_employee_Number],src.[fact_employee_remuneration_businessEntity_id],src.[fact_employee_remuneration_businessUnit_id],src.[fact_employee_remuneration_location_id],src.[fact_employee_remuneration_recruitment_cost], src.[fact_employee_remuneration_recruitment_currency], src.[fact_employee_remuneration_recruitment_source_name], src.[fact_employee_remuneration_pay_grade_name], src.[fact_employee_remuneration_pay_grade_code], src.[fact_employee_remuneration_establishment_name], src.[fact_employee_remuneration_schedule_type], src.[fact_employee_remuneration_schedule_currency], src.[fact_employee_remuneration_schedule_hours_per_cycle], src.[fact_employee_remuneration_schedule_pay_cycle], src.[fact_employee_remuneration_schedule_annual_package], src.[fact_employee_remuneration_schedule_hourly_package], src.[fact_employee_remuneration_schedule_base_annual_salary], src.[fact_employee_remuneration_schedule_base_hourly_rate], src.[fact_employee_remuneration_schedule_currency_conversion_occurred], src.[fact_employee_remuneration_schedule_employment_condition_name], src.[fact_employee_remuneration_job_title], src.[fact_employee_remuneration_job_status], src.[fact_employee_remuneration_Position], src.[fact_employee_remuneration_fte], src.[fact_employee_remuneration_work_type], src.[fact_employee_remuneration_work_class], src.[fact_employee_remuneration_primary_job_indicator],  src.[fact_employee_remuneration_end_date_confirmed_indicator], src.[fact_employee_remuneration_turnover_type], src.[fact_employee_remuneration_turnover_reason], src.[fact_employee_remuneration_created_at], src.[fact_employee_remuneration_maori_indicator], src.[fact_employee_remuneration_pasifika_indicator]--, case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select   trg.dim_location_key, trg.[fact_employee_remuneration_employee_Number],trg.[fact_employee_remuneration_businessEntity_id],trg.[fact_employee_remuneration_businessUnit_id],trg.[fact_employee_remuneration_location_id],trg.[fact_employee_remuneration_recruitment_cost], trg.[fact_employee_remuneration_recruitment_currency], trg.[fact_employee_remuneration_recruitment_source_name], trg.[fact_employee_remuneration_pay_grade_name], trg.[fact_employee_remuneration_pay_grade_code], trg.[fact_employee_remuneration_establishment_name], trg.[fact_employee_remuneration_schedule_type], trg.[fact_employee_remuneration_schedule_currency], trg.[fact_employee_remuneration_schedule_hours_per_cycle], trg.[fact_employee_remuneration_schedule_pay_cycle], trg.[fact_employee_remuneration_schedule_annual_package], trg.[fact_employee_remuneration_schedule_hourly_package], trg.[fact_employee_remuneration_schedule_base_annual_salary], trg.[fact_employee_remuneration_schedule_base_hourly_rate], trg.[fact_employee_remuneration_schedule_currency_conversion_occurred], trg.[fact_employee_remuneration_schedule_employment_condition_name], trg.[fact_employee_remuneration_job_title], trg.[fact_employee_remuneration_job_status], trg.[fact_employee_remuneration_Position], trg.[fact_employee_remuneration_fte], trg.[fact_employee_remuneration_work_type], trg.[fact_employee_remuneration_work_class], trg.[fact_employee_remuneration_primary_job_indicator], trg.[fact_employee_remuneration_end_date_confirmed_indicator], trg.[fact_employee_remuneration_turnover_type], trg.[fact_employee_remuneration_turnover_reason], trg.[fact_employee_remuneration_created_at], trg.[fact_employee_remuneration_maori_indicator], trg.[fact_employee_remuneration_pasifika_indicator]--, 'X'
			) then 
			
			update set 
						   [dim_Company_Key]=src.[dim_Company_Key] --Added as fix
               ,[dim_employee_key]=src.[dim_employee_key] --Added as fix
           ,[dim_service_key]=src.[dim_service_key] --Added as fix
           ,[dim_ethnicity_key]=src.[dim_ethnicity_key] --Added as fix
		    ,[dim_role_hierarchy_key]=src.[dim_role_hierarchy_key] --Added as fix
           ,[dim_people_hierarchy_key]=src.[dim_people_hierarchy_key] --Added as fix
           ,[dim_payroll_categories_key]=src.[dim_payroll_categories_key] --Added as fix
		   ,[dim_Location_Key] = src.[dim_Location_Key]
		  , fact_employee_remuneration_employee_Number = src.fact_employee_remuneration_employee_Number  --Added
           ,fact_employee_remuneration_businessEntity_id = src.fact_employee_remuneration_businessEntity_id  --Added
           ,fact_employee_remuneration_businessUnit_id = src.fact_employee_remuneration_businessUnit_id  --Added
           ,fact_employee_remuneration_location_id = src.fact_employee_remuneration_location_id,  --Added
			
			fact_employee_remuneration_recruitment_cost=src.[fact_employee_remuneration_recruitment_cost],
			fact_employee_remuneration_recruitment_currency= src.[fact_employee_remuneration_recruitment_currency],
			fact_employee_remuneration_recruitment_source_name= src.[fact_employee_remuneration_recruitment_source_name],
			fact_employee_remuneration_pay_grade_name= src.[fact_employee_remuneration_pay_grade_name],
			fact_employee_remuneration_pay_grade_code= src.[fact_employee_remuneration_pay_grade_code],
			fact_employee_remuneration_establishment_name= src.[fact_employee_remuneration_establishment_name],
			fact_employee_remuneration_schedule_type= src.[fact_employee_remuneration_schedule_type],
			fact_employee_remuneration_schedule_currency= src.[fact_employee_remuneration_schedule_currency],
			fact_employee_remuneration_schedule_hours_per_cycle= src.[fact_employee_remuneration_schedule_hours_per_cycle],
			fact_employee_remuneration_schedule_pay_cycle= src.[fact_employee_remuneration_schedule_pay_cycle],
			fact_employee_remuneration_schedule_annual_package= src.[fact_employee_remuneration_schedule_annual_package],
			fact_employee_remuneration_schedule_hourly_package= src.[fact_employee_remuneration_schedule_hourly_package],
			fact_employee_remuneration_schedule_base_annual_salary= src.[fact_employee_remuneration_schedule_base_annual_salary],
			fact_employee_remuneration_schedule_base_hourly_rate= src.[fact_employee_remuneration_schedule_base_hourly_rate],
			fact_employee_remuneration_schedule_currency_conversion_occurred= src.[fact_employee_remuneration_schedule_currency_conversion_occurred],
			fact_employee_remuneration_schedule_employment_condition_name= src.[fact_employee_remuneration_schedule_employment_condition_name],
			fact_employee_remuneration_job_title= src.[fact_employee_remuneration_job_title],
			fact_employee_remuneration_job_status= src.[fact_employee_remuneration_job_status],
			fact_employee_remuneration_position_StartDate = src.[fact_employee_remuneration_position_StartDate],  --Added

			fact_employee_remuneration_Position= src.[fact_employee_remuneration_Position],
			fact_employee_remuneration_fte= src.[fact_employee_remuneration_fte],
			fact_employee_remuneration_work_type= src.[fact_employee_remuneration_work_type],
			fact_employee_remuneration_work_class= src.[fact_employee_remuneration_work_class],
			fact_employee_remuneration_primary_job_indicator= src.[fact_employee_remuneration_primary_job_indicator],

			fact_employee_remuneration_company_StartDate = src.[fact_employee_remuneration_company_StartDate],  --Added
            fact_employee_remuneration_company_EndDate = src.[fact_employee_remuneration_company_EndDate],  --Added


			fact_employee_remuneration_end_date_confirmed_indicator=  src.[fact_employee_remuneration_end_date_confirmed_indicator],
			fact_employee_remuneration_turnover_type= src.[fact_employee_remuneration_turnover_type],
			fact_employee_remuneration_turnover_reason= src.[fact_employee_remuneration_turnover_reason],
			fact_employee_remuneration_created_at= src.[fact_employee_remuneration_created_at],
			fact_employee_remuneration_maori_indicator= src.[fact_employee_remuneration_maori_indicator],
		   fact_employee_remuneration_pasifika_indicator= src.[fact_employee_remuneration_pasifika_indicator]
		   ,[DWHIsCurrent] = 1
			,[DWHSourceSystem] = @SourceSystem
			,[DWHEffectiveTo] = @SystemDefaultEffectiveTo
			,[DWHBatchId] = @BatchID
			,[DWHDMLOperation] = 'U'
			
			-- [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
		when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @systemCurrentDate, [DWHIsCurrent] = 0, [DWHBatchId] = @BatchID
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [dim_Company_Key] 
					,[dim_Location_Key] 
					,[dim_employee_key] 
					,[dim_service_key] 
					,[dim_ethnicity_key] 
					,[dim_role_hierarchy_key] 
					,[dim_people_hierarchy_key] 
					,[dim_payroll_categories_key] 
					,[dim_job_start_date_key] 
					,[dim_job_end_date_key] 
					,[dim_position_start_date_key] 
					,[dim_position_end_date_key] 
					,[fact_employee_remuneration_job_key] 
					,fact_employee_remuneration_employee_Number   --Added
					,fact_employee_remuneration_businessEntity_id   --Added
                    ,fact_employee_remuneration_businessUnit_id  --Added
                    ,fact_employee_remuneration_location_id   --Added
					,[fact_employee_remuneration_recruitment_cost] 
					,[fact_employee_remuneration_recruitment_currency] 
					,[fact_employee_remuneration_recruitment_source_name] 
					,[fact_employee_remuneration_pay_grade_name] 
					,[fact_employee_remuneration_pay_grade_code] 
					,[fact_employee_remuneration_establishment_name] 
					,[fact_employee_remuneration_schedule_type] 
					,[fact_employee_remuneration_schedule_currency] 
					,[fact_employee_remuneration_schedule_hours_per_cycle] 
					,[fact_employee_remuneration_schedule_pay_cycle] 
					,[fact_employee_remuneration_schedule_annual_package] 
					,[fact_employee_remuneration_schedule_hourly_package] 
					,[fact_employee_remuneration_schedule_base_annual_salary] 
					,[fact_employee_remuneration_schedule_base_hourly_rate] 
					,[fact_employee_remuneration_schedule_currency_conversion_occurred] 
					,[fact_employee_remuneration_schedule_employment_condition_name] 
					,[fact_employee_remuneration_job_title] 
					,[fact_employee_remuneration_job_status] 
					,fact_employee_remuneration_position_StartDate 
					,[fact_employee_remuneration_Position] 
					,[fact_employee_remuneration_fte] 
					,[fact_employee_remuneration_work_type] 
					,[fact_employee_remuneration_work_class] 
					,[fact_employee_remuneration_primary_job_indicator] 
					,fact_employee_remuneration_company_StartDate
					,fact_employee_remuneration_company_EndDate
					,[fact_employee_remuneration_end_date_confirmed_indicator] 
					,[fact_employee_remuneration_turnover_type] 
					,[fact_employee_remuneration_turnover_reason] 
					,[fact_employee_remuneration_created_at] 
					,[fact_employee_remuneration_maori_indicator] 
					,[fact_employee_remuneration_pasifika_indicator] 
				,[DWHSourceSystem]
				,[DWHBatchId]
				,[DWHDMLOperation]
				,[DWHIsCurrent]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				)
				values
				(
					 src.[dim_Company_Key] 
					,src.[dim_Location_Key] 
					,src.[dim_employee_key] 
					,src.[dim_service_key] 
					,src.[dim_ethnicity_key] 
					--,src.[dim_ethnicity_secondary_key] 
					--,src.[dim_ethnicity_tertiary_key] 
					,src.[dim_role_hierarchy_key] 
					,src.[dim_people_hierarchy_key] 
					,src.[dim_payroll_categories_key] 
					,src.[dim_job_start_date_key] 
					,src.[dim_job_end_date_key] 
					,src.[dim_position_start_date_key] 
					,src.[dim_position_end_date_key] 
					,src.[fact_employee_remuneration_job_key] 
					--,src.[jobs_id] 
					--,src.[person_employeeNumber] 
					--,src.[businessEntity_id] 
					--,src.[businessUnit_id] 
					--,src.[location_id] 

					,src.fact_employee_remuneration_employee_Number   --Added
					,src.fact_employee_remuneration_businessEntity_id   --Added
                    ,src.fact_employee_remuneration_businessUnit_id  --Added
                    ,src.fact_employee_remuneration_location_id   --Added

					,src.[fact_employee_remuneration_recruitment_cost] 
					,src.[fact_employee_remuneration_recruitment_currency] 
					,src.[fact_employee_remuneration_recruitment_source_name] 
					,src.[fact_employee_remuneration_pay_grade_name] 
					,src.[fact_employee_remuneration_pay_grade_code] 
					,src.[fact_employee_remuneration_establishment_name] 
					,src.[fact_employee_remuneration_schedule_type] 
					,src.[fact_employee_remuneration_schedule_currency] 
					,src.[fact_employee_remuneration_schedule_hours_per_cycle] 
					,src.[fact_employee_remuneration_schedule_pay_cycle] 
					,src.[fact_employee_remuneration_schedule_annual_package] 
					,src.[fact_employee_remuneration_schedule_hourly_package] 
					,src.[fact_employee_remuneration_schedule_base_annual_salary] 
					,src.[fact_employee_remuneration_schedule_base_hourly_rate] 
					,src.[fact_employee_remuneration_schedule_currency_conversion_occurred] 
					,src.[fact_employee_remuneration_schedule_employment_condition_name] 
					,src.[fact_employee_remuneration_job_title] 
					,src.[fact_employee_remuneration_job_status] 
					--,src.[positionStartDate] 
					,src.fact_employee_remuneration_position_StartDate
					,src.[fact_employee_remuneration_Position] 
					,src.[fact_employee_remuneration_fte] 
					,src.[fact_employee_remuneration_work_type] 
					,src.[fact_employee_remuneration_work_class] 
					,src.[fact_employee_remuneration_primary_job_indicator] 
					,src.fact_employee_remuneration_company_StartDate
					,src.fact_employee_remuneration_company_EndDate
					,src.[fact_employee_remuneration_end_date_confirmed_indicator] 
					,src.[fact_employee_remuneration_turnover_type] 
					,src.[fact_employee_remuneration_turnover_reason] 
					,src.[fact_employee_remuneration_created_at] 
					,src.[fact_employee_remuneration_maori_indicator] 
					,src.[fact_employee_remuneration_pasifika_indicator] 
				,src.[DWHSourceSystem]
				,src.[DWHBatchId]
				,src.[DWHDMLOperation]
				,src.[DWHIsCurrent]
				,src.[DWHEffectiveFrom]
				,src.[DWHEffectiveTo]
				)
			output  coalesce(src.[fact_employee_remuneration_job_key],inserted.[fact_employee_remuneration_job_key]), $action As [MergeAction] into #SummaryOfChanges;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_employee_remuneration]
		where [DWHEffectiveTo] = @SystemDefaultEffectiveTo;

		commit transaction;
	end try
	begin catch
		rollback transaction;

		set @pErrorRecords = @stagedRecords - @insertedRecords - @updatedRecords - @deletedRecords;
		set @pInsertRecords = @insertedRecords;
		set @pUpdateRecords = @updatedRecords;
		set @pDeleteRecords = @deletedRecords;
		set @pCompleted = 0;
		set @pTargetRecords = @targetRecords;
		set @pErrorMessage = ERROR_MESSAGE();

		if (@pOutputParamsAsDataset = 1)
		begin
			-- Select return parameters as a dataset
			select @pErrorRecords	as ErrorRecords,
					@pInsertRecords as InsertRecords,
					@pUpdateRecords as UpdateRecords,
					@pDeleteRecords as DeleteRecords,
					@pCompleted		as Completed,
					@targetRecords	as TargetRecords,
					@pErrorMessage as ErrorMessage;
		end;
		throw;
	end catch

	set @pErrorRecords = @stagedRecords - @insertedRecords - @updatedRecords - @deletedRecords;
	set @pInsertRecords = @insertedRecords;
	set @pUpdateRecords = @updatedRecords;
	set @pDeleteRecords = @deletedRecords;
	set @pCompleted = 1;
	set @pTargetRecords = @targetRecords;

	if (@pOutputParamsAsDataset = 1)
	begin
		-- Select return parameters as a dataset
		select @pErrorRecords	as ErrorRecords,
				@pInsertRecords as InsertRecords,
				@pUpdateRecords as UpdateRecords,
				@pDeleteRecords as DeleteRecords,
				@pCompleted		as Completed,
				@targetRecords	as TargetRecords,
				@pErrorMessage as ErrorMessage;
	end;
end;