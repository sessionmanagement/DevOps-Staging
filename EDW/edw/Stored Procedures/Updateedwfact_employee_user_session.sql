

CREATE procedure [edw].[Updateedwfact_employee_user_session] 
	@pBatchID int, 
	@pIndexRebuildThreshold int,
	@pOutputParamsAsDataset int = 0,
	@pErrorRecords int = null OUTPUT, 
	@pInsertRecords int = null OUTPUT, 
	@pUpdateRecords int = null OUTPUT, 
	@pDeleteRecords int = null OUTPUT,
	@pCompleted int = null OUTPUT,
	@pTargetRecords int = null OUTPUT 
as begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = 'recordbase dl.FactUserSession';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_employee_user_session];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_employee_user_session];

		-- Select success details
		select
			 @pErrorRecords = 0
			,@pInsertRecords = 0
			,@pUpdateRecords = 0
			,@pDeleteRecords = 0
			,@pCompleted = 1
			,@pTargetRecords = @targetRecords;	

		if (@pOutputParamsAsDataset = 1)
		begin
			-- Select return parameters as a dataset
			select @pErrorRecords	as ErrorRecords,
					@pInsertRecords as InsertRecords,
					@pUpdateRecords as UpdateRecords,
					@pDeleteRecords as DeleteRecords,
					@pCompleted		as Completed,
					@targetRecords	as TargetRecords;
		end;

		return;
	end;

	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[fact_employee_user_session]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_employee_user_session]
			(
				 [employee_session_id] 
				,[dim_employee_key]
				,[user_id]
				,[company_id]
				,[sign_on_date] 
				,[IP_address] 
				,[browser_name] 
				,[browser_version] 
				,[application_id] 
				,[user_agent] 
				,[impersonator_id] 
				,[identity_sign_on_session] 
				,[employee_id] 
				,[employee_email] 
				,[employee_role] 
				,[session_location] 
				,[DWHBatchId] 
				,[DWHCreatedAt] 
				,[DWHModifiedOn] 
				,[DWHDMLOperation] 
				,[DWHSourceSystem] 
			)
			select
				 src.[employee_session_id] 
				,src.[dim_employee_key]
				,src.[user_id]
				,src.[company_id]
				,src.[sign_on_date] 
				,src.[IP_address] 
				,src.[browser_name] 
				,src.[browser_version] 
				,src.[application_id] 
				,src.[user_agent] 
				,src.[impersonator_id] 
				,src.[identity_sign_on_session] 
				,src.[employee_id] 
				,src.[employee_email] 
				,src.[employee_role] 
				,src.[session_location] 
					,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_employee_user_session] as src;
		end else begin
			merge into [edw].[fact_employee_user_session] as trg
			using 
			(
				select
				 src.[employee_session_id]
				,src.[dim_employee_key]
				,src.[user_id]
				,src.[company_id]
				,src.[sign_on_date] 
				,src.[IP_address] 
				,src.[browser_name] 
				,src.[browser_version] 
				,src.[application_id] 
				,src.[user_agent] 
				,src.[impersonator_id] 
				,src.[identity_sign_on_session] 
				,src.[employee_id] 
				,src.[employee_email] 
				,src.[employee_role] 
				,src.[session_location] 
				
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_employee_user_session] as src
			) as src on (src.[employee_session_id] = trg.[employee_session_id])			-- Retire existing records
			when matched and exists 
			( 
				select src.[user_id], src.company_id, src.[sign_on_date], src.[IP_address], src.[browser_name], src.[browser_version], src.[application_id], src.[user_agent], src.[impersonator_id], src.[identity_sign_on_session], src.[employee_id], src.[employee_email], src.[employee_role], src.[session_location]
				except
				select trg.[user_id], trg.company_id, trg.[sign_on_date], trg.[IP_address], trg.[browser_name], trg.[browser_version], trg.[application_id], trg.[user_agent], trg.[impersonator_id], trg.[identity_sign_on_session], trg.[employee_id], trg.[employee_email], trg.[employee_role], trg.[session_location]
			) then  update set 
				 [employee_session_id] = src.[employee_session_id]
				, [user_id] = src.[user_id]
				, [company_id] = src.[company_id]
				, [sign_on_date] = src.[sign_on_date]
				, [IP_address] = src.[IP_address]
				, [browser_name] = src.[browser_name]
				, [browser_version] = src.[browser_version]
				, [application_id] = src.[application_id]
				, [user_agent] = src.[user_agent]
				, [impersonator_id] = src.[impersonator_id]
				, [identity_sign_on_session] = src.[identity_sign_on_session]
				, [employee_id] = src.[employee_id]
				, [employee_email] = src.[employee_email]
				, [employee_role] = src.[employee_role]
				, [session_location] = src.[session_location]
				
				,[DWHModifiedOn] = @systemCurrentDate
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = isnull(nullif(src.[DWHDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source and trg.[DWHDMLOperation] <> 'D' then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [employee_session_id]
					,[dim_employee_key]
					,[user_id]
					,[company_id]
					,[sign_on_date] 
					,[IP_address] 
					,[browser_name] 
					,[browser_version] 
					,[application_id] 
					,[user_agent] 
					,[impersonator_id] 
					,[identity_sign_on_session] 
					,[employee_id] 
					,[employee_email] 
					,[employee_role] 
					,[session_location] 
				
					,[DWHBatchId] 
					,[DWHCreatedAt] 
					,[DWHModifiedOn] 
					,[DWHDMLOperation] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[employee_session_id] 
					,src.[dim_employee_key]
					,src.[user_id]
					,src.[company_id]
					,src.[sign_on_date] 
					,src.[IP_address] 
					,src.[browser_name] 
					,src.[browser_version] 
					,src.[application_id] 
					,src.[user_agent] 
					,src.[impersonator_id] 
					,src.[identity_sign_on_session] 
					,src.[employee_id] 
					,src.[employee_email] 
					,src.[employee_role] 
					,src.[session_location] 
					
					,src.[DWHBatchId] 
					,src.[DWHCreatedAt] 
					,src.[DWHModifiedOn] 
					,src.[DWHDMLOperation] 
					,src.[DWHSourceSystem] 
				);
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_employee_user_session];

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

		if (@pOutputParamsAsDataset = 1)
		begin
			-- Select return parameters as a dataset
			select @pErrorRecords	as ErrorRecords,
					@pInsertRecords as InsertRecords,
					@pUpdateRecords as UpdateRecords,
					@pDeleteRecords as DeleteRecords,
					@pCompleted		as Completed,
					@targetRecords	as TargetRecords;
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
				@targetRecords	as TargetRecords;
	end;
end;