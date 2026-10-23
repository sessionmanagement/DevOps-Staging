
		CREATE procedure [edw].[GetHighwaterForedwdim_property]
			@synapse_link_sink_modified_on datetime2(0) = null output
		as begin
			select
				 @synapse_link_sink_modified_on = max([synapse_link_sink_modified_on])
			from [edw].[dim_property]

			--select @synapse_link_sink_modified_on = '2025-01-01 15:58:04.0000000'

			return 0;
		end