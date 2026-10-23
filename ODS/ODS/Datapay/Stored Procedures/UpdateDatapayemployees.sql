


CREATE   procedure [DataPay].[UpdateDatapayemployees] 
	@pBatchID int,
	@pMode varchar(10) = 'Full'
as begin

	set nocount on;
	set xact_abort on;

	declare @pErrorRecords		int;
	declare @pInsertRecords		int;
	declare @pUpdateRecords		int;
	declare @pDeleteRecords		int;
	declare @pCompleted			int;
	declare @pTargetRecords		int;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = '[datapay].[employees]';
	
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


	-- Check if there are records in the source table
	select @stagedRecords = count(1) from [Staging].[Datapay_employees];

	-- Do not run if there are no records in source
	if( @stagedRecords = 0 )
	begin
		-- Select return parameters as a dataset
		select	0				as ErrorRecords,
				0				as InsertRecords,
				0				as UpdateRecords,
				0				as DeleteRecords,
				1				as Completed,
				null			as TargetRecords;
		return;
	end;


	-- Check if there are records in the target table
	set @targetRecords = (select count(1) from [Working].[Datapay_employees]);

	-- On first pass / initial load only insert from landing, as existing data folders (main/working) will be empty
	if ( (@pMode = 'initial') or (@targetRecords = 0) )
	begin

		create external table [Datapay].[employees]
			with (
				location = 'Datapay/employees/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[id] ,src.[type] ,src.[company_id] ,src.[code] ,src.[first_name] ,src.[last_name] ,src.[preferred_name] ,src.[start_date] ,src.[termination_date] ,src.[gender] ,src.[title] ,src.[birth_date] ,src.[email_address] ,src.[street_value] ,src.[street_start_date] ,src.[street_end_date] ,src.[suburb_value] ,src.[suburb_start_date] ,src.[suburb_end_date] ,src.[city_value] ,src.[city_start_date] ,src.[city_end_date] ,src.[home_phone_value] ,src.[home_phone_start_date] ,src.[home_phone_end_date] ,src.[work_phone_value] ,src.[work_phone_start_date] ,src.[work_phone_end_date] ,src.[mobile_phone_value] ,src.[mobile_phone_start_date] ,src.[mobile_phone_end_date] ,src.[emergency_contact_name_value] ,src.[emergency_contact_name_start_date] ,src.[emergency_contact_name_end_date] ,src.[emergency_contact_relationship_value] ,src.[emergency_contact_relationship_start_date] ,src.[emergency_contact_relationship_end_date] ,src.[emergency_contact_address_value] ,src.[emergency_contact_address_start_date] ,src.[emergency_contact_address_end_date] ,src.[emergency_contact_home_phone_value] ,src.[emergency_contact_home_phone_start_date] ,src.[emergency_contact_home_phone_end_date] ,src.[emergency_contact_mobile_phone_value] ,src.[emergency_contact_mobile_phone_start_date] ,src.[emergency_contact_mobile_phone_end_date] ,src.[home_cost_box_value] ,src.[home_cost_box_start_date] ,src.[home_cost_box_end_date] ,src.[occupation_value] ,src.[occupation_start_date] ,src.[occupation_end_date] ,src.[manager_id] ,src.[pay_group_value] ,src.[pay_group_start_date] ,src.[pay_group_end_date] ,src.[sick_leave_stand_down] ,src.[sick_leave_stand_down_unit] ,src.[pay_point] ,src.[region_value] ,src.[region_start_date] ,src.[region_end_date] ,src.[tenure_value] ,src.[tenure_start_date] ,src.[tenure_end_date] ,src.[pay_rate_value] ,src.[pay_rate_start_date] ,src.[pay_rate_end_date] ,src.[pay_rate_option_value] ,src.[pay_rate_option_start_date] ,src.[pay_rate_option_end_date] ,src.[bank_account_value] ,src.[bank_account_start_date] ,src.[bank_account_end_date] ,src.[bank_account_holders_name_value] ,src.[bank_account_holders_name_start_date] ,src.[bank_account_holders_name_end_date] ,src.[pay_setup_value] ,src.[pay_setup_start_date] ,src.[pay_setup_end_date] ,src.[alt_pay_rate1_value] ,src.[alt_pay_rate1_start_date] ,src.[alt_pay_rate1_end_date] ,src.[alt_pay_rate2_value] ,src.[alt_pay_rate2_start_date] ,src.[alt_pay_rate2_end_date] ,src.[standard_hours_per_week_value] ,src.[standard_hours_per_week_start_date] ,src.[standard_hours_per_week_end_date] ,src.[standard_days_per_week_value] ,src.[standard_days_per_week_start_date] ,src.[standard_days_per_week_end_date] ,src.[esct_rate_value] ,src.[esct_tax_rate_start_date] ,src.[esct_tax_rate_end_date] ,src.[acc_class_value] ,src.[acc_class_start_date] ,src.[acc_class_end_date] ,src.[eligible_for_cec_and_etc_value] ,src.[eligible_for_cec_and_etc_start_date] ,src.[eligible_for_cec_and_etc_end_date] ,src.[employment_conditions_free_text_1_value] ,src.[employment_conditions_free_text_1_start_date] ,src.[employment_conditions_free_text_1_end_date] ,src.[free_text_2_value] ,src.[free_text_2_start_date] ,src.[free_text_2_end_date] ,src.[work_visa_free_text_3_value] ,src.[work_visa_free_text_3_start_date] ,src.[work_visa_free_text_3_end_date] ,src.[student_visa_free_text_4_value] ,src.[student_visa_free_text_4_start_date] ,src.[student_visa_free_text_4_end_date] ,src.[free_text_5_value] ,src.[free_text_5_start_date] ,src.[free_text_5_end_date] ,src.[free_text_6_value] ,src.[free_text_6_start_date] ,src.[free_text_6_end_date] ,src.[free_text_7_value] ,src.[free_text_7_start_date] ,src.[free_text_7_end_date] ,src.[hours_per_cycle_free_text_8_value] ,src.[hours_per_cycle_free_text_8_start_date] ,src.[hours_per_cycle_free_text_8_end_date] ,src.[free_text_9_value] ,src.[free_text_9_start_date] ,src.[free_text_9_end_date] , CAST(1 AS int) as [ODSIsCurrent], @SystemEffectiveFrom as [ODSEffectiveFrom], @SystemDefaultEffectiveTo as [ODSEffectiveTo], CAST('I' AS varchar(1)) as [ODSDMLOperation], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[Datapay_employees] src
		
		-- Select return parameters as a dataset
		select	0				as ErrorRecords,
				@stagedRecords	as InsertRecords,
				0				as UpdateRecords,
				0				as DeleteRecords,
				1				as Completed,
				@stagedRecords	as TargetRecords;

		return;

	end;

	begin try

		create external table [Datapay].[employees]
			with (
				location = 'Datapay/employees/main' ,
				data_source = [data],
				file_format = [parquet]
			)

		as 

		with cte_SummaryOfChanges as 
		(

			-- New in source, no record in target
			select  src.[id] , 'New' as MergeType
			from [Staging].[Datapay_employees] as src
				left outer join [Working].[Datapay_employees] trg
				on src.[id] = trg.[id] collate database_default and isnull(trg.[ODSIsCurrent], 0) = 1
			where  trg.[id] is null

			union all

			-- Match, but current record in target is marked as soft delete
			select  src.[id] ,  'NTD' as MergeType
			from [Staging].[Datapay_employees] as src
			inner join [Working].[Datapay_employees] trg
				on src.[id] = trg.[id] collate database_default
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') = 'D'

			union all

			-- Match, source data different from target data (following anything other than soft delete)
			select  src.[id] , 'Chg' as MergeType
			from [Staging].[Datapay_employees] as src
				inner join [Working].[Datapay_employees] trg
				on src.[id] = trg.[id] collate database_default
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'
				and exists
				( 
					select src.[type], src.[company_id], src.[code], src.[first_name], src.[last_name], src.[preferred_name], src.[start_date], src.[termination_date], src.[gender], src.[title], src.[birth_date], src.[email_address], src.[street_value], src.[street_start_date], src.[street_end_date], src.[suburb_value], src.[suburb_start_date], src.[suburb_end_date], src.[city_value], src.[city_start_date], src.[city_end_date], src.[home_phone_value], src.[home_phone_start_date], src.[home_phone_end_date], src.[work_phone_value], src.[work_phone_start_date], src.[work_phone_end_date], src.[mobile_phone_value], src.[mobile_phone_start_date], src.[mobile_phone_end_date], src.[emergency_contact_name_value], src.[emergency_contact_name_start_date], src.[emergency_contact_name_end_date], src.[emergency_contact_relationship_value], src.[emergency_contact_relationship_start_date], src.[emergency_contact_relationship_end_date], src.[emergency_contact_address_value], src.[emergency_contact_address_start_date], src.[emergency_contact_address_end_date], src.[emergency_contact_home_phone_value], src.[emergency_contact_home_phone_start_date], src.[emergency_contact_home_phone_end_date], src.[emergency_contact_mobile_phone_value], src.[emergency_contact_mobile_phone_start_date], src.[emergency_contact_mobile_phone_end_date], src.[home_cost_box_value], src.[home_cost_box_start_date], src.[home_cost_box_end_date], src.[occupation_value], src.[occupation_start_date], src.[occupation_end_date], src.[manager_id], src.[pay_group_value], src.[pay_group_start_date], src.[pay_group_end_date], src.[sick_leave_stand_down], src.[sick_leave_stand_down_unit], src.[pay_point], src.[region_value], src.[region_start_date], src.[region_end_date], src.[tenure_value], src.[tenure_start_date], src.[tenure_end_date], src.[pay_rate_value], src.[pay_rate_start_date], src.[pay_rate_end_date], src.[pay_rate_option_value], src.[pay_rate_option_start_date], src.[pay_rate_option_end_date], src.[bank_account_value], src.[bank_account_start_date], src.[bank_account_end_date], src.[bank_account_holders_name_value], src.[bank_account_holders_name_start_date], src.[bank_account_holders_name_end_date], src.[pay_setup_value], src.[pay_setup_start_date], src.[pay_setup_end_date], src.[alt_pay_rate1_value], src.[alt_pay_rate1_start_date], src.[alt_pay_rate1_end_date], src.[alt_pay_rate2_value], src.[alt_pay_rate2_start_date], src.[alt_pay_rate2_end_date], src.[standard_hours_per_week_value], src.[standard_hours_per_week_start_date], src.[standard_hours_per_week_end_date], src.[standard_days_per_week_value], src.[standard_days_per_week_start_date], src.[standard_days_per_week_end_date], src.[esct_rate_value], src.[esct_tax_rate_start_date], src.[esct_tax_rate_end_date], src.[acc_class_value], src.[acc_class_start_date], src.[acc_class_end_date], src.[eligible_for_cec_and_etc_value], src.[eligible_for_cec_and_etc_start_date], src.[eligible_for_cec_and_etc_end_date], src.[employment_conditions_free_text_1_value], src.[employment_conditions_free_text_1_start_date], src.[employment_conditions_free_text_1_end_date], src.[free_text_2_value], src.[free_text_2_start_date], src.[free_text_2_end_date], src.[work_visa_free_text_3_value], src.[work_visa_free_text_3_start_date], src.[work_visa_free_text_3_end_date], src.[student_visa_free_text_4_value], src.[student_visa_free_text_4_start_date], src.[student_visa_free_text_4_end_date], src.[free_text_5_value], src.[free_text_5_start_date], src.[free_text_5_end_date], src.[free_text_6_value], src.[free_text_6_start_date], src.[free_text_6_end_date], src.[free_text_7_value], src.[free_text_7_start_date], src.[free_text_7_end_date], src.[hours_per_cycle_free_text_8_value], src.[hours_per_cycle_free_text_8_start_date], src.[hours_per_cycle_free_text_8_end_date], src.[free_text_9_value], src.[free_text_9_start_date], src.[free_text_9_end_date]
					except
					select trg.[type], trg.[company_id], trg.[code], trg.[first_name], trg.[last_name], trg.[preferred_name], trg.[start_date], trg.[termination_date], trg.[gender], trg.[title], trg.[birth_date], trg.[email_address], trg.[street_value], trg.[street_start_date], trg.[street_end_date], trg.[suburb_value], trg.[suburb_start_date], trg.[suburb_end_date], trg.[city_value], trg.[city_start_date], trg.[city_end_date], trg.[home_phone_value], trg.[home_phone_start_date], trg.[home_phone_end_date], trg.[work_phone_value], trg.[work_phone_start_date], trg.[work_phone_end_date], trg.[mobile_phone_value], trg.[mobile_phone_start_date], trg.[mobile_phone_end_date], trg.[emergency_contact_name_value], trg.[emergency_contact_name_start_date], trg.[emergency_contact_name_end_date], trg.[emergency_contact_relationship_value], trg.[emergency_contact_relationship_start_date], trg.[emergency_contact_relationship_end_date], trg.[emergency_contact_address_value], trg.[emergency_contact_address_start_date], trg.[emergency_contact_address_end_date], trg.[emergency_contact_home_phone_value], trg.[emergency_contact_home_phone_start_date], trg.[emergency_contact_home_phone_end_date], trg.[emergency_contact_mobile_phone_value], trg.[emergency_contact_mobile_phone_start_date], trg.[emergency_contact_mobile_phone_end_date], trg.[home_cost_box_value], trg.[home_cost_box_start_date], trg.[home_cost_box_end_date], trg.[occupation_value], trg.[occupation_start_date], trg.[occupation_end_date], trg.[manager_id], trg.[pay_group_value], trg.[pay_group_start_date], trg.[pay_group_end_date], trg.[sick_leave_stand_down], trg.[sick_leave_stand_down_unit], trg.[pay_point], trg.[region_value], trg.[region_start_date], trg.[region_end_date], trg.[tenure_value], trg.[tenure_start_date], trg.[tenure_end_date], trg.[pay_rate_value], trg.[pay_rate_start_date], trg.[pay_rate_end_date], trg.[pay_rate_option_value], trg.[pay_rate_option_start_date], trg.[pay_rate_option_end_date], trg.[bank_account_value], trg.[bank_account_start_date], trg.[bank_account_end_date], trg.[bank_account_holders_name_value], trg.[bank_account_holders_name_start_date], trg.[bank_account_holders_name_end_date], trg.[pay_setup_value], trg.[pay_setup_start_date], trg.[pay_setup_end_date], trg.[alt_pay_rate1_value], trg.[alt_pay_rate1_start_date], trg.[alt_pay_rate1_end_date], trg.[alt_pay_rate2_value], trg.[alt_pay_rate2_start_date], trg.[alt_pay_rate2_end_date], trg.[standard_hours_per_week_value], trg.[standard_hours_per_week_start_date], trg.[standard_hours_per_week_end_date], trg.[standard_days_per_week_value], trg.[standard_days_per_week_start_date], trg.[standard_days_per_week_end_date], trg.[esct_rate_value], trg.[esct_tax_rate_start_date], trg.[esct_tax_rate_end_date], trg.[acc_class_value], trg.[acc_class_start_date], trg.[acc_class_end_date], trg.[eligible_for_cec_and_etc_value], trg.[eligible_for_cec_and_etc_start_date], trg.[eligible_for_cec_and_etc_end_date], trg.[employment_conditions_free_text_1_value], trg.[employment_conditions_free_text_1_start_date], trg.[employment_conditions_free_text_1_end_date], trg.[free_text_2_value], trg.[free_text_2_start_date], trg.[free_text_2_end_date], trg.[work_visa_free_text_3_value], trg.[work_visa_free_text_3_start_date], trg.[work_visa_free_text_3_end_date], trg.[student_visa_free_text_4_value], trg.[student_visa_free_text_4_start_date], trg.[student_visa_free_text_4_end_date], trg.[free_text_5_value], trg.[free_text_5_start_date], trg.[free_text_5_end_date], trg.[free_text_6_value], trg.[free_text_6_start_date], trg.[free_text_6_end_date], trg.[free_text_7_value], trg.[free_text_7_start_date], trg.[free_text_7_end_date], trg.[hours_per_cycle_free_text_8_value], trg.[hours_per_cycle_free_text_8_start_date], trg.[hours_per_cycle_free_text_8_end_date], trg.[free_text_9_value], trg.[free_text_9_start_date], trg.[free_text_9_end_date]
				)

			union all
 
			-- Match, source data identical to target (following anything other than soft delete)
			select  src.[id] , 'Non' as MergeType
			from [Staging].[Datapay_employees] as src
				inner join [Working].[Datapay_employees] trg
				on src.[id] = trg.[id] collate database_default
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'
				and not exists
				( 
					select src.[type], src.[company_id], src.[code], src.[first_name], src.[last_name], src.[preferred_name], src.[start_date], src.[termination_date], src.[gender], src.[title], src.[birth_date], src.[email_address], src.[street_value], src.[street_start_date], src.[street_end_date], src.[suburb_value], src.[suburb_start_date], src.[suburb_end_date], src.[city_value], src.[city_start_date], src.[city_end_date], src.[home_phone_value], src.[home_phone_start_date], src.[home_phone_end_date], src.[work_phone_value], src.[work_phone_start_date], src.[work_phone_end_date], src.[mobile_phone_value], src.[mobile_phone_start_date], src.[mobile_phone_end_date], src.[emergency_contact_name_value], src.[emergency_contact_name_start_date], src.[emergency_contact_name_end_date], src.[emergency_contact_relationship_value], src.[emergency_contact_relationship_start_date], src.[emergency_contact_relationship_end_date], src.[emergency_contact_address_value], src.[emergency_contact_address_start_date], src.[emergency_contact_address_end_date], src.[emergency_contact_home_phone_value], src.[emergency_contact_home_phone_start_date], src.[emergency_contact_home_phone_end_date], src.[emergency_contact_mobile_phone_value], src.[emergency_contact_mobile_phone_start_date], src.[emergency_contact_mobile_phone_end_date], src.[home_cost_box_value], src.[home_cost_box_start_date], src.[home_cost_box_end_date], src.[occupation_value], src.[occupation_start_date], src.[occupation_end_date], src.[manager_id], src.[pay_group_value], src.[pay_group_start_date], src.[pay_group_end_date], src.[sick_leave_stand_down], src.[sick_leave_stand_down_unit], src.[pay_point], src.[region_value], src.[region_start_date], src.[region_end_date], src.[tenure_value], src.[tenure_start_date], src.[tenure_end_date], src.[pay_rate_value], src.[pay_rate_start_date], src.[pay_rate_end_date], src.[pay_rate_option_value], src.[pay_rate_option_start_date], src.[pay_rate_option_end_date], src.[bank_account_value], src.[bank_account_start_date], src.[bank_account_end_date], src.[bank_account_holders_name_value], src.[bank_account_holders_name_start_date], src.[bank_account_holders_name_end_date], src.[pay_setup_value], src.[pay_setup_start_date], src.[pay_setup_end_date], src.[alt_pay_rate1_value], src.[alt_pay_rate1_start_date], src.[alt_pay_rate1_end_date], src.[alt_pay_rate2_value], src.[alt_pay_rate2_start_date], src.[alt_pay_rate2_end_date], src.[standard_hours_per_week_value], src.[standard_hours_per_week_start_date], src.[standard_hours_per_week_end_date], src.[standard_days_per_week_value], src.[standard_days_per_week_start_date], src.[standard_days_per_week_end_date], src.[esct_rate_value], src.[esct_tax_rate_start_date], src.[esct_tax_rate_end_date], src.[acc_class_value], src.[acc_class_start_date], src.[acc_class_end_date], src.[eligible_for_cec_and_etc_value], src.[eligible_for_cec_and_etc_start_date], src.[eligible_for_cec_and_etc_end_date], src.[employment_conditions_free_text_1_value], src.[employment_conditions_free_text_1_start_date], src.[employment_conditions_free_text_1_end_date], src.[free_text_2_value], src.[free_text_2_start_date], src.[free_text_2_end_date], src.[work_visa_free_text_3_value], src.[work_visa_free_text_3_start_date], src.[work_visa_free_text_3_end_date], src.[student_visa_free_text_4_value], src.[student_visa_free_text_4_start_date], src.[student_visa_free_text_4_end_date], src.[free_text_5_value], src.[free_text_5_start_date], src.[free_text_5_end_date], src.[free_text_6_value], src.[free_text_6_start_date], src.[free_text_6_end_date], src.[free_text_7_value], src.[free_text_7_start_date], src.[free_text_7_end_date], src.[hours_per_cycle_free_text_8_value], src.[hours_per_cycle_free_text_8_start_date], src.[hours_per_cycle_free_text_8_end_date], src.[free_text_9_value], src.[free_text_9_start_date], src.[free_text_9_end_date]
					except
					select trg.[type], trg.[company_id], trg.[code], trg.[first_name], trg.[last_name], trg.[preferred_name], trg.[start_date], trg.[termination_date], trg.[gender], trg.[title], trg.[birth_date], trg.[email_address], trg.[street_value], trg.[street_start_date], trg.[street_end_date], trg.[suburb_value], trg.[suburb_start_date], trg.[suburb_end_date], trg.[city_value], trg.[city_start_date], trg.[city_end_date], trg.[home_phone_value], trg.[home_phone_start_date], trg.[home_phone_end_date], trg.[work_phone_value], trg.[work_phone_start_date], trg.[work_phone_end_date], trg.[mobile_phone_value], trg.[mobile_phone_start_date], trg.[mobile_phone_end_date], trg.[emergency_contact_name_value], trg.[emergency_contact_name_start_date], trg.[emergency_contact_name_end_date], trg.[emergency_contact_relationship_value], trg.[emergency_contact_relationship_start_date], trg.[emergency_contact_relationship_end_date], trg.[emergency_contact_address_value], trg.[emergency_contact_address_start_date], trg.[emergency_contact_address_end_date], trg.[emergency_contact_home_phone_value], trg.[emergency_contact_home_phone_start_date], trg.[emergency_contact_home_phone_end_date], trg.[emergency_contact_mobile_phone_value], trg.[emergency_contact_mobile_phone_start_date], trg.[emergency_contact_mobile_phone_end_date], trg.[home_cost_box_value], trg.[home_cost_box_start_date], trg.[home_cost_box_end_date], trg.[occupation_value], trg.[occupation_start_date], trg.[occupation_end_date], trg.[manager_id], trg.[pay_group_value], trg.[pay_group_start_date], trg.[pay_group_end_date], trg.[sick_leave_stand_down], trg.[sick_leave_stand_down_unit], trg.[pay_point], trg.[region_value], trg.[region_start_date], trg.[region_end_date], trg.[tenure_value], trg.[tenure_start_date], trg.[tenure_end_date], trg.[pay_rate_value], trg.[pay_rate_start_date], trg.[pay_rate_end_date], trg.[pay_rate_option_value], trg.[pay_rate_option_start_date], trg.[pay_rate_option_end_date], trg.[bank_account_value], trg.[bank_account_start_date], trg.[bank_account_end_date], trg.[bank_account_holders_name_value], trg.[bank_account_holders_name_start_date], trg.[bank_account_holders_name_end_date], trg.[pay_setup_value], trg.[pay_setup_start_date], trg.[pay_setup_end_date], trg.[alt_pay_rate1_value], trg.[alt_pay_rate1_start_date], trg.[alt_pay_rate1_end_date], trg.[alt_pay_rate2_value], trg.[alt_pay_rate2_start_date], trg.[alt_pay_rate2_end_date], trg.[standard_hours_per_week_value], trg.[standard_hours_per_week_start_date], trg.[standard_hours_per_week_end_date], trg.[standard_days_per_week_value], trg.[standard_days_per_week_start_date], trg.[standard_days_per_week_end_date], trg.[esct_rate_value], trg.[esct_tax_rate_start_date], trg.[esct_tax_rate_end_date], trg.[acc_class_value], trg.[acc_class_start_date], trg.[acc_class_end_date], trg.[eligible_for_cec_and_etc_value], trg.[eligible_for_cec_and_etc_start_date], trg.[eligible_for_cec_and_etc_end_date], trg.[employment_conditions_free_text_1_value], trg.[employment_conditions_free_text_1_start_date], trg.[employment_conditions_free_text_1_end_date], trg.[free_text_2_value], trg.[free_text_2_start_date], trg.[free_text_2_end_date], trg.[work_visa_free_text_3_value], trg.[work_visa_free_text_3_start_date], trg.[work_visa_free_text_3_end_date], trg.[student_visa_free_text_4_value], trg.[student_visa_free_text_4_start_date], trg.[student_visa_free_text_4_end_date], trg.[free_text_5_value], trg.[free_text_5_start_date], trg.[free_text_5_end_date], trg.[free_text_6_value], trg.[free_text_6_start_date], trg.[free_text_6_end_date], trg.[free_text_7_value], trg.[free_text_7_start_date], trg.[free_text_7_end_date], trg.[hours_per_cycle_free_text_8_value], trg.[hours_per_cycle_free_text_8_start_date], trg.[hours_per_cycle_free_text_8_end_date], trg.[free_text_9_value], trg.[free_text_9_start_date], trg.[free_text_9_end_date]
				)

			union all

			-- Record in Target, not Source - soft delete.  Ignore any existing soft deletes in target
			select  trg.[id] , 'Del' as MergeType
			from [Staging].[Datapay_employees] as src
				right outer join [Working].[Datapay_employees] trg
				on src.[id] = trg.[id] collate database_default
			where  src.[id] is null
				and trg.[ODSIsCurrent] = 1 
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'

			union all

			-- Previously soft deleted records that (still) dont exist in source
			select  trg.[id] ,  'Non' as MergeType
			from [Staging].[Datapay_employees] as src
				right outer join [Working].[Datapay_employees] trg
					on src.[id] = trg.[id] collate database_default
			where  src.[id] is null    
				and isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') = 'D'

			union all


			-- Old versions of any row-versioned record
			select DISTINCT trg.[id] , 'Old' as MergeType
			from [Working].[Datapay_employees] trg
			where isnull(trg.[ODSIsCurrent], 0) = 0

		),

		cte_AllChanges as 
		(

			/* "INSERTS" - add new versions of records */

			-- New in source, either brand new or new following previous soft delete
			select  src.[id] ,src.[type] ,src.[company_id] ,src.[code] ,src.[first_name] ,src.[last_name] ,src.[preferred_name] ,src.[start_date] ,src.[termination_date] ,src.[gender] ,src.[title] ,src.[birth_date] ,src.[email_address] ,src.[street_value] ,src.[street_start_date] ,src.[street_end_date] ,src.[suburb_value] ,src.[suburb_start_date] ,src.[suburb_end_date] ,src.[city_value] ,src.[city_start_date] ,src.[city_end_date] ,src.[home_phone_value] ,src.[home_phone_start_date] ,src.[home_phone_end_date] ,src.[work_phone_value] ,src.[work_phone_start_date] ,src.[work_phone_end_date] ,src.[mobile_phone_value] ,src.[mobile_phone_start_date] ,src.[mobile_phone_end_date] ,src.[emergency_contact_name_value] ,src.[emergency_contact_name_start_date] ,src.[emergency_contact_name_end_date] ,src.[emergency_contact_relationship_value] ,src.[emergency_contact_relationship_start_date] ,src.[emergency_contact_relationship_end_date] ,src.[emergency_contact_address_value] ,src.[emergency_contact_address_start_date] ,src.[emergency_contact_address_end_date] ,src.[emergency_contact_home_phone_value] ,src.[emergency_contact_home_phone_start_date] ,src.[emergency_contact_home_phone_end_date] ,src.[emergency_contact_mobile_phone_value] ,src.[emergency_contact_mobile_phone_start_date] ,src.[emergency_contact_mobile_phone_end_date] ,src.[home_cost_box_value] ,src.[home_cost_box_start_date] ,src.[home_cost_box_end_date] ,src.[occupation_value] ,src.[occupation_start_date] ,src.[occupation_end_date] ,src.[manager_id] ,src.[pay_group_value] ,src.[pay_group_start_date] ,src.[pay_group_end_date] ,src.[sick_leave_stand_down] ,src.[sick_leave_stand_down_unit] ,src.[pay_point] ,src.[region_value] ,src.[region_start_date] ,src.[region_end_date] ,src.[tenure_value] ,src.[tenure_start_date] ,src.[tenure_end_date] ,src.[pay_rate_value] ,src.[pay_rate_start_date] ,src.[pay_rate_end_date] ,src.[pay_rate_option_value] ,src.[pay_rate_option_start_date] ,src.[pay_rate_option_end_date] ,src.[bank_account_value] ,src.[bank_account_start_date] ,src.[bank_account_end_date] ,src.[bank_account_holders_name_value] ,src.[bank_account_holders_name_start_date] ,src.[bank_account_holders_name_end_date] ,src.[pay_setup_value] ,src.[pay_setup_start_date] ,src.[pay_setup_end_date] ,src.[alt_pay_rate1_value] ,src.[alt_pay_rate1_start_date] ,src.[alt_pay_rate1_end_date] ,src.[alt_pay_rate2_value] ,src.[alt_pay_rate2_start_date] ,src.[alt_pay_rate2_end_date] ,src.[standard_hours_per_week_value] ,src.[standard_hours_per_week_start_date] ,src.[standard_hours_per_week_end_date] ,src.[standard_days_per_week_value] ,src.[standard_days_per_week_start_date] ,src.[standard_days_per_week_end_date] ,src.[esct_rate_value] ,src.[esct_tax_rate_start_date] ,src.[esct_tax_rate_end_date] ,src.[acc_class_value] ,src.[acc_class_start_date] ,src.[acc_class_end_date] ,src.[eligible_for_cec_and_etc_value] ,src.[eligible_for_cec_and_etc_start_date] ,src.[eligible_for_cec_and_etc_end_date] ,src.[employment_conditions_free_text_1_value] ,src.[employment_conditions_free_text_1_start_date] ,src.[employment_conditions_free_text_1_end_date] ,src.[free_text_2_value] ,src.[free_text_2_start_date] ,src.[free_text_2_end_date] ,src.[work_visa_free_text_3_value] ,src.[work_visa_free_text_3_start_date] ,src.[work_visa_free_text_3_end_date] ,src.[student_visa_free_text_4_value] ,src.[student_visa_free_text_4_start_date] ,src.[student_visa_free_text_4_end_date] ,src.[free_text_5_value] ,src.[free_text_5_start_date] ,src.[free_text_5_end_date] ,src.[free_text_6_value] ,src.[free_text_6_start_date] ,src.[free_text_6_end_date] ,src.[free_text_7_value] ,src.[free_text_7_start_date] ,src.[free_text_7_end_date] ,src.[hours_per_cycle_free_text_8_value] ,src.[hours_per_cycle_free_text_8_start_date] ,src.[hours_per_cycle_free_text_8_end_date] ,src.[free_text_9_value] ,src.[free_text_9_start_date] ,src.[free_text_9_end_date] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'I' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Staging].[Datapay_employees] src
				inner join cte_SummaryOfChanges chg 
				   on src.[id] = chg.[id] collate database_default
			where chg.MergeType IN ('New', 'NTD')
  
			union all

			-- "Soft delete" row version - i.e. record missing in source that was previously in target
			select  trg.[id] ,trg.[type] ,trg.[company_id] ,trg.[code] ,trg.[first_name] ,trg.[last_name] ,trg.[preferred_name] ,trg.[start_date] ,trg.[termination_date] ,trg.[gender] ,trg.[title] ,trg.[birth_date] ,trg.[email_address] ,trg.[street_value] ,trg.[street_start_date] ,trg.[street_end_date] ,trg.[suburb_value] ,trg.[suburb_start_date] ,trg.[suburb_end_date] ,trg.[city_value] ,trg.[city_start_date] ,trg.[city_end_date] ,trg.[home_phone_value] ,trg.[home_phone_start_date] ,trg.[home_phone_end_date] ,trg.[work_phone_value] ,trg.[work_phone_start_date] ,trg.[work_phone_end_date] ,trg.[mobile_phone_value] ,trg.[mobile_phone_start_date] ,trg.[mobile_phone_end_date] ,trg.[emergency_contact_name_value] ,trg.[emergency_contact_name_start_date] ,trg.[emergency_contact_name_end_date] ,trg.[emergency_contact_relationship_value] ,trg.[emergency_contact_relationship_start_date] ,trg.[emergency_contact_relationship_end_date] ,trg.[emergency_contact_address_value] ,trg.[emergency_contact_address_start_date] ,trg.[emergency_contact_address_end_date] ,trg.[emergency_contact_home_phone_value] ,trg.[emergency_contact_home_phone_start_date] ,trg.[emergency_contact_home_phone_end_date] ,trg.[emergency_contact_mobile_phone_value] ,trg.[emergency_contact_mobile_phone_start_date] ,trg.[emergency_contact_mobile_phone_end_date] ,trg.[home_cost_box_value] ,trg.[home_cost_box_start_date] ,trg.[home_cost_box_end_date] ,trg.[occupation_value] ,trg.[occupation_start_date] ,trg.[occupation_end_date] ,trg.[manager_id] ,trg.[pay_group_value] ,trg.[pay_group_start_date] ,trg.[pay_group_end_date] ,trg.[sick_leave_stand_down] ,trg.[sick_leave_stand_down_unit] ,trg.[pay_point] ,trg.[region_value] ,trg.[region_start_date] ,trg.[region_end_date] ,trg.[tenure_value] ,trg.[tenure_start_date] ,trg.[tenure_end_date] ,trg.[pay_rate_value] ,trg.[pay_rate_start_date] ,trg.[pay_rate_end_date] ,trg.[pay_rate_option_value] ,trg.[pay_rate_option_start_date] ,trg.[pay_rate_option_end_date] ,trg.[bank_account_value] ,trg.[bank_account_start_date] ,trg.[bank_account_end_date] ,trg.[bank_account_holders_name_value] ,trg.[bank_account_holders_name_start_date] ,trg.[bank_account_holders_name_end_date] ,trg.[pay_setup_value] ,trg.[pay_setup_start_date] ,trg.[pay_setup_end_date] ,trg.[alt_pay_rate1_value] ,trg.[alt_pay_rate1_start_date] ,trg.[alt_pay_rate1_end_date] ,trg.[alt_pay_rate2_value] ,trg.[alt_pay_rate2_start_date] ,trg.[alt_pay_rate2_end_date] ,trg.[standard_hours_per_week_value] ,trg.[standard_hours_per_week_start_date] ,trg.[standard_hours_per_week_end_date] ,trg.[standard_days_per_week_value] ,trg.[standard_days_per_week_start_date] ,trg.[standard_days_per_week_end_date] ,trg.[esct_rate_value] ,trg.[esct_tax_rate_start_date] ,trg.[esct_tax_rate_end_date] ,trg.[acc_class_value] ,trg.[acc_class_start_date] ,trg.[acc_class_end_date] ,trg.[eligible_for_cec_and_etc_value] ,trg.[eligible_for_cec_and_etc_start_date] ,trg.[eligible_for_cec_and_etc_end_date] ,trg.[employment_conditions_free_text_1_value] ,trg.[employment_conditions_free_text_1_start_date] ,trg.[employment_conditions_free_text_1_end_date] ,trg.[free_text_2_value] ,trg.[free_text_2_start_date] ,trg.[free_text_2_end_date] ,trg.[work_visa_free_text_3_value] ,trg.[work_visa_free_text_3_start_date] ,trg.[work_visa_free_text_3_end_date] ,trg.[student_visa_free_text_4_value] ,trg.[student_visa_free_text_4_start_date] ,trg.[student_visa_free_text_4_end_date] ,trg.[free_text_5_value] ,trg.[free_text_5_start_date] ,trg.[free_text_5_end_date] ,trg.[free_text_6_value] ,trg.[free_text_6_start_date] ,trg.[free_text_6_end_date] ,trg.[free_text_7_value] ,trg.[free_text_7_start_date] ,trg.[free_text_7_end_date] ,trg.[hours_per_cycle_free_text_8_value] ,trg.[hours_per_cycle_free_text_8_start_date] ,trg.[hours_per_cycle_free_text_8_end_date] ,trg.[free_text_9_value] ,trg.[free_text_9_start_date] ,trg.[free_text_9_end_date] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'D' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Working].[Datapay_employees] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[id] = chg.[id] collate database_default
			where chg.MergeType IN ('Del')
				and trg.[ODSIsCurrent] = 1

			union all

			-- Match, source data different from target data - i.e. basic new version of record
			select  src.[id] ,src.[type] ,src.[company_id] ,src.[code] ,src.[first_name] ,src.[last_name] ,src.[preferred_name] ,src.[start_date] ,src.[termination_date] ,src.[gender] ,src.[title] ,src.[birth_date] ,src.[email_address] ,src.[street_value] ,src.[street_start_date] ,src.[street_end_date] ,src.[suburb_value] ,src.[suburb_start_date] ,src.[suburb_end_date] ,src.[city_value] ,src.[city_start_date] ,src.[city_end_date] ,src.[home_phone_value] ,src.[home_phone_start_date] ,src.[home_phone_end_date] ,src.[work_phone_value] ,src.[work_phone_start_date] ,src.[work_phone_end_date] ,src.[mobile_phone_value] ,src.[mobile_phone_start_date] ,src.[mobile_phone_end_date] ,src.[emergency_contact_name_value] ,src.[emergency_contact_name_start_date] ,src.[emergency_contact_name_end_date] ,src.[emergency_contact_relationship_value] ,src.[emergency_contact_relationship_start_date] ,src.[emergency_contact_relationship_end_date] ,src.[emergency_contact_address_value] ,src.[emergency_contact_address_start_date] ,src.[emergency_contact_address_end_date] ,src.[emergency_contact_home_phone_value] ,src.[emergency_contact_home_phone_start_date] ,src.[emergency_contact_home_phone_end_date] ,src.[emergency_contact_mobile_phone_value] ,src.[emergency_contact_mobile_phone_start_date] ,src.[emergency_contact_mobile_phone_end_date] ,src.[home_cost_box_value] ,src.[home_cost_box_start_date] ,src.[home_cost_box_end_date] ,src.[occupation_value] ,src.[occupation_start_date] ,src.[occupation_end_date] ,src.[manager_id] ,src.[pay_group_value] ,src.[pay_group_start_date] ,src.[pay_group_end_date] ,src.[sick_leave_stand_down] ,src.[sick_leave_stand_down_unit] ,src.[pay_point] ,src.[region_value] ,src.[region_start_date] ,src.[region_end_date] ,src.[tenure_value] ,src.[tenure_start_date] ,src.[tenure_end_date] ,src.[pay_rate_value] ,src.[pay_rate_start_date] ,src.[pay_rate_end_date] ,src.[pay_rate_option_value] ,src.[pay_rate_option_start_date] ,src.[pay_rate_option_end_date] ,src.[bank_account_value] ,src.[bank_account_start_date] ,src.[bank_account_end_date] ,src.[bank_account_holders_name_value] ,src.[bank_account_holders_name_start_date] ,src.[bank_account_holders_name_end_date] ,src.[pay_setup_value] ,src.[pay_setup_start_date] ,src.[pay_setup_end_date] ,src.[alt_pay_rate1_value] ,src.[alt_pay_rate1_start_date] ,src.[alt_pay_rate1_end_date] ,src.[alt_pay_rate2_value] ,src.[alt_pay_rate2_start_date] ,src.[alt_pay_rate2_end_date] ,src.[standard_hours_per_week_value] ,src.[standard_hours_per_week_start_date] ,src.[standard_hours_per_week_end_date] ,src.[standard_days_per_week_value] ,src.[standard_days_per_week_start_date] ,src.[standard_days_per_week_end_date] ,src.[esct_rate_value] ,src.[esct_tax_rate_start_date] ,src.[esct_tax_rate_end_date] ,src.[acc_class_value] ,src.[acc_class_start_date] ,src.[acc_class_end_date] ,src.[eligible_for_cec_and_etc_value] ,src.[eligible_for_cec_and_etc_start_date] ,src.[eligible_for_cec_and_etc_end_date] ,src.[employment_conditions_free_text_1_value] ,src.[employment_conditions_free_text_1_start_date] ,src.[employment_conditions_free_text_1_end_date] ,src.[free_text_2_value] ,src.[free_text_2_start_date] ,src.[free_text_2_end_date] ,src.[work_visa_free_text_3_value] ,src.[work_visa_free_text_3_start_date] ,src.[work_visa_free_text_3_end_date] ,src.[student_visa_free_text_4_value] ,src.[student_visa_free_text_4_start_date] ,src.[student_visa_free_text_4_end_date] ,src.[free_text_5_value] ,src.[free_text_5_start_date] ,src.[free_text_5_end_date] ,src.[free_text_6_value] ,src.[free_text_6_start_date] ,src.[free_text_6_end_date] ,src.[free_text_7_value] ,src.[free_text_7_start_date] ,src.[free_text_7_end_date] ,src.[hours_per_cycle_free_text_8_value] ,src.[hours_per_cycle_free_text_8_start_date] ,src.[hours_per_cycle_free_text_8_end_date] ,src.[free_text_9_value] ,src.[free_text_9_start_date] ,src.[free_text_9_end_date] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'U' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Staging].[Datapay_employees] src
				inner join cte_SummaryOfChanges chg 
					on src.[id] = chg.[id] collate database_default
			where chg.MergeType = 'Chg'

			union all

			/* "UPDATES" - expire old versions of records that have been newly updated or deleted.  Set system flags accordingly. */

			-- Expire old versions of records that have had new version added
			select  trg.[id] ,trg.[type] ,trg.[company_id] ,trg.[code] ,trg.[first_name] ,trg.[last_name] ,trg.[preferred_name] ,trg.[start_date] ,trg.[termination_date] ,trg.[gender] ,trg.[title] ,trg.[birth_date] ,trg.[email_address] ,trg.[street_value] ,trg.[street_start_date] ,trg.[street_end_date] ,trg.[suburb_value] ,trg.[suburb_start_date] ,trg.[suburb_end_date] ,trg.[city_value] ,trg.[city_start_date] ,trg.[city_end_date] ,trg.[home_phone_value] ,trg.[home_phone_start_date] ,trg.[home_phone_end_date] ,trg.[work_phone_value] ,trg.[work_phone_start_date] ,trg.[work_phone_end_date] ,trg.[mobile_phone_value] ,trg.[mobile_phone_start_date] ,trg.[mobile_phone_end_date] ,trg.[emergency_contact_name_value] ,trg.[emergency_contact_name_start_date] ,trg.[emergency_contact_name_end_date] ,trg.[emergency_contact_relationship_value] ,trg.[emergency_contact_relationship_start_date] ,trg.[emergency_contact_relationship_end_date] ,trg.[emergency_contact_address_value] ,trg.[emergency_contact_address_start_date] ,trg.[emergency_contact_address_end_date] ,trg.[emergency_contact_home_phone_value] ,trg.[emergency_contact_home_phone_start_date] ,trg.[emergency_contact_home_phone_end_date] ,trg.[emergency_contact_mobile_phone_value] ,trg.[emergency_contact_mobile_phone_start_date] ,trg.[emergency_contact_mobile_phone_end_date] ,trg.[home_cost_box_value] ,trg.[home_cost_box_start_date] ,trg.[home_cost_box_end_date] ,trg.[occupation_value] ,trg.[occupation_start_date] ,trg.[occupation_end_date] ,trg.[manager_id] ,trg.[pay_group_value] ,trg.[pay_group_start_date] ,trg.[pay_group_end_date] ,trg.[sick_leave_stand_down] ,trg.[sick_leave_stand_down_unit] ,trg.[pay_point] ,trg.[region_value] ,trg.[region_start_date] ,trg.[region_end_date] ,trg.[tenure_value] ,trg.[tenure_start_date] ,trg.[tenure_end_date] ,trg.[pay_rate_value] ,trg.[pay_rate_start_date] ,trg.[pay_rate_end_date] ,trg.[pay_rate_option_value] ,trg.[pay_rate_option_start_date] ,trg.[pay_rate_option_end_date] ,trg.[bank_account_value] ,trg.[bank_account_start_date] ,trg.[bank_account_end_date] ,trg.[bank_account_holders_name_value] ,trg.[bank_account_holders_name_start_date] ,trg.[bank_account_holders_name_end_date] ,trg.[pay_setup_value] ,trg.[pay_setup_start_date] ,trg.[pay_setup_end_date] ,trg.[alt_pay_rate1_value] ,trg.[alt_pay_rate1_start_date] ,trg.[alt_pay_rate1_end_date] ,trg.[alt_pay_rate2_value] ,trg.[alt_pay_rate2_start_date] ,trg.[alt_pay_rate2_end_date] ,trg.[standard_hours_per_week_value] ,trg.[standard_hours_per_week_start_date] ,trg.[standard_hours_per_week_end_date] ,trg.[standard_days_per_week_value] ,trg.[standard_days_per_week_start_date] ,trg.[standard_days_per_week_end_date] ,trg.[esct_rate_value] ,trg.[esct_tax_rate_start_date] ,trg.[esct_tax_rate_end_date] ,trg.[acc_class_value] ,trg.[acc_class_start_date] ,trg.[acc_class_end_date] ,trg.[eligible_for_cec_and_etc_value] ,trg.[eligible_for_cec_and_etc_start_date] ,trg.[eligible_for_cec_and_etc_end_date] ,trg.[employment_conditions_free_text_1_value] ,trg.[employment_conditions_free_text_1_start_date] ,trg.[employment_conditions_free_text_1_end_date] ,trg.[free_text_2_value] ,trg.[free_text_2_start_date] ,trg.[free_text_2_end_date] ,trg.[work_visa_free_text_3_value] ,trg.[work_visa_free_text_3_start_date] ,trg.[work_visa_free_text_3_end_date] ,trg.[student_visa_free_text_4_value] ,trg.[student_visa_free_text_4_start_date] ,trg.[student_visa_free_text_4_end_date] ,trg.[free_text_5_value] ,trg.[free_text_5_start_date] ,trg.[free_text_5_end_date] ,trg.[free_text_6_value] ,trg.[free_text_6_start_date] ,trg.[free_text_6_end_date] ,trg.[free_text_7_value] ,trg.[free_text_7_start_date] ,trg.[free_text_7_end_date] ,trg.[hours_per_cycle_free_text_8_value] ,trg.[hours_per_cycle_free_text_8_start_date] ,trg.[hours_per_cycle_free_text_8_end_date] ,trg.[free_text_9_value] ,trg.[free_text_9_start_date] ,trg.[free_text_9_end_date] 
					, 0 as [ODSIsCurrent], trg.[ODSEffectiveFrom] as [ODSEffectiveFrom], null as [ODSEffectiveTo], trg.[ODSDMLOperation] as [ODSDMLOperation], trg.[ODSBatchId] as [ODSBatchId], trg.[ODSSourceSystem] as [ODSSourceSystem]
			from [Working].[Datapay_employees] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[id] = chg.[id] collate database_default
			where chg.MergeType IN ('Chg', 'Del', 'NTD')
				and trg.[ODSIsCurrent] = 1

			union all

			/*  "UNCHANGED" - copy across all records that have not otherwise been changed */

			-- Match, source data different from target data, or soft delete - expire old versions of records
			select  trg.[id] ,trg.[type] ,trg.[company_id] ,trg.[code] ,trg.[first_name] ,trg.[last_name] ,trg.[preferred_name] ,trg.[start_date] ,trg.[termination_date] ,trg.[gender] ,trg.[title] ,trg.[birth_date] ,trg.[email_address] ,trg.[street_value] ,trg.[street_start_date] ,trg.[street_end_date] ,trg.[suburb_value] ,trg.[suburb_start_date] ,trg.[suburb_end_date] ,trg.[city_value] ,trg.[city_start_date] ,trg.[city_end_date] ,trg.[home_phone_value] ,trg.[home_phone_start_date] ,trg.[home_phone_end_date] ,trg.[work_phone_value] ,trg.[work_phone_start_date] ,trg.[work_phone_end_date] ,trg.[mobile_phone_value] ,trg.[mobile_phone_start_date] ,trg.[mobile_phone_end_date] ,trg.[emergency_contact_name_value] ,trg.[emergency_contact_name_start_date] ,trg.[emergency_contact_name_end_date] ,trg.[emergency_contact_relationship_value] ,trg.[emergency_contact_relationship_start_date] ,trg.[emergency_contact_relationship_end_date] ,trg.[emergency_contact_address_value] ,trg.[emergency_contact_address_start_date] ,trg.[emergency_contact_address_end_date] ,trg.[emergency_contact_home_phone_value] ,trg.[emergency_contact_home_phone_start_date] ,trg.[emergency_contact_home_phone_end_date] ,trg.[emergency_contact_mobile_phone_value] ,trg.[emergency_contact_mobile_phone_start_date] ,trg.[emergency_contact_mobile_phone_end_date] ,trg.[home_cost_box_value] ,trg.[home_cost_box_start_date] ,trg.[home_cost_box_end_date] ,trg.[occupation_value] ,trg.[occupation_start_date] ,trg.[occupation_end_date] ,trg.[manager_id] ,trg.[pay_group_value] ,trg.[pay_group_start_date] ,trg.[pay_group_end_date] ,trg.[sick_leave_stand_down] ,trg.[sick_leave_stand_down_unit] ,trg.[pay_point] ,trg.[region_value] ,trg.[region_start_date] ,trg.[region_end_date] ,trg.[tenure_value] ,trg.[tenure_start_date] ,trg.[tenure_end_date] ,trg.[pay_rate_value] ,trg.[pay_rate_start_date] ,trg.[pay_rate_end_date] ,trg.[pay_rate_option_value] ,trg.[pay_rate_option_start_date] ,trg.[pay_rate_option_end_date] ,trg.[bank_account_value] ,trg.[bank_account_start_date] ,trg.[bank_account_end_date] ,trg.[bank_account_holders_name_value] ,trg.[bank_account_holders_name_start_date] ,trg.[bank_account_holders_name_end_date] ,trg.[pay_setup_value] ,trg.[pay_setup_start_date] ,trg.[pay_setup_end_date] ,trg.[alt_pay_rate1_value] ,trg.[alt_pay_rate1_start_date] ,trg.[alt_pay_rate1_end_date] ,trg.[alt_pay_rate2_value] ,trg.[alt_pay_rate2_start_date] ,trg.[alt_pay_rate2_end_date] ,trg.[standard_hours_per_week_value] ,trg.[standard_hours_per_week_start_date] ,trg.[standard_hours_per_week_end_date] ,trg.[standard_days_per_week_value] ,trg.[standard_days_per_week_start_date] ,trg.[standard_days_per_week_end_date] ,trg.[esct_rate_value] ,trg.[esct_tax_rate_start_date] ,trg.[esct_tax_rate_end_date] ,trg.[acc_class_value] ,trg.[acc_class_start_date] ,trg.[acc_class_end_date] ,trg.[eligible_for_cec_and_etc_value] ,trg.[eligible_for_cec_and_etc_start_date] ,trg.[eligible_for_cec_and_etc_end_date] ,trg.[employment_conditions_free_text_1_value] ,trg.[employment_conditions_free_text_1_start_date] ,trg.[employment_conditions_free_text_1_end_date] ,trg.[free_text_2_value] ,trg.[free_text_2_start_date] ,trg.[free_text_2_end_date] ,trg.[work_visa_free_text_3_value] ,trg.[work_visa_free_text_3_start_date] ,trg.[work_visa_free_text_3_end_date] ,trg.[student_visa_free_text_4_value] ,trg.[student_visa_free_text_4_start_date] ,trg.[student_visa_free_text_4_end_date] ,trg.[free_text_5_value] ,trg.[free_text_5_start_date] ,trg.[free_text_5_end_date] ,trg.[free_text_6_value] ,trg.[free_text_6_start_date] ,trg.[free_text_6_end_date] ,trg.[free_text_7_value] ,trg.[free_text_7_start_date] ,trg.[free_text_7_end_date] ,trg.[hours_per_cycle_free_text_8_value] ,trg.[hours_per_cycle_free_text_8_start_date] ,trg.[hours_per_cycle_free_text_8_end_date] ,trg.[free_text_9_value] ,trg.[free_text_9_start_date] ,trg.[free_text_9_end_date] 
					, trg.[ODSIsCurrent] as [ODSIsCurrent], trg.[ODSEffectiveFrom] as [ODSEffectiveFrom], trg.[ODSEffectiveTo] as [ODSEffectiveTo], trg.[ODSDMLOperation] as [ODSDMLOperation], null as [ODSBatchId], trg.[ODSSourceSystem] as [ODSSourceSystem]
			from [Working].[Datapay_employees] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[id] = chg.[id] collate database_default
			where (chg.MergeType = 'Old' and trg.[ODSIsCurrent] != 1) or (chg.MergeType = 'Non' and trg.[ODSIsCurrent] = 1)

		)

		select  src.[id] ,src.[type] ,src.[company_id] ,src.[code] ,src.[first_name] ,src.[last_name] ,src.[preferred_name] ,src.[start_date] ,src.[termination_date] ,src.[gender] ,src.[title] ,src.[birth_date] ,src.[email_address] ,src.[street_value] ,src.[street_start_date] ,src.[street_end_date] ,src.[suburb_value] ,src.[suburb_start_date] ,src.[suburb_end_date] ,src.[city_value] ,src.[city_start_date] ,src.[city_end_date] ,src.[home_phone_value] ,src.[home_phone_start_date] ,src.[home_phone_end_date] ,src.[work_phone_value] ,src.[work_phone_start_date] ,src.[work_phone_end_date] ,src.[mobile_phone_value] ,src.[mobile_phone_start_date] ,src.[mobile_phone_end_date] ,src.[emergency_contact_name_value] ,src.[emergency_contact_name_start_date] ,src.[emergency_contact_name_end_date] ,src.[emergency_contact_relationship_value] ,src.[emergency_contact_relationship_start_date] ,src.[emergency_contact_relationship_end_date] ,src.[emergency_contact_address_value] ,src.[emergency_contact_address_start_date] ,src.[emergency_contact_address_end_date] ,src.[emergency_contact_home_phone_value] ,src.[emergency_contact_home_phone_start_date] ,src.[emergency_contact_home_phone_end_date] ,src.[emergency_contact_mobile_phone_value] ,src.[emergency_contact_mobile_phone_start_date] ,src.[emergency_contact_mobile_phone_end_date] ,src.[home_cost_box_value] ,src.[home_cost_box_start_date] ,src.[home_cost_box_end_date] ,src.[occupation_value] ,src.[occupation_start_date] ,src.[occupation_end_date] ,src.[manager_id] ,src.[pay_group_value] ,src.[pay_group_start_date] ,src.[pay_group_end_date] ,src.[sick_leave_stand_down] ,src.[sick_leave_stand_down_unit] ,src.[pay_point] ,src.[region_value] ,src.[region_start_date] ,src.[region_end_date] ,src.[tenure_value] ,src.[tenure_start_date] ,src.[tenure_end_date] ,src.[pay_rate_value] ,src.[pay_rate_start_date] ,src.[pay_rate_end_date] ,src.[pay_rate_option_value] ,src.[pay_rate_option_start_date] ,src.[pay_rate_option_end_date] ,src.[bank_account_value] ,src.[bank_account_start_date] ,src.[bank_account_end_date] ,src.[bank_account_holders_name_value] ,src.[bank_account_holders_name_start_date] ,src.[bank_account_holders_name_end_date] ,src.[pay_setup_value] ,src.[pay_setup_start_date] ,src.[pay_setup_end_date] ,src.[alt_pay_rate1_value] ,src.[alt_pay_rate1_start_date] ,src.[alt_pay_rate1_end_date] ,src.[alt_pay_rate2_value] ,src.[alt_pay_rate2_start_date] ,src.[alt_pay_rate2_end_date] ,src.[standard_hours_per_week_value] ,src.[standard_hours_per_week_start_date] ,src.[standard_hours_per_week_end_date] ,src.[standard_days_per_week_value] ,src.[standard_days_per_week_start_date] ,src.[standard_days_per_week_end_date] ,src.[esct_rate_value] ,src.[esct_tax_rate_start_date] ,src.[esct_tax_rate_end_date] ,src.[acc_class_value] ,src.[acc_class_start_date] ,src.[acc_class_end_date] ,src.[eligible_for_cec_and_etc_value] ,src.[eligible_for_cec_and_etc_start_date] ,src.[eligible_for_cec_and_etc_end_date] ,src.[employment_conditions_free_text_1_value] ,src.[employment_conditions_free_text_1_start_date] ,src.[employment_conditions_free_text_1_end_date] ,src.[free_text_2_value] ,src.[free_text_2_start_date] ,src.[free_text_2_end_date] ,src.[work_visa_free_text_3_value] ,src.[work_visa_free_text_3_start_date] ,src.[work_visa_free_text_3_end_date] ,src.[student_visa_free_text_4_value] ,src.[student_visa_free_text_4_start_date] ,src.[student_visa_free_text_4_end_date] ,src.[free_text_5_value] ,src.[free_text_5_start_date] ,src.[free_text_5_end_date] ,src.[free_text_6_value] ,src.[free_text_6_start_date] ,src.[free_text_6_end_date] ,src.[free_text_7_value] ,src.[free_text_7_start_date] ,src.[free_text_7_end_date] ,src.[hours_per_cycle_free_text_8_value] ,src.[hours_per_cycle_free_text_8_start_date] ,src.[hours_per_cycle_free_text_8_end_date] ,src.[free_text_9_value] ,src.[free_text_9_start_date] ,src.[free_text_9_end_date] , 
			CAST(isnull(ODSIsCurrent, 1) AS int) as ODSIsCurrent,
			isnull(ODSEffectiveFrom, @SystemEffectiveFrom) as ODSEffectiveFrom, 
			isnull(ODSEffectiveTo, case ODSIsCurrent when 1 then @SystemDefaultEffectiveTo else @SystemEffectiveTo end) as ODSEffectiveTo, 
			CAST(isnull([ODSDMLOperation], 'I') AS varchar(1)) as [ODSDMLOperation], 
			isnull(ODSBatchId, @batchId) as ODSBatchId, 
			isnull(ODSSourceSystem, @SourceSystem) as ODSSourceSystem
		from cte_AllChanges as src;

		set @insertedRecords = (select count(1) from [Datapay].[employees] 
									where [ODSDMLOperation] = 'I' 
										and [ODSIsCurrent] = 1
										and [ODSBatchId] = @batchId);
		set @updatedRecords = (select count(1) from [Datapay].[employees] 
									where [ODSDMLOperation] = 'U' 
										and [ODSIsCurrent] = 1
										and [ODSBatchId] = @batchId);
		set @deletedRecords = (select count(1) from [Datapay].[employees] 
									where [ODSDMLOperation] = 'D' 
										and [ODSIsCurrent] = 1
										and [ODSBatchId] = @batchId);

		-- Select return parameters as a dataset
		select	0					as ErrorRecords,
				@insertedRecords	as InsertRecords,
				@updatedRecords		as UpdateRecords,
				@deletedRecords		as DeleteRecords,
				1					as Completed,
				@targetRecords		as TargetRecords;

		return;
	end try
	begin catch
		-- Select return parameters as a dataset
		select	0				as ErrorRecords,
				0				as InsertRecords,
				0				as UpdateRecords,
				0				as DeleteRecords,
				0				as Completed,
				0				as TargetRecords;

		throw;
	end catch

end;