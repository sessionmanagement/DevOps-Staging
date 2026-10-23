
CREATE procedure [edw].[Updateedwfact_property_rent_charges] 
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
	declare @SourceSystem nvarchar(120) = 'Zavanti.zav_propertyrentcharges';
	
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

	-- Do not run if there are no records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_property_rent_charges];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_property_rent_charges];

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

	if( object_id( 'tempdb..#SummaryOfChanges') is not null ) drop table #SummaryOfChanges;
	create table #SummaryOfChanges
	(	
		 [rent_charge_id] uniqueidentifier null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[fact_property_rent_charges]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_property_rent_charges]
			(
				 [rent_charge_id]
				,dim_property_key
				,dim_employee_key
				,dim_company_key
				,[rent_charge_name] 
				,[property_id] 
				,[property_name] 
				,[provider_name] 
				,[company_name] 
				,[agreed_rent] 
				,[market_rent] 
				,[supplement_amount] 
				,[start_date] 
				,[end_date] 
				,[employee_name] 
				,[employee_id] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[rent_charge_id]
				,src.dim_property_key
				,src.dim_employee_key
				,src.dim_company_key
				,src.[rent_charge_name] 
				,src.[property_id] 
				,src.[property_name] 
				,src.[provider_name] 
				,src.[company_name] 
				,src.[agreed_rent] 
				,src.[market_rent] 
				,src.[supplement_amount] 
				,src.[start_date] 
				,src.[end_date] 
				,src.[employee_name] 
				,src.[employee_id] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_property_rent_charges] as src;
		end else begin
			merge into [edw].[fact_property_rent_charges] as trg
			using 
			(
				select
				 src.[rent_charge_id]
				,src.dim_property_key
				,src.dim_employee_key
				,src.dim_company_key
				,src.[rent_charge_name] 
				,src.[property_id] 
				,src.[property_name] 
				,src.[provider_name] 
				,src.[company_name] 
				,src.[agreed_rent] 
				,src.[market_rent] 
				,src.[supplement_amount] 
				,src.[start_date] 
				,src.[end_date] 
				,src.[employee_name] 
				,src.[employee_id] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_property_rent_charges] as src
			) as src on (src.[rent_charge_id] = trg.[rent_charge_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[rent_charge_name]
				, src.[property_id]
				, src.[property_name]
				, src.[provider_name]
				, src.[company_name]
				, src.[agreed_rent]
				, src.[market_rent]
				, src.[supplement_amount]
				, src.[start_date]
				, src.[end_date]
				, src.[employee_name]
				, src.[employee_id]
				, case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[rent_charge_name]
				, trg.[property_id]
				, trg.[property_name]
				, trg.[provider_name]
				, trg.[company_name]
				, trg.[agreed_rent]
				, trg.[market_rent]
				, trg.[supplement_amount]
				, trg.[start_date]
				, trg.[end_date]
				, trg.[employee_name]
				, trg.[employee_id], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [rent_charge_id] 
					 ,dim_property_key
					 ,dim_employee_key
				     ,dim_company_key
					,[rent_charge_name] 
					,[property_id] 
					,[property_name] 
					,[provider_name] 
					,[company_name] 
					,[agreed_rent] 
					,[market_rent] 
					,[supplement_amount] 
					,[start_date] 
					,[end_date] 
					,[employee_name] 
					,[employee_id] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[rent_charge_id] 
					,src.dim_property_key
				    ,src.dim_employee_key
				    ,src.dim_company_key
					,src.[rent_charge_name] 
					,src.[property_id] 
					,src.[property_name] 
					,src.[provider_name] 
					,src.[company_name] 
					,src.[agreed_rent] 
					,src.[market_rent] 
					,src.[supplement_amount] 
					,src.[start_date] 
					,src.[end_date] 
					,src.[employee_name] 
					,src.[employee_id] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[rent_charge_id],inserted.[rent_charge_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[fact_property_rent_charges]
			(
				 [rent_charge_id] 
				,dim_property_key
				,dim_employee_key
				,dim_company_key
				,[rent_charge_name] 
				,[property_id] 
				,[property_name] 
				,[provider_name] 
				,[company_name] 
				,[agreed_rent] 
				,[market_rent] 
				,[supplement_amount] 
				,[start_date] 
				,[end_date] 
				,[employee_name] 
				,[employee_id] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[rent_charge_id] 
				,src.dim_property_key
				,src.dim_employee_key
				,src.dim_company_key
				,src.[rent_charge_name] 
				,src.[property_id] 
				,src.[property_name] 
				,src.[provider_name] 
				,src.[company_name] 
				,src.[agreed_rent] 
				,src.[market_rent] 
				,src.[supplement_amount] 
				,src.[start_date] 
				,src.[end_date] 
				,src.[employee_name] 
				,src.[employee_id] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'Zavanti.zav_propertyrentcharges'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLfact_property_rent_charges] as src on src.[rent_charge_id] = base.[rent_charge_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[rent_charge_id] 
				,tbl.dim_property_key
				,tbl.dim_employee_key
				,tbl.dim_company_key
				,tbl.[rent_charge_name] 
				,tbl.[property_id] 
				,tbl.[property_name] 
				,tbl.[provider_name] 
				,tbl.[company_name] 
				,tbl.[agreed_rent] 
				,tbl.[market_rent] 
				,tbl.[supplement_amount] 
				,tbl.[start_date] 
				,tbl.[end_date] 
				,tbl.[employee_name] 
				,tbl.[employee_id] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'Zavanti.zav_propertyrentcharges'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[fact_property_rent_charges] as tbl on tbl.[rent_charge_id] = base.[rent_charge_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLfact_property_rent_charges] as src on src.[rent_charge_id] = base.[rent_charge_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[rent_charge_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_property_rent_charges]
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