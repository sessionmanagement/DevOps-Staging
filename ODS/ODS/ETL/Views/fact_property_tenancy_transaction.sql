
CREATE   VIEW [ETL].[fact_property_tenancy_transaction]
AS
    --1.0        2026-02-20     GitHub Copilot  Removed 12 redundant columns per work item 12210


SELECT
    [zav_tenancytransactiondetailsid] as property_tenancy_transaction_id
    , opp.zav_property as property_id
    , td.[zav_tenancy] as property_tenancy_id  
    , opp.[zav_program]  AS [property_program_id]
    , opp.[zav_subprogram]  AS [property_subprogram_id]
    , CAST(FORMAT(CONVERT(DATE, td.[zav_date] ), 'yyyyMMdd') AS INT)  AS property_tenancy_transaction_date_id
    , CAST(FORMAT(CONVERT(DATE, td.[zav_rentfromdate] ), 'yyyyMMdd') AS INT)  AS property_tenancy_transaction_rent_from_date_id
    , CAST(FORMAT(CONVERT(DATE, td.[zav_renttodate] ), 'yyyyMMdd') AS INT)  AS property_tenancy_transaction_rent_to_date_id
    , CAST(FORMAT(CONVERT(DATE, td.[zav_rentpaidto] ), 'yyyyMMdd') AS INT)  AS property_tenancy_transaction_rent_paid_to_date_id
    , CAST(FORMAT(CONVERT(DATE, td.[zav_tenancyasatdate] ), 'yyyyMMdd') AS INT)  AS property_tenancy_transaction_as_at_date_id
    , CAST(td.[zav_name] AS VARCHAR(200)) as property_tenancy_transaction_name  --VAGUE
    , CAST(td.[new_transactiontypecode] AS VARCHAR(10)) as property_tenancy_transaction_type_code  --4 digits - appears to be a link to GL codes?  that would make it property_tenancy_transaction_credit_GL_account_no 
    , CAST(td.[zav_transactiontypename] AS VARCHAR(100)) as property_tenancy_transaction_type
    
    , (SELECT CAST([LocalizedLabel] AS VARCHAR(40))
            FROM [Zavanti].[vw_GlobalOptionsetMetadata]
            where EntityName='zav_tenancytransactiondetails' and OptionSetName = 'zav_accounttype' and [Option]=td.[zav_accounttype]) as property_tenancy_transaction_account_type 
    , CAST(td.[zav_subtransactionname] AS VARCHAR(40)) as property_tenancy_transaction_subtransaction_name  --null
    , td.[zav_comments] as property_tenancy_transaction_comments
    
    , (SELECT CAST([LocalizedLabel] AS VARCHAR(10))
            FROM [Zavanti].[vw_StateMetadata]
            where EntityName='zav_tenancytransactiondetails' and state=td.[statecode]) as property_tenancy_transaction_state  
    
    , (SELECT CAST([LocalizedLabel] AS VARCHAR(10))
            FROM [Zavanti].[vw_StatusMetadata]
            where EntityName='zav_tenancytransactiondetails' and state=0 and status=td.[statuscode]) as property_tenancy_transaction_status  
    
    ,td.[zav_paymenttype] as property_tenancy_transaction_payment_type_id

    , (SELECT CAST([LocalizedLabel] AS VARCHAR(20))
            FROM [Zavanti].[vw_GlobalOptionsetMetadata]
            where EntityName='zav_tenancytransactiondetails' and OptionSetName = 'zav_rent' and [Option]=[zav_rent]) as property_tenancy_transaction_rent_nonrent

    , (SELECT CAST([LocalizedLabel] AS VARCHAR(10))
            FROM [Zavanti].[vw_GlobalOptionsetMetadata]
            where EntityName='zav_tenancytransactiondetails' and OptionSetName = 'zav_transaction' and [Option]=[zav_transaction]) as property_tenancy_transaction_credit_debit

    , CAST(td.[zav_arrearsarrangementname] AS VARCHAR(200)) as property_tenancy_transaction_arrears_arrangement
    , CAST(td.[zav_importpaymentname]  AS VARCHAR(100)) as property_tenancy_transaction_import_payment_name
    , CAST(td.[zav_rentgenerationbatchname] AS VARCHAR(20)) as property_tenancy_transaction_rent_generation_batch
    , CAST(td.[zav_bcentryno] AS VARCHAR(10)) as property_tenancy_transaction_bc_entry_number  --oddly in but leaving it here for future use?
    , td.[zav_amount] as property_tenancy_transaction_amount
    , td.[new_balancenonrent] as property_tenancy_transaction_balance_non_rent
    , td.[new_balancerent] as property_tenancy_transaction_balance_rent
    , td.[new_balancetotal] as property_tenancy_transaction_balance_total
    , td.[new_receiptnumber] as property_tenancy_transaction_receipt_number
    , CAST(CAST(td.[new_suspenseaccount] as BIT) as INT) as property_tenancy_transaction_suspense_account_flag
    , CAST(CAST(td.[zav_fromzavantiimport] as BIT) as INT) as property_tenancy_transaction_from_zavanti_import_flag
    , td.createdon AS property_tenancy_transaction_created_datetime
    , td.modifiedon  AS property_tenancy_transaction_modified_datetime
    , CAST(CAST(td.[IsDelete]  as BIT) as INT) AS property_tenancy_transaction_is_delete_flag

    --,td.[zav_renttodate] as property_tenancy_transaction_rent_to_date
    --,td.[zav_rentfromdate] as property_tenancy_transaction_rent_from_date
    --,td.[zav_transactiontype] as property_tenancy_transaction_type_id  --link to dim_property_tenancy_transaction_type_breakup on property_tenancy_transaction_type_id  << this was removed as link was not working
    --,td.[zav_rentpaidto] as property_tenancy_transaction_rent_paid_to_date
    --,td.[zav_tenancyname] as property_tenancy << removed as this will be included in dim_property_tenancy
    --,td.[zav_date] as property_tenancy_transaction_date  --CLARIFY - date of what??  Transaction?  VAGUE
    --,td.[zav_propertyreferencenumber] as property_tenancy_property_reference_number
    --,td.[zav_tenancyasatdate] as property_tenancy_transaction_as_at_date
    --,td.[zav_accounttype] as property_tenancy_transaction_account_type_id
    --,td.[statecode] as property_tenancy_transaction_state_code
    --,td.[statuscode] as property_tenancy_transaction_status_code
    --,td.[zav_rent] as property_tenancy_transaction_rent_nonrent_id
    --,td.[zav_transaction] as property_tenancy_transaction_credit_debit_id
    --,td.[zav_importpayment] as property_tenancy_transaction_import_payment_id  --new_zavantiimport
    --,td.[zav_arrearsarrangement] as property_tenancy_transaction_arrears_arrangement_id --zav_arrearsarrangement
    --,td.[zav_importpayment] as property_tenancy_transaction_import_payment_id  --new_zavantiimport
    --,td.[zav_importwaterchargeid]  --null
    --,td.[zav_importwaterchargeid_entitytype]
    --,td.[zav_rentgenerationbatch] as property_tenancy_transaction_rent_generation_batch_id  --zav_rentgenerationbatch
    --,td.[zav_dummyorder] as property_tenancy_transaction_dummy_order  --null
    --,td.[zav_importwaterchargeidname] as property_tenancy_transaction_ --null
    --,td.[zav_numberofdays] as property_tenancy_transaction_number_of_days  --paid?  left to pay?  overdue????  null anyway
    --,td.[new_lessconcession] as property_tenancy_transaction_less_concession   -- all Null
    --,td.[new_lessconcession_base] as property_tenancy_transaction_less_concession_base   -- all Null
    --,td.[new_specialmeterreadingcost] as property_tenancy_transaction_special_meter_reading_cost   -- all Null
    --,td.[new_specialmeterreadingcost_base] as property_tenancy_transaction_special_meter_reading_cost_base   -- all Null
    --,td.[new_totalbalances] as property_tenancy_transaction_total_balances   -- all Null
    --,td.[new_totalbalances_base] as property_tenancy_transaction_total_balances_base   -- all Null
    --,td.[new_totalcharge] as property_tenancy_transaction_total_charge   -- all Null
    --,td.[new_totalcharge_base] as property_tenancy_transaction_total_charge_base   -- all Null
    --,td.[new_waterusecost1] as property_tenancy_transaction_water_use_cost_1   -- all Null
    --,td.[new_waterusecost1_base] as property_tenancy_transaction_water_use_cost_1_base   -- all Null
    --,td.[new_waterusecost2] as property_tenancy_transaction_water_use_cost_2   -- all Null
    --,td.[new_waterusecost2_base] as property_tenancy_transaction_water_use_cost_2_base   -- all Null
    --,td.[new_waterusecost3] as property_tenancy_transaction_water_use_cost_3   -- all Null
    --,td.[new_waterusecost3_base] as property_tenancy_transaction_water_use_cost_3_base   -- all Null
    --,td.[new_wateruserate1] as property_tenancy_transaction_water_use_rate_1   -- all Null
    --,td.[new_wateruserate1_base] as property_tenancy_transaction_water_use_rate_1_base   -- all Null
    --,td.[new_wateruserate2] as property_tenancy_transaction_water_use_rate_2   -- all Null
    --,td.[new_wateruserate2_base] as property_tenancy_transaction_water_use_rate_2_base   -- all Null
    --,td.[new_wateruserate3] as property_tenancy_transaction_water_use_rate_3   -- all Null
    --,td.[new_wateruserate3_base] as property_tenancy_transaction_water_use_rate_3_base   -- all Null
    --,td.[zav_amountdue] as property_tenancy_transaction_amount_due   -- all Null
    --,td.[zav_amountdue_base] as property_tenancy_transaction_amount_due_base   -- all Null
    --,td.[zav_amountspaidinadvance] as property_tenancy_transaction_amounts_paid_in_advance   -- all Null
    --,td.[zav_amountspaidinadvance_base] as property_tenancy_transaction_amounts_paid_in_advance_base   -- all Null
    --,td.[zav_chargeforthisperiod] as property_tenancy_transaction_charge_for_this_period   -- all Null
    --,td.[zav_chargeforthisperiod_base] as property_tenancy_transaction_charge_for_this_period_base   -- all Null
    --,td.[zav_closingbalance] as property_tenancy_transaction_closing_balance   -- all Null
    --,td.[zav_closingbalance_base] as property_tenancy_transaction_closing_balance_base   -- all Null
    --,td.[zav_openingbalance] as property_tenancy_transaction_opening_balance   -- all Null
    --,td.[zav_openingbalance_base] as property_tenancy_transaction_opening_balance_base   -- all Null
    --,td.[exchangerate] as property_tenancy_transaction_exchange_rate  --all 1.0 so probably useless
    --,td.[new_meterreadingfrom] as property_tenancy_transaction_meter_reading_from  --null
    --,td.[new_meterreadingfromkl] as property_tenancy_transaction_ --null
    --,td.[new_meterreadingto] as property_tenancy_transaction_ --null
    --,td.[new_meterreadingtokl] as property_tenancy_transaction_ --null
    --,td.[new_netmeterreadingkl] as property_tenancy_transaction_ --null
    --,CAST(td.[zav_receiptnumber] as property_tenancy_transaction_receipt_number_other  --seems to be the same as the previous column
    --,td.[new_waterusedesc1] as property_tenancy_transaction_water_use_description_1 -- All Null
    --,td.[new_waterusedesc2] as property_tenancy_transaction_water_use_description_2 -- All Null
    --,td.[new_waterusedesc3] as property_tenancy_transaction_water_use_description_3 -- All Null
    --,td.[new_waterusekl1] as property_tenancy_transaction_water_use_kl_1 -- All Null
    --,td.[new_waterusekl2] as property_tenancy_transaction_water_use_kl_2 -- All Null
    --,td.[new_waterusekl3] as property_tenancy_transaction_water_use_kl_3 -- All Null
    --,td.[transactioncurrencyidname] as property_tenancy_transaction_  --all NZD
    --,td.[zav_accountreferenceno] as property_tenancy_transaction_account_reference_number -- all Null
    --,td.[zav_zavantiimportuniquecode] as property_tenancy_transaction_zavanti_import_unique_code  --unlikely to be useful
    --,td.[zav_fromzavantiimport] as property_tenancy_transaction_from_zavanti_import_flag
    --,td.[owningbusinessunit] as property_tenancy_transaction_owning_business_unit_id << moved to dim_property_tenancy
    --,td.[owningbusinessunitname] as property_tenancy_transaction_owning_business_unit << moved to dim_property_tenancy
    --,td.[owningteam] as property_tenancy_transaction_owning_team_id  -- all Null
    --,td.[owninguser] as property_tenancy_transaction_owning_user_id << moved to dim_property_tenancy
    -- ,td.[transactioncurrencyid] as property_tenancy_transaction_currency_id  --all NZD, so useless column
    --,opp.SinkCreatedOn
    
    
FROM [Zavanti].[vw_zav_tenancytransactiondetails]	AS  td
        LEFT JOIN [Zavanti].[vw_opportunity] AS opp ON td.zav_tenancy = opp.Id
    
 WHERE [zav_tenancytransactiondetailsid] IS NOT NULL
        AND td.[IsDelete] IS NULL