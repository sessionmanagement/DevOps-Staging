

create procedure [edw].[Updateedwdim_employee_incident] 
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
as 

/***************************************************************************
NAME:     [edw].[Updateedwdim_employee_incident]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-01-20    Pankaj Bhatt		Initial version

****************************************************************************/

begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = 'EcoPortal.incident_investigations';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_employee_incident];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_employee_incident];

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
		 [incident_id] nvarchar(4000) null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try

	-- insert N/A, Unknown records

	if( not exists (select top(1) 1 from [edw].[dim_employee_incident] where dim_employee_incident_key <= 0) )
		begin
			-- turn the identity insert on 
		   SET IDENTITY_INSERT [edw].[dim_employee_incident] ON

			insert into [edw].[dim_employee_incident]
			(
				 [dim_employee_incident_key]
				,[incident_id] 
				,[incident_title] 
				,[current_stage] 
				,[active_stage_status] 
				,[incident_details] 
				,[incident_business_unit] 
				,[incident_sub_unit] 
				,[incident_team] 
				,[incident_specific_location] 
				,[incident_site_address] 
				,[incident_who_is_involved] 
				,[incident_nature_of_eyewitness] 
				,[actual_likelihood_guidance] 
				,[actual_likelihood_occurrence] 
				,[actual_severity_level] 
				,[actual_severity_consequence] 
				,[ongoing_risk_likelihood_guidance] 
				,[ongoing_risk_expected_outcome] 
				,[ongoing_risk_level] 
				,[ongoing_risk_reoccurrence_likelihood] 
				,[incident_primary_location] 
				,[incident_locations_list] 
				,[is_abuse_procedure_in_place] 
				,[is_assault_procedure_in_place] 
				,[is_fire_risk_cooking_procedure_in_place] 
				,[is_fire_risk_other_procedure_in_place] 
				,[is_smoking_procedure_in_place] 
				,[is_investigation_completed] 
				,[incident_immediate_actions_taken] 
				,[is_incident_in_recordbase] 
				,[incident_recordbase_detail] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem]  
			)
			VALUES	(0,0,'N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','X','X','X','X','X','X','N/A','X','N/A',0,@SystemDefaultEffectiveFrom,@SystemDefaultEffectiveTo,'I',1,@SourceSystem),	
			(-1,-1,'Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','U','U','U','U','U','U','Unknown','U','Unknown',0,@SystemDefaultEffectiveFrom,@SystemDefaultEffectiveTo,'I',1,@SourceSystem)
			 -- turn the identity insert off
			SET IDENTITY_INSERT [edw].[dim_employee_incident] OFF
		end


		if( not exists (select top(1) 1 from [edw].[dim_employee_incident] where dim_employee_incident_key > 0 ) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_employee_incident]
			(
				 [incident_id] 
				,[incident_title] 
				,[current_stage] 
				,[active_stage_status] 
				,[incident_details] 
				,[incident_business_unit] 
				,[incident_sub_unit] 
				,[incident_team] 
				,[incident_specific_location] 
				,[incident_site_address] 
				,[incident_who_is_involved] 
				,[incident_nature_of_eyewitness] 
				,[actual_likelihood_guidance] 
				,[actual_likelihood_occurrence] 
				,[actual_severity_level] 
				,[actual_severity_consequence] 
				,[ongoing_risk_likelihood_guidance] 
				,[ongoing_risk_expected_outcome] 
				,[ongoing_risk_level] 
				,[ongoing_risk_reoccurrence_likelihood] 
				,[incident_primary_location] 
				,[incident_locations_list] 
				,[is_abuse_procedure_in_place] 
				,[is_assault_procedure_in_place] 
				,[is_fire_risk_cooking_procedure_in_place] 
				,[is_fire_risk_other_procedure_in_place] 
				,[is_smoking_procedure_in_place] 
				,[is_investigation_completed] 
				,[incident_immediate_actions_taken] 
				,[is_incident_in_recordbase] 
				,[incident_recordbase_detail] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[incident_id] 
				,src.[incident_title] 
				,src.[current_stage] 
				,src.[active_stage_status] 
				,src.[incident_details] 
				,src.[incident_business_unit] 
				,src.[incident_sub_unit] 
				,src.[incident_team] 
				,src.[incident_specific_location] 
				,src.[incident_site_address] 
				,src.[incident_who_is_involved] 
				,src.[incident_nature_of_eyewitness] 
				,src.[actual_likelihood_guidance] 
				,src.[actual_likelihood_occurrence] 
				,src.[actual_severity_level] 
				,src.[actual_severity_consequence] 
				,src.[ongoing_risk_likelihood_guidance] 
				,src.[ongoing_risk_expected_outcome] 
				,src.[ongoing_risk_level] 
				,src.[ongoing_risk_reoccurrence_likelihood] 
				,src.[incident_primary_location] 
				,src.[incident_locations_list] 
				,src.[is_abuse_procedure_in_place] 
				,src.[is_assault_procedure_in_place] 
				,src.[is_fire_risk_cooking_procedure_in_place] 
				,src.[is_fire_risk_other_procedure_in_place] 
				,src.[is_smoking_procedure_in_place] 
				,src.[is_investigation_completed] 
				,src.[incident_immediate_actions_taken] 
				,src.[is_incident_in_recordbase] 
				,src.[incident_recordbase_detail] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_employee_incident] as src;
		end else begin
			merge into [edw].[dim_employee_incident] as trg
			using 
			(
				select
				 src.[incident_id] 
				,src.[incident_title] 
				,src.[current_stage] 
				,src.[active_stage_status] 
				,src.[incident_details] 
				,src.[incident_business_unit] 
				,src.[incident_sub_unit] 
				,src.[incident_team] 
				,src.[incident_specific_location] 
				,src.[incident_site_address] 
				,src.[incident_who_is_involved] 
				,src.[incident_nature_of_eyewitness] 
				,src.[actual_likelihood_guidance] 
				,src.[actual_likelihood_occurrence] 
				,src.[actual_severity_level] 
				,src.[actual_severity_consequence] 
				,src.[ongoing_risk_likelihood_guidance] 
				,src.[ongoing_risk_expected_outcome] 
				,src.[ongoing_risk_level] 
				,src.[ongoing_risk_reoccurrence_likelihood] 
				,src.[incident_primary_location] 
				,src.[incident_locations_list] 
				,src.[is_abuse_procedure_in_place] 
				,src.[is_assault_procedure_in_place] 
				,src.[is_fire_risk_cooking_procedure_in_place] 
				,src.[is_fire_risk_other_procedure_in_place] 
				,src.[is_smoking_procedure_in_place] 
				,src.[is_investigation_completed] 
				,src.[incident_immediate_actions_taken] 
				,src.[is_incident_in_recordbase] 
				,src.[incident_recordbase_detail] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_employee_incident] as src
			) as src on (src.[incident_id] = trg.[incident_id] collate database_default and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[incident_title], src.[current_stage], src.[active_stage_status], src.[incident_details], src.[incident_business_unit], src.[incident_sub_unit], src.[incident_team], src.[incident_specific_location], src.[incident_site_address], src.[incident_who_is_involved], src.[incident_nature_of_eyewitness], src.[actual_likelihood_guidance], src.[actual_likelihood_occurrence], src.[actual_severity_level], src.[actual_severity_consequence], src.[ongoing_risk_likelihood_guidance], src.[ongoing_risk_expected_outcome], src.[ongoing_risk_level], src.[ongoing_risk_reoccurrence_likelihood], src.[incident_primary_location], src.[incident_locations_list], src.[is_abuse_procedure_in_place], src.[is_assault_procedure_in_place], src.[is_fire_risk_cooking_procedure_in_place], src.[is_fire_risk_other_procedure_in_place], src.[is_smoking_procedure_in_place], src.[is_investigation_completed], src.[incident_immediate_actions_taken], src.[is_incident_in_recordbase], src.[incident_recordbase_detail], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[incident_title], trg.[current_stage], trg.[active_stage_status], trg.[incident_details], trg.[incident_business_unit], trg.[incident_sub_unit], trg.[incident_team], trg.[incident_specific_location], trg.[incident_site_address], trg.[incident_who_is_involved], trg.[incident_nature_of_eyewitness], trg.[actual_likelihood_guidance], trg.[actual_likelihood_occurrence], trg.[actual_severity_level], trg.[actual_severity_consequence], trg.[ongoing_risk_likelihood_guidance], trg.[ongoing_risk_expected_outcome], trg.[ongoing_risk_level], trg.[ongoing_risk_reoccurrence_likelihood], trg.[incident_primary_location], trg.[incident_locations_list], trg.[is_abuse_procedure_in_place], trg.[is_assault_procedure_in_place], trg.[is_fire_risk_cooking_procedure_in_place], trg.[is_fire_risk_other_procedure_in_place], trg.[is_smoking_procedure_in_place], trg.[is_investigation_completed], trg.[incident_immediate_actions_taken], trg.[is_incident_in_recordbase], trg.[incident_recordbase_detail], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' and trg.dim_employee_incident_key > 0 then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [incident_id] 
					,[incident_title] 
					,[current_stage] 
					,[active_stage_status] 
					,[incident_details] 
					,[incident_business_unit] 
					,[incident_sub_unit] 
					,[incident_team] 
					,[incident_specific_location] 
					,[incident_site_address] 
					,[incident_who_is_involved] 
					,[incident_nature_of_eyewitness] 
					,[actual_likelihood_guidance] 
					,[actual_likelihood_occurrence] 
					,[actual_severity_level] 
					,[actual_severity_consequence] 
					,[ongoing_risk_likelihood_guidance] 
					,[ongoing_risk_expected_outcome] 
					,[ongoing_risk_level] 
					,[ongoing_risk_reoccurrence_likelihood] 
					,[incident_primary_location] 
					,[incident_locations_list] 
					,[is_abuse_procedure_in_place] 
					,[is_assault_procedure_in_place] 
					,[is_fire_risk_cooking_procedure_in_place] 
					,[is_fire_risk_other_procedure_in_place] 
					,[is_smoking_procedure_in_place] 
					,[is_investigation_completed] 
					,[incident_immediate_actions_taken] 
					,[is_incident_in_recordbase] 
					,[incident_recordbase_detail] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[incident_id] 
					,src.[incident_title] 
					,src.[current_stage] 
					,src.[active_stage_status] 
					,src.[incident_details] 
					,src.[incident_business_unit] 
					,src.[incident_sub_unit] 
					,src.[incident_team] 
					,src.[incident_specific_location] 
					,src.[incident_site_address] 
					,src.[incident_who_is_involved] 
					,src.[incident_nature_of_eyewitness] 
					,src.[actual_likelihood_guidance] 
					,src.[actual_likelihood_occurrence] 
					,src.[actual_severity_level] 
					,src.[actual_severity_consequence] 
					,src.[ongoing_risk_likelihood_guidance] 
					,src.[ongoing_risk_expected_outcome] 
					,src.[ongoing_risk_level] 
					,src.[ongoing_risk_reoccurrence_likelihood] 
					,src.[incident_primary_location] 
					,src.[incident_locations_list] 
					,src.[is_abuse_procedure_in_place] 
					,src.[is_assault_procedure_in_place] 
					,src.[is_fire_risk_cooking_procedure_in_place] 
					,src.[is_fire_risk_other_procedure_in_place] 
					,src.[is_smoking_procedure_in_place] 
					,src.[is_investigation_completed] 
					,src.[incident_immediate_actions_taken] 
					,src.[is_incident_in_recordbase] 
					,src.[incident_recordbase_detail] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[incident_id],inserted.[incident_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_employee_incident]
			(
				 [incident_id] 
				,[incident_title] 
				,[current_stage] 
				,[active_stage_status] 
				,[incident_details] 
				,[incident_business_unit] 
				,[incident_sub_unit] 
				,[incident_team] 
				,[incident_specific_location] 
				,[incident_site_address] 
				,[incident_who_is_involved] 
				,[incident_nature_of_eyewitness] 
				,[actual_likelihood_guidance] 
				,[actual_likelihood_occurrence] 
				,[actual_severity_level] 
				,[actual_severity_consequence] 
				,[ongoing_risk_likelihood_guidance] 
				,[ongoing_risk_expected_outcome] 
				,[ongoing_risk_level] 
				,[ongoing_risk_reoccurrence_likelihood] 
				,[incident_primary_location] 
				,[incident_locations_list] 
				,[is_abuse_procedure_in_place] 
				,[is_assault_procedure_in_place] 
				,[is_fire_risk_cooking_procedure_in_place] 
				,[is_fire_risk_other_procedure_in_place] 
				,[is_smoking_procedure_in_place] 
				,[is_investigation_completed] 
				,[incident_immediate_actions_taken] 
				,[is_incident_in_recordbase] 
				,[incident_recordbase_detail] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[incident_id] 
				,src.[incident_title] 
				,src.[current_stage] 
				,src.[active_stage_status] 
				,src.[incident_details] 
				,src.[incident_business_unit] 
				,src.[incident_sub_unit] 
				,src.[incident_team] 
				,src.[incident_specific_location] 
				,src.[incident_site_address] 
				,src.[incident_who_is_involved] 
				,src.[incident_nature_of_eyewitness] 
				,src.[actual_likelihood_guidance] 
				,src.[actual_likelihood_occurrence] 
				,src.[actual_severity_level] 
				,src.[actual_severity_consequence] 
				,src.[ongoing_risk_likelihood_guidance] 
				,src.[ongoing_risk_expected_outcome] 
				,src.[ongoing_risk_level] 
				,src.[ongoing_risk_reoccurrence_likelihood] 
				,src.[incident_primary_location] 
				,src.[incident_locations_list] 
				,src.[is_abuse_procedure_in_place] 
				,src.[is_assault_procedure_in_place] 
				,src.[is_fire_risk_cooking_procedure_in_place] 
				,src.[is_fire_risk_other_procedure_in_place] 
				,src.[is_smoking_procedure_in_place] 
				,src.[is_investigation_completed] 
				,src.[incident_immediate_actions_taken] 
				,src.[is_incident_in_recordbase] 
				,src.[incident_recordbase_detail] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLdim_employee_incident] as src on src.[incident_id] = base.[incident_id] collate database_default
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[incident_id] 
				,tbl.[incident_title] 
				,tbl.[current_stage] 
				,tbl.[active_stage_status] 
				,tbl.[incident_details] 
				,tbl.[incident_business_unit] 
				,tbl.[incident_sub_unit] 
				,tbl.[incident_team] 
				,tbl.[incident_specific_location] 
				,tbl.[incident_site_address] 
				,tbl.[incident_who_is_involved] 
				,tbl.[incident_nature_of_eyewitness] 
				,tbl.[actual_likelihood_guidance] 
				,tbl.[actual_likelihood_occurrence] 
				,tbl.[actual_severity_level] 
				,tbl.[actual_severity_consequence] 
				,tbl.[ongoing_risk_likelihood_guidance] 
				,tbl.[ongoing_risk_expected_outcome] 
				,tbl.[ongoing_risk_level] 
				,tbl.[ongoing_risk_reoccurrence_likelihood] 
				,tbl.[incident_primary_location] 
				,tbl.[incident_locations_list] 
				,tbl.[is_abuse_procedure_in_place] 
				,tbl.[is_assault_procedure_in_place] 
				,tbl.[is_fire_risk_cooking_procedure_in_place] 
				,tbl.[is_fire_risk_other_procedure_in_place] 
				,tbl.[is_smoking_procedure_in_place] 
				,tbl.[is_investigation_completed] 
				,tbl.[incident_immediate_actions_taken] 
				,tbl.[is_incident_in_recordbase] 
				,tbl.[incident_recordbase_detail] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[dim_employee_incident] as tbl on tbl.[incident_id] = base.[incident_id] collate database_default and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLdim_employee_incident] as src on src.[incident_id] = base.[incident_id] collate database_default
			where base.[MergeAction] = 'UPDATE'
			and  src.[incident_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_employee_incident]
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