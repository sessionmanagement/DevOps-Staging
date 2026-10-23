

		CREATE procedure [edw].[GetHighwaterForedwdim_district]
			@last_modified_date_time datetime2(0) = null output
		as begin
			select
				 @last_modified_date_time = max([district_last_modified_date_time])
			from [edw].[dim_district];

			return 0;
		end