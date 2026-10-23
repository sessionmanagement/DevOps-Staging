CREATE PROCEDURE [edw].[kpi_tenancy_sp_158_rent_payments]
AS
/**********************************************************************************************************
 Procedure: [edw].[kpi_tenancy_sp_158_rent_payments]
 Author: GitHub Copilot
 Created: 2026-05-18
 Purpose: Returns KPI 158 tenancy rows for snapshot generation.
 User Story: 13447
 Feature: 13369

 Notes: Implements the approved KPI 158 cumulative rent payment logic directly so tenancy snapshot
        generation can consume KPI 158 via the standard INSERT...EXEC pattern without relying on a wrapper.

 REVISIONS:
 Version  Date         Author            Description
 -------  ----------   ----------------  --------------------------------------------------------------
 1.0      2026-05-18   Mike Gencic       Initial stored procedure version for KPI 158 snapshot output
 1.1      2026-05-18   Mike Gencic       Inlined approved KPI 158 logic to match production view behaviour
 *************************************************************************************************************/

BEGIN
    SET NOCOUNT ON;

    DECLARE @SnapshotDate DATE = CAST(((GETUTCDATE() AT TIME ZONE 'UTC') AT TIME ZONE 'New Zealand Standard Time') AS DATE);
    DECLARE @KPI_ID INT = 158;

    ;WITH CurrentNZTime AS (
        SELECT CAST(((GETUTCDATE() AT TIME ZONE 'UTC') AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS CurrentDateTime
    ),
    SelectedKPI AS (
        SELECT TOP 1
            dim_kpi.kpi_id,
            dim_kpi.dim_kpi_key,
            dim_kpi.what_is_measured,
            dim_kpi.kpi_g_value,
            dim_kpi.kpi_a_value,
                CASE REPLACE(LTRIM(RTRIM(ISNULL(dim_kpi.kpi_g_sign, ''))), ' ', '')
                    WHEN '=>' THEN '>='
                    WHEN '=<' THEN '<='
                    ELSE REPLACE(LTRIM(RTRIM(ISNULL(dim_kpi.kpi_g_sign, ''))), ' ', '')
                END AS kpi_g_sign,
                CASE REPLACE(LTRIM(RTRIM(ISNULL(dim_kpi.kpi_a_sign, ''))), ' ', '')
                    WHEN '=>' THEN '>='
                    WHEN '=<' THEN '<='
                    ELSE REPLACE(LTRIM(RTRIM(ISNULL(dim_kpi.kpi_a_sign, ''))), ' ', '')
                END AS kpi_a_sign
        FROM edw.dim_kpi
        WHERE dim_kpi.DWHDMLOperation <> 'D'
          AND dim_kpi.DWHIsCurrent = 1
          AND dim_kpi.kpi_id = @KPI_ID
        ORDER BY dim_kpi.dim_kpi_key DESC
    ),
    Service_type_grouping AS (
        SELECT DISTINCT
            dim_kpi.kpi_id,
            dim_kpi.dim_kpi_key,
            dim_service.service_id
        FROM edw.dim_kpi
        LEFT JOIN edw.bridge_kpi_measure_to_service_type_group
            ON dim_kpi.dim_kpi_key = bridge_kpi_measure_to_service_type_group.dim_kpi_key
        LEFT JOIN edw.dim_kpi_service_type_grouping
            ON bridge_kpi_measure_to_service_type_group.service_type_grouping_id = dim_kpi_service_type_grouping.dim_kpi_service_type_grouping_key
            AND dim_kpi_service_type_grouping.DWHIsCurrent = 1
        LEFT JOIN edw.bridge_kpi_service_type_to_grouping
            ON bridge_kpi_measure_to_service_type_group.dim_kpi_service_type_grouping_key = bridge_kpi_service_type_to_grouping.dim_kpi_service_type_grouping_key
        LEFT JOIN edw.dim_kpi_service_type
            ON bridge_kpi_service_type_to_grouping.dim_kpi_service_type_key = dim_kpi_service_type.dim_kpi_service_type_key
        LEFT JOIN edw.dim_service
            ON dim_kpi_service_type.service_type = dim_service.service_type_name
            AND dim_service.DWHIsCurrent = 1
            AND dim_service.DWHDMLOperation <> 'D'
        WHERE dim_kpi.DWHIsCurrent = 1
          AND dim_kpi.kpi_id = (SELECT kpi_id FROM SelectedKPI)
    ),
    ms_count_0 AS (
        SELECT
            (SELECT DISTINCT kpi_id FROM SelectedKPI) AS kpi_id,
            service_id
        FROM Service_type_grouping
    ),
    ms_count AS (
        SELECT
            kpi_id,
            COUNT(service_id) AS service_count
        FROM ms_count_0
        GROUP BY kpi_id
    ),
    Dim_Current_Tenancies AS (
        SELECT
            vw_dim_service.dim_company_key,
            vw_dim_property_tenancy.property_tenancy_id,
            vw_dim_property_tenancy.dim_property_tenancy_key,
            COALESCE(vw_dim_service.dim_service_key, dim_service_2.dim_service_key) AS dim_service_key,
            vw_dim_property.dim_property_key,
            vw_dim_property.property_id,
            vw_dim_property.property_program,
            vw_dim_property.property_sub_program,
            vw_dim_property.property_sub_property_type,
            vw_dim_property_tenancy.property_tenancy_expected_payment_frequency,
            CAST(vw_dim_property_tenancy.property_tenancy_weekly_rent_payable AS DECIMAL(18, 4)) AS property_tenancy_weekly_rent_payable,
            COALESCE(vw_dim_service.service_name, dim_service_2.service_name) AS service_name,
            COALESCE(vw_dim_service.service_id, dim_service_2.service_id) AS service_id
        FROM edw.vw_dim_property_tenancy
        CROSS JOIN CurrentNZTime cnt
        INNER JOIN edw.vw_dim_property
            ON vw_dim_property_tenancy.property_id = vw_dim_property.property_id
            AND vw_dim_property.DWHIsCurrent = 1
            AND vw_dim_property.DWHDMLOperation <> 'D'
        LEFT JOIN edw.vw_dim_service
            ON vw_dim_property.property_contract_bc_service_code = vw_dim_service.service_code
            AND vw_dim_service.DWHIsCurrent = 1
            AND vw_dim_service.DWHDMLOperation <> 'D'
        LEFT JOIN edw.vw_dim_service AS dim_service_2
            ON vw_dim_property.property_bc_service_code = dim_service_2.service_code
            AND dim_service_2.DWHIsCurrent = 1
            AND dim_service_2.DWHDMLOperation <> 'D'
        WHERE vw_dim_property_tenancy.DWHIsCurrent = 1
          AND vw_dim_property_tenancy.DWHDMLOperation <> 'D'
          AND vw_dim_property.dim_property_key > 0
          AND vw_dim_property.property_statecode = 'Active'
          AND vw_dim_property_tenancy.property_tenant_opportunity_status IN ('new', 'active arrears', 'active')
          AND vw_dim_property_tenancy.property_tenancy_vacate_confirmation_flag = 0
          AND vw_dim_property_tenancy.property_tenancy_actual_close_date IS NULL
          AND vw_dim_property_tenancy.property_tenancy_tenancy_start_date IS NOT NULL
          AND DATEDIFF(DAY, vw_dim_property_tenancy.property_tenancy_tenancy_start_date, CAST(cnt.CurrentDateTime AS DATE)) >= 29
          AND vw_dim_property.property_name NOT LIKE '%parent%'
          AND ISNULL(vw_dim_property.property_confirmed_disposal_date, '2099-12-31') > CAST(cnt.CurrentDateTime AS DATE)
          AND ISNULL(vw_dim_property.property_acquired_date, '2099-12-31') <= CAST(cnt.CurrentDateTime AS DATE)
          AND LOWER(ISNULL(vw_dim_property.property_status, '')) <> 'vacant: un-tenantable'
          AND vw_dim_property.property_current_tenancy IS NOT NULL
          AND (
                (ISNULL(vw_dim_property.property_program, '') = 'Affordable Housing Management' AND ISNULL(vw_dim_property.property_sub_program, '') = 'Rotorua Lakes Council')
             OR (ISNULL(vw_dim_property.property_program, '') = 'Affordable Rental' AND ISNULL(vw_dim_property.property_sub_program, '') = 'Affordable Rental')
             OR (ISNULL(vw_dim_property.property_program, '') = 'Boarding' AND ISNULL(vw_dim_property.property_sub_program, '') = 'Residential Services Boarding')
             OR (ISNULL(vw_dim_property.property_program, '') = 'IRRS' AND ISNULL(vw_dim_property.property_sub_program, '') IN (
                    'CCP (Creating Positive Pathways Spot)',
                    'Housing First (SPOT)',
                    'Social Housing (Capacity)',
                    'Social Housing (SPOT)',
                    'Social Housing TM'
                ))
             OR (
                    ISNULL(vw_dim_property.property_program, '') = 'Transitional Housing'
                AND ISNULL(vw_dim_property.property_sub_program, '') = 'Transitional Housing'
                AND ISNULL(vw_dim_property.property_sub_property_type, '') <> 'Office'
                )
          )
          AND ISNULL(vw_dim_property.property_program, '') <> 'Motels'
          AND ISNULL(vw_dim_property.property_sub_program, '') NOT IN ('Motels', 'Motels (CLS)')
    ),
    DimCurrentTenancies2 AS (
        SELECT
            vw_dim_service.dim_company_key,
            Dim_Current_Tenancies.dim_service_key,
            Dim_Current_Tenancies.dim_property_key,
            Dim_Current_Tenancies.property_id,
            Dim_Current_Tenancies.property_tenancy_id,
            Dim_Current_Tenancies.dim_property_tenancy_key,
            Dim_Current_Tenancies.service_id,
            Dim_Current_Tenancies.property_program,
            Dim_Current_Tenancies.property_sub_program,
            Dim_Current_Tenancies.property_tenancy_expected_payment_frequency,
            Dim_Current_Tenancies.property_tenancy_weekly_rent_payable,
            dim_kpi_service_type_grouping.service_type_grouping
        FROM Dim_Current_Tenancies
        LEFT JOIN edw.vw_dim_service
            ON Dim_Current_Tenancies.dim_service_key = vw_dim_service.dim_service_key
            AND vw_dim_service.DWHDMLOperation <> 'D'
            AND vw_dim_service.DWHIsCurrent = 1
        LEFT JOIN edw.dim_kpi_service_type
            ON vw_dim_service.service_type_name = dim_kpi_service_type.service_type
            AND dim_kpi_service_type.DWHIsCurrent = 1
        LEFT JOIN edw.bridge_kpi_service_type_to_grouping
            ON dim_kpi_service_type.dim_kpi_service_type_key = bridge_kpi_service_type_to_grouping.dim_kpi_service_type_key
        LEFT JOIN edw.dim_kpi_service_type_grouping
            ON bridge_kpi_service_type_to_grouping.service_type_grouping_id = dim_kpi_service_type_grouping.service_type_grouping_id
            AND dim_kpi_service_type_grouping.DWHIsCurrent = 1
        WHERE Dim_Current_Tenancies.dim_service_key IS NOT NULL
    ),
    TenancyPaymentRules AS (
        SELECT
            dct2.dim_company_key,
            dct2.dim_service_key,
            dct2.dim_property_tenancy_key,
            dct2.property_tenancy_id,
            dct2.service_id,
            CAST(cnt.CurrentDateTime AS DATE) AS report_as_at_date,
            CASE
                WHEN UPPER(ISNULL(dct2.property_tenancy_expected_payment_frequency, '')) = 'FORTNIGHTLY'
                    THEN 'Fortnightly'
                ELSE 'Weekly'
            END AS payment_frequency,
            CASE
                WHEN UPPER(ISNULL(dct2.property_tenancy_expected_payment_frequency, '')) = 'FORTNIGHTLY'
                    THEN CAST(dct2.property_tenancy_weekly_rent_payable * 2 AS DECIMAL(18, 4))
                ELSE CAST(dct2.property_tenancy_weekly_rent_payable AS DECIMAL(18, 4))
            END AS expected_rent_payable,
            CASE
                WHEN UPPER(ISNULL(dct2.property_tenancy_expected_payment_frequency, '')) = 'FORTNIGHTLY'
                    THEN 21
                ELSE 10
            END AS payment_period_days
        FROM DimCurrentTenancies2 dct2
        CROSS JOIN CurrentNZTime cnt
    ),
    RentPayments AS (
        SELECT
            fact_property_tenancy_transaction.property_tenancy_id,
            TRY_CONVERT(DATE, CONVERT(VARCHAR(8), fact_property_tenancy_transaction.property_tenancy_transaction_date_key)) AS transaction_date,
            CAST(fact_property_tenancy_transaction.property_tenancy_transaction_amount AS DECIMAL(18, 4)) AS transaction_amount,
            fact_property_tenancy_transaction.property_tenancy_transaction_created_datetime,
            fact_property_tenancy_transaction.fact_property_tenancy_transaction_id
        FROM edw.fact_property_tenancy_transaction
        WHERE fact_property_tenancy_transaction.DWHDMLOperation <> 'D'
          AND fact_property_tenancy_transaction.property_tenancy_id IS NOT NULL
          AND fact_property_tenancy_transaction.property_tenancy_transaction_type = 'Rent Payment'
          AND fact_property_tenancy_transaction.property_tenancy_transaction_date_key IS NOT NULL
          AND TRY_CONVERT(DATE, CONVERT(VARCHAR(8), fact_property_tenancy_transaction.property_tenancy_transaction_date_key)) IS NOT NULL
    ),
    LatestRentPayment AS (
        SELECT
            RankedPayments.property_tenancy_id,
            RankedPayments.last_rent_payment_date,
            RankedPayments.last_rent_payment_amount
        FROM (
            SELECT
                RentPayments.property_tenancy_id,
                RentPayments.transaction_date AS last_rent_payment_date,
                RentPayments.transaction_amount AS last_rent_payment_amount,
                ROW_NUMBER() OVER (
                    PARTITION BY RentPayments.property_tenancy_id
                    ORDER BY RentPayments.transaction_date DESC,
                             RentPayments.property_tenancy_transaction_created_datetime DESC,
                             RentPayments.fact_property_tenancy_transaction_id DESC
                ) AS payment_rank
            FROM RentPayments
        ) AS RankedPayments
        WHERE RankedPayments.payment_rank = 1
    ),
    PaymentWindowSummary AS (
        SELECT
            tpr.property_tenancy_id,
            COUNT(RentPayments.fact_property_tenancy_transaction_id) AS payment_count_in_period,
            CAST(ISNULL(SUM(RentPayments.transaction_amount), 0) AS DECIMAL(18, 4)) AS total_payments_in_period
        FROM TenancyPaymentRules tpr
        LEFT JOIN RentPayments
            ON tpr.property_tenancy_id = RentPayments.property_tenancy_id
            AND RentPayments.transaction_date >= DATEADD(DAY, -tpr.payment_period_days, tpr.report_as_at_date)
            AND RentPayments.transaction_date <= tpr.report_as_at_date
        GROUP BY tpr.property_tenancy_id
    ),
    AllTransactions AS (
        SELECT
            fact_property_tenancy_transaction.property_tenancy_id,
            TRY_CONVERT(DATE, CONVERT(VARCHAR(8), fact_property_tenancy_transaction.property_tenancy_transaction_date_key)) AS transaction_date,
            CAST(fact_property_tenancy_transaction.property_tenancy_transaction_balance_rent AS DECIMAL(18, 2)) AS rent_balance,
            fact_property_tenancy_transaction.property_tenancy_transaction_created_datetime,
            fact_property_tenancy_transaction.fact_property_tenancy_transaction_id
        FROM edw.fact_property_tenancy_transaction
        WHERE fact_property_tenancy_transaction.DWHDMLOperation <> 'D'
          AND fact_property_tenancy_transaction.property_tenancy_id IS NOT NULL
          AND fact_property_tenancy_transaction.property_tenancy_transaction_date_key IS NOT NULL
          AND TRY_CONVERT(DATE, CONVERT(VARCHAR(8), fact_property_tenancy_transaction.property_tenancy_transaction_date_key)) IS NOT NULL
    ),
    LatestTransactionBalance AS (
        SELECT
            RankedTransactions.property_tenancy_id,
            RankedTransactions.rent_balance
        FROM (
            SELECT
                AllTransactions.property_tenancy_id,
                AllTransactions.rent_balance,
                ROW_NUMBER() OVER (
                    PARTITION BY AllTransactions.property_tenancy_id
                    ORDER BY AllTransactions.transaction_date DESC,
                             AllTransactions.property_tenancy_transaction_created_datetime DESC,
                             AllTransactions.fact_property_tenancy_transaction_id DESC
                ) AS transaction_rank
            FROM AllTransactions
        ) AS RankedTransactions
        WHERE RankedTransactions.transaction_rank = 1
    ),
    FinalTable AS (
        SELECT
            tpr.dim_company_key,
            tpr.dim_service_key,
            tpr.dim_property_tenancy_key,
            tpr.property_tenancy_id,
            tpr.service_id,
            tpr.report_as_at_date,
            tpr.payment_frequency,
            tpr.expected_rent_payable,
            tpr.payment_period_days,
            LatestRentPayment.last_rent_payment_date,
            LatestRentPayment.last_rent_payment_amount,
            ISNULL(PaymentWindowSummary.payment_count_in_period, 0) AS payment_count_in_period,
            ISNULL(PaymentWindowSummary.total_payments_in_period, CAST(0 AS DECIMAL(18, 4))) AS total_payments_in_period,
            LatestTransactionBalance.rent_balance,
            CASE
                WHEN LatestRentPayment.last_rent_payment_date IS NULL THEN NULL
                ELSE DATEDIFF(DAY, LatestRentPayment.last_rent_payment_date, tpr.report_as_at_date)
            END AS days_since_last_payment,
            CASE
                WHEN tpr.expected_rent_payable IS NULL OR tpr.expected_rent_payable <= 0 THEN NULL
                ELSE CAST(ISNULL(PaymentWindowSummary.total_payments_in_period, 0) / NULLIF(tpr.expected_rent_payable, 0) AS DECIMAL(18, 4))
            END AS payment_ratio,
            CASE
                WHEN ISNULL(PaymentWindowSummary.payment_count_in_period, 0) > 0 THEN 1
                ELSE 0
            END AS has_payment_in_period_flag,
            CASE
                WHEN ISNULL(PaymentWindowSummary.payment_count_in_period, 0) = 0 THEN CAST(0 AS DECIMAL(18, 4))
                WHEN tpr.expected_rent_payable IS NULL OR tpr.expected_rent_payable <= 0 THEN CAST(0 AS DECIMAL(18, 4))
                ELSE CAST(ISNULL(PaymentWindowSummary.total_payments_in_period, 0) / NULLIF(tpr.expected_rent_payable, 0) AS DECIMAL(18, 4))
            END AS kpi_value
        FROM TenancyPaymentRules tpr
        LEFT JOIN LatestRentPayment
            ON tpr.property_tenancy_id = LatestRentPayment.property_tenancy_id
        LEFT JOIN PaymentWindowSummary
            ON tpr.property_tenancy_id = PaymentWindowSummary.property_tenancy_id
        LEFT JOIN LatestTransactionBalance
            ON tpr.property_tenancy_id = LatestTransactionBalance.property_tenancy_id
    ),
    ScoredTenancies AS (
        SELECT
            SelectedKPI.kpi_id,
            SelectedKPI.dim_kpi_key,
            FinalTable.dim_company_key,
            FinalTable.dim_service_key,
            FinalTable.dim_property_tenancy_key,
            FinalTable.property_tenancy_id,
            CONCAT('888', '_', FinalTable.property_tenancy_id, '_', FinalTable.service_id, '_', FinalTable.dim_company_key) AS entity_key,
            FinalTable.service_id,
            FinalTable.kpi_value,
            status_evaluation.kpi_status,
            CASE
                WHEN status_evaluation.kpi_status = 3 THEN CONCAT(
                    'Last payment made ',
                    FinalTable.days_since_last_payment,
                    ' day',
                    CASE WHEN FinalTable.days_since_last_payment = 1 THEN '' ELSE 's' END,
                    ' ago on ',
                    CONVERT(VARCHAR(8), FinalTable.last_rent_payment_date, 3),
                    '. Rent balance is $',
                    CONVERT(VARCHAR(32), CAST(ROUND(ISNULL(FinalTable.rent_balance, 0), 2) AS MONEY), 1),
                    '.'
                )
                WHEN status_evaluation.kpi_status = 2 THEN CONCAT(
                    'Last payment made ',
                    FinalTable.days_since_last_payment,
                    ' day',
                    CASE WHEN FinalTable.days_since_last_payment = 1 THEN '' ELSE 's' END,
                    ' ago on ',
                    CONVERT(VARCHAR(8), FinalTable.last_rent_payment_date, 3),
                    '. Over the last ',
                    FinalTable.payment_period_days,
                    ' days, ',
                    FinalTable.payment_count_in_period,
                    ' payment',
                    CASE WHEN FinalTable.payment_count_in_period = 1 THEN ' was' ELSE 's were' END,
                    ' made with a total value of $',
                    CONVERT(VARCHAR(32), CAST(ROUND(ISNULL(FinalTable.total_payments_in_period, 0), 2) AS MONEY), 1),
                    ' (',
                    CONVERT(VARCHAR(12), CAST(ROUND(ISNULL(FinalTable.payment_ratio, 0) * 100.0, 1) AS DECIMAL(10, 1))),
                    '% of expected rent). Rent balance is $',
                    CONVERT(VARCHAR(32), CAST(ROUND(ISNULL(FinalTable.rent_balance, 0), 2) AS MONEY), 1),
                    '.'
                )
                WHEN FinalTable.has_payment_in_period_flag = 1 THEN CONCAT(
                    'Payment support may be needed. Last payment made ',
                    FinalTable.days_since_last_payment,
                    ' day',
                    CASE WHEN FinalTable.days_since_last_payment = 1 THEN '' ELSE 's' END,
                    ' ago on ',
                    CONVERT(VARCHAR(8), FinalTable.last_rent_payment_date, 3),
                    '. Over the last ',
                    FinalTable.payment_period_days,
                    ' days, ',
                    FinalTable.payment_count_in_period,
                    ' payment',
                    CASE WHEN FinalTable.payment_count_in_period = 1 THEN ' was' ELSE 's were' END,
                    ' made with a total value of $',
                    CONVERT(VARCHAR(32), CAST(ROUND(ISNULL(FinalTable.total_payments_in_period, 0), 2) AS MONEY), 1),
                    ' (',
                    CONVERT(VARCHAR(12), CAST(ROUND(ISNULL(FinalTable.payment_ratio, 0) * 100.0, 1) AS DECIMAL(10, 1))),
                    '% of expected rent). Rent balance is $',
                    CONVERT(VARCHAR(32), CAST(ROUND(ISNULL(FinalTable.rent_balance, 0), 2) AS MONEY), 1),
                    '.'
                )
                ELSE CONCAT(
                    'Payment support may be needed. No payments have been made over the last ',
                    FinalTable.payment_period_days,
                    ' days. Rent balance is $',
                    CONVERT(VARCHAR(32), CAST(ROUND(ISNULL(FinalTable.rent_balance, 0), 2) AS MONEY), 1),
                    '.'
                )
            END AS user_friendly_score_explanation
        FROM FinalTable
        CROSS JOIN SelectedKPI
        CROSS APPLY (
            SELECT
                CASE
                    WHEN FinalTable.has_payment_in_period_flag = 1 AND (
                            (SelectedKPI.kpi_g_sign = '>=' AND FinalTable.kpi_value >= SelectedKPI.kpi_g_value) OR
                            (SelectedKPI.kpi_g_sign = '>'  AND FinalTable.kpi_value >  SelectedKPI.kpi_g_value) OR
                            (SelectedKPI.kpi_g_sign = '<=' AND FinalTable.kpi_value <= SelectedKPI.kpi_g_value) OR
                            (SelectedKPI.kpi_g_sign = '<'  AND FinalTable.kpi_value <  SelectedKPI.kpi_g_value) OR
                            (SelectedKPI.kpi_g_sign = '='  AND FinalTable.kpi_value =  SelectedKPI.kpi_g_value)
                        ) THEN 3
                    WHEN FinalTable.has_payment_in_period_flag = 1 AND (
                            (SelectedKPI.kpi_a_sign = '>=' AND FinalTable.kpi_value >= SelectedKPI.kpi_a_value) OR
                            (SelectedKPI.kpi_a_sign = '>'  AND FinalTable.kpi_value >  SelectedKPI.kpi_a_value) OR
                            (SelectedKPI.kpi_a_sign = '<=' AND FinalTable.kpi_value <= SelectedKPI.kpi_a_value) OR
                            (SelectedKPI.kpi_a_sign = '<'  AND FinalTable.kpi_value <  SelectedKPI.kpi_a_value) OR
                            (SelectedKPI.kpi_a_sign = '='  AND FinalTable.kpi_value =  SelectedKPI.kpi_a_value)
                        ) THEN 2
                    ELSE 1
                END AS kpi_status
        ) AS status_evaluation
    )
    SELECT
        ScoredTenancies.dim_kpi_key,
        ScoredTenancies.dim_company_key,
        ScoredTenancies.dim_property_tenancy_key,
        ScoredTenancies.dim_service_key,
        ScoredTenancies.entity_key,
        @KPI_ID AS kpi_id,
        ScoredTenancies.property_tenancy_id,
        ScoredTenancies.service_id,
        ScoredTenancies.kpi_value,
        ScoredTenancies.user_friendly_score_explanation,
        ScoredTenancies.kpi_status,
        @SnapshotDate AS snapshot_date
    FROM ScoredTenancies
    LEFT JOIN Service_type_grouping stg
        ON ScoredTenancies.dim_kpi_key = stg.dim_kpi_key
        AND ScoredTenancies.service_id = stg.service_id
    LEFT JOIN ms_count mc
        ON mc.kpi_id = ScoredTenancies.kpi_id
    WHERE (mc.service_count IS NULL OR mc.service_count = 0)
       OR (stg.service_id IS NOT NULL);
END