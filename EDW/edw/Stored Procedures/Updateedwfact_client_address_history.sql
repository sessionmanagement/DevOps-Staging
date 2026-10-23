








/**********************************************************************************************************
 Procedure	[edw].[Updateedwfact_client_address_history] 
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
1.11	2023-08-29	  Glenn McLeod			Updated table/column names
1.2		2023-09-25	  Glenn McLeod			Add -1 record, update to identify difference between N/A and Unknown dim records
											Updated dim joins to use company_id rather than dim_company_key
											Updated so that [dim_company_key] is not the company_id
1.21	2024-02-21	  Glenn McLeod			User Story 7161: (Bug Fix 6824) updates to records not being captured

**********************************************************************************************************/


CREATE procedure [edw].[Updateedwfact_client_address_history] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[fact_client_address_history]';
	
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



	-- Do not run if there are no records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_client_address_history];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_client_address_history];

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


		
		  if( not exists (select top(1) 1 from [edw].[fact_client_address_history] where [fact_client_address_history_key] > 0) )
			begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_client_address_history]
			(
				[fact_client_address_history_unique_key]
				,[dim_company_key]
				,[dim_client_key]
				,[client_id]
				,[client_address_id]
				,[client_address_name]
				,[client_address_line1]
				,[client_address_line2]
				,[client_address_line3]
				,[client_address_suburb]
				,[client_address_town_or_city]
				,[client_address_post_code]
				,[client_address_created_date_key]
				,[client_address_start_date_key]
				,[client_address_end_date_key]
				,[client_address_is_postal_flag]
				,[client_address_is_primary_flag]
				,[DWHSourceSystem]
				,[DWHBatchId]
				,[DWHDMLOperation]
				,[DWHModifiedOn]
				,[DWHCreatedAt]
			)
			select
				src.[fact_client_address_history_unique_key]
				--,src.[dim_company_key]
				,isnull(DCY.[dim_company_key], CASE WHEN src.company_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_company_key]
				,isnull(dc.[dim_client_key],case when src.client_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_client_key]
				,src.[client_id]
				,src.[client_address_id]
				,src.[client_address_name]
				,src.[client_address_line1]
				,src.[client_address_line2]
				,src.[client_address_line3]
				,src.[client_address_suburb]
				,src.[client_address_town_or_city]
				,src.[client_address_post_code]
				,src.[client_address_created_date_key]
				,src.[client_address_start_date_key]
				,src.[client_address_end_date_key]
				,src.[client_address_is_postal_flag]
				,src.[client_address_is_primary_flag]
				,@SourceSystem as [DWHSourceSystem]
				,@BatchID as [DWHBatchId]
				,'I' as [DWHDMLOperation]
				,@systemCurrentDate as [DWHCreatedAt]
				,@systemCurrentDate as [DWHModifiedOn]
			from [staging].[ODSETLfact_client_address_history] as src
			LEFT JOIN [edw].[dim_client] dc
				on src.client_id = dc.client_id
				and CONVERT(datetime,cast(src.client_address_created_date_key as nvarchar)) between dc.DWHEffectiveFrom and dc.DWHEffectiveTo
				and src.company_id= dc.company_id
			LEFT JOIN edw.dim_company DCY
			   on src.company_id = dcy.company_id
			   and dcy.DWHIsCurrent = 1
				;
			end else begin
			merge into [edw].[fact_client_address_history] as trg
			using 
			(
			select
				src.[fact_client_address_history_unique_key]
				--,src.[dim_company_key]
				,isnull(DCY.[dim_company_key], CASE WHEN src.company_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_company_key]
				,isnull(dc.[dim_client_key],case when src.client_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_client_key]
				,src.[client_id]
				,src.[client_address_id]
				,src.[client_address_name]
				,src.[client_address_line1]
				,src.[client_address_line2]
				,src.[client_address_line3]
				,src.[client_address_suburb]
				,src.[client_address_town_or_city]
				,src.[client_address_post_code]
				,src.[client_address_created_date_key]
				,src.[client_address_start_date_key]
				,src.[client_address_end_date_key]
				,src.[client_address_is_postal_flag]
				,src.[client_address_is_primary_flag]
				,@SourceSystem as [DWHSourceSystem]
				,@BatchID as [DWHBatchId]
				,'I' as [DWHDMLOperation]
				,@systemCurrentDate as [DWHCreatedAt]
				,@systemCurrentDate as [DWHModifiedOn]
			from [staging].[ODSETLfact_client_address_history] as src
			LEFT JOIN [edw].[dim_client] dc
				on src.client_id = dc.client_id
				and CONVERT(datetime,cast(src.client_address_created_date_key as nvarchar)) between dc.DWHEffectiveFrom and dc.DWHEffectiveTo
				and src.company_id= dc.company_id
			LEFT JOIN edw.dim_company DCY
			   on src.company_id = dcy.company_id
			   and dcy.DWHIsCurrent = 1
		) as src on (src.[fact_client_address_history_unique_key] = trg.[fact_client_address_history_unique_key] collate database_default)   
			-- Update existing records
			when matched and exists 
			( 
			select --src.[fact_client_address_history_unique_key]
				 src.[client_id]
				,src.[client_address_id]
				,src.[client_address_name]
				,src.[client_address_line1]
				,src.[client_address_line2]
				,src.[client_address_line3]
				,src.[client_address_suburb]
				,src.[client_address_town_or_city]
				,src.[client_address_post_code]
				,src.[client_address_created_date_key]
				,src.[client_address_start_date_key]
				,src.[client_address_end_date_key]
				,src.[client_address_is_postal_flag]
				,src.[client_address_is_primary_flag]

			EXCEPT

			SELECT
				 trg.[client_id]
				,trg.[client_address_id]
				,trg.[client_address_name]
				,trg.[client_address_line1]
				,trg.[client_address_line2]
				,trg.[client_address_line3]
				,trg.[client_address_suburb]
				,trg.[client_address_town_or_city]
				,trg.[client_address_post_code]
				,trg.[client_address_created_date_key]
				,trg.[client_address_start_date_key]
				,trg.[client_address_end_date_key]
				,trg.[client_address_is_postal_flag]
				,trg.[client_address_is_primary_flag]


			) then  update set 
				[fact_client_address_history_unique_key]=src.[fact_client_address_history_unique_key]
				,[dim_company_key]=src.[dim_company_key]
				,[dim_client_key]=src.[dim_client_key]
				,[client_id]=src.[client_id]
				,[client_address_id]=src.[client_address_id]
				,[client_address_name]=src.[client_address_name]
				,[client_address_line1]=src.[client_address_line1]
				,[client_address_line2]=src.[client_address_line2]
				,[client_address_line3]=src.[client_address_line3]
				,[client_address_suburb]=src.[client_address_suburb]
				,[client_address_town_or_city]=src.[client_address_town_or_city]
				,[client_address_post_code]=src.[client_address_post_code]
				,[client_address_created_date_key]=src.[client_address_created_date_key]
				,[client_address_start_date_key]=src.[client_address_start_date_key]
				,[client_address_end_date_key]=src.[client_address_end_date_key]
				,[client_address_is_postal_flag]=src.[client_address_is_postal_flag]
				,[client_address_is_primary_flag]=src.[client_address_is_primary_flag]
				,[DWHSourceSystem] = @SourceSystem
				,[DWHModifiedOn] = @systemCurrentDate
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = 'U'
			-- Soft delete missing records
			when not matched by source and trg.[DWHDMLOperation] <> 'D' then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
			-- Insert new records
			when not matched by target then 
			insert 
			(
				[fact_client_address_history_unique_key]
				,[dim_company_key]
				,[dim_client_key]
				,[client_id]
				,[client_address_id]
				,[client_address_name]
				,[client_address_line1]
				,[client_address_line2]
				,[client_address_line3]
				,[client_address_suburb]
				,[client_address_town_or_city]
				,[client_address_post_code]
				,[client_address_created_date_key]
				,[client_address_start_date_key]
				,[client_address_end_date_key]
				,[client_address_is_postal_flag]
				,[client_address_is_primary_flag]
				,[DWHSourceSystem]
				,[DWHBatchId]
				,[DWHDMLOperation]
				,[DWHModifiedOn]
				,[DWHCreatedAt]
			)
			values
			(
				src.[fact_client_address_history_unique_key]
				,src.[dim_company_key]
				,src.[dim_client_key]
				,src.[client_id]
				,src.[client_address_id]
				,src.[client_address_name]
				,src.[client_address_line1]
				,src.[client_address_line2]
				,src.[client_address_line3]
				,src.[client_address_suburb]
				,src.[client_address_town_or_city]
				,src.[client_address_post_code]
				,src.[client_address_created_date_key]
				,src.[client_address_start_date_key]
				,src.[client_address_end_date_key]
				,src.[client_address_is_postal_flag]
				,src.[client_address_is_primary_flag]
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
			,@insertedRecords =	isnull(sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end),0)
			,@updatedRecords =	isnull(isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end),0)
			,@deletedRecords =  isnull(sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end),0)
		from [edw].[fact_client_address_history]
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