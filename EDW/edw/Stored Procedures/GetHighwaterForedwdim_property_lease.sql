		CREATE procedure [edw].[GetHighwaterForedwdim_property_lease]
			@synapse_link_sink_modified_on datetime = null output
		as begin
			select
				 @synapse_link_sink_modified_on = min([synapse_link_sink_modified_on])
			from [edw].[dim_property_lease];

			--select @synapse_link_sink_modified_on = '1900-01-01 13:00:00.000'

			return 0;
		end