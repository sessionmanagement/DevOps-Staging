
--------------------------------------------------------------------------------
-- v1.0.1 - 2025-04-29 - Mike Gencic
-- Change Notes: Added short, technical comments referencing EDW usage.
--------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- 2) CREATE THE PROCEDURE
--    Purpose: Execute dictionary-based data-quality checks, storing results 
--    in [DQ].[DQResults].
------------------------------------------------------------------------------
Create   procedure [meta_data].[populate_dq_from_dictionary]
(
    @OnlyInsertWhenRecordCountPositive BIT = 1,
    @RunDateTimeNZ DATETIME2 = null
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

    ----------------------------------------------------------------------------
    -- v1.0.1: Loop each DQDictionary row, run @CheckSQL, store result in DQResults.
    ----------------------------------------------------------------------------
    DECLARE @CheckID       INT;
    DECLARE @TableName     NVARCHAR(200);
    DECLARE @ColumnName    NVARCHAR(200);
    DECLARE @CheckName     NVARCHAR(200);
    DECLARE @CheckSQL      NVARCHAR(MAX);

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


    DECLARE checkCursor CURSOR FOR
        SELECT 
            [dictionary_id],
	        [table_name],
	        [column_name],
	        [check_name],
	        [check_sql]
        from meta_data.dq_dictionary
        ORDER BY dictionary_id;

    OPEN checkCursor;
    FETCH NEXT FROM checkCursor 
      INTO @CheckID, @TableName, @ColumnName, @CheckName, @CheckSQL;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        BEGIN TRY
            ----------------------------------------------------------------------------
            -- v1.0.1: Execute dynamic SQL from dictionary and capture IssueCount.
            ----------------------------------------------------------------------------
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

        FETCH NEXT FROM checkCursor 
          INTO @CheckID, @TableName, @ColumnName, @CheckName, @CheckSQL;
    END;

    CLOSE checkCursor;
    DEALLOCATE checkCursor;

    ----------------------------------------------------------------------------
    -- 5) End of procedure
    ----------------------------------------------------------------------------
    SET NOCOUNT OFF;

    SELECT    
        [CheckID] as check_id,
        [TableName] as table_name,
        [ColumnName] as column_name,
        [CheckName] as check_name,
        [StatusMessage] as status_name, 
        [RecordCount] as record_count,
        [RunDateTime] as run_date_time
    
    FROM #Results

END;