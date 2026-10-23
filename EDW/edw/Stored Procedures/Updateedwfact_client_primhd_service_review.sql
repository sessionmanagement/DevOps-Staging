
create procedure [edw].[Updateedwfact_client_primhd_service_review] 
	@pBatchID int, 
	@pIndexRebuildThreshold int,
	@pOutputParamsAsDataset int = 0,
	@pErrorRecords int = null OUTPUT, 
	@pInsertRecords int = null OUTPUT, 
	@pUpdateRecords int = null OUTPUT, 
	@pDeleteRecords int = null OUTPUT,
	@pCompleted int = null OUTPUT,
	@pTargetRecords int = null OUTPUT 
as 
/***************************************************************************
NAME:     [edw].[Updateedwfact_client_primhd_service_review] 
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-04-21    Pankaj Bhatt		Initial version

****************************************************************************/

begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = 'rbeal/rbmnb dlfactprimhdservicereview';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_client_primhd_service_review];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_client_primhd_service_review];

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
		if( not exists (select top(1) 1 from [edw].[fact_client_primhd_service_review]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_client_primhd_service_review]
			(
				 [dim_company_key] 
				,[dim_client_key]
			    ,[dim_client_unique_key]
			    ,[dim_client_referral_key]
			    ,[dim_client_referral_unique_key]
			    ,[dim_created_by_employee_key]
			    ,[dim_review_date_key]
			    ,[dim_created_date_key]
			    ,[primhd_service_review_id] 
				,[client_id] 
				,[client_referral_id] 
				,[created_by_employee_id] 
				,[created_by_user_email_address] 
				,[review_date] 
				,[created_date] 
				,[accommodation_status_value] 
				,[accommodation_status_text] 
				,[parent_accommodation_status_value] 
				,[parent_accommodation_status_text] 
				,[education_status_value] 
				,[education_status_text] 
				,[parent_education_status_value] 
				,[parent_education_status_text] 
				,[employment_status_value] 
				,[employment_status_text] 
				,[parent_employment_status_value] 
				,[parent_employment_status_text] 
				,[wellness_plan_status_value] 
				,[wellness_plan_status_text] 
				,[parent_wellness_plan_status_value] 
				,[parent_wellness_plan_status_text] 
				,[DWHBatchId] 
				,[DWHCreatedAt] 
				,[DWHModifiedOn] 
				,[DWHDMLOperation] 
				,[DWHSourceSystem] 
			)
			select
				 src.[dim_company_key]
				,src.[dim_client_key]
				,src.[dim_client_unique_key]
				,src.[dim_client_referral_key]
				,src.[dim_client_referral_unique_key]
				,src.[dim_created_by_employee_key]
				,src.[dim_review_date_key]
				,src.[dim_created_date_key]				 
				,src.[primhd_service_review_id] 
				,src.[client_id] 
				,src.[client_referral_id] 
				,src.[created_by_employee_id] 
				,src.[created_by_user_email_address] 
				,src.[review_date] 
				,src.[created_date] 
				,src.[accommodation_status_value] 
				,src.[accommodation_status_text] 
				,src.[parent_accommodation_status_value] 
				,src.[parent_accommodation_status_text] 
				,src.[education_status_value] 
				,src.[education_status_text] 
				,src.[parent_education_status_value] 
				,src.[parent_education_status_text] 
				,src.[employment_status_value] 
				,src.[employment_status_text] 
				,src.[parent_employment_status_value] 
				,src.[parent_employment_status_text] 
				,src.[wellness_plan_status_value] 
				,src.[wellness_plan_status_text] 
				,src.[parent_wellness_plan_status_value] 
				,src.[parent_wellness_plan_status_text] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_client_primhd_service_review] as src;
		end else begin
			merge into [edw].[fact_client_primhd_service_review] as trg
			using 
			(
				select
				 src.[dim_company_key] 
				,src.[dim_client_key]
				,src.[dim_client_unique_key]
				,src.[dim_client_referral_key]
				,src.[dim_client_referral_unique_key]
				,src.[dim_created_by_employee_key]
				,src.[dim_review_date_key]
				,src.[dim_created_date_key]	
				,src.[primhd_service_review_id] 
				,src.[client_id] 
				,src.[client_referral_id] 
				,src.[created_by_employee_id] 
				,src.[created_by_user_email_address] 
				,src.[review_date] 
				,src.[created_date] 
				,src.[accommodation_status_value] 
				,src.[accommodation_status_text] 
				,src.[parent_accommodation_status_value] 
				,src.[parent_accommodation_status_text] 
				,src.[education_status_value] 
				,src.[education_status_text] 
				,src.[parent_education_status_value] 
				,src.[parent_education_status_text] 
				,src.[employment_status_value] 
				,src.[employment_status_text] 
				,src.[parent_employment_status_value] 
				,src.[parent_employment_status_text] 
				,src.[wellness_plan_status_value] 
				,src.[wellness_plan_status_text] 
				,src.[parent_wellness_plan_status_value] 
				,src.[parent_wellness_plan_status_text] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_client_primhd_service_review] as src
			) as src on (src.[dim_company_key] = trg.[dim_company_key] and src.[primhd_service_review_id] = trg.[primhd_service_review_id])			-- Retire existing records
			when matched and exists 
			( 
				select src.[dim_client_key], src.[dim_client_unique_key], src.[dim_client_referral_key], src.[dim_client_referral_unique_key], src.[dim_created_by_employee_key], src.[dim_review_date_key], src.[dim_created_date_key], src.[client_id], src.[client_referral_id], src.[created_by_employee_id], src.[created_by_user_email_address], src.[review_date], src.[created_date], src.[accommodation_status_value], src.[accommodation_status_text], src.[parent_accommodation_status_value], src.[parent_accommodation_status_text], src.[education_status_value], src.[education_status_text], src.[parent_education_status_value], src.[parent_education_status_text], src.[employment_status_value], src.[employment_status_text], src.[parent_employment_status_value], src.[parent_employment_status_text], src.[wellness_plan_status_value], src.[wellness_plan_status_text], src.[parent_wellness_plan_status_value], src.[parent_wellness_plan_status_text]
				except
				select trg.[dim_client_key], trg.[dim_client_unique_key], trg.[dim_client_referral_key], trg.[dim_client_referral_unique_key], trg.[dim_created_by_employee_key], trg.[dim_review_date_key], trg.[dim_created_date_key], trg.[client_id], trg.[client_referral_id], trg.[created_by_employee_id], trg.[created_by_user_email_address], trg.[review_date], trg.[created_date], trg.[accommodation_status_value], trg.[accommodation_status_text], trg.[parent_accommodation_status_value], trg.[parent_accommodation_status_text], trg.[education_status_value], trg.[education_status_text], trg.[parent_education_status_value], trg.[parent_education_status_text], trg.[employment_status_value], trg.[employment_status_text], trg.[parent_employment_status_value], trg.[parent_employment_status_text], trg.[wellness_plan_status_value], trg.[wellness_plan_status_text], trg.[parent_wellness_plan_status_value], trg.[parent_wellness_plan_status_text]
			) then  update set 
				 [dim_company_key] = src.[dim_company_key]
				, [dim_client_key] = src.[dim_client_key]
				, [dim_client_unique_key] = src.[dim_client_unique_key]
				, [dim_client_referral_key] = src.[dim_client_referral_key]
				, [dim_client_referral_unique_key] = src.[dim_client_referral_unique_key]
				, [dim_created_by_employee_key] = src.[dim_created_by_employee_key]
				, [dim_review_date_key] = src.[dim_review_date_key]
				, [dim_created_date_key] = src.[dim_created_date_key]
				, [primhd_service_review_id] = src.[primhd_service_review_id]
				, [client_id] = src.[client_id]
				, [client_referral_id] = src.[client_referral_id]
				, [created_by_employee_id] = src.[created_by_employee_id]
				, [created_by_user_email_address] = src.[created_by_user_email_address]
				, [review_date] = src.[review_date]
				, [created_date] = src.[created_date]
				, [accommodation_status_value] = src.[accommodation_status_value]
				, [accommodation_status_text] = src.[accommodation_status_text]
				, [parent_accommodation_status_value] = src.[parent_accommodation_status_value]
				, [parent_accommodation_status_text] = src.[parent_accommodation_status_text]
				, [education_status_value] = src.[education_status_value]
				, [education_status_text] = src.[education_status_text]
				, [parent_education_status_value] = src.[parent_education_status_value]
				, [parent_education_status_text] = src.[parent_education_status_text]
				, [employment_status_value] = src.[employment_status_value]
				, [employment_status_text] = src.[employment_status_text]
				, [parent_employment_status_value] = src.[parent_employment_status_value]
				, [parent_employment_status_text] = src.[parent_employment_status_text]
				, [wellness_plan_status_value] = src.[wellness_plan_status_value]
				, [wellness_plan_status_text] = src.[wellness_plan_status_text]
				, [parent_wellness_plan_status_value] = src.[parent_wellness_plan_status_value]
				, [parent_wellness_plan_status_text] = src.[parent_wellness_plan_status_text]
				,[DWHModifiedOn] = @systemCurrentDate
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = isnull(nullif(src.[DWHDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source and trg.[DWHDMLOperation] <> 'D' then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [dim_company_key] 
					,[dim_client_key]
					,[dim_client_unique_key]
					,[dim_client_referral_key]
					,[dim_client_referral_unique_key]
					,[dim_created_by_employee_key]
					,[dim_review_date_key]
					,[dim_created_date_key]
					,[primhd_service_review_id] 
					,[client_id] 
					,[client_referral_id] 
					,[created_by_employee_id] 
					,[created_by_user_email_address] 
					,[review_date] 
					,[created_date] 
					,[accommodation_status_value] 
					,[accommodation_status_text] 
					,[parent_accommodation_status_value] 
					,[parent_accommodation_status_text] 
					,[education_status_value] 
					,[education_status_text] 
					,[parent_education_status_value] 
					,[parent_education_status_text] 
					,[employment_status_value] 
					,[employment_status_text] 
					,[parent_employment_status_value] 
					,[parent_employment_status_text] 
					,[wellness_plan_status_value] 
					,[wellness_plan_status_text] 
					,[parent_wellness_plan_status_value] 
					,[parent_wellness_plan_status_text] 
					,[DWHBatchId] 
					,[DWHCreatedAt] 
					,[DWHModifiedOn] 
					,[DWHDMLOperation] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[dim_company_key] 
					,src.[dim_client_key]
					,src.[dim_client_unique_key]
					,src.[dim_client_referral_key]
					,src.[dim_client_referral_unique_key]
					,src.[dim_created_by_employee_key]
					,src.[dim_review_date_key]
					,src.[dim_created_date_key]				 
					,src.[primhd_service_review_id] 
					,src.[client_id] 
					,src.[client_referral_id] 
					,src.[created_by_employee_id] 
					,src.[created_by_user_email_address] 
					,src.[review_date] 
					,src.[created_date] 
					,src.[accommodation_status_value] 
					,src.[accommodation_status_text] 
					,src.[parent_accommodation_status_value] 
					,src.[parent_accommodation_status_text] 
					,src.[education_status_value] 
					,src.[education_status_text] 
					,src.[parent_education_status_value] 
					,src.[parent_education_status_text] 
					,src.[employment_status_value] 
					,src.[employment_status_text] 
					,src.[parent_employment_status_value] 
					,src.[parent_employment_status_text] 
					,src.[wellness_plan_status_value] 
					,src.[wellness_plan_status_text] 
					,src.[parent_wellness_plan_status_value] 
					,src.[parent_wellness_plan_status_text] 
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
		from [edw].[fact_client_primhd_service_review];

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