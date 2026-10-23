










/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_client_personal_goal_action_status] 
 Author		
 Created		
 Purpose		
				

				
 Call By		EDW Pipeline '30_Load_From_ODS'
 Parameter(s)  None 
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		?			  ?						Initial creation of stored procedure
1.1		2023-08-22	  Glenn McLeod			Rename source tables
1.11	2023-08-23	  Glenn McLeod			Altered to stop 0 record [DWHEffectiveTo] from being update
1.12	2023-08-25	  Glenn McLeod			Updated table/column names
1.2		2023-09-25	  Glenn McLeod			Add -1 record of for Unknown and updated 0 record to be N/A
											Renamed dim_company_key as company_id
1.21	2024-02-22	  Glenn McLeod			User Story 7161: (Bug Fix 6824) Fact_Client_Referral - updates to records not being captured

**********************************************************************************************************/


CREATE procedure [edw].[Updateedwdim_client_personal_goal_action_status] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[dim_client_personal_goal_action_status]';
	
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

	begin transaction;

	begin try



	   if( not exists (select 1 from [edw].[dim_client_personal_goal_action_status] where dim_client_personal_goal_action_status_key<=0) )
		BEGIN
			-- turn the identity insert on 
		   SET IDENTITY_INSERT [edw].[dim_client_personal_goal_action_status] ON
		   insert into [edw].[dim_client_personal_goal_action_status]
		   (
			   [dim_client_personal_goal_action_status_key]
			  ,[company_id]
			  ,[dim_client_personal_goal_action_status_unique_key]
			  ,[personal_goal_action_status_id]
			  ,[personal_goal_action_status_code]
			  ,[personal_goal_action_status_text]
			  ,[personal_goal_action_status_is_completed_status]
			  ,[personal_goal_action_status_is_cancelled_status]
			  ,[personal_goal_action_status_sort_index]
			  ,[DWHSourceSystem]
			  ,[DWHBatchId]
			  ,[DWHDMLOperation]
			  ,[DWHModifiedOn]
			  ,[DWHCreatedAt]
		   )
		VALUES (0,0,'N/A',0,'N/A','N/A',0,0,0,@SourceSystem,0,'I',@systemCurrentDate,@systemCurrentDate),
				(-1,-1,'Unknown',-1,'Unknown','Unknown',-1,-1,-1,@SourceSystem,0,'I',@systemCurrentDate,@systemCurrentDate)
		  -- turn the identity insert off
			   SET IDENTITY_INSERT [edw].[dim_client_personal_goal_action_status] OFF
		END 


	-- Do not run if there are no records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_client_personal_goal_action_status];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) 
			,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_client_personal_goal_action_status];

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



	  if( not exists (select top(1) 1 from [edw].[dim_client_personal_goal_action_status] WHERE [dim_client_personal_goal_action_status_key] > 0) )
		  begin
		   -- There are no records in the target; insert all
		   insert into [edw].[dim_client_personal_goal_action_status]
		   (
			   [company_id]
			  ,[dim_client_personal_goal_action_status_unique_key]
			  ,[personal_goal_action_status_id]
			  ,[personal_goal_action_status_code]
			  ,[personal_goal_action_status_text]
			  ,[personal_goal_action_status_is_completed_status]
			  ,[personal_goal_action_status_is_cancelled_status]
			  ,[personal_goal_action_status_sort_index]
			  ,[DWHSourceSystem]
			  ,[DWHBatchId]
			  ,[DWHDMLOperation]
			  ,[DWHModifiedOn]
			  ,[DWHCreatedAt]
		   )
		   select
			   src.[company_id]
			  ,src.[dim_client_personal_goal_action_status_unique_key]
			  ,src.[personal_goal_action_status_id]
			  ,src.[personal_goal_action_status_code]
			  ,src.[personal_goal_action_status_text]
			  ,src.[personal_goal_action_status_is_completed_status]
			  ,src.[personal_goal_action_status_is_cancelled_status]
			  ,src.[personal_goal_action_status_sort_index]
			  ,@SourceSystem as [DWHSourceSystem]
			  ,@BatchID as [DWHBatchId]
			  ,'I' as [DWHDMLOperation]
			  ,@systemCurrentDate as [DWHCreatedAt]
			  ,@systemCurrentDate as [DWHModifiedOn]
		   from [staging].[ODSETLdim_client_personal_goal_action_status] as src;
		  end else 
		begin
		   merge into [edw].[dim_client_personal_goal_action_status] as trg
		   using 
		   (
			select
			   src.[company_id]
			  ,src.[dim_client_personal_goal_action_status_unique_key]
			  ,src.[personal_goal_action_status_id]
			  ,src.[personal_goal_action_status_code]
			  ,src.[personal_goal_action_status_text]
			  ,src.[personal_goal_action_status_is_completed_status]
			  ,src.[personal_goal_action_status_is_cancelled_status]
			  ,src.[personal_goal_action_status_sort_index]
			  ,@SourceSystem as [DWHSourceSystem]
			  ,@BatchID as [DWHBatchId]
			  ,'I' as [DWHDMLOperation]
			  ,@systemCurrentDate as [DWHCreatedAt]
			  ,@systemCurrentDate as [DWHModifiedOn]
			from [staging].[ODSETLdim_client_personal_goal_action_status] as src
		) as src on (src.[dim_client_personal_goal_action_status_unique_key] = trg.[dim_client_personal_goal_action_status_unique_key] collate database_default)   -- Retire existing records
		   when matched and exists 
		   ( 
			select --src.[dim_client_personal_goal_action_status_unique_key],src.[personal_goal_action_status_id]
			   src.[personal_goal_action_status_code]
			  ,src.[personal_goal_action_status_text]
			  ,src.[personal_goal_action_status_is_completed_status]
			  ,src.[personal_goal_action_status_is_cancelled_status]
			  ,src.[personal_goal_action_status_sort_index]

			except

			select --trg.[dim_client_personal_goal_action_status_unique_key],trg.[personal_goal_action_status_id]
			   trg.[personal_goal_action_status_code]
			  ,trg.[personal_goal_action_status_text]
			  ,trg.[personal_goal_action_status_is_completed_status]
			  ,trg.[personal_goal_action_status_is_cancelled_status]
			  ,trg.[personal_goal_action_status_sort_index]


		   ) then  update set 
			 [company_id]=src.[company_id]
			,[dim_client_personal_goal_action_status_unique_key]=src.[dim_client_personal_goal_action_status_unique_key]
			,[personal_goal_action_status_id]=src.[personal_goal_action_status_id]
			,[personal_goal_action_status_code]=src.[personal_goal_action_status_code]
			,[personal_goal_action_status_text]=src.[personal_goal_action_status_text]
			,[personal_goal_action_status_is_completed_status]=src.[personal_goal_action_status_is_completed_status]
			,[personal_goal_action_status_is_cancelled_status]=src.[personal_goal_action_status_is_cancelled_status]
			,[personal_goal_action_status_sort_index]=src.[personal_goal_action_status_sort_index]
			,[DWHSourceSystem] = @SourceSystem
			,[DWHModifiedOn] = @systemCurrentDate
			,[DWHBatchId] = @BatchID
			,[DWHDMLOperation] = 'U'
		   -- Soft delete missing records
		   when not matched by source 
				and trg.[dim_client_personal_goal_action_status_key] > 0
				and trg.[DWHDMLOperation] <> 'D' 
			then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
		   -- Insert new records
		   when not matched by target then 
			insert 
			(
			   [company_id]
			  ,[dim_client_personal_goal_action_status_unique_key]
			  ,[personal_goal_action_status_id]
			  ,[personal_goal_action_status_code]
			  ,[personal_goal_action_status_text]
			  ,[personal_goal_action_status_is_completed_status]
			  ,[personal_goal_action_status_is_cancelled_status]
			  ,[personal_goal_action_status_sort_index]
			  ,[DWHSourceSystem]
			  ,[DWHBatchId]
			  ,[DWHDMLOperation]
			  ,[DWHModifiedOn]
			  ,[DWHCreatedAt]
			)
			values
			(
			   src.[company_id]
			  ,src.[dim_client_personal_goal_action_status_unique_key]
			  ,src.[personal_goal_action_status_id]
			  ,src.[personal_goal_action_status_code]
			  ,src.[personal_goal_action_status_text]
			  ,src.[personal_goal_action_status_is_completed_status]
			  ,src.[personal_goal_action_status_is_cancelled_status]
			  ,src.[personal_goal_action_status_sort_index]
			  ,src.[DWHSourceSystem]
			  ,src.[DWHBatchId]
			  ,src.[DWHDMLOperation]
			  ,src.[DWHModifiedOn]
			  ,src.[DWHCreatedAt]
			);
		  end;



		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_client_personal_goal_action_status]
		--where [DWHEffectiveTo] = @SystemDefaultEffectiveTo;

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