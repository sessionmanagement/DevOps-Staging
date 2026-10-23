







/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_company] 
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
1.11	2023-08-24	  Glenn McLeod			Updated table/column names
1.2		2023-09-25	  Glenn McLeod			Add -1 record of for Unknown and updated 0 record to be N/A
											Added dim_company_id and updated to use that as the merge key

**********************************************************************************************************/


CREATE procedure [edw].[Updateedwdim_company] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[dim_company]';
	
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


	-- Get a count of number records in staging
    SELECT @stagedRecords = COUNT(1)
    FROM [staging].[ODSETLdim_company];


	 -- check to see if the table is empty and if so then 
    -- we need to insert the unknown record
    IF NOT EXISTS (SELECT dim_company_key FROM edw.dim_company WHERE [dim_company_key] <= 0)
    BEGIN
        -- turn the identity insert on 
        SET IDENTITY_INSERT edw.dim_company ON

        INSERT INTO edw.dim_company
        (
			[dim_company_key]
			,[company_id]
			,[company_name]
			,[company_short_code]
			,[dim_company_intellihr_key]
			,[dim_company_datapay_key]
			,[company_datapay_code]
			,[company_recordbase_id]
			,[DWHSourceSystem]
			,[DWHBatchId]
			,[DWHDMLOperation]
			,[DWHEffectiveFrom]
			,[DWHEffectiveTo]
			,[DWHIsCurrent]
        )
        VALUES
        ( 0  --dim_company_key
		,0 --dim_company_id
		, 'N/A' --company_name
		, 'N/A' --shortcode
		, 'N/A'  --dim_company_intellihr_key
		, 'N/A' --dim_company_datapay_key
		, 0  --datapay code
		, 0 --company_recordbase_id
		, 'N/A'  --DWHSourceID
		, 0 -- DWHBatchID
		, 'I' --DWHDMLOperation
		, @SystemDefaultEffectiveFrom --DWHEffectiveFrom
		, @SystemDefaultEffectiveTo  --DWHEffectiveTo
		, 1   --DWHIsCurrent
		),
		( -1  --dim_company_key
		,-1 --dim_company_id
		, 'Unknown' --company_name
		, 'Unknown' --shortcode
		, 'Unknown'  --dim_company_intellihr_key
		, 'Unknown' --dim_company_datapay_key
		, -1  --datapay code
		, -1 --company_recordbase_id
		, 'Unknown'  --DWHSourceID
		, 0 -- DWHBatchID
		, 'I' --DWHDMLOperation
		, @SystemDefaultEffectiveFrom --DWHEffectiveFrom
		, @SystemDefaultEffectiveTo  --DWHEffectiveTo
		, 1   --DWHIsCurrent
		)

        -- turn the identity insert off
        SET IDENTITY_INSERT edw.dim_company OFF
    END


	-- Do not run if there are no records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_company];
	if( @stagedRecords = 0 )
	begin
		select	@targetRecords = count(1) 
				,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_company];

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



		-- Deal with Slowly Changing Diminision Type 1 columns here
		WITH TARGET
		AS (SELECT 
			*
			FROM [edw].[dim_company]
			WHERE DWHIsCurrent = 1)
		MERGE INTO TARGET
		USING  (SELECT TOP 100 PERCENT * FROM [Staging].[ODSETLdim_company]  order by [company_id]) AS SOURCE
		--ON (TARGET.[company_short_code] = SOURCE.[company_short_code])
		ON (TARGET.[company_id] = SOURCE.[company_id])
		WHEN MATCHED AND EXISTS
				(
					-- Compare the SCD1 columns in source to the target
					-- and return rows if there is any difference
					SELECT 
						SOURCE.[company_short_code]
						, SOURCE.[company_name]
						, SOURCE.[intellihr_company_id]
						, SOURCE.[datapay_company_id]
						, SOURCE.[company_datapay_code]
						, SOURCE.[company_recordbase_id]
					EXCEPT
					SELECT 
						TARGET.[company_short_code]
						, TARGET.[company_name]
						, TARGET.[dim_company_intellihr_key]
						, TARGET.[dim_company_datapay_key]
						, TARGET.[company_datapay_code]
						, TARGET.[company_recordbase_id]
							) THEN
			-- if we have difference then updated the edw table
			-- with the new values
			UPDATE SET TARGET.[company_short_code] = SOURCE.[company_short_code]
						, TARGET.company_name = SOURCE.company_name
						, TARGET.[dim_company_intellihr_key] = SOURCE.[intellihr_company_id]
						, TARGET.[dim_company_datapay_key] = SOURCE.[datapay_company_id]
						, TARGET.[company_datapay_code] = SOURCE.[company_datapay_code]
						, TARGET.[company_recordbase_id] = SOURCE.[company_recordbase_id]
						, TARGET.[DWHBatchId] = @pBatchID
						, TARGET.[DWHDMLOperation] = 'U'
			WHEN NOT MATCHED BY TARGET THEN
			INSERT (
				[company_id]
				, [company_name]
				, [company_short_code]
				, [dim_company_intellihr_key]
				, [dim_company_datapay_key]
				, [company_datapay_code]
				, [company_recordbase_id]
				, [DWHSourceSystem]
				, [DWHBatchId]
				, [DWHDMLOperation]
				, [DWHEffectiveFrom]
				, [DWHEffectiveTo]
				, [DWHIsCurrent]
			)
			VALUES (
					SOURCE.[company_id]
					, SOURCE.[company_name]
					, SOURCE.[company_short_code]
					, SOURCE.[intellihr_company_id]
					, SOURCE.[datapay_company_id]
					, SOURCE.[company_datapay_code]
					, SOURCE.[company_recordbase_id]
					,  @SourceSystem
					, @batchID
					, 'I'
					, @SystemEffectiveFrom
					,  @SystemDefaultEffectiveTo
					, 1
			);


		-- Get process counts
		select 
			@targetRecords = count(1) 
			,@insertedRecords =	ISNULL(sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end),0)
			,@updatedRecords =	ISNULL(isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end),0)
			,@deletedRecords =  ISNULL(sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end),0)
		from [edw].[dim_company]
		where [DWHEffectiveTo] = @SystemDefaultEffectiveTo;
		--WHERE DWHBatchId = @batchID


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