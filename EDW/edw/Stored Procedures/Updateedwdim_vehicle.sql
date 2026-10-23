
CREATE procedure [edw].[Updateedwdim_vehicle] 
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


/***************************************************************************
NAME:     [edw].[Updateedwdim_vehicle]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-05-19    Pankaj Bhatt		Initial version
1.1		 2026-10-21    GitHub Copilot	Add vehicle_service_code to SCD loads (#15036)

****************************************************************************/

begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = 'TapuiWaka.asset';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_vehicle];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_vehicle];

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
		 [vehicle_id] varchar(40) null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
	
		
		-- insert N/A, Unknown records

		if( not exists (select top(1) 1 from [edw].[dim_vehicle] where dim_vehicle_key <= 0) )
			begin
			
			-- turn the identity insert on 
		SET IDENTITY_INSERT [edw].[dim_vehicle] ON

		INSERT INTO [edw].[dim_vehicle]
				   (
				   [dim_vehicle_key]
				   ,[vehicle_id]
				   ,[vehicle_name]
				   ,[vehicle_description]
				   ,[vehicle_number_plate]
				   ,[vehicle_type]
				   ,[vehicle_class]
				   ,[vehicle_make]
				   ,[vehicle_model]
				   ,[vehicle_year]
				   ,[vehicle_nzta_subject_to_ruc]
				   ,[vehicle_nzta_subject_to_ruc_hubo]
				   ,[vehicle_nzta_wof_expiry_date]
				   ,[vehicle_nzta_wof_type]
				   ,[vehicle_nzta_license_expiry_date]
				   ,[vehicle_nzta_fuel_type]
				   ,[vehicle_nzta_ruc_expiry]
				   ,[vehicle_nzta_ruc_expiry_date]
				   ,[vehicle_service_code]
				   ,[DWHBatchId]
				   ,[DWHEffectiveFrom]
				   ,[DWHEffectiveTo]
				   ,[DWHDMLOperation]
				   ,[DWHIsCurrent]
				   ,[DWHSourceSystem])			
			VALUES	(0,'N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A',0,0,0,'1900-01-01','N/A','1900-01-01','N/A',0,'1900-01-01','N/A',0,@SystemDefaultEffectiveFrom,@SystemDefaultEffectiveTo,'I',1,@SourceSystem),				(-1,'Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown',-1,-1,-1,'1900-01-01','Unknown','1900-01-01','Unknown',-1,'1900-01-01','Unknown',0,@SystemDefaultEffectiveFrom,@SystemDefaultEffectiveTo,'I',1,@SourceSystem)
			 -- turn the identity insert off
			SET IDENTITY_INSERT [edw].[dim_vehicle] OFF
			end
		
		
	
		if( not exists (select top(1) 1 from [edw].[dim_vehicle] where dim_vehicle_key > 0) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_vehicle]
			(
				 [vehicle_id] 
				,[vehicle_name] 
				,[vehicle_description] 
				,[vehicle_number_plate] 
				,[vehicle_type] 
				,[vehicle_class] 
				,[vehicle_make] 
				,[vehicle_model] 
				,[vehicle_year] 
				,[vehicle_nzta_subject_to_ruc] 
				,[vehicle_nzta_subject_to_ruc_hubo] 
				,[vehicle_nzta_wof_expiry_date] 
				,[vehicle_nzta_wof_type] 
				,[vehicle_nzta_license_expiry_date] 
				,[vehicle_nzta_fuel_type] 
				,[vehicle_nzta_ruc_expiry] 
				,[vehicle_nzta_ruc_expiry_date] 
				,[vehicle_service_code]
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[vehicle_id] 
				,src.[vehicle_name] 
				,src.[vehicle_description] 
				,src.[vehicle_number_plate] 
				,src.[vehicle_type] 
				,src.[vehicle_class] 
				,src.[vehicle_make] 
				,src.[vehicle_model] 
				,src.[vehicle_year] 
				,src.[vehicle_nzta_subject_to_ruc] 
				,src.[vehicle_nzta_subject_to_ruc_hubo] 
				,src.[vehicle_nzta_wof_expiry_date] 
				,src.[vehicle_nzta_wof_type] 
				,src.[vehicle_nzta_license_expiry_date] 
				,src.[vehicle_nzta_fuel_type] 
				,src.[vehicle_nzta_ruc_expiry] 
				,src.[vehicle_nzta_ruc_expiry_date] 
				,src.[vehicle_service_code]
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_vehicle] as src;
		end else begin
			merge into [edw].[dim_vehicle] as trg
			using 
			(
				select
				 src.[vehicle_id] 
				,src.[vehicle_name] 
				,src.[vehicle_description] 
				,src.[vehicle_number_plate] 
				,src.[vehicle_type] 
				,src.[vehicle_class] 
				,src.[vehicle_make] 
				,src.[vehicle_model] 
				,src.[vehicle_year] 
				,src.[vehicle_nzta_subject_to_ruc] 
				,src.[vehicle_nzta_subject_to_ruc_hubo] 
				,src.[vehicle_nzta_wof_expiry_date] 
				,src.[vehicle_nzta_wof_type] 
				,src.[vehicle_nzta_license_expiry_date] 
				,src.[vehicle_nzta_fuel_type] 
				,src.[vehicle_nzta_ruc_expiry] 
				,src.[vehicle_nzta_ruc_expiry_date] 
				,src.[vehicle_service_code]
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_vehicle] as src
			) as src on (src.[vehicle_id] = trg.[vehicle_id] collate database_default and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[vehicle_name], src.[vehicle_description], src.[vehicle_number_plate], src.[vehicle_type], src.[vehicle_class], src.[vehicle_make], src.[vehicle_model], src.[vehicle_year], src.[vehicle_nzta_subject_to_ruc], src.[vehicle_nzta_subject_to_ruc_hubo], src.[vehicle_nzta_wof_expiry_date], src.[vehicle_nzta_wof_type], src.[vehicle_nzta_license_expiry_date], src.[vehicle_nzta_fuel_type], src.[vehicle_nzta_ruc_expiry], src.[vehicle_nzta_ruc_expiry_date], src.[vehicle_service_code], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[vehicle_name], trg.[vehicle_description], trg.[vehicle_number_plate], trg.[vehicle_type], trg.[vehicle_class], trg.[vehicle_make], trg.[vehicle_model], trg.[vehicle_year], trg.[vehicle_nzta_subject_to_ruc], trg.[vehicle_nzta_subject_to_ruc_hubo], trg.[vehicle_nzta_wof_expiry_date], trg.[vehicle_nzta_wof_type], trg.[vehicle_nzta_license_expiry_date], trg.[vehicle_nzta_fuel_type], trg.[vehicle_nzta_ruc_expiry], trg.[vehicle_nzta_ruc_expiry_date], trg.[vehicle_service_code], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' and trg.dim_vehicle_key > 0 then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [vehicle_id] 
					,[vehicle_name] 
					,[vehicle_description] 
					,[vehicle_number_plate] 
					,[vehicle_type] 
					,[vehicle_class] 
					,[vehicle_make] 
					,[vehicle_model] 
					,[vehicle_year] 
					,[vehicle_nzta_subject_to_ruc] 
					,[vehicle_nzta_subject_to_ruc_hubo] 
					,[vehicle_nzta_wof_expiry_date] 
					,[vehicle_nzta_wof_type] 
					,[vehicle_nzta_license_expiry_date] 
					,[vehicle_nzta_fuel_type] 
					,[vehicle_nzta_ruc_expiry] 
					,[vehicle_nzta_ruc_expiry_date] 
					,[vehicle_service_code]
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[vehicle_id] 
					,src.[vehicle_name] 
					,src.[vehicle_description] 
					,src.[vehicle_number_plate] 
					,src.[vehicle_type] 
					,src.[vehicle_class] 
					,src.[vehicle_make] 
					,src.[vehicle_model] 
					,src.[vehicle_year] 
					,src.[vehicle_nzta_subject_to_ruc] 
					,src.[vehicle_nzta_subject_to_ruc_hubo] 
					,src.[vehicle_nzta_wof_expiry_date] 
					,src.[vehicle_nzta_wof_type] 
					,src.[vehicle_nzta_license_expiry_date] 
					,src.[vehicle_nzta_fuel_type] 
					,src.[vehicle_nzta_ruc_expiry] 
					,src.[vehicle_nzta_ruc_expiry_date] 
					,src.[vehicle_service_code]
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[vehicle_id],inserted.[vehicle_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_vehicle]
			(
				 [vehicle_id] 
				,[vehicle_name] 
				,[vehicle_description] 
				,[vehicle_number_plate] 
				,[vehicle_type] 
				,[vehicle_class] 
				,[vehicle_make] 
				,[vehicle_model] 
				,[vehicle_year] 
				,[vehicle_nzta_subject_to_ruc] 
				,[vehicle_nzta_subject_to_ruc_hubo] 
				,[vehicle_nzta_wof_expiry_date] 
				,[vehicle_nzta_wof_type] 
				,[vehicle_nzta_license_expiry_date] 
				,[vehicle_nzta_fuel_type] 
				,[vehicle_nzta_ruc_expiry] 
				,[vehicle_nzta_ruc_expiry_date] 
				,[vehicle_service_code]
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[vehicle_id] 
				,src.[vehicle_name] 
				,src.[vehicle_description] 
				,src.[vehicle_number_plate] 
				,src.[vehicle_type] 
				,src.[vehicle_class] 
				,src.[vehicle_make] 
				,src.[vehicle_model] 
				,src.[vehicle_year] 
				,src.[vehicle_nzta_subject_to_ruc] 
				,src.[vehicle_nzta_subject_to_ruc_hubo] 
				,src.[vehicle_nzta_wof_expiry_date] 
				,src.[vehicle_nzta_wof_type] 
				,src.[vehicle_nzta_license_expiry_date] 
				,src.[vehicle_nzta_fuel_type] 
				,src.[vehicle_nzta_ruc_expiry] 
				,src.[vehicle_nzta_ruc_expiry_date] 
				,src.[vehicle_service_code]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_vehicle]'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLdim_vehicle] as src on src.[vehicle_id] = base.[vehicle_id] collate database_default
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[vehicle_id] 
				,tbl.[vehicle_name] 
				,tbl.[vehicle_description] 
				,tbl.[vehicle_number_plate] 
				,tbl.[vehicle_type] 
				,tbl.[vehicle_class] 
				,tbl.[vehicle_make] 
				,tbl.[vehicle_model] 
				,tbl.[vehicle_year] 
				,tbl.[vehicle_nzta_subject_to_ruc] 
				,tbl.[vehicle_nzta_subject_to_ruc_hubo] 
				,tbl.[vehicle_nzta_wof_expiry_date] 
				,tbl.[vehicle_nzta_wof_type] 
				,tbl.[vehicle_nzta_license_expiry_date] 
				,tbl.[vehicle_nzta_fuel_type] 
				,tbl.[vehicle_nzta_ruc_expiry] 
				,tbl.[vehicle_nzta_ruc_expiry_date] 
				,tbl.[vehicle_service_code]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_vehicle]'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[dim_vehicle] as tbl on tbl.[vehicle_id] = base.[vehicle_id] collate database_default and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLdim_vehicle] as src on src.[vehicle_id] = base.[vehicle_id] collate database_default
			where base.[MergeAction] = 'UPDATE'
			and  src.[vehicle_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_vehicle]
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