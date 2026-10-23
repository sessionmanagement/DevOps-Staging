


		create procedure [edw].[GetHighwaterForedwfact_powerbi_activity_log]
			@create_date date = null output
		as begin
			select
				 @create_date = max([create_date])
			from [edw].[fact_powerbi_activity_log];

			return 0;
		end