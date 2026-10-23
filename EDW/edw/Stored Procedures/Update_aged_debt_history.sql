CREATE PROCEDURE [edw].[Update_aged_debt_history] 
  
as

/***************************************************************************
NAME:     [edw].[Update_aged_debt_history]
PURPOSE:  Generate aged debt history from property tenancy transactions

NOTES:    This stored procedure migrates the complex aged debt calculation 
          logic from Power BI to the EDW database level for better performance.
          Part of User Story 11045 - Migrate Fact Aged Debt Logic to EDW.

REVISIONS:
Version	 Date		   Author			Description
-------	------------  ---------------	--------------------------
1.0		2025-09-16    Mike Gencic		Initial version
1.1		2025-10-16    System Generated	Migrated from dev database
1.2     2026-03-26    Greg Nuthall      Changed to only regenerate all data, it has to generate the complete 
                                        set to work out what has changed and might as well insert it all, rather
                                        than work out the incrementals
1.3     2026-04-14    Malhar Badheka    Optimised version created
****************************************************************************/

BEGIN

    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- Parameters
    ------------------------------------------------------------
    DECLARE @Today DATE = CAST(((GETUTCDATE() AT TIME ZONE 'UTC') AT TIME ZONE 'New Zealand Standard Time') AS DATE);

    DECLARE @BatchID AS INT = (SELECT MAX(DWHBatchId) FROM edw.fact_aged_debt);
        SELECT @BatchID = ISNULL(@BatchID,1);
    DECLARE @HistoricalMonths INT = 3;

    ------------------------------------------------------------
    -- Cleanup temp tables
    ------------------------------------------------------------
    IF OBJECT_ID('tempdb..#AllTransactions')      IS NOT NULL DROP TABLE #AllTransactions;
    IF OBJECT_ID('tempdb..#Months')               IS NOT NULL DROP TABLE #Months;
    IF OBJECT_ID('tempdb..#Months_Union')         IS NOT NULL DROP TABLE #Months_Union;
    IF OBJECT_ID('tempdb..#Cumulative')           IS NOT NULL DROP TABLE #Cumulative;
    IF OBJECT_ID('tempdb..#MonthSnapshots')       IS NOT NULL DROP TABLE #MonthSnapshots;
    IF OBJECT_ID('tempdb..#Unpaid')               IS NOT NULL DROP TABLE #Unpaid;
    IF OBJECT_ID('tempdb..#LeftoverCredit')       IS NOT NULL DROP TABLE #LeftoverCredit;
    IF OBJECT_ID('tempdb..#LastCreditLine')       IS NOT NULL DROP TABLE #LastCreditLine;
    IF OBJECT_ID('tempdb..#Surplus')              IS NOT NULL DROP TABLE #Surplus;
    IF OBJECT_ID('tempdb..#CombinedUnpaid')       IS NOT NULL DROP TABLE #CombinedUnpaid;
    IF OBJECT_ID('tempdb..#Aged')                 IS NOT NULL DROP TABLE #Aged;
    IF OBJECT_ID('tempdb..#FinalAged')            IS NOT NULL DROP TABLE #FinalAged;
    IF OBJECT_ID('tempdb..#LastPaymentPerTenancy')IS NOT NULL DROP TABLE #LastPaymentPerTenancy;

    ------------------------------------------------------------
    -- Extract ALL transactions
    ------------------------------------------------------------
    SELECT
        fptt.property_tenancy_id,
        ptt.property_tenancy_customer_name,
        fptt.dim_property_tenancy_key,
        fptt.dim_property_key,
        fptt.dim_property_program_key,
        CONVERT(DATE, CONVERT(VARCHAR(8), fptt.property_tenancy_transaction_date_key), 112) AS TransactionDate,
        fptt.property_tenancy_transaction_amount AS Amount,
        fptt.property_tenancy_transaction_credit_debit AS CreditDebit,
        fptt.property_tenancy_transaction_type AS TransactionType,
        fptt.property_tenancy_transaction_rent_nonrent AS RentNonRent,
        fptt.property_tenancy_transaction_receipt_number AS ReceiptNumber,
        fptt.property_tenancy_transaction_comments,
        ROW_NUMBER() OVER (
            PARTITION BY fptt.property_tenancy_id
            ORDER BY
                fptt.property_tenancy_transaction_date_key,
                CASE WHEN fptt.property_tenancy_transaction_credit_debit = 'Debit' THEN 1 ELSE 2 END,
                fptt.property_tenancy_transaction_receipt_number
        ) AS TransactionSequence
    INTO #AllTransactions
    FROM edw.fact_property_tenancy_transaction fptt
    JOIN edw.dim_property_tenancy ptt
        ON fptt.dim_property_tenancy_key = ptt.dim_property_tenancy_key
    WHERE fptt.DWHDMLOperation <> 'D'
      AND fptt.property_tenancy_transaction_suspense_account_flag = 0
      AND fptt.property_tenancy_id IS NOT NULL;

    -- Covering index: includes all columns read downstream to avoid key lookups
    CREATE NONCLUSTERED INDEX IX_AllTransactions_Tenancy_RentDateSeq
    ON #AllTransactions (property_tenancy_id, RentNonRent, TransactionDate, TransactionSequence)
    INCLUDE (Amount, CreditDebit, property_tenancy_customer_name,
             dim_property_tenancy_key, dim_property_key, dim_property_program_key,
             property_tenancy_transaction_comments);

    ------------------------------------------------------------
    -- Earliest date
    ------------------------------------------------------------
    DECLARE @EarliestDate DATE = (SELECT MIN(TransactionDate) FROM #AllTransactions);

    ------------------------------------------------------------
    -- Generate month-end dates
    ------------------------------------------------------------
    ;WITH MonthGenerator AS (
        SELECT EOMONTH(@EarliestDate) AS MonthEnd
        UNION ALL
        SELECT EOMONTH(DATEADD(MONTH, 1, MonthEnd))
        FROM MonthGenerator
        WHERE MonthEnd < EOMONTH(@Today, -1)
    )
    SELECT MonthEnd
    INTO #Months
    FROM MonthGenerator
    OPTION (MAXRECURSION 0);

    SELECT MonthEnd INTO #Months_Union FROM #Months;
    INSERT INTO #Months_Union SELECT @Today;
    CREATE NONCLUSTERED INDEX IX_Months_Union ON #Months_Union (MonthEnd);

    ------------------------------------------------------------
    -- Compute cumulative sums per (tenancy, Rent/NonRent)
    -- ROWS UNBOUNDED PRECEDING avoids spool disk operators vs default RANGE
    -- LAG pre-computed here — value is identical for a given transaction
    -- regardless of which month snapshot later references it
    ------------------------------------------------------------
    ;WITH CumulativeBase AS (
        SELECT
            atx.property_tenancy_id,
            atx.property_tenancy_customer_name,
            atx.dim_property_tenancy_key,
            atx.dim_property_key,
            atx.dim_property_program_key,
            atx.TransactionDate,
            atx.TransactionSequence,
            atx.property_tenancy_transaction_comments,
            atx.Amount,
            atx.RentNonRent,
            SUM(CASE WHEN atx.Amount < 0 THEN -atx.Amount ELSE 0 END)
                OVER (PARTITION BY atx.property_tenancy_id, atx.RentNonRent
                      ORDER BY atx.TransactionDate, atx.TransactionSequence
                      ROWS UNBOUNDED PRECEDING) AS cum_debit_abs,
            SUM(CASE WHEN atx.Amount > 0 THEN atx.Amount ELSE 0 END)
                OVER (PARTITION BY atx.property_tenancy_id, atx.RentNonRent
                      ORDER BY atx.TransactionDate, atx.TransactionSequence
                      ROWS UNBOUNDED PRECEDING) AS cum_credit
        FROM #AllTransactions atx
    )
    SELECT
        cb.*,
        LAG(cb.cum_debit_abs) OVER (
            PARTITION BY cb.property_tenancy_id, cb.RentNonRent
            ORDER BY cb.TransactionDate, cb.TransactionSequence
        ) AS prev_cum_debit_abs
    INTO #Cumulative
    FROM CumulativeBase cb;

    CREATE NONCLUSTERED INDEX IX_Cumulative_Tenancy_RentDateSeq
    ON #Cumulative (property_tenancy_id, RentNonRent, TransactionDate, TransactionSequence)
    INCLUDE (Amount, cum_debit_abs, cum_credit, prev_cum_debit_abs,
             property_tenancy_customer_name, dim_property_tenancy_key,
             dim_property_key, dim_property_program_key,
             property_tenancy_transaction_comments);

    ------------------------------------------------------------
    -- Pre-compute month-end snapshots per (tenancy, chargeType)
    --
    -- KEY OPTIMISATION: replaces the original CROSS JOIN + three window functions
    -- over the full N-transactions × M-months intermediate set.
    -- Result is one aggregated row per (tenancy, chargeType, month) instead of
    -- one row per (transaction × month).
    -- cum_credit and cum_debit_abs are monotonically non-decreasing, so MAX = last value.
    ------------------------------------------------------------
    SELECT
        c.property_tenancy_id,
        c.RentNonRent,
        mu.MonthEnd AS AsAtDate,
        MAX(c.cum_credit)     AS final_cum_credit,
        MAX(c.cum_debit_abs)  AS final_cum_debit_abs
    INTO #MonthSnapshots
    FROM #Cumulative c
    JOIN #Months_Union mu ON c.TransactionDate <= mu.MonthEnd
    GROUP BY c.property_tenancy_id, c.RentNonRent, mu.MonthEnd;

    CREATE NONCLUSTERED INDEX IX_MonthSnapshots
    ON #MonthSnapshots (property_tenancy_id, RentNonRent, AsAtDate)
    INCLUDE (final_cum_credit, final_cum_debit_abs);

    ------------------------------------------------------------
    -- Compute Unpaid amounts
    -- Only debit lines (Amount < 0) can ever be unpaid; credits always
    -- produce UnpaidAmount = 0 so they are excluded to halve the row count.
    -- Join individual charge transactions to their pre-aggregated month snapshot.
    ------------------------------------------------------------
    SELECT
        c.property_tenancy_id,
        c.dim_property_tenancy_key,
        c.dim_property_key,
        c.dim_property_program_key,
        c.property_tenancy_customer_name AS TenantName,
        c.RentNonRent AS ChargeType,
        ms.AsAtDate,
        c.TransactionDate,
        c.TransactionSequence,
        c.Amount,
        CASE
            WHEN ms.final_cum_credit >= c.cum_debit_abs THEN 0
            WHEN ms.final_cum_credit <= ISNULL(c.prev_cum_debit_abs, 0) THEN c.Amount
            ELSE -(c.cum_debit_abs - ms.final_cum_credit)
        END AS UnpaidAmount
    INTO #Unpaid
    FROM #Cumulative c
    JOIN #MonthSnapshots ms
        ON  ms.property_tenancy_id = c.property_tenancy_id
        AND ms.RentNonRent          = c.RentNonRent
        AND c.TransactionDate      <= ms.AsAtDate
    WHERE c.Amount < 0;  -- only charge lines carry an unpaid balance

    CREATE NONCLUSTERED INDEX IX_Unpaid_Tenancy_AsAt
    ON #Unpaid (property_tenancy_id, ChargeType, AsAtDate);

    ------------------------------------------------------------
    -- Detect Surplus Credit per (tenancy, chargeType, snapshot)
    -- Derived directly from the pre-aggregated #MonthSnapshots —
    -- no scan of #Unpaid, no DISTINCT, no window functions needed.
    ------------------------------------------------------------
    SELECT
        ms.property_tenancy_id,
        ms.RentNonRent AS ChargeType,
        ms.AsAtDate,
        ms.final_cum_credit,
        ms.final_cum_debit_abs,
        ms.final_cum_credit - ms.final_cum_debit_abs AS leftover_credit
    INTO #LeftoverCredit
    FROM #MonthSnapshots ms
    WHERE ms.final_cum_credit > ms.final_cum_debit_abs;

    CREATE NONCLUSTERED INDEX IX_LeftoverCredit
    ON #LeftoverCredit (property_tenancy_id, ChargeType, AsAtDate);

    ------------------------------------------------------------
    -- Find last credit line per (tenancy, chargeType, snapshot date)
    ------------------------------------------------------------
    SELECT
        lc.property_tenancy_id,
        lc.ChargeType,
        lc.AsAtDate,
        cc.TransactionDate,
        cc.TransactionSequence
    INTO #LastCreditLine
    FROM #LeftoverCredit lc
    CROSS APPLY (
        SELECT TOP (1) c.TransactionDate, c.TransactionSequence
        FROM #Cumulative c
        WHERE c.property_tenancy_id = lc.property_tenancy_id
          AND c.RentNonRent         = lc.ChargeType
          AND c.Amount              > 0
          AND c.TransactionDate    <= lc.AsAtDate
        ORDER BY c.TransactionDate DESC, c.TransactionSequence DESC
    ) cc;

    CREATE NONCLUSTERED INDEX IX_LastCreditLine
    ON #LastCreditLine (property_tenancy_id, ChargeType, AsAtDate);

    ------------------------------------------------------------
    -- Create Surplus lines for leftover credit
    ------------------------------------------------------------
    SELECT
        ccx.dim_property_tenancy_key,
        ccx.dim_property_key,
        ccx.dim_property_program_key,
        lcl.property_tenancy_id,
        ccx.property_tenancy_customer_name AS TenantName,
        lcl.ChargeType,
        lcl.AsAtDate,
        lcl.TransactionDate,
        lcl.TransactionSequence,
        CAST(NULL AS DECIMAL(38,4)) AS Amount,
        lc.leftover_credit AS UnpaidAmount
    INTO #Surplus
    FROM #LeftoverCredit lc
    JOIN #LastCreditLine lcl
        ON  lc.property_tenancy_id = lcl.property_tenancy_id
        AND lc.AsAtDate            = lcl.AsAtDate
        AND lc.ChargeType          = lcl.ChargeType
    JOIN #Cumulative ccx
        ON  ccx.property_tenancy_id    = lcl.property_tenancy_id
        AND ccx.RentNonRent            = lcl.ChargeType
        AND ccx.TransactionDate        = lcl.TransactionDate
        AND ccx.TransactionSequence    = lcl.TransactionSequence;

    CREATE NONCLUSTERED INDEX IX_Surplus_Tenancy_AsAt
    ON #Surplus (property_tenancy_id, ChargeType, AsAtDate);

    ------------------------------------------------------------
    -- Combine Unpaid and Surplus
    ------------------------------------------------------------
    SELECT
        dim_property_tenancy_key, dim_property_key, dim_property_program_key,
        property_tenancy_id, TenantName, ChargeType, AsAtDate,
        TransactionDate, TransactionSequence, Amount, UnpaidAmount
    INTO #CombinedUnpaid
    FROM #Unpaid

    UNION ALL

    SELECT
        dim_property_tenancy_key, dim_property_key, dim_property_program_key,
        property_tenancy_id, TenantName, ChargeType, AsAtDate,
        TransactionDate, TransactionSequence, Amount, UnpaidAmount
    FROM #Surplus;

    CREATE NONCLUSTERED INDEX IX_CombinedUnpaid_Tenancy_AsAt
    ON #CombinedUnpaid (property_tenancy_id, ChargeType, AsAtDate);

    ------------------------------------------------------------
    -- Compute aging buckets
    ------------------------------------------------------------
    SELECT
        dim_property_tenancy_key,
        dim_property_key,
        dim_property_program_key,
        property_tenancy_id,
        TenantName,
        ChargeType,
        AsAtDate,
        SUM(CASE WHEN DATEDIFF(day, TransactionDate, AsAtDate) BETWEEN  0 AND  6 THEN UnpaidAmount ELSE 0 END) AS Current_0_6,
        SUM(CASE WHEN DATEDIFF(day, TransactionDate, AsAtDate) BETWEEN  7 AND 14 THEN UnpaidAmount ELSE 0 END) AS Days_7_14,
        SUM(CASE WHEN DATEDIFF(day, TransactionDate, AsAtDate) BETWEEN 15 AND 21 THEN UnpaidAmount ELSE 0 END) AS Days_15_21,
        SUM(CASE WHEN DATEDIFF(day, TransactionDate, AsAtDate) BETWEEN 22 AND 28 THEN UnpaidAmount ELSE 0 END) AS Days_22_28,
        SUM(CASE WHEN DATEDIFF(day, TransactionDate, AsAtDate) BETWEEN 29 AND 60 THEN UnpaidAmount ELSE 0 END) AS Days_29_60,
        SUM(CASE WHEN DATEDIFF(day, TransactionDate, AsAtDate) BETWEEN 61 AND 90 THEN UnpaidAmount ELSE 0 END) AS Days_61_90,
        SUM(CASE WHEN DATEDIFF(day, TransactionDate, AsAtDate) >= 91              THEN UnpaidAmount ELSE 0 END) AS Days_91_Plus,
        SUM(UnpaidAmount) AS ActualBalance
    INTO #Aged
    FROM #CombinedUnpaid
    GROUP BY
        dim_property_tenancy_key, dim_property_key, dim_property_program_key,
        property_tenancy_id, TenantName, ChargeType, AsAtDate;

    ------------------------------------------------------------
    -- Compute LastPaymentDate per (tenancy, chargeType)
    ------------------------------------------------------------
    SELECT
        st.property_tenancy_id,
        st.RentNonRent,
        MAX(st.TransactionDate) AS LastPaymentDate
    INTO #LastPaymentPerTenancy
    FROM #AllTransactions st
    WHERE st.CreditDebit = 'Credit'
    GROUP BY st.property_tenancy_id, st.RentNonRent;

    CREATE NONCLUSTERED INDEX IX_LastPaymentPerTenancy
    ON #LastPaymentPerTenancy (property_tenancy_id, RentNonRent)
    INCLUDE (LastPaymentDate);

    ------------------------------------------------------------
    -- Build #FinalAged in one pass (eliminates separate INSERT + UPDATE)
    -- LastPaymentDate and NoRecentPayment populated only for today's row
    ------------------------------------------------------------
    SELECT
        a.dim_property_tenancy_key,
        a.dim_property_key,
        a.dim_property_program_key,
        a.property_tenancy_id,
        pt.property_id,
        a.TenantName,
        a.ChargeType,
        a.AsAtDate,
        a.Current_0_6,
        a.Days_7_14,
        a.Days_15_21,
        a.Days_22_28,
        a.Days_29_60,
        a.Days_61_90,
        a.Days_91_Plus,
        a.ActualBalance,
        CASE WHEN a.AsAtDate = @Today THEN l.LastPaymentDate ELSE NULL END AS LastPaymentDate,
        CASE WHEN a.AsAtDate = @Today THEN
            CASE WHEN l.LastPaymentDate IS NULL
                     OR l.LastPaymentDate <= DATEADD(day, -14, a.AsAtDate) THEN 1 ELSE 0
            END
        ELSE NULL END AS NoRecentPayment
    INTO #FinalAged
    FROM #Aged a
    LEFT JOIN #LastPaymentPerTenancy l
        ON  l.property_tenancy_id = a.property_tenancy_id
        AND l.RentNonRent          = a.ChargeType
        AND a.AsAtDate             = @Today   -- join only for today's rows; NULLs for history
    left join edw.dim_property_tenancy pt on a.dim_property_tenancy_key = pt.dim_property_tenancy_key

    ------------------------------------------------------------
    -- Final Output
    -- HasNoOverallDebt computed as a window function — eliminates
    -- #OverallBalances, ALTER TABLE, and the second UPDATE pass
    ------------------------------------------------------------
    SELECT
        *,
        CASE
            WHEN SUM(ActualBalance) OVER (
                PARTITION BY dim_property_tenancy_key, dim_property_key, dim_property_program_key,
                             property_tenancy_id, TenantName, AsAtDate
            ) = 0 THEN 'TRUE'
            ELSE 'FALSE'
        END AS HasNoOverallDebt
    FROM #FinalAged;


    TRUNCATE TABLE edw.fact_aged_debt;

    INSERT INTO edw.fact_aged_debt (
            dim_property_tenancy_key,
            dim_property_key,
            dim_property_program_key,
            property_tenancy_id,
            Property_id,
            TenantName,
            ChargeType,
            AsAtDate,
            Current_0_6,
            Days_7_14,
            Days_15_21,
            Days_22_28,
            Days_29_60,
            Days_61_90,
            Days_91_Plus,
            ActualBalance,
            LastPaymentDate,
            NoRecentPayment,
            HasNoOverallDebt,
            [DWHBatchId],
            [DWHCreatedAt],
            [DWHModifiedOn],
            [DWHDMLOperation],
            [DWHSourceSystem]
        )
        SELECT 
            f.dim_property_tenancy_key,
            f.dim_property_key,
            f.dim_property_program_key,
            f.property_tenancy_id,
            f.property_id,
            f.TenantName,
            f.ChargeType,
            f.AsAtDate,
            f.Current_0_6,
            f.Days_7_14,
            f.Days_15_21,
            f.Days_22_28,
            f.Days_29_60,
            f.Days_61_90,
            f.Days_91_Plus,
            f.ActualBalance,
            f.LastPaymentDate,
            f.NoRecentPayment,
            CASE
                WHEN SUM(f.ActualBalance) OVER (
                    PARTITION BY f.dim_property_tenancy_key, f.dim_property_key, f.dim_property_program_key,
                                 f.property_tenancy_id, f.TenantName, f.AsAtDate
                ) = 0 THEN 'TRUE'
                ELSE 'FALSE'
            END AS HasNoOverallDebt,
            @BatchID AS DWHBatchId,
            GETDATE() AS DWHCreatedAt,
            GETDATE() AS DWHModifiedOn,
            'I' AS DWHDMLOperation,
            'edw.fact_property_tenancy_transaction' AS DWHSourceSystem
        FROM #FinalAged f
        LEFT OUTER JOIN edw.fact_aged_debt ad 
            ON f.property_tenancy_id = ad.property_tenancy_id
           AND f.property_id = ad.property_id
           AND f.AsAtDate = ad.AsAtDate
           AND f.ChargeType = ad.ChargeType
           AND f.TenantName = ad.TenantName
        WHERE ISNULL(ad.fact_aged_debt_key,-1) = -1
        ORDER BY AsAtDate, TenantName, ChargeType;

end