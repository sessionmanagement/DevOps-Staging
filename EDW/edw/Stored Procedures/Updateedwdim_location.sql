




/**********************************************************************************************************
Procedure	staging.[Updateedwdim_location]
Author		Stefen Hasselberg
Created		2023/04/04
Purpose		Move data from landing.dim_location table into
			[staging].[ODSETLdim_location] table
				

				
Notes: Call By	EDW Pipeline '30_Load_From_ODS'
Parameter(s)  None 
=========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2023-04-11    Stefen Hasselberg		Initial creation of stored procedure
1.1		2023-08-04	  Glenn McLeod			Updated to use table Framework table names 
1.11	2023-08-28	  Glenn McLeod			Updated table/column names
1.2		2023-09-25	  Glenn McLeod			Add -1 record of for Unknown and updated 0 record to be N/A

**********************************************************************************************************/

CREATE procedure [edw].[Updateedwdim_location] 
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
	declare @SourceSystem nvarchar(120) = '[Staging].[ODSETLdim_location]';

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
		IF NOT EXISTS (SELECT dim_location_key FROM edw.dim_location WHERE [dim_location_key] <= 0)
		BEGIN
			-- turn the identity insert on 
			SET IDENTITY_INSERT edw.dim_location ON

			INSERT INTO edw.dim_location
			(
				[dim_location_key],
				[location_dimension_value_id],
				[location_code],
				[location_name],
				[location_company_name],
				[location_last_modified_date_time],
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
			SET IDENTITY_INSERT edw.dim_location OFF
		END

		
		-- Do not run if there are no records in source
		select @stagedRecords = count(1) from [Staging].[ODSETLdim_location];
		if( @stagedRecords = 0 )
		begin
			select 
				 @targetRecords = count(1) 
				,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			from [edw].[dim_location];
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
				location_dimension_value_id
				, location_code
				, location_company_name
				, location_last_modified_date_time
				FROM [edw].[dim_location]
				WHERE DWHIsCurrent = 1)
			MERGE INTO TARGET
			USING [staging].[ODSETLdim_location]AS SOURCE
			ON (TARGET.[location_dimension_value_id] = SOURCE.[location_dimension_value_id])
			WHEN MATCHED AND EXISTS
							 (
								 -- Compare the SCD1 columns in source to the target
								 -- and return rows if there is any difference
								 SELECT SOURCE.[location_code]
										, SOURCE.[location_last_modified_date_time]
										, SOURCE.[location_company_name]
								 EXCEPT
								 SELECT TARGET.[location_code]
										, TARGET.[location_last_modified_date_time]
										, TARGET.[location_company_name]
							 ) THEN
				-- if we have difference then updated the edw table
				-- with the new values
				UPDATE SET TARGET.location_code = SOURCE.location_code
						   , TARGET.[location_last_modified_date_time] = SOURCE.[location_last_modified_date_time]
						   , TARGET.[location_company_name] = SOURCE.[location_company_name]
		;


		-- Deal with Slowly Changing Diminision Type 2 here
		WITH TARGET
		AS (SELECT *
			FROM [edw].[dim_location]
			WHERE DWHIsCurrent = 1)
		INSERT INTO [edw].[dim_location]
		(
			[location_dimension_value_id],
			[location_code],
			[location_name],
			[location_company_name],
			[location_last_modified_date_time],
			[DWHSourceSystem],
			[DWHBatchId],
			[DWHDMLOperation],
			[DWHEffectiveFrom],
			[DWHEffectiveTo],
			[DWHIsCurrent]
		)
		SELECT [location_dimension_value_id],
				[location_code],
				[location_name],
				[location_company_name],
				[location_last_modified_date_time],
				[DWHSourceSystem],
				[DWHBatchId],
				[DWHDMLOperation],
				[DWHEffectiveFrom],
				[DWHEffectiveTo],
				[DWHIsCurrent]
		FROM
		(
			MERGE INTO TARGET
			USING [staging].[ODSETLdim_location]AS SOURCE
			ON (TARGET.[location_dimension_value_id] = SOURCE.[location_dimension_value_id])

			-- When we have a new record in the source but not in target
			-- then insert a new record
			WHEN NOT MATCHED BY TARGET THEN
				INSERT
				(
					[location_dimension_value_id],
					[location_code],
					[location_name],
					[location_company_name],
					[location_last_modified_date_time],
					[DWHSourceSystem],
					[DWHBatchId],
					[DWHDMLOperation],
					[DWHEffectiveFrom],
					[DWHEffectiveTo],
					[DWHIsCurrent]
				)
				VALUES
				(SOURCE.[location_dimension_value_id], SOURCE.[location_code], SOURCE.[location_name],
					SOURCE.[location_company_name], SOURCE.[location_last_modified_date_time], @SourceSystem, @pBatchID,
					'I', @SystemEffectiveFrom, @SystemDefaultEffectiveTo, 1)

			-- when we have a record that matches on the business key but the SCD2 columns are 
			-- different then we will update the current record so that it's not the current one anymore
			WHEN MATCHED AND EXISTS
								(
									SELECT SOURCE.[location_name] EXCEPT SELECT TARGET.[location_name]
								) THEN
				UPDATE SET TARGET.[DWHEffectiveTo] = @SystemEffectiveTo,
							TARGET.[DWHIsCurrent] = 0
			OUTPUT $Action Action_Taken,
					SOURCE.[location_dimension_value_id],
					SOURCE.[location_code],
					SOURCE.[location_name],
					SOURCE.[location_company_name],
					SOURCE.[location_last_modified_date_time],
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
		from [edw].[dim_location]
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