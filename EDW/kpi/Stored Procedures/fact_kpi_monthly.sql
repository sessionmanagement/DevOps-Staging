CREATE   PROCEDURE [kpi].[fact_kpi_monthly]
AS
/***************************************************************************
NAME:     [kpi].[fact_kpi_monthly]
PURPOSE:  Archive current KPI data from kpi.fact_kpi_current into kpi.fact_kpi_history
          This procedure runs on the 1st business day of each month to create
          historical snapshots for trend analysis and reporting.

NOTES:    - Only executes on business days (Monday-Friday)
          - Creates a new batch ID for each archive run
          - Inserts all current KPI data with archive timestamp
          - Related to User Story #10962, Updated for User Story #10994

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-07-31    Greg Nuthall		Initial version for monthly KPI archival
1.1		 2025-08-06    Greg Nuthall		Added tenancy columns: dim_property_tenancy_key, property_tenancy_id
1.2      2025-12-10    Greg Nuthall     Changed to NZT to check it loads  
1.3      2026-05-04    Greg Nuthall     Change the snapshot date from the end of the month to the start of the month
1.4      2026-07-27    Greg Nuthall     Fixed snapshot_date calculation - it now always resolves to the 1st of
                                        the month nearest the archive run date, whether the process runs on the
                                        last working day of the month or slips into the 1st/2nd of the next
                                        month. The duplicate-run check now keys off snapshot_date instead of
                                        archive_date's month, so a late run is correctly recognised as a repeat
                                        of the same snapshot instead of being archived again.
****************************************************************************/
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @BatchId INT;
    DECLARE @CurrentDate DATE = dateadd(mi, DATEPART(tz, (CAST('2021-01-01' AS DATETIMEOFFSET) AT TIME ZONE 'New Zealand Standard Time')), getdate());
    DECLARE @RecordsInserted INT = 0;

    -- The snapshot_date must always be the 1st of the month "nearest" the archive run date, e.g.:
    --   Run on 30/06 (last working day of June)        -> nearest month start is 01/07 -> snapshot_date = 01/07
    --   Run on 01/07 or 02/07 (process slipped a day/2) -> nearest month start is 01/07 -> snapshot_date = 01/07
    DECLARE @StartOfCurrentMonth DATE = DATEFROMPARTS(YEAR(@CurrentDate), MONTH(@CurrentDate), 1);
    DECLARE @StartOfNextMonth DATE = DATEADD(MONTH, 1, @StartOfCurrentMonth);
    DECLARE @SnapshotDate DATE =
        CASE
            WHEN DATEDIFF(DAY, @StartOfCurrentMonth, @CurrentDate) < DATEDIFF(DAY, @CurrentDate, @StartOfNextMonth)
                THEN @StartOfCurrentMonth
            ELSE @StartOfNextMonth
        END;
    
    BEGIN TRY
        -- Check if we've already archived data for this snapshot date. Keying off snapshot_date
        -- (rather than archive_date's calendar month) means a run that slips across the month
        -- boundary - e.g. 30/06 vs 01/07 vs 02/07 - is still correctly treated as a duplicate.
        IF EXISTS (
            SELECT 1 
            FROM [kpi].[fact_kpi_history] 
            WHERE [snapshot_date] = @SnapshotDate
        )
        BEGIN
            PRINT 'Archive process skipped - data already archived for snapshot date ' + CONVERT(VARCHAR(10), @SnapshotDate, 105) + '.';
            RETURN;
        END
        
        -- Generate new batch ID
        SELECT @BatchId = ISNULL(MAX(archive_batch_id), 0) + 1 
        FROM [kpi].[fact_kpi_history];
        
        PRINT 'Starting KPI monthly archive process...';
        PRINT 'Batch ID: ' + CAST(@BatchId AS VARCHAR(10));
        PRINT 'Archive Date: ' + CAST(@CurrentDate AS VARCHAR(10));
        PRINT 'Snapshot Date: ' + CAST(@SnapshotDate AS VARCHAR(10));
        
        -- Insert current KPI data into history table
        -- UPDATED: Added dim_property_tenancy_key and property_tenancy_id columns
        INSERT INTO [kpi].[fact_kpi_history] (
            [fact_kpi_id],
            [dim_kpi_key],
            [dim_company_key],
            [dim_employee_key],
            [dim_client_key],
            [dim_client_referral_key],
            [dim_property_key],
            [dim_property_tenancy_key],        -- NEW COLUMN
            [dim_service_key],
            [kpi_id],
            [service_id],
            [employee_id],
            [client_id],
            [client_referral_id],
            [property_id],
            [property_tenancy_id],             -- NEW COLUMN
            [entity_key],
            [kpi_value],
            [user_friendly_score_explanation],
            [kpi_status],
            [snapshot_date],
            [archive_date],
            [archive_batch_id]
        )
        SELECT 
            [fact_kpi_id],
            [dim_kpi_key],
            [dim_company_key],
            [dim_employee_key],
            [dim_client_key],
            [dim_client_referral_key],
            [dim_property_key],
            [dim_property_tenancy_key],        -- NEW COLUMN
            [dim_service_key],
            [kpi_id],
            [service_id],
            [employee_id],
            [client_id],
            [client_referral_id],
            [property_id],
            [property_tenancy_id],             -- NEW COLUMN
            [entity_key],
            [kpi_value],
            [user_friendly_score_explanation],
            [kpi_status],
            @SnapshotDate AS [snapshot_date],
            @CurrentDate AS [archive_date],
            @BatchId AS [archive_batch_id]
        FROM [kpi].[fact_kpi_current];
        
        SET @RecordsInserted = @@ROWCOUNT;
        
        PRINT 'KPI monthly archive completed successfully.';
        PRINT 'Records inserted: ' + CAST(@RecordsInserted AS VARCHAR(10));
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        PRINT 'Error in KPI monthly archive process:';
        PRINT 'Error Message: ' + @ErrorMessage;
        
        -- Re-raise the error
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
    
END