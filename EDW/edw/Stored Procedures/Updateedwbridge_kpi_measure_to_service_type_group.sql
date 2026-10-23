CREATE PROCEDURE [edw].[Updateedwbridge_kpi_measure_to_service_type_group]
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
    DECLARE @SourceSystem NVARCHAR(120) = '[ETL].[bridge_kpi_measure_to_service_type_group]';

    DECLARE @stagedRecords INT = 0;
    DECLARE @targetRecords INT = 0;
    DECLARE @insertedRecords INT = 0;
    DECLARE @updatedRecords INT = 0;
    DECLARE @deletedRecords INT = 0;

    DECLARE @systemCurrentDate DATETIME = GETDATE();

    TRUNCATE TABLE [edw].[bridge_kpi_measure_to_service_type_group];

    -- Exit early if no records in staging
    SELECT @stagedRecords = COUNT(1)
    FROM [Staging].[ODSETLbridge_kpi_measure_to_service_type_group];

    IF (@stagedRecords = 0)
    BEGIN
        SELECT @targetRecords = COUNT(1)
        FROM [edw].[bridge_kpi_measure_to_service_type_group];

        -- Set output parameters
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
        -- Insert new records
        INSERT INTO [edw].[bridge_kpi_measure_to_service_type_group] (
            [dim_kpi_key]
    ,[dim_kpi_service_type_grouping_key]
    ,[measure_id] 
    ,[service_type_grouping_id],
            [DWHBatchId],
            [DWHCreatedAt],
            [DWHSourceSystem]
        )
        SELECT
     src.[dim_kpi_key]
    ,src.[dim_kpi_service_type_grouping_key]
    ,isnull(src.[measure_id],-777) as measure_id
	,isnull(src.[service_type_grouping_id],-777) as service_type_grouping_id
            ,@BatchID,
            GETDATE(),
            @SourceSystem
        FROM [Staging].[ODSETLbridge_kpi_measure_to_service_type_group] AS src;

        -- Get counts
        SELECT 
            @targetRecords = COUNT(1),
            @insertedRecords = SUM(CASE WHEN [DWHBatchId] = @BatchID THEN 1 ELSE 0 END),
            @updatedRecords = 0
        FROM [edw].[bridge_kpi_measure_to_service_type_group];

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        -- Set error counts
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

    -- Final output parameters
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