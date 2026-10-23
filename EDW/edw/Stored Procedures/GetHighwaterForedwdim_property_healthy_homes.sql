
		CREATE procedure [edw].[GetHighwaterForedwdim_property_healthy_homes]
			@synapse_link_sink_modified_on datetime2(0) = null output
		as begin
			select
				 @synapse_link_sink_modified_on = max([synapse_link_sink_modified_on])
			from [edw].[dim_property_healthy_homes];

			return 0;
		end