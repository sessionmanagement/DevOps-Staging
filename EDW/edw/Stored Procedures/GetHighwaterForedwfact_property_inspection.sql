

		CREATE procedure [edw].[GetHighwaterForedwfact_property_inspection]
			@property_inspection_modified_datetime datetime2(0) = null output
		as begin
			select
				 @property_inspection_modified_datetime = max([property_inspection_modified_datetime])
			from [edw].[fact_property_inspection];

			return 0;
		end