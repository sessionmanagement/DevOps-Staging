












/**********************************************************************************************************
Procedure	[edw].[Updateedwfact_finance_budget] 
Purpose	
		
Notes: Call By	EDW Pipeline '30_Load_From_ODS'

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2023/06/30	  Shashi Sharma			Initial creation of stored procedure
1.1		2023-09-01	  Glenn McLeod			Updated to use table Framework table names 
1.11	2023-09-01	  Glenn McLeod			Updated table/column names
1.2		2023-09-25	  Glenn McLeod			Update to identify difference between N/A and Unknown dim records
1.3     2024-04-18    Manish Singh			Update deleted records in source 
1.4     2026-04-28    Pankaj Bhatt			Update join for location dim

**********************************************************************************************************/


CREATE procedure [edw].[Updateedwfact_finance_budget] 
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
	declare @SourceSystem nvarchar(120) = '[Staging].[ODSETLfact_finance_budget]';

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
	if( object_id( 'tempdb..#SummaryOfChanges') is not null ) drop table #SummaryOfChanges;
	create table #SummaryOfChanges
	(	
			 [PartitionKey] nvarchar(max) null
		,[RowKey] nvarchar(max) null
		,[MergeAction] varchar(10)
	);
	begin transaction;
	begin try
		
		-- Do not run if there are no records in source
		select @stagedRecords = count(1) from [Staging].[ODSETLfact_finance_budget];
		if( @stagedRecords = 0 )
		begin
			select 
				 @targetRecords = count(1) 
				,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			from [edw].[fact_finance_budget];
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
			   [dim_finance_general_ledger_account_key]
			  ,[dim_finance_budget_holder_key]
			  ,[dim_finance_contract_key]
			  ,[dim_finance_customer_key]
			  ,[dim_department_key]
			  ,[dim_district_key]
			  ,[dim_finance_funder_key]
			  ,[dim_finance_funding_agency_key]
			  ,[dim_location_key]
			  ,[dim_region_key]
			  ,[dim_service_key]
			  ,[dim_finance_vendor_key]
			  ,[dim_company_key]
			  ,[fact_finance_budget_partition_key]
			  ,[fact_finance_budget_row_key]
			  ,[finance_budget_holder_id]
			  ,[finance_contract_id]
			  ,[finance_customer_id]
			  ,[department_id]
			  ,[district_id]
			  ,[finance_funder_id]
			  ,[finance_funding_agency_id]
			  ,[location_id]
			  ,[region_id]
			  ,[service_id]
			  ,[finance_vendor_id]
			  ,[finance_budget_company_name]
			  ,[finance_budget_general_ledger_account_no]
			  ,[finance_budget_dimension_set_id]
			  ,[finance_budget_budget_name]
			  ,[finance_budget_description]
			  ,[finance_budget_global_dimension_1_code]
			  ,[finance_budget_entry_no]
			  ,[finance_budget_date_key]
			  ,[finance_budget_last_modified_date_time]
			  ,[finance_budget_amount]
			  ,[DWHSourceSystem]
			  ,[DWHBatchId]
			  ,[DWHDMLOperation]
			  ,[DWHModifiedOn]
			  ,[DWHCreatedAt]
		  FROM [edw].[fact_finance_budget]
				--WHERE DWHIsCurrent = 1
				)
			MERGE INTO TARGET
			USING 
			(
			SELECT 
				isnull(DGLA.[dim_finance_general_ledger_account_key], CASE WHEN src.[finance_budget_general_ledger_account_no] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_finance_general_ledger_account_key]
				,isnull(DBH.[dim_finance_budget_holder_key], CASE WHEN src.[finance_budget_holder_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_finance_budget_holder_key]
				,isnull(DC.[dim_finance_contract_key], CASE WHEN src.[finance_contract_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_finance_contract_key]
				,isnull(DFC.[dim_finance_customer_key], CASE WHEN src.[finance_customer_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_finance_customer_key]
				,isnull(DP.[dim_department_key], CASE WHEN src.[department_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_department_key]
				,isnull(DD.[dim_district_key], CASE WHEN src.[district_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_district_key]
				,isnull(DF.[dim_finance_funder_key], CASE WHEN src.[finance_funder_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_finance_funder_key]
				,isnull(DFA.[dim_finance_funding_agency_key], CASE WHEN src.[finance_funding_agency_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_finance_funding_agency_key]
				,isnull(DL.[dim_location_key], CASE WHEN src.[location_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_location_key]
				,isnull(DR.[dim_region_key], CASE WHEN src.[region_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_region_key]
				,isnull(DSE.[dim_service_key], CASE WHEN src.[service_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_service_key]
				,isnull(DV.[dim_finance_vendor_key], CASE WHEN src.[finance_vendor_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_finance_vendor_key]
				,isnull(DCY.[dim_company_key], CASE WHEN src.finance_budget_company_name IS NOT NULL THEN -1 ELSE 0 END) AS [dim_company_key]
				,src.[fact_finance_budget_partition_key]
				,src.[fact_finance_budget_row_key]
				,src.[finance_budget_holder_id]
				,src.[finance_contract_id]
				,src.[finance_customer_id]
				,src.[department_id]
				,src.[district_id]
				,src.[finance_funder_id]
				,src.[finance_funding_agency_id]
				,src.[location_id]
				,src.[region_id]
				,src.[service_id]
				,src.[finance_vendor_id]
				,src.[finance_budget_company_name]
				,src.[finance_budget_general_ledger_account_no]
				,src.[finance_budget_dimension_set_id]
				,src.[finance_budget_budget_name]
				,src.[finance_budget_description]
				,src.[finance_budget_global_dimension_1_code]
				,src.[finance_budget_entry_no]
				,src.[finance_budget_date_key]
				,src.[finance_budget_last_modified_date_time]
				,src.[finance_budget_amount]
				,@SourceSystem AS [DWHSourceSystem]
				,@BatchID AS [DWHBatchId]
				,'I' AS [DWHDMLOperation]
				,@systemCurrentDate AS [DWHCreatedAt]
				,@systemCurrentDate AS [DWHModifiedOn]
			FROM [Staging].[ODSETLfact_finance_budget] src
			LEFT JOIN [edw].[dim_finance_general_ledger_account] DGLA ON src.[finance_budget_general_ledger_account_no] = DGLA.[finance_general_ledger_account_code]
				AND src.[finance_budget_company_name] = dgla.[finance_general_ledger_account_company_name]
				AND DGLA.[DWHIsCurrent] = 1
			LEFT JOIN [edw].[dim_finance_customer] DFC ON src.[finance_customer_id] = DFC.[finance_customer_dimension_value_id]
				AND src.finance_budget_company_name = dfc.[finance_customer_company_name]
				AND DFC.[DWHIsCurrent] = 1
			LEFT JOIN [edw].[dim_finance_budget_holder] DBH ON src.[finance_budget_holder_id] = DBH.finance_budget_holder_dimension_value_id
				AND src.finance_budget_company_name = dbh.finance_budget_holder_company_name
				AND dbh.[DWHIsCurrent] = 1
			LEFT JOIN [edw].[dim_finance_contract] DC ON src.[finance_contract_id] = DC.finance_contract_dimension_value_id
				AND src.finance_budget_company_name = dc.finance_contract_company_name
				AND dc.[DWHIsCurrent] = 1
			LEFT JOIN [edw].[dim_department] DP ON src.[department_id] = Dp.[department_dimension_value_id]
				AND src.finance_budget_company_name = dp.[department_company_name]
				AND dp.[DWHIsCurrent] = 1
			LEFT JOIN [edw].[dim_district] DD ON src.[district_id] = DD.district_dimension_value_id
				AND src.finance_budget_company_name = DD.[district_company_name]
				AND dd.[DWHIsCurrent] = 1
			LEFT JOIN [edw].[dim_finance_funder] df ON src.[finance_funder_id] = df.[finance_funder_dimension_value_id]
				AND src.finance_budget_company_name = df.finance_funder_company_name
				AND df.[DWHIsCurrent] = 1
			LEFT JOIN [edw].[dim_finance_funding_agency] DFA ON src.[finance_funding_agency_id] = DFA.[finance_funding_agency_dimension_value_id]
				AND src.finance_budget_company_name = DFA.[finance_funding_agency_company_name]
				AND dfa.[DWHIsCurrent] = 1
			LEFT JOIN [edw].[dim_location_new] DL ON cast(src.[location_id] as nvarchar) = DL.business_central_location_id
				AND src.finance_budget_company_name = dl.company_name
				AND dl.[DWHIsCurrent] = 1
			LEFT JOIN [edw].[dim_region] DR ON src.[region_id] = DR.[region_dimension_value_id]
				AND src.finance_budget_company_name = dr.region_company_name
				AND dr.[DWHIsCurrent] = 1
			LEFT JOIN [edw].[dim_service] DSE ON src.[service_id] = DSE.service_id
				AND src.finance_budget_company_name = DSE.[company_name]
				AND dse.[DWHIsCurrent] = 1
			LEFT JOIN [edw].[dim_finance_vendor] DV ON src.[finance_vendor_id] = dv.finance_vendor_dimension_value_id
				AND src.finance_budget_company_name = dv.finance_vendor_company_name
				AND dv.[DWHIsCurrent] = 1
			LEFT JOIN [edw].[dim_company] DCY ON src.finance_budget_company_name = DCY.company_name
				AND dcy.[DWHIsCurrent] = 1
			)	AS SOURCE
			ON (TARGET.[fact_finance_budget_row_key] = SOURCE.[fact_finance_budget_row_key]
			and TARGET.[fact_finance_budget_partition_key] = SOURCE.[fact_finance_budget_partition_key])
			WHEN MATCHED AND 
				(
					-- Compare the SCD1 columns in source to the target
					-- and return rows if there is any difference
                    SOURCE.[dim_location_key]<>TARGET.[dim_location_key]      OR
					SOURCE.[finance_budget_holder_id]<>TARGET.[finance_budget_holder_id]      OR
					SOURCE.[finance_contract_id]<>TARGET.[finance_contract_id]      OR
					SOURCE.[finance_customer_id]<>TARGET.[finance_customer_id]      OR
					SOURCE.[department_id]<>TARGET.[department_id]      OR
					SOURCE.[district_id]<>TARGET.[district_id]      OR
					SOURCE.[finance_funder_id]<>TARGET.[finance_funder_id]      OR
					SOURCE.[finance_funding_agency_id]<>TARGET.[finance_funding_agency_id]      OR
					SOURCE.[location_id]<>TARGET.[location_id]      OR
					SOURCE.[region_id]<>TARGET.[region_id]      OR
					SOURCE.[service_id]<>TARGET.[service_id]      OR
					SOURCE.[finance_vendor_id]<>TARGET.[finance_vendor_id]      OR
					SOURCE.[finance_budget_company_name]<>TARGET.[finance_budget_company_name]      OR
					SOURCE.[finance_budget_general_ledger_account_no]<>TARGET.[finance_budget_general_ledger_account_no]      OR
					SOURCE.[finance_budget_dimension_set_id]<>TARGET.[finance_budget_dimension_set_id]      OR
					SOURCE.[finance_budget_budget_name]<>TARGET.[finance_budget_budget_name]      OR
					SOURCE.[finance_budget_description]<>TARGET.[finance_budget_description]      OR
					SOURCE.[finance_budget_global_dimension_1_code]<>TARGET.[finance_budget_global_dimension_1_code]      OR
					SOURCE.[finance_budget_entry_no]<>TARGET.[finance_budget_entry_no]      OR
					SOURCE.[finance_budget_date_key]<>TARGET.[finance_budget_date_key]      OR
					SOURCE.[finance_budget_last_modified_date_time]<>TARGET.[finance_budget_last_modified_date_time]      OR
					SOURCE.[finance_budget_amount]<>TARGET.[finance_budget_amount]    

					 ) THEN
				-- if we have difference then updated the edw table
				-- with the new values
				UPDATE SET 
					TARGET.[dim_finance_general_ledger_account_key]=SOURCE.[dim_finance_general_ledger_account_key]
					,TARGET.[dim_finance_budget_holder_key]=SOURCE.[dim_finance_budget_holder_key]
					,TARGET.[dim_finance_contract_key]=SOURCE.[dim_finance_contract_key]
					,TARGET.[dim_finance_customer_key] =SOURCE.[dim_finance_customer_key] 
					,TARGET.[dim_department_key]=SOURCE.[dim_department_key]
					,TARGET.[dim_district_key]=SOURCE.[dim_district_key]
					,TARGET.[dim_finance_funder_key]=SOURCE.[dim_finance_funder_key]
					,TARGET.[dim_finance_funding_agency_key]=SOURCE.[dim_finance_funding_agency_key]
					,TARGET.[dim_location_key]=SOURCE.[dim_location_key]
					,TARGET.[dim_region_key]=SOURCE.[dim_region_key]
					,TARGET.[dim_service_key]=SOURCE.[dim_service_key]
					,TARGET.[dim_finance_vendor_key]=SOURCE.[dim_finance_vendor_key]
					,TARGET.[dim_company_key]=SOURCE.[dim_company_key]
					,TARGET.[fact_finance_budget_partition_key]=SOURCE.[fact_finance_budget_partition_key]
					,TARGET.[fact_finance_budget_row_key]=SOURCE.[fact_finance_budget_row_key]
					,TARGET.[finance_budget_holder_id]=SOURCE.[finance_budget_holder_id]
					,TARGET.[finance_contract_id]=SOURCE.[finance_contract_id]
					,TARGET.[finance_customer_id]=SOURCE.[finance_customer_id]
					,TARGET.[department_id]=SOURCE.[department_id]
					,TARGET.[district_id]=SOURCE.[district_id]
					,TARGET.[finance_funder_id]=SOURCE.[finance_funder_id]
					,TARGET.[finance_funding_agency_id]=SOURCE.[finance_funding_agency_id]
					,TARGET.[location_id]=SOURCE.[location_id]
					,TARGET.[region_id]=SOURCE.[region_id]
					,TARGET.[service_id]=SOURCE.[service_id]
					,TARGET.[finance_vendor_id]=SOURCE.[finance_vendor_id]
					,TARGET.[finance_budget_company_name]=SOURCE.[finance_budget_company_name]
					,TARGET.[finance_budget_general_ledger_account_no]=SOURCE.[finance_budget_general_ledger_account_no]
					,TARGET.[finance_budget_dimension_set_id]=SOURCE.[finance_budget_dimension_set_id]
					,TARGET.[finance_budget_budget_name]=SOURCE.[finance_budget_budget_name]
					,TARGET.[finance_budget_description]=SOURCE.[finance_budget_description]
					,TARGET.[finance_budget_global_dimension_1_code]=SOURCE.[finance_budget_global_dimension_1_code]
					,TARGET.[finance_budget_entry_no]=SOURCE.[finance_budget_entry_no]
					,TARGET.[finance_budget_date_key]=SOURCE.[finance_budget_date_key]
					,TARGET.[finance_budget_last_modified_date_time]=SOURCE.[finance_budget_last_modified_date_time]
					,TARGET.[finance_budget_amount]=SOURCE.[finance_budget_amount]
					,TARGET.[DWHSourceSystem] = @SourceSystem
					,TARGET.[DWHModifiedOn] = @systemCurrentDate
					,TARGET.[DWHBatchId] = @BatchID
					,TARGET.[DWHDMLOperation] = 'U'
				 -- Insert new records
		   when not matched by target then 
			insert 
			(
				 [dim_finance_general_ledger_account_key]
				,[dim_finance_budget_holder_key]
				,[dim_finance_contract_key]
				,[dim_finance_customer_key]
				,[dim_department_key]
				,[dim_district_key]
				,[dim_finance_funder_key]
				,[dim_finance_funding_agency_key]
				,[dim_location_key]
				,[dim_region_key]
				,[dim_service_key]
				,[dim_finance_vendor_key]
				,[dim_company_key]
				,[fact_finance_budget_partition_key]
				,[fact_finance_budget_row_key]
				,[finance_budget_holder_id]
				,[finance_contract_id]
				,[finance_customer_id]
				,[department_id]
				,[district_id]
				,[finance_funder_id]
				,[finance_funding_agency_id]
				,[location_id]
				,[region_id]
				,[service_id]
				,[finance_vendor_id]
				,[finance_budget_company_name]
				,[finance_budget_general_ledger_account_no]
				,[finance_budget_dimension_set_id]
				,[finance_budget_budget_name]
				,[finance_budget_description]
				,[finance_budget_global_dimension_1_code]
				,[finance_budget_entry_no]
				,[finance_budget_date_key]
				,[finance_budget_last_modified_date_time]
				,[finance_budget_amount]
				,[DWHSourceSystem]
				,[DWHBatchId]
				,[DWHDMLOperation]
				,[DWHModifiedOn]
				,[DWHCreatedAt]
			)
			values
			(
				 SOURCE.[dim_finance_general_ledger_account_key]
				,SOURCE.[dim_finance_budget_holder_key]
				,SOURCE.[dim_finance_contract_key]
				,SOURCE.[dim_finance_customer_key]
				,SOURCE.[dim_department_key]
				,SOURCE.[dim_district_key]
				,SOURCE.[dim_finance_funder_key]
				,SOURCE.[dim_finance_funding_agency_key]
				,SOURCE.[dim_location_key]
				,SOURCE.[dim_region_key]
				,SOURCE.[dim_service_key]
				,SOURCE.[dim_finance_vendor_key]
				,SOURCE.[dim_company_key]

				,SOURCE.[fact_finance_budget_partition_key]
				,SOURCE.[fact_finance_budget_row_key]
				,SOURCE.[finance_budget_holder_id]
				,SOURCE.[finance_contract_id]
				,SOURCE.[finance_customer_id]
				,SOURCE.[department_id]
				,SOURCE.[district_id]
				,SOURCE.[finance_funder_id]
				,SOURCE.[finance_funding_agency_id]
				,SOURCE.[location_id]
				,SOURCE.[region_id]
				,SOURCE.[service_id]
				,SOURCE.[finance_vendor_id]
				,SOURCE.[finance_budget_company_name]
				,SOURCE.[finance_budget_general_ledger_account_no]
				,SOURCE.[finance_budget_dimension_set_id]
				,SOURCE.[finance_budget_budget_name]
				,SOURCE.[finance_budget_description]
				,SOURCE.[finance_budget_global_dimension_1_code]
				,SOURCE.[finance_budget_entry_no]
				,SOURCE.[finance_budget_date_key]
				,SOURCE.[finance_budget_last_modified_date_time]
				,SOURCE.[finance_budget_amount]
				,SOURCE.[DWHSourceSystem]
				,SOURCE.[DWHBatchId]
				,SOURCE.[DWHDMLOperation]
				,SOURCE.[DWHModifiedOn]
				,SOURCE.[DWHCreatedAt]  )
	WHEN NOT MATCHED BY SOURCE THEN 

		UPDATE 	   set 
	                TARGET.[DWHSourceSystem] = @SourceSystem
					,TARGET.[DWHModifiedOn] = @systemCurrentDate
					,TARGET.[DWHBatchId] = @BatchID
					,TARGET.[DWHDMLOperation] = 'D'
				 
				 	 ;
    
	--if( @stagedRecords > 1 )
	--begin
	--UPDATE tgt 
	--   set 
	--                tgt.[DWHSourceSystem] = @SourceSystem
	--				,tgt.[DWHModifiedOn] = @systemCurrentDate
	--				,tgt.[DWHBatchId] = @BatchID
	--				,tgt.[DWHDMLOperation] = 'D'
 --        FROM  [edw].[fact_finance_budget] tgt left outer join [Staging].[ODSETLfact_finance_budget] src
	--	 ON (tgt.[fact_finance_budget_row_key] = src.[fact_finance_budget_row_key]
	--		and tgt.[fact_finance_budget_partition_key] = src.[fact_finance_budget_partition_key])
	--		WHERE src.[fact_finance_budget_row_key] is null and src.[fact_finance_budget_partition_key] is null

	--		end ;
				

	
	-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_finance_budget]
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