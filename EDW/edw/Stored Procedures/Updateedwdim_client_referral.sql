

/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_client_referral]
 Author		
 Created		
 Purpose		
				

				
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
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
1.21	2024-02-22	  Glenn McLeod			7161: Bug Fix (7058) updates to records not being captured
												Added new column [client_referral_status]
1.22	2024-03-04	  Glenn McLeod			User Story 7207: added multiple columns
1.23	2024-03-22	  Glenn McLeod			Bug 7255: Rename client_referral_code to client_referrer_code

**********************************************************************************************************/


CREATE procedure [edw].[Updateedwdim_client_referral] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[dim_client_referral]';
	
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

	   if( not exists (select 1 from [edw].[dim_client_referral] where dim_client_referral_key<=0) )
		BEGIN
			-- turn the identity insert on 
		   SET IDENTITY_INSERT [edw].[dim_client_referral] ON
		   insert into [edw].[dim_client_referral]
		   (
			   [dim_client_referral_key]
			  ,[client_referral_id]
			  ,[client_id]
			  ,[dim_client_referral_unique_key]
			  ,[company_id]
			  ,[DWHSourceSystem]
			  ,[DWHBatchId]
			  ,[DWHDMLOperation]
			  ,[DWHModifiedOn]
			  ,[DWHCreatedAt]
		   )
		VALUES	(0,0,0,'N/A',0,@SourceSystem,0,'I',@systemCurrentDate,@systemCurrentDate),
				(-1,-1,-1,'Unknown',0,@SourceSystem,0,'I',@systemCurrentDate,@systemCurrentDate)
		  -- turn the identity insert off
			   SET IDENTITY_INSERT [edw].[dim_client_referral] OFF
		END 


	-- Do not run if there are no records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_client_referral];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) 
			,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_client_referral];

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


	if( not exists (select top(1) 1 from [edw].[dim_client_referral] WHERE [dim_client_referral_key] > 0) )
	  begin
	   -- There are no records in the target; insert all
	   insert into [edw].[dim_client_referral]
	   (
		  [client_referral_id]
		  ,[dim_client_referral_unique_key]
		  ,[company_id]
		  ,[client_id]
		  ,[client_team_id]
		  ,[client_referral_type]
		  ,[client_referrer_name]
		  ,[client_referral_source_id]
		  ,[client_referral_discharge_reason]
		  ,[client_referral_accepted_reason]
		  ,[client_referral_waitlist_reason]
		  ,[client_referral_declined_reason]
		  ,[client_referral_pending_reason]
		  ,[client_status_is_active]
		  ,[client_referral_status]
		  ,[client_referral_discharge_reason_code]
		  ,[client_referral_accepted_reason_code]
		  ,[client_referral_waitlist_reason_code]
		  ,[client_referral_declined_reason_code]
		  ,[client_referral_pending_reason_code]
		  ,[client_referrer_code]
		  ,[client_referral_discharge_comment]
		  ,[client_referral_accepted_comment]
		  ,[client_referral_waitlist_comment]
		  ,[client_referral_declined_comment]
		  ,[client_referral_pending_comment]
		  ,[DWHSourceSystem]
		  ,[DWHBatchId]
		  ,[DWHDMLOperation]
		  ,[DWHModifiedOn]
		  ,[DWHCreatedAt]
	   )
	   select
		    src.[client_referral_id]
		  ,src.[dim_client_referral_unique_key]
		  ,src.[company_id]
		  ,src.[client_id]
		  ,src.[client_team_id]
		  ,src.[client_referral_type]
		  ,src.[client_referrer_name]
		  ,src.[client_referral_source_id]
		  ,src.[client_referral_discharge_reason]
		  ,src.[client_referral_accepted_reason]
		  ,src.[client_referral_waitlist_reason]
		  ,src.[client_referral_declined_reason]
		  ,src.[client_referral_pending_reason]
		  ,src.[client_status_is_active]
		  ,src.[client_referral_status]
		  ,src.[client_referral_discharge_reason_code]
		  ,src.[client_referral_accepted_reason_code]
		  ,src.[client_referral_waitlist_reason_code]
		  ,src.[client_referral_declined_reason_code]
		  ,src.[client_referral_pending_reason_code]
		  ,src.[client_referrer_code]
	      ,src.[client_referral_discharge_comment]
		  ,src.[client_referral_accepted_comment]
		  ,src.[client_referral_waitlist_comment]
		  ,src.[client_referral_declined_comment]
		  ,src.[client_referral_pending_comment]
		  ,@SourceSystem as [DWHSourceSystem]
		  ,@BatchID as [DWHBatchId]
		  ,'I' as [DWHDMLOperation]
		  ,@systemCurrentDate as [DWHCreatedAt]
		  ,@systemCurrentDate as [DWHModifiedOn]
	   from [Staging].[ODSETLdim_client_referral] as src;
	  end else 
	begin
		merge into [edw].[dim_client_referral] as trg
		   using 
		   (
			select
			 src.[client_referral_id]
			  ,src.[dim_client_referral_unique_key]
			  ,src.[company_id]
			  ,src.[client_id]
			  ,src.[client_team_id]
			  ,src.[client_referral_type]
			  ,src.[client_referrer_name]
			  ,src.[client_referral_source_id]
			  ,src.[client_referral_discharge_reason]
			  ,src.[client_referral_accepted_reason]
			  ,src.[client_referral_waitlist_reason]
			  ,src.[client_referral_declined_reason]
			  ,src.[client_referral_pending_reason]
			  ,src.[client_status_is_active]
			  ,src.[client_referral_status]
			  ,src.[client_referral_discharge_reason_code]
			  ,src.[client_referral_accepted_reason_code]
			  ,src.[client_referral_waitlist_reason_code]
			  ,src.[client_referral_declined_reason_code]
			  ,src.[client_referral_pending_reason_code]
			  ,src.[client_referrer_code]
			  ,src.[client_referral_discharge_comment]
			  ,src.[client_referral_accepted_comment]
			  ,src.[client_referral_waitlist_comment]
			  ,src.[client_referral_declined_comment]
			  ,src.[client_referral_pending_comment]
			  ,@BatchID as [DWHBatchId]
			  ,@systemCurrentDate as [DWHCreatedAt]
			  ,@systemCurrentDate as [DWHModifiedOn]
			  ,'I' as [DWHDMLOperation]
			  ,@SourceSystem as [DWHSourceSystem]
			from [staging].[ODSETLdim_client_referral] as src
		) as src on (src.[dim_client_referral_unique_key] = trg.[dim_client_referral_unique_key] collate database_default)   
		-- Update existing records
		   when matched and exists 
		   ( 
			select --src.[dim_client_referral_unique_key]
			   src.[company_id]
			  ,src.[client_id]
			  ,src.[client_team_id]
			  ,src.[client_referral_type]
			  ,src.[client_referrer_name]
			  ,src.[client_referral_source_id]
			  ,src.[client_referral_discharge_reason]
			  ,src.[client_referral_accepted_reason]
			  ,src.[client_referral_waitlist_reason]
			  ,src.[client_referral_declined_reason]
			  ,src.[client_referral_pending_reason]
			  ,src.[client_status_is_active]
			  ,src.[client_referral_status]
			  ,src.[client_referral_discharge_reason_code]
			  ,src.[client_referral_accepted_reason_code]
			  ,src.[client_referral_waitlist_reason_code]
			  ,src.[client_referral_declined_reason_code]
			  ,src.[client_referral_pending_reason_code]
			  ,src.[client_referrer_code]
			  ,src.[client_referral_discharge_comment]
			  ,src.[client_referral_accepted_comment]
			  ,src.[client_referral_waitlist_comment]
			  ,src.[client_referral_declined_comment]
			  ,src.[client_referral_pending_comment]
			
			except

			select --trg.[dim_client_referral_unique_key]
			   trg.[company_id]
			  ,trg.[client_id]
			  ,trg.[client_team_id]
			  ,trg.[client_referral_type]
			  ,trg.[client_referrer_name]
			  ,trg.[client_referral_source_id]
			  ,trg.[client_referral_discharge_reason]
			  ,trg.[client_referral_accepted_reason]
			  ,trg.[client_referral_waitlist_reason]
			  ,trg.[client_referral_declined_reason]
			  ,trg.[client_referral_pending_reason]
			  ,trg.[client_status_is_active]
			  ,trg.[client_referral_status]
			  ,trg.[client_referral_discharge_reason_code]
			  ,trg.[client_referral_accepted_reason_code]
			  ,trg.[client_referral_waitlist_reason_code]
			  ,trg.[client_referral_declined_reason_code]
			  ,trg.[client_referral_pending_reason_code]
			  ,trg.[client_referrer_code]
			  ,trg.[client_referral_discharge_comment]
			  ,trg.[client_referral_accepted_comment]
			  ,trg.[client_referral_waitlist_comment]
			  ,trg.[client_referral_declined_comment]
			  ,trg.[client_referral_pending_comment]

		   ) then  update set 
			 [client_referral_id]=src.[client_referral_id]
			,[dim_client_referral_unique_key]=src.[dim_client_referral_unique_key]
			,[company_id]=src.[company_id]
			,[client_id]=src. [client_id]
			,[client_team_id]=src.[client_team_id]
			,[client_referral_type]=src.[client_referral_type]
			,[client_referrer_name]=src.[client_referrer_name]
			,[client_referral_source_id]=src.[client_referral_source_id]
			,[client_referral_discharge_reason]=src.[client_referral_discharge_reason]
			,[client_referral_accepted_reason]=src.[client_referral_accepted_reason]
			,[client_referral_waitlist_reason]=src.[client_referral_waitlist_reason]
			,[client_referral_declined_reason]=src.[client_referral_declined_reason]
			,[client_referral_pending_reason]=src.[client_referral_pending_reason]
			,[client_status_is_active]=src.[client_status_is_active]
			,[client_referral_status] = src.[client_referral_status]
			,[client_referral_discharge_reason_code] = src.[client_referral_discharge_reason_code]
			,[client_referral_accepted_reason_code] = src.[client_referral_accepted_reason_code]
			,[client_referral_waitlist_reason_code] = src.[client_referral_waitlist_reason_code]
			,[client_referral_declined_reason_code] = src.[client_referral_declined_reason_code]
			,[client_referral_pending_reason_code] = src.[client_referral_pending_reason_code]
			,[client_referrer_code] = src.[client_referrer_code]
			,[client_referral_discharge_comment] = src.[client_referral_discharge_comment]
			,[client_referral_accepted_comment] = src.[client_referral_accepted_comment]
			,[client_referral_waitlist_comment] = src.[client_referral_waitlist_comment]
			,[client_referral_declined_comment] = src.[client_referral_declined_comment]
			,[client_referral_pending_comment] = src.[client_referral_pending_comment]
			,[DWHSourceSystem] = @SourceSystem
			,[DWHModifiedOn] = @systemCurrentDate
			,[DWHBatchId] = @BatchID
			,[DWHDMLOperation] = 'U'
		   -- Soft delete missing records
		   when not matched by source 
				and trg.[dim_client_referral_key] > 0
				and trg.[DWHDMLOperation] <> 'D' 
			then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
		   -- Insert new records
		   when not matched by target then 
			insert 
			(
			   [client_referral_id]
			  ,[dim_client_referral_unique_key]
			  ,[company_id]
			  ,[client_id]
			  ,[client_team_id]
			  ,[client_referral_type]
			  ,[client_referrer_name]
			  ,[client_referral_source_id]
			  ,[client_referral_discharge_reason]
			  ,[client_referral_accepted_reason]
			  ,[client_referral_waitlist_reason]
			  ,[client_referral_declined_reason]
			  ,[client_referral_pending_reason]
			  ,[client_status_is_active]
			  ,[client_referral_status]
			  ,[client_referral_discharge_reason_code]
			  ,[client_referral_accepted_reason_code]
			  ,[client_referral_waitlist_reason_code]
			  ,[client_referral_declined_reason_code]
			  ,[client_referral_pending_reason_code]
			  ,[client_referrer_code]
			  ,[client_referral_discharge_comment]
			  ,[client_referral_accepted_comment]
			  ,[client_referral_waitlist_comment]
			  ,[client_referral_declined_comment]
			  ,[client_referral_pending_comment]
			  ,[DWHSourceSystem]
			  ,[DWHBatchId]
			  ,[DWHDMLOperation]
			  ,[DWHModifiedOn]
			  ,[DWHCreatedAt]
			)
			values
			(
			   src.[client_referral_id]
			  ,src.[dim_client_referral_unique_key]
			  ,src.[company_id]
			  ,src.[client_id]
			  ,src.[client_team_id]
			  ,src.[client_referral_type]
			  ,src.[client_referrer_name]
			  ,src.[client_referral_source_id]
			  ,src.[client_referral_discharge_reason]
			  ,src.[client_referral_accepted_reason]
			  ,src.[client_referral_waitlist_reason]
			  ,src.[client_referral_declined_reason]
			  ,src.[client_referral_pending_reason]
			  ,src.[client_status_is_active]
			  ,src.[client_referral_status]
			  ,src.[client_referral_discharge_reason_code]
			  ,src.[client_referral_accepted_reason_code]
			  ,src.[client_referral_waitlist_reason_code]
			  ,src.[client_referral_declined_reason_code]
			  ,src.[client_referral_pending_reason_code]
			  ,src.[client_referrer_code]
			  ,src.[client_referral_discharge_comment]
			  ,src.[client_referral_accepted_comment]
			  ,src.[client_referral_waitlist_comment]
			  ,src.[client_referral_declined_comment]
			  ,src.[client_referral_pending_comment]
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
		from [edw].[dim_client_referral]
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