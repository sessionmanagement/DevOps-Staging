CREATE PROCEDURE [edw].[Updateedwbridge_kpi_service_type_to_grouping]
    @pBatchID INT,
    @pIndexRebuildThreshold INT,
    @pOutputParamsAsDataset INT = 0,
    @pErrorRecords INT = NULL OUTPUT,
    @pInsertRecords INT = NULL OUTPUT,
    @pUpdateRecords INT = NULL OUTPUT,
    @pDeleteRecords INT = NULL OUTPUT,
    @pCompleted INT = NULL OUTPUT,
    @pTargetRecords INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Variables
    DECLARE @batchID INT = @pBatchID;
    DECLARE @SourceSystem NVARCHAR(120) = '[ETL].[bridge_kpi_service_type_to_grouping]';

    DECLARE @stagedRecords INT = 0;
    DECLARE @targetRecords INT = 0;

    DECLARE @insertedRecords INT = 0;
    DECLARE @updatedRecords INT = 0;
    DECLARE @deletedRecords INT = 0;

    DECLARE @systemCurrentDate DATETIME = GETDATE();

    TRUNCATE TABLE [edw].[bridge_kpi_service_type_to_grouping];

    -- Check if staging has any records
    SELECT @stagedRecords = COUNT(1)
    FROM [Staging].[ODSETLbridge_kpi_service_type_to_grouping];

    IF (@stagedRecords = 0)
    BEGIN
        SELECT @targetRecords = COUNT(1)
        FROM [edw].[bridge_kpi_service_type_to_grouping];

        SET @pErrorRecords = 0;
        SET @pInsertRecords = 0;
        SET @pUpdateRecords = 0;
        SET @pDeleteRecords = 0;
        SET @pCompleted = 1;
        SET @pTargetRecords = @targetRecords;

        IF (@pOutputParamsAsDataset = 1)
        BEGIN
            SELECT
                @pErrorRecords AS ErrorRecords,
                @pInsertRecords AS InsertRecords,
                @pUpdateRecords AS UpdateRecords,
                @pDeleteRecords AS DeleteRecords,
                @pCompleted AS Completed,
                @targetRecords AS TargetRecords;
        END;

        RETURN;
    END;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Insert records
        INSERT INTO [edw].[bridge_kpi_service_type_to_grouping] (
 dim_kpi_service_type_key,
dim_kpi_service_type_grouping_key,
                [service_type_grouping_id],
                [service_type_id],
            [DWHBatchId],
            [DWHCreatedAt],
            [DWHSourceSystem]
        )
        SELECT
			src.dim_kpi_service_type_key,
src.dim_kpi_service_type_grouping_key,
                src.[service_type_grouping_id],
                src.[service_type_id]
				,
            @BatchID,
            GETDATE(),
            @SourceSystem
        FROM [Staging].[ODSETLbridge_kpi_service_type_to_grouping] AS src;

        -- Count inserted rows
        SELECT
            @targetRecords = COUNT(1),
            @insertedRecords = SUM(CASE WHEN [DWHBatchId] = @BatchID THEN 1 ELSE 0 END),
            @updatedRecords = 0
        FROM [edw].[bridge_kpi_service_type_to_grouping];

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        SET @pErrorRecords = @stagedRecords - @insertedRecords - @updatedRecords - @deletedRecords;
        SET @pInsertRecords = @insertedRecords;
        SET @pUpdateRecords = @updatedRecords;
        SET @pDeleteRecords = @deletedRecords;
        SET @pCompleted = 0;
        SET @pTargetRecords = @targetRecords;

        IF (@pOutputParamsAsDataset = 1)
        BEGIN
            SELECT
                @pErrorRecords AS ErrorRecords,
                @pInsertRecords AS InsertRecords,
                @pUpdateRecords AS UpdateRecords,
                @pDeleteRecords AS DeleteRecords,
                @pCompleted AS Completed,
                @targetRecords AS TargetRecords;
        END;

        THROW;
    END CATCH;

    -- Finalize output
    SET @pErrorRecords = @stagedRecords - @insertedRecords - @updatedRecords - @deletedRecords;
    SET @pInsertRecords = @insertedRecords;
    SET @pUpdateRecords = @updatedRecords;
    SET @pDeleteRecords = @deletedRecords;
    SET @pCompleted = 1;
    SET @pTargetRecords = @targetRecords;

    IF (@pOutputParamsAsDataset = 1)
    BEGIN
        SELECT
            @pErrorRecords AS ErrorRecords,
            @pInsertRecords AS InsertRecords,
            @pUpdateRecords AS UpdateRecords,
            @pDeleteRecords AS DeleteRecords,
            @pCompleted AS Completed,
            @targetRecords AS TargetRecords;
    END;
END;