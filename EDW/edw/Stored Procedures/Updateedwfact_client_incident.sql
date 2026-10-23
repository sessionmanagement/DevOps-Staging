




CREATE procedure [edw].[Updateedwfact_client_incident] 
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
NAME:     [edw].[Updateedwfact_client_incident] 
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-11-13    Pankaj Bhatt		Initial version
1.1		 2025-11-28    Pankaj Bhatt		Added IncidentStatus
1.2		 2026-01-13	   Pankaj Bhatt		added composite key

****************************************************************************/


begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = 'rbeal/rbmnb dlFactIncident';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_client_incident];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_client_incident];

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
		 [dim_company_key] int not null
		,[incident_id] int null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[fact_client_incident]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_client_incident]
			(
				 [dim_client_incident_company_key_incident_id_key]
				,[dim_client_incident_company_key_category_type_id_key]
				,[dim_client_incident_company_key_severity_id_key]
				,[dim_client_incident_company_key_status_type_id_key]
				,[dim_company_key]
				,[dim_client_incident_key]
				,[dim_incident_date_key]
				,[dim_incident_created_date_key]
				,[dim_current_owner_employee_key]
				,[dim_current_investigator_employee_key]
				,[dim_current_reporter_employee_key]
				,[dim_creator_employee_key]
				,[dim_current_client_incident_status_type_key]
				,[dim_client_team_key]
				,[dim_originator_employee_key]
				,[dim_current_client_incident_severity_key]
				,[dim_client_incident_category_type_key]
				,[incident_id]
				,[incident_date]
				,[incident_created_date]
				,[current_owner_employee_id]
				,[current_investigator_employee_id]
				,[current_reporter_employee_id]
				,[creator_employee_id]
				,[current_owner_email_address]
				,[current_investigator_email_address]
				,[current_reporter_email_address]
				,[creator_email_address]
				,[current_incident_status_type_id]
				,[current_incident_status_created_date]
				,[client_team_id]
				,[originator_employee_id]
				,[originator_email_address]
				,[current_incident_severity_id]
				,[incident_category_type_id] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[dim_client_incident_company_key_incident_id_key]
				,src.[dim_client_incident_company_key_category_type_id_key]
				,src.[dim_client_incident_company_key_severity_id_key]
				,src.[dim_client_incident_company_key_status_type_id_key]
				,src.[dim_company_key]
				,src.[dim_client_incident_key]
				,src.[dim_incident_date_key]
				,src.[dim_incident_created_date_key]
				,src.[dim_current_owner_employee_key]
				,src.[dim_current_investigator_employee_key]
				,src.[dim_current_reporter_employee_key]
				,src.[dim_creator_employee_key]
				,src.[dim_current_client_incident_status_type_key]
				,src.[dim_client_team_key]
				,src.[dim_originator_employee_key]
				,src.[dim_current_client_incident_severity_key]
				,src.[dim_client_incident_category_type_key]
				,src.[incident_id]
				,src.[incident_date]
				,src.[incident_created_date]
				,src.[current_owner_employee_id]
				,src.[current_investigator_employee_id]
				,src.[current_reporter_employee_id]
				,src.[creator_employee_id]
				,src.[current_owner_email_address]
				,src.[current_investigator_email_address]
				,src.[current_reporter_email_address]
				,src.[creator_email_address]
				,src.[current_incident_status_type_id]
				,src.[current_incident_status_created_date]
				,src.[client_team_id]
				,src.[originator_employee_id]
				,src.[originator_email_address]
				,src.[current_incident_severity_id]
				,src.[incident_category_type_id] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_client_incident] as src;
		end else begin
			merge into [edw].[fact_client_incident] as trg
			using 
			(
				select
				 src.[dim_client_incident_company_key_incident_id_key]
				,src.[dim_client_incident_company_key_category_type_id_key]
				,src.[dim_client_incident_company_key_severity_id_key]
				,src.[dim_client_incident_company_key_status_type_id_key]
				,src.[dim_company_key]
				,src.[dim_client_incident_key]
				,src.[dim_incident_date_key]
				,src.[dim_incident_created_date_key]
				,src.[dim_current_owner_employee_key]
				,src.[dim_current_investigator_employee_key]
				,src.[dim_current_reporter_employee_key]
				,src.[dim_creator_employee_key]
				,src.[dim_current_client_incident_status_type_key]
				,src.[dim_client_team_key]
				,src.[dim_originator_employee_key]
				,src.[dim_current_client_incident_severity_key]
				,src.[dim_client_incident_category_type_key]
				,src.[incident_id]
				,src.[incident_date]
				,src.[incident_created_date]
				,src.[current_owner_employee_id]
				,src.[current_investigator_employee_id]
				,src.[current_reporter_employee_id]
				,src.[creator_employee_id]
				,src.[current_owner_email_address]
				,src.[current_investigator_email_address]
				,src.[current_reporter_email_address]
				,src.[creator_email_address]
				,src.[current_incident_status_type_id]
				,src.[current_incident_status_created_date]
				,src.[client_team_id]
				,src.[originator_employee_id]
				,src.[originator_email_address]
				,src.[current_incident_severity_id]
				,src.[incident_category_type_id] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_client_incident] as src
			) as src on (src.[dim_company_key] = trg.[dim_company_key] and src.[incident_id] = trg.[incident_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[dim_client_incident_company_key_incident_id_key], src.[dim_client_incident_company_key_category_type_id_key], src.[dim_client_incident_company_key_severity_id_key], src.[dim_client_incident_company_key_status_type_id_key], src.[incident_date] ,src.[incident_created_date] ,src.[current_owner_employee_id] ,src.[current_investigator_employee_id] ,src.[current_reporter_employee_id] ,src.[creator_employee_id] ,src.[current_owner_email_address] ,src.[current_investigator_email_address] ,src.[current_reporter_email_address] ,src.[creator_email_address] ,src.[current_incident_status_type_id] ,src.[current_incident_status_created_date] ,src.[client_team_id] ,src.[originator_employee_id] ,src.[originator_email_address] ,src.[current_incident_severity_id] ,src.[incident_category_type_id], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[dim_client_incident_company_key_incident_id_key], trg.[dim_client_incident_company_key_category_type_id_key], trg.[dim_client_incident_company_key_severity_id_key], trg.[dim_client_incident_company_key_status_type_id_key], trg.[incident_date] ,trg.[incident_created_date] ,trg.[current_owner_employee_id] ,trg.[current_investigator_employee_id] ,trg.[current_reporter_employee_id] ,trg.[creator_employee_id] ,trg.[current_owner_email_address] ,trg.[current_investigator_email_address] ,trg.[current_reporter_email_address] ,trg.[creator_email_address] ,trg.[current_incident_status_type_id] ,trg.[current_incident_status_created_date] ,trg.[client_team_id] ,trg.[originator_employee_id] ,trg.[originator_email_address] ,trg.[current_incident_severity_id] ,trg.[incident_category_type_id], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
				 [dim_client_incident_company_key_incident_id_key]
				,[dim_client_incident_company_key_category_type_id_key]
				,[dim_client_incident_company_key_severity_id_key]
				,[dim_client_incident_company_key_status_type_id_key]
				,[dim_company_key]
				,[dim_client_incident_key]
				,[dim_incident_date_key]
				,[dim_incident_created_date_key]
				,[dim_current_owner_employee_key]
				,[dim_current_investigator_employee_key]
				,[dim_current_reporter_employee_key]
				,[dim_creator_employee_key]
				,[dim_current_client_incident_status_type_key]
				,[dim_client_team_key]
				,[dim_originator_employee_key]
				,[dim_current_client_incident_severity_key]
				,[dim_client_incident_category_type_key]
				,[incident_id]
				,[incident_date]
				,[incident_created_date]
				,[current_owner_employee_id]
				,[current_investigator_employee_id]
				,[current_reporter_employee_id]
				,[creator_employee_id]
				,[current_owner_email_address]
				,[current_investigator_email_address]
				,[current_reporter_email_address]
				,[creator_email_address]
				,[current_incident_status_type_id]
				,[current_incident_status_created_date]
				,[client_team_id]
				,[originator_employee_id]
				,[originator_email_address]
				,[current_incident_severity_id]
				,[incident_category_type_id] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
				)
				values
				(
					 src.[dim_client_incident_company_key_incident_id_key]
					,src.[dim_client_incident_company_key_category_type_id_key]
					,src.[dim_client_incident_company_key_severity_id_key]
					,src.[dim_client_incident_company_key_status_type_id_key]
					,src.[dim_company_key]
					,src.[dim_client_incident_key]
					,src.[dim_incident_date_key]
					,src.[dim_incident_created_date_key]
					,src.[dim_current_owner_employee_key]
					,src.[dim_current_investigator_employee_key]
					,src.[dim_current_reporter_employee_key]
					,src.[dim_creator_employee_key]
					,src.[dim_current_client_incident_status_type_key]
					,src.[dim_client_team_key]
					,src.[dim_originator_employee_key]
					,src.[dim_current_client_incident_severity_key]
					,src.[dim_client_incident_category_type_key]
					,src.[incident_id]
					,src.[incident_date]
					,src.[incident_created_date]
					,src.[current_owner_employee_id]
					,src.[current_investigator_employee_id]
					,src.[current_reporter_employee_id]
					,src.[creator_employee_id]
					,src.[current_owner_email_address]
					,src.[current_investigator_email_address]
					,src.[current_reporter_email_address]
					,src.[creator_email_address]
					,src.[current_incident_status_type_id]
					,src.[current_incident_status_created_date]
					,src.[client_team_id]
					,src.[originator_employee_id]
					,src.[originator_email_address]
					,src.[current_incident_severity_id]
					,src.[incident_category_type_id] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[dim_company_key],inserted.[dim_company_key]), coalesce(src.[incident_id],inserted.[incident_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[fact_client_incident]
			(
				 [dim_client_incident_company_key_incident_id_key]
				,[dim_client_incident_company_key_category_type_id_key]
				,[dim_client_incident_company_key_severity_id_key]
				,[dim_client_incident_company_key_status_type_id_key]
				,[dim_company_key]
				,[dim_client_incident_key]
				,[dim_incident_date_key]
				,[dim_incident_created_date_key]
				,[dim_current_owner_employee_key]
				,[dim_current_investigator_employee_key]
				,[dim_current_reporter_employee_key]
				,[dim_creator_employee_key]
				,[dim_current_client_incident_status_type_key]
				,[dim_client_team_key]
				,[dim_originator_employee_key]
				,[dim_current_client_incident_severity_key]
				,[dim_client_incident_category_type_key]
				,[incident_id]
				,[incident_date]
				,[incident_created_date]
				,[current_owner_employee_id]
				,[current_investigator_employee_id]
				,[current_reporter_employee_id]
				,[creator_employee_id]
				,[current_owner_email_address]
				,[current_investigator_email_address]
				,[current_reporter_email_address]
				,[creator_email_address]
				,[current_incident_status_type_id]
				,[current_incident_status_created_date]
				,[client_team_id]
				,[originator_employee_id]
				,[originator_email_address]
				,[current_incident_severity_id]
				,[incident_category_type_id] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[dim_client_incident_company_key_incident_id_key]
				,src.[dim_client_incident_company_key_category_type_id_key]
				,src.[dim_client_incident_company_key_severity_id_key]
				,src.[dim_client_incident_company_key_status_type_id_key]
				,src.[dim_company_key]
				,src.[dim_client_incident_key]
				,src.[dim_incident_date_key]
				,src.[dim_incident_created_date_key]
				,src.[dim_current_owner_employee_key]
				,src.[dim_current_investigator_employee_key]
				,src.[dim_current_reporter_employee_key]
				,src.[dim_creator_employee_key]
				,src.[dim_current_client_incident_status_type_key]
				,src.[dim_client_team_key]
				,src.[dim_originator_employee_key]
				,src.[dim_current_client_incident_severity_key]
				,src.[dim_client_incident_category_type_key]
				,src.[incident_id]
				,src.[incident_date]
				,src.[incident_created_date]
				,src.[current_owner_employee_id]
				,src.[current_investigator_employee_id]
				,src.[current_reporter_employee_id]
				,src.[creator_employee_id]
				,src.[current_owner_email_address]
				,src.[current_investigator_email_address]
				,src.[current_reporter_email_address]
				,src.[creator_email_address]
				,src.[current_incident_status_type_id]
				,src.[current_incident_status_created_date]
				,src.[client_team_id]
				,src.[originator_employee_id]
				,src.[originator_email_address]
				,src.[current_incident_severity_id]
				,src.[incident_category_type_id]  
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLfact_client_incident] as src on src.[dim_company_key] = base.[dim_company_key] and src.[incident_id] = base.[incident_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[dim_client_incident_company_key_incident_id_key]
				,tbl.[dim_client_incident_company_key_category_type_id_key]
				,tbl.[dim_client_incident_company_key_severity_id_key]
				,tbl.[dim_client_incident_company_key_status_type_id_key]
				,tbl.[dim_company_key]
				,tbl.[dim_client_incident_key]
				,tbl.[dim_incident_date_key]
				,tbl.[dim_incident_created_date_key]
				,tbl.[dim_current_owner_employee_key]
				,tbl.[dim_current_investigator_employee_key]
				,tbl.[dim_current_reporter_employee_key]
				,tbl.[dim_creator_employee_key]
				,tbl.[dim_current_client_incident_status_type_key]
				,tbl.[dim_client_team_key]
				,tbl.[dim_originator_employee_key]
				,tbl.[dim_current_client_incident_severity_key]
				,tbl.[dim_client_incident_category_type_key]
				,tbl.[incident_id]
				,tbl.[incident_date]
				,tbl.[incident_created_date]
				,tbl.[current_owner_employee_id]
				,tbl.[current_investigator_employee_id]
				,tbl.[current_reporter_employee_id]
				,tbl.[creator_employee_id]
				,tbl.[current_owner_email_address]
				,tbl.[current_investigator_email_address]
				,tbl.[current_reporter_email_address]
				,tbl.[creator_email_address]
				,tbl.[current_incident_status_type_id]
				,tbl.[current_incident_status_created_date]
				,tbl.[client_team_id]
				,tbl.[originator_employee_id]
				,tbl.[originator_email_address]
				,tbl.[current_incident_severity_id]
				,tbl.[incident_category_type_id]  
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[fact_client_incident] as tbl on tbl.[dim_company_key] = base.[dim_company_key] and tbl.[incident_id] = base.[incident_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLfact_client_incident] as src on src.[dim_company_key] = base.[dim_company_key] and src.[incident_id] = base.[incident_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[dim_company_key] is null and src.[incident_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_client_incident]
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