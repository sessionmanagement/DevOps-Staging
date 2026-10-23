CREATE procedure [edw].[Updateedwfact_client_account_activity] 

/**********************************************************************************************************
 Procedure	[edw].[Updateedwfact_client_account_activity]
 Author		
 Created		

 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
 Parameter(s)  None 
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		?			  ?						Initial creation of stored procedure
1.1		2025-04-01	  Greg Nuthall			Added clause to seperate MnB old referrals client team 
											and the new referral client team, changed the source
1.2     2026-01-28    Greg Nuthall			Added participated_employee_id
**********************************************************************************************************/

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
	declare @SourceSystem nvarchar(120) = 'recordbase.dlfactaccountactivity, dlfactAccountactivityparticipant';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_client_account_activity];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_client_account_activity];

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
		 [fact_client_account_activity_id] nvarchar(100) null
		,[participated_employee_id] integer null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[fact_client_account_activity]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_client_account_activity]
			(
				 [fact_client_account_activity_id]
				 ,dim_client_team_key
				 ,dim_service_key
				 ,dim_company_key
				 ,dim_participated_employee_key
				 ,dim_created_employee_key
				,[client_account_activity_id] 
				,[client_account_activity_location] 
				,[client_account_activity_subject] 
				,[client_account_activity_description_html] 
				,[client_account_activity_description_raw] 
				,[client_account_activity_start_date] 
				,[client_account_activity_end_date] 
				,[client_account_activity_type_id] 
				,[client_account_activity_classification_id] 
				,[client_account_activity_created_date] 
				,[client_account_activity_created_user_id] 
				,[client_account_activity_udf1] 
				,[client_account_activity_udf2] 
				,[client_account_activity_udf3] 
				,[client_account_activity_udf4] 
				,[client_account_activity_udf5] 
				,[client_account_activity_other_participants] 
				,[client_team_id] 
				,[client_account_activity_audience_size] 
				,[client_account_activity_classification_text] 
				,[client_account_activity_type_text] 
				,[client_account_name] 
				,[primary_contact_id]
				,[participated_employee_id]
				,[created_employee_id]
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[fact_client_account_activity_id] 
				,src.dim_client_team_key
				,src.dim_service_Key
				,src.dim_company_key
				,src.dim_participated_employee_key
				,src.dim_created_employee_key
				,src.[client_account_activity_id] 
				,src.[client_account_activity_location] 
				,src.[client_account_activity_subject] 
				,src.[client_account_activity_description_html] 
				,src.[client_account_activity_description_raw] 
				,src.[client_account_activity_start_date] 
				,src.[client_account_activity_end_date] 
				,src.[client_account_activity_type_id] 
				,src.[client_account_activity_classification_id] 
				,src.[client_account_activity_created_date] 
				,src.[client_account_activity_created_user_id] 
				,src.[client_account_activity_udf1] 
				,src.[client_account_activity_udf2] 
				,src.[client_account_activity_udf3] 
				,src.[client_account_activity_udf4] 
				,src.[client_account_activity_udf5] 
				,src.[client_account_activity_other_participants] 
				,src.[client_team_id] 
				,src.[client_account_activity_audience_size] 
				,src.[client_account_activity_classification_text] 
				,src.[client_account_activity_type_text] 
				,src.[client_account_name] 
				,src.[primary_contact_id] 
				,src.[participated_employee_id]
				,src.[created_employee_id]
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_client_account_activity] as src
			

		end else begin
			merge into [edw].[fact_client_account_activity] as trg
			using 
			(
				select
				 src.[fact_client_account_activity_id] 
				,src.dim_client_team_key
				,src.dim_service_Key
				,src.dim_company_key
				,src.dim_participated_employee_key
				,src.dim_created_employee_key
				,src.[client_account_activity_id] 
				,src.[client_account_activity_location] 
				,src.[client_account_activity_subject] 
				,src.[client_account_activity_description_html] 
				,src.[client_account_activity_description_raw] 
				,src.[client_account_activity_start_date] 
				,src.[client_account_activity_end_date] 
				,src.[client_account_activity_type_id] 
				,src.[client_account_activity_classification_id] 
				,src.[client_account_activity_created_date] 
				,src.[client_account_activity_created_user_id] 
				,src.[client_account_activity_udf1] 
				,src.[client_account_activity_udf2] 
				,src.[client_account_activity_udf3] 
				,src.[client_account_activity_udf4] 
				,src.[client_account_activity_udf5] 
				,src.[client_account_activity_other_participants] 
				,src.[client_team_id] 
				,src.[client_account_activity_audience_size] 
				,src.[client_account_activity_classification_text] 
				,src.[client_account_activity_type_text] 
				,src.[client_account_name] 
				,src.[primary_contact_id] 
				,src.[participated_employee_id]
				,src.[created_employee_id]
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_client_account_activity] as src
		
			) as src on (src.[fact_client_account_activity_id] = trg.[fact_client_account_activity_id] collate database_default and isnull(src.participated_employee_id,0) = isnull(trg.participated_employee_id,0) and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				SELECT src.[client_account_activity_id]
				,src.[client_account_activity_location]
				,src.[client_account_activity_subject]
				,src.[client_account_activity_description_html]
				,src.[client_account_activity_description_raw]
				,src.[client_account_activity_start_date]
				,src.[client_account_activity_end_date]
				,src.[client_account_activity_type_id]
				,src.[client_account_activity_classification_id]
				,src.[client_account_activity_created_date]
				,src.[client_account_activity_created_user_id]
				,src.[client_account_activity_udf1]
				,src.[client_account_activity_udf2]
				,src.[client_account_activity_udf3]
				,src.[client_account_activity_udf4]
				,src.[client_account_activity_udf5]
				,src.[client_account_activity_other_participants]
				,src.[client_team_id]
				,src.[client_account_activity_audience_size]
				,src.[client_account_activity_classification_text]
				,src.[client_account_activity_type_text]
				,src.[client_account_name]
				,isnull(src.[primary_contact_id],0) as primary_contact_id
				,isnull(src.[participated_employee_id],0) as participated_employee_id
				,isnull(src.[created_employee_id],0) as created_employee_id
				,CASE 
					WHEN trg.[DWHDMLOperation] = 'D'
						THEN 'U'
					ELSE 'X'
					END

			EXCEPT

			SELECT trg.[client_account_activity_id]
				,trg.[client_account_activity_location]
				,trg.[client_account_activity_subject]
				,trg.[client_account_activity_description_html]
				,trg.[client_account_activity_description_raw]
				,trg.[client_account_activity_start_date]
				,trg.[client_account_activity_end_date]
				,trg.[client_account_activity_type_id]
				,trg.[client_account_activity_classification_id]
				,trg.[client_account_activity_created_date]
				,trg.[client_account_activity_created_user_id]
				,trg.[client_account_activity_udf1]
				,trg.[client_account_activity_udf2]
				,trg.[client_account_activity_udf3]
				,trg.[client_account_activity_udf4]
				,trg.[client_account_activity_udf5]
				,trg.[client_account_activity_other_participants]
				,trg.[client_team_id]
				,trg.[client_account_activity_audience_size]
				,trg.[client_account_activity_classification_text]
				,trg.[client_account_activity_type_text]
				,trg.[client_account_name]
				,isnull(trg.[primary_contact_id],0) as primary_contact_id
				,isnull(trg.[participated_employee_id],0) as participated_employee_id
				,isnull(trg.[created_employee_id],0) as created_employee_id
				,'X'
			
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
				 [fact_client_account_activity_id]
				 ,dim_client_team_key
				 ,dim_service_key
				 ,dim_company_key
				 ,dim_participated_employee_key
				 ,dim_created_employee_key
				,[client_account_activity_id] 
				,[client_account_activity_location] 
				,[client_account_activity_subject] 
				,[client_account_activity_description_html] 
				,[client_account_activity_description_raw] 
				,[client_account_activity_start_date] 
				,[client_account_activity_end_date] 
				,[client_account_activity_type_id] 
				,[client_account_activity_classification_id] 
				,[client_account_activity_created_date] 
				,[client_account_activity_created_user_id] 
				,[client_account_activity_udf1] 
				,[client_account_activity_udf2] 
				,[client_account_activity_udf3] 
				,[client_account_activity_udf4] 
				,[client_account_activity_udf5] 
				,[client_account_activity_other_participants] 
				,[client_team_id] 
				,[client_account_activity_audience_size] 
				,[client_account_activity_classification_text] 
				,[client_account_activity_type_text] 
				,[client_account_name] 
				,[primary_contact_id] 
				,[participated_employee_id]
				,[created_employee_id]
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
				)
				values
				(
					 src.[fact_client_account_activity_id]
					,src.dim_client_team_key
					,src.dim_service_key
					,src.dim_company_key
					,src.dim_participated_employee_key
					,src.dim_created_employee_key

					,src.[client_account_activity_id] 
					,src.[client_account_activity_location] 
					,src.[client_account_activity_subject] 
					,src.[client_account_activity_description_html] 
					,src.[client_account_activity_description_raw] 
					,src.[client_account_activity_start_date] 
					,src.[client_account_activity_end_date] 
					,src.[client_account_activity_type_id] 
					,src.[client_account_activity_classification_id] 
					,src.[client_account_activity_created_date] 
					,src.[client_account_activity_created_user_id] 
					,src.[client_account_activity_udf1] 
					,src.[client_account_activity_udf2] 
					,src.[client_account_activity_udf3] 
					,src.[client_account_activity_udf4] 
					,src.[client_account_activity_udf5] 
					,src.[client_account_activity_other_participants] 
					,src.[client_team_id] 
					,src.[client_account_activity_audience_size] 
					,src.[client_account_activity_classification_text] 
					,src.[client_account_activity_type_text] 
					,src.[client_account_name] 
					,src.[primary_contact_id] 
					,src.[participated_employee_id]
					,src.[created_employee_id]
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[fact_client_account_activity_id],inserted.[fact_client_account_activity_id]),coalesce(src.participated_employee_id,inserted.participated_employee_id),  $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[fact_client_account_activity]
			(
				 [fact_client_account_activity_id] 
				 ,dim_client_team_key
				 ,dim_service_key
				 ,dim_company_key
				 ,dim_participated_employee_key
				 ,dim_created_employee_key

				,[client_account_activity_id] 
				,[client_account_activity_location] 
				,[client_account_activity_subject] 
				,[client_account_activity_description_html] 
				,[client_account_activity_description_raw] 
				,[client_account_activity_start_date] 
				,[client_account_activity_end_date] 
				,[client_account_activity_type_id] 
				,[client_account_activity_classification_id] 
				,[client_account_activity_created_date] 
				,[client_account_activity_created_user_id] 
				,[client_account_activity_udf1] 
				,[client_account_activity_udf2] 
				,[client_account_activity_udf3] 
				,[client_account_activity_udf4] 
				,[client_account_activity_udf5] 
				,[client_account_activity_other_participants] 
				,[client_team_id] 
				,[client_account_activity_audience_size] 
				,[client_account_activity_classification_text] 
				,[client_account_activity_type_text] 
				,[client_account_name] 
				,[primary_contact_id] 
				,[participated_employee_id]
				,[created_employee_id]
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[fact_client_account_activity_id]
				,src.dim_client_team_key
				,src.dim_service_key
				,src.dim_company_key
				,src.dim_participated_employee_key
				,src.dim_created_employee_key

				,src.[client_account_activity_id] 
				,src.[client_account_activity_location] 
				,src.[client_account_activity_subject] 
				,src.[client_account_activity_description_html] 
				,src.[client_account_activity_description_raw] 
				,src.[client_account_activity_start_date] 
				,src.[client_account_activity_end_date] 
				,src.[client_account_activity_type_id] 
				,src.[client_account_activity_classification_id] 
				,src.[client_account_activity_created_date] 
				,src.[client_account_activity_created_user_id] 
				,src.[client_account_activity_udf1] 
				,src.[client_account_activity_udf2] 
				,src.[client_account_activity_udf3] 
				,src.[client_account_activity_udf4] 
				,src.[client_account_activity_udf5] 
				,src.[client_account_activity_other_participants] 
				,src.[client_team_id] 
				,src.[client_account_activity_audience_size] 
				,src.[client_account_activity_classification_text] 
				,src.[client_account_activity_type_text] 
				,src.[client_account_name] 
				,src.[primary_contact_id]
				,src.[participated_employee_id]
				,src.[created_employee_id]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLfact_client_account_activity] as src 
				on src.[fact_client_account_activity_id] = base.[fact_client_account_activity_id] collate database_default
				and src.participated_employee_id = base.participated_employee_id 

			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[fact_client_account_activity_id] 
				,tbl.dim_client_team_key
				,tbl.dim_service_key
				,tbl.dim_company_key
				,tbl.dim_participated_employee_key
				,tbl.dim_created_employee_key
				,tbl.[client_account_activity_id] 
				,tbl.[client_account_activity_location] 
				,tbl.[client_account_activity_subject] 
				,tbl.[client_account_activity_description_html] 
				,tbl.[client_account_activity_description_raw] 
				,tbl.[client_account_activity_start_date] 
				,tbl.[client_account_activity_end_date] 
				,tbl.[client_account_activity_type_id] 
				,tbl.[client_account_activity_classification_id] 
				,tbl.[client_account_activity_created_date] 
				,tbl.[client_account_activity_created_user_id] 
				,tbl.[client_account_activity_udf1] 
				,tbl.[client_account_activity_udf2] 
				,tbl.[client_account_activity_udf3] 
				,tbl.[client_account_activity_udf4] 
				,tbl.[client_account_activity_udf5] 
				,tbl.[client_account_activity_other_participants] 
				,tbl.[client_team_id] 
				,tbl.[client_account_activity_audience_size] 
				,tbl.[client_account_activity_classification_text] 
				,tbl.[client_account_activity_type_text] 
				,tbl.[client_account_name] 
				,tbl.[primary_contact_id]
				,tbl.[participated_employee_id]
				,tbl.[created_employee_id]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[fact_client_account_activity] as tbl 
				on tbl.[fact_client_account_activity_id] = base.[fact_client_account_activity_id] collate database_default 
				and tbl.participated_employee_id = base.participated_employee_id  
				and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLfact_client_account_activity] as src 
				on src.[fact_client_account_activity_id] = base.[fact_client_account_activity_id] collate database_default
				and src.participated_employee_id = base.participated_employee_id 
			where base.[MergeAction] = 'UPDATE'
			and src.[fact_client_account_activity_id] is null
			and src.participated_employee_id is null
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_client_account_activity]
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