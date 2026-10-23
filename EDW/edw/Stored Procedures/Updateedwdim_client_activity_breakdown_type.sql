











/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_client_activity_breakdown_type] 
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
1.1		2023-08-21	  Glenn McLeod			Rename source tables
1.11	2023-08-23	  Glenn McLeod			Altered to stop 0 record [DWHEffectiveTo] from being update
1.2		2023-09-25	  Glenn McLeod			Add -1 record of for Unknown and updated 0 record to be N/A
											Renamed dim_company_key as company_id
1.21	2024-02-22	  Glenn McLeod			User Story 7161: (Bug Fix 6824) Fact_Client_Referral - updates to records not being captured

**********************************************************************************************************/


CREATE procedure [edw].[Updateedwdim_client_activity_breakdown_type] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[dim_client_activity_breakdown_type]';
	
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

	   if( not exists (select 1 from [edw].[dim_client_activity_breakdown_type] where dim_client_activity_breakdown_type_key<=0) )
			BEGIN
				-- turn the identity insert on 
			   SET IDENTITY_INSERT [edw].[dim_client_activity_breakdown_type] ON

			   insert into [edw].[dim_client_activity_breakdown_type]
			   (
				   [dim_client_activity_breakdown_type_key]
				  ,[client_activity_breakdown_type_id]
				  ,[dim_client_activity_breakdown_type_unique_key]
				  ,[company_id]
				  ,[client_activity_breakdown_type_code]
				  ,[client_activity_breakdown_type_name]
				  ,[DWHSourceSystem]
				  ,[DWHBatchId]
				  ,[DWHDMLOperation]
				  ,[DWHModifiedOn]
				  ,[DWHCreatedAt]
			   )
			   	VALUES	(0,0,'N/A',0,'N/A','N/A',@SourceSystem,0,'I',@systemCurrentDate,@systemCurrentDate),
						(-1,-1,'Unknown',-1,'Unknown','Unknown',@SourceSystem,0,'I',@systemCurrentDate,@systemCurrentDate)

				-- turn the identity insert off
				SET IDENTITY_INSERT [edw].[dim_client_activity_breakdown_type] OFF

			END 



	-- Do not run if there are no records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_client_activity_breakdown_type];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_client_activity_breakdown_type];

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


	 if( not exists (select top(1) 1 from [edw].[dim_client_activity_breakdown_type] where [dim_client_activity_breakdown_type_key] >0) )
	  begin
	   -- There are no records in the target; insert all
	   insert into [edw].[dim_client_activity_breakdown_type]
	   (
		   [client_activity_breakdown_type_id]
		  ,[dim_client_activity_breakdown_type_unique_key]
		  ,[company_id]
		  ,[team_configuration_name]
		  ,[client_activity_breakdown_type_code]
		  ,[client_activity_breakdown_type_name]
		  ,[client_parent_activity_breakdown_type]
		  ,[client_parent_activity_breakdown_type_name]
		  ,[DWHSourceSystem]
		  ,[DWHBatchId]
		  ,[DWHDMLOperation]
		  ,[DWHModifiedOn]
		  ,[DWHCreatedAt]
	   )
	   select
		   src.[client_activity_breakdown_type_id]
		  ,src.[dim_client_activity_breakdown_type_unique_key]
		  ,src.[company_id]
		  ,src.[team_configuration_name]
		  ,src.[client_activity_breakdown_type_code]
		  ,src.[client_activity_breakdown_type_name]
		  ,src.[client_parent_activity_breakdown_type]
		  ,src.[client_parent_activity_breakdown_type_name]
		  ,@SourceSystem as [DWHSourceSystem]
		  ,@BatchID as [DWHBatchId]
		  ,'I' as [DWHDMLOperation]
		  ,@systemCurrentDate as [DWHCreatedAt]
		  ,@systemCurrentDate as [DWHModifiedOn]
	   from [Staging].[ODSETLdim_client_activity_breakdown_type] as src;
	  end else
	  begin
	  merge into [edw].[dim_client_activity_breakdown_type] as trg
		using 
		(
		select
			src.[client_activity_breakdown_type_id]
			,src.[dim_client_activity_breakdown_type_unique_key]
			,src.[company_id]
			,src.[team_configuration_name]
			,src.[client_activity_breakdown_type_code]
			,src.[client_activity_breakdown_type_name]
			,src.[client_parent_activity_breakdown_type]
			,src.[client_parent_activity_breakdown_type_name]
			,@SourceSystem as [DWHSourceSystem]
			,@BatchID as [DWHBatchId]
			,'I' as [DWHDMLOperation]
			,@systemCurrentDate as [DWHCreatedAt]
			,@systemCurrentDate as [DWHModifiedOn]
		from [Staging].[ODSETLdim_client_activity_breakdown_type] as src
	) as src on (src.[dim_client_activity_breakdown_type_unique_key] = trg.[dim_client_activity_breakdown_type_unique_key] collate database_default)   -- Retire existing records
		when matched and exists 
		( 
		select --src.[dim_client_activity_breakdown_type_unique_key]
			 src.[team_configuration_name]
			,src.[client_activity_breakdown_type_code]
			,src.[client_activity_breakdown_type_name]
			,src.[client_parent_activity_breakdown_type]
			,src.[client_parent_activity_breakdown_type_name]

		except

		select --trg.[dim_client_activity_breakdown_type_unique_key]
			 trg.[team_configuration_name]
			,trg.[client_activity_breakdown_type_code]
			,trg.[client_activity_breakdown_type_name]
			,trg.[client_parent_activity_breakdown_type]
			,trg.[client_parent_activity_breakdown_type_name]

		) then  update set 
		[client_activity_breakdown_type_id]=src.[client_activity_breakdown_type_id]
		,[dim_client_activity_breakdown_type_unique_key]=src.[dim_client_activity_breakdown_type_unique_key]
		,[company_id]=src.[company_id]
		,[team_configuration_name]=src.[team_configuration_name]
		,[client_activity_breakdown_type_code]=src.[client_activity_breakdown_type_code]
		,[client_activity_breakdown_type_name]=src.[client_activity_breakdown_type_name]
		,[client_parent_activity_breakdown_type]=src.[client_parent_activity_breakdown_type]
		,[client_parent_activity_breakdown_type_name]=src.[client_parent_activity_breakdown_type_name]
		,[DWHSourceSystem] = @SourceSystem
		,[DWHModifiedOn] = @systemCurrentDate
		,[DWHBatchId] = @BatchID
		,[DWHDMLOperation] = 'U'
		-- Soft delete missing records
		when not matched by source 
			and trg.[dim_client_activity_breakdown_type_key] > 0
			and trg.[DWHDMLOperation] <> 'D' 
		then 
			update 
			set [DWHModifiedOn] = @systemCurrentDate
				,[DWHDMLOperation] = 'D'
		-- Insert new records
		when not matched by target then 
		insert 
		(
			[client_activity_breakdown_type_id]
			,[dim_client_activity_breakdown_type_unique_key]
			,[company_id]
			,[team_configuration_name]
			,[client_activity_breakdown_type_code]
			,[client_activity_breakdown_type_name]
			,[client_parent_activity_breakdown_type]
			,[client_parent_activity_breakdown_type_name]
			,[DWHSourceSystem]
			,[DWHBatchId]
			,[DWHDMLOperation]
			,[DWHModifiedOn]
			,[DWHCreatedAt]
		)
		values
		(
			src.[client_activity_breakdown_type_id]
			,src.[dim_client_activity_breakdown_type_unique_key]
			,src.[company_id]
			,src.[team_configuration_name]
			,src.[client_activity_breakdown_type_code]
			,src.[client_activity_breakdown_type_name]
			,src.[client_parent_activity_breakdown_type]
			,src.[client_parent_activity_breakdown_type_name]
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
		from [edw].[dim_client_activity_breakdown_type]
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