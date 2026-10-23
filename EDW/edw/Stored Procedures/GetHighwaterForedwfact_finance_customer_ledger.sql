



		CREATE procedure [edw].[GetHighwaterForedwfact_finance_customer_ledger]
			@ODSEffectiveFrom datetime = null output
		as begin
			select
				 @ODSEffectiveFrom = max([finance_customer_ledger_ODSEffectiveFrom])
			from [edw].[fact_finance_customer_ledger];

			return 0;
		end