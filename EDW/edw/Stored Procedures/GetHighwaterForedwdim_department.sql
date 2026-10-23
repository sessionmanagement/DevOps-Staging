

		CREATE procedure [edw].[GetHighwaterForedwdim_department]
			@last_modified_date_time datetime2(0) = null output
		as begin
			select
				 @last_modified_date_time = max([department_last_modified_date_time])
			from [edw].[dim_department];

			return 0;
		end
		