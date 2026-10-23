





/**********************************************************************************************************
Procedure	staging.upsert_edw_dim_region
Author			Glenn McLeod
Created		2023/06/19
Purpose		Move data from landing.dim_region table into
			[Staging].[ODSETLdim_region]
				
				
Notes: Call By	EDW Pipeline '30_Load_From_ODS'
Parameter(s)  None 
=========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2023-06-19	  Glenn McLeod			Initial creation of stored procedure
1.01	2023-08-28	  Glenn McLeod			Updated table/column names
1.2		2023-09-25	  Glenn McLeod			Add -1 record of for Unknown and updated 0 record to be N/A

**********************************************************************************************************/

CREATE procedure [edw].[Updateedwdim_region] 
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

begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = '[Staging].[ODSETLdim_region]';

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


	    -- check to see if the table is empty and if so then 
		-- we need to insert the unknown record
		IF NOT EXISTS (SELECT dim_region_key FROM edw.dim_region WHERE [dim_region_key] <= 0)
		BEGIN
			-- turn the identity insert on 
			SET IDENTITY_INSERT edw.dim_region ON

			INSERT INTO edw.dim_region
			(
				[dim_region_key],
				[region_dimension_value_id],
				[region_code],
				[region_name],
				[region_company_name],
				[region_last_modified_date_time],
				[DWHSourceSystem],
				[DWHBatchId],
				[DWHDMLOperation],
				[DWHEffectiveFrom],
				[DWHEffectiveTo],
				[DWHIsCurrent]
			)
			VALUES
			(0, 0, 'N/A', 'N/A', 'N/A', '19700101', 'N/A', 0, 'I', @SystemDefaultEffectiveFrom, @SystemDefaultEffectiveTo, 1),
			(-1, -1, 'Unknown', 'Unknown', 'Unknown', '19700101', 'Unknown', 0, 'I', @SystemDefaultEffectiveFrom, @SystemDefaultEffectiveTo, 1)

			-- turn the identity insert off
			SET IDENTITY_INSERT edw.dim_region OFF
		END

		
		-- Do not run if there are no records in source
		select @stagedRecords = count(1) from [Staging].[ODSETLdim_region];
		if( @stagedRecords = 0 )
		begin
			select 
				 @targetRecords = count(1) 
				,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			from [edw].[dim_region];
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
						@targetRecords	as TargetRecords,
						@pErrorMessage as ErrorMessage;
			end;

			commit transaction;
			return;
		end;


		    -- Deal with Slowly Changing Diminision Type 1 columns here
			WITH TARGET
			AS (SELECT 
				region_dimension_value_id
				, region_code
				, region_company_name
				, region_last_modified_date_time
				FROM [edw].[dim_region]
				WHERE DWHIsCurrent = 1)
			MERGE INTO TARGET
			USING [Staging].[ODSETLdim_region] AS SOURCE
			ON (TARGET.[region_dimension_value_id] = SOURCE.[region_dimension_value_id])
			WHEN MATCHED AND EXISTS
							 (
								 -- Compare the SCD1 columns in source to the target
								 -- and return rows if there is any difference
								 SELECT SOURCE.[region_code]
										, SOURCE.[region_last_modified_date_time]
										, SOURCE.[region_company_name]
								 EXCEPT
								 SELECT TARGET.[region_code]
										, TARGET.[region_last_modified_date_time]
										, TARGET.[region_company_name]
							 ) THEN
				-- if we have difference then updated the edw table
				-- with the new values
				UPDATE SET TARGET.region_code = SOURCE.region_code
						   , TARGET.[region_last_modified_date_time] = SOURCE.[region_last_modified_date_time]
						   , TARGET.[region_company_name] = SOURCE.[region_company_name]
			;
	
	    -- Deal with Slowly Changing Diminision Type 2 here
			WITH TARGET
			AS (SELECT *
				FROM [edw].[dim_region]
				WHERE DWHIsCurrent = 1)
			INSERT INTO [edw].[dim_region]
			(
				[region_dimension_value_id],
				[region_code],
				[region_name],
				[region_company_name],
				[region_last_modified_date_time],
				[DWHSourceSystem],
				[DWHBatchId],
				[DWHDMLOperation],
				[DWHEffectiveFrom],
				[DWHEffectiveTo],
				[DWHIsCurrent]
			)
			SELECT [region_dimension_value_id],
				   [region_code],
				   [region_name],
				   [region_company_name],
				   [region_last_modified_date_time],
				   [DWHSourceSystem],
				   [DWHBatchId],
				   [DWHDMLOperation],
				   [DWHEffectiveFrom],
				   [DWHEffectiveTo],
				   [DWHIsCurrent]
			FROM
			(
				MERGE INTO TARGET
				USING [Staging].[ODSETLdim_region] AS SOURCE
				ON (TARGET.[region_dimension_value_id] = SOURCE.[region_dimension_value_id])

				-- When we have a new record in the source but not in target
				-- then insert a new record
				WHEN NOT MATCHED BY TARGET THEN
					INSERT
					(
						[region_dimension_value_id],
						[region_code],
						[region_name],
						[region_company_name],
						[region_last_modified_date_time],
						[DWHSourceSystem],
						[DWHBatchId],
						[DWHDMLOperation],
						[DWHEffectiveFrom],
						[DWHEffectiveTo],
						[DWHIsCurrent]
					)
					VALUES
					(SOURCE.[region_dimension_value_id], SOURCE.[region_code], SOURCE.[region_name],
					 SOURCE.[region_company_name], SOURCE.[region_last_modified_date_time], @SourceSystem, @pBatchID,
					 'I', @SystemEffectiveFrom, @SystemDefaultEffectiveTo, 1)

				-- when we have a record that matches on the business key but the SCD2 columns are 
				-- different then we will update the current record so that it's not the current one anymore
				WHEN MATCHED AND EXISTS
								 (
									 SELECT SOURCE.[region_name] EXCEPT SELECT TARGET.[region_name]
								 ) THEN
					UPDATE SET TARGET.[DWHEffectiveTo] = @SystemEffectiveTo,
							   TARGET.[DWHIsCurrent] = 0
				OUTPUT $Action Action_Taken,
					   SOURCE.[region_dimension_value_id],
					   SOURCE.[region_code],
					   SOURCE.[region_name],
					   SOURCE.[region_company_name],
					   SOURCE.[region_last_modified_date_time],
					   @SourceSystem AS DWHSourceSystem,
					   @pBatchID AS DWHBatchId,
					   'U' AS [DWHDMLOperation],
					   @SystemEffectiveFrom AS [DWHEffectiveFrom],
					   @SystemDefaultEffectiveTo AS [DWHEffectiveTo],
					   1 AS [DWHIsCurrent]
			)   AS MERGE_OUT
			WHERE MERGE_OUT.Action_Taken = 'UPDATE'


		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_region]
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