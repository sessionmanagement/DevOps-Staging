




		CREATE procedure [edw].[GetHighwaterForedwfact_finance_budget]
			@Last_Date_Modified datetime2(0) = null output
		as begin
			select @Last_Date_Modified='1900-01-01'
			--=dateadd(yy,-1,dd.[financial_first_day_of_year_date])
			-- FROM 
			--(select
			-- max([finance_budget_last_modified_date_time]) as last_modify_dt
			--from [edw].[fact_finance_budget] )last_modify
			--INNER JOIN edw.dim_date dd on cast(last_modify.last_modify_dt as date)=dd.calendar_date
			;

			return 0;
		end