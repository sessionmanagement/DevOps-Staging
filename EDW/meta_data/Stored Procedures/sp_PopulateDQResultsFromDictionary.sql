-- Created by Copilot in SSMS - review carefully before executing
--------------------------------------------------------------------------------
-- v1.0.1 - 2025-04-29 - Mike Gencic
-- Change Notes: Added short, technical comments referencing EDW usage.
--------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- 2) CREATE THE PROCEDURE
--    Purpose: Execute dictionary-based data-quality checks, storing results 
--    in [DQ].[DQResults].
------------------------------------------------------------------------------
CREATE   PROCEDURE [meta_data].[sp_PopulateDQResultsFromDictionary]
(
    @OnlyInsertWhenRecordCountPositive BIT = 0,
    @RunDateTimeNZ DATETIME2 = NULL,
    @CheckID       INT,
    @TableName     NVARCHAR(200),
    @ColumnName    NVARCHAR(200),
    @CheckName     NVARCHAR(200),
    @CheckSQL      NVARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON;

    ----------------------------------------------------------------------------
    -- v1.0.1: If no @RunDateTimeNZ, set using DST-safe approach.
    ----------------------------------------------------------------------------
    IF @RunDateTimeNZ IS NULL
    BEGIN
        SET @RunDateTimeNZ = CAST(((GETUTCDATE() AT TIME ZONE 'UTC') AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2);
    END;

    -- Created by Copilot in SSMS - review carefully before executing
    IF OBJECT_ID('tempdb..#Results') IS NOT NULL
    DROP TABLE #Results;

    CREATE TABLE #Results 
    (
        [ID] [int] IDENTITY(1,1) NOT NULL,
        [CheckID] [int] NULL,
        [TableName] [nvarchar](200) NOT NULL,
        [ColumnName] [nvarchar](200) NULL,
        [CheckName] [nvarchar](200) NOT NULL,
        [StatusMessage] [nvarchar](4000) NOT NULL,
        [RecordCount] [int] NOT NULL,
        [RunDateTime] [datetime2] NOT NULL
    );

    BEGIN TRY
        DECLARE @tempTable TABLE
        (
            CheckType       NVARCHAR(200),
            IssueCount      INT NULL,
            DuplicateCount  INT NULL,
            NegativeCount   INT NULL
        );

        INSERT INTO @tempTable
        (
            CheckType,
            IssueCount,
            DuplicateCount,
            NegativeCount
        )
        EXEC sp_executesql @CheckSQL;

        ----------------------------------------------------------------------------
        -- v1.0.1: We expect 1 row with 'CheckName' plus a numeric IssueCount.
        ----------------------------------------------------------------------------
        DECLARE @RecordCount INT = 0;
        DECLARE @CheckType   NVARCHAR(200) = '';

        SELECT TOP 1
            @CheckType = ISNULL(CheckType, 'Unknown'),
            @RecordCount = CASE
                                WHEN IssueCount     IS NOT NULL THEN IssueCount
                                WHEN DuplicateCount IS NOT NULL THEN DuplicateCount
                                WHEN NegativeCount  IS NOT NULL THEN NegativeCount
                                ELSE 0
                            END
        FROM @tempTable
        WHERE CheckType = @CheckName;

        ----------------------------------------------------------------------------
        -- v1.0.1: Insert into DQResults, skip if RecordCount=0 & user only wants >0.
        ----------------------------------------------------------------------------
        IF NOT(@OnlyInsertWhenRecordCountPositive = 1 AND @RecordCount = 0)
        BEGIN
            INSERT INTO #Results
            (
                CheckID,
                TableName,
                ColumnName,
                CheckName,
                StatusMessage,
                RecordCount,
                RunDateTime
            )
            VALUES
            (
                @CheckID,
                @TableName,
                @ColumnName,
                @CheckName,
                CONCAT('Completed: ', @CheckType, ' => FoundCount=', @RecordCount),
                @RecordCount,
                @RunDateTimeNZ
            );
        END;
    END TRY
    BEGIN CATCH
        ----------------------------------------------------------------------------
        -- If there's an error, log it in [DQ].[DQResults].
        ----------------------------------------------------------------------------
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();

        INSERT INTO #Results
        (
            CheckID,
            TableName,
            ColumnName,
            CheckName,
            StatusMessage,
            RecordCount,
            RunDateTime
        )
        VALUES
        (
            @CheckID,
            @TableName,
            @ColumnName,
            @CheckName,
            CONCAT('ERROR: ', @ErrMsg),
            0,
            @RunDateTimeNZ
        );
    END CATCH;

    SELECT    
        [CheckID] as check_id,
        [TableName] as table_name,
        [ColumnName] as column_name,
        [CheckName] as check_name,
        [StatusMessage] as status_name, 
        [RecordCount] as record_count,
        [RunDateTime] as run_date_time
    
    FROM #Results
    
END