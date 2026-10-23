
CREATE   procedure [kpi].[Updatekpids_snapshot_client_current]
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

    -- Declare Variables
    DECLARE @batchID INT = @pBatchID;
    DECLARE @SourceSystem NVARCHAR(120) = '[edw].[kpi_snapshot_client_current]';
    DECLARE @stagedRecords INT = 0;
    DECLARE @targetRecords INT = 0;
    DECLARE @insertedRecords INT = 0;
    DECLARE @updatedRecords INT = 0;
    DECLARE @systemCurrentDate DATETIME = GETDATE();

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Truncate target table before inserting new data
        TRUNCATE TABLE [kpi].[ds_snapshot_client_current];

        -- Insert new records from landing table
        INSERT INTO [kpi].[ds_snapshot_client_current]
        (
 				 [dim_kpi_key] 
				,[dim_company_key] 
				,[dim_client_key] 
				,[dim_service_key] 
				,[entity_key]
                ,[kpi_id]
				,[client_id]
				,[service_id] 
				,[kpi_value] 
				,[user_friendly_score_explanation] 
				,[kpi_status] 
				,[snapshot_date] 
				,[KPIBatchId]
				
				
        )
        SELECT 
				 src.[dim_kpi_key] 
				,src.[dim_company_key] 
				,src.[dim_client_key] 
				,src.[dim_service_key]
				,src.[entity_key]
                ,src.[kpi_id]
				,src.[client_id]
				,src.[service_id] 
				,src.[kpi_value] 
				,src.[user_friendly_score_explanation] 
				,src.[kpi_status] 
				,src.[snapshot_date] 
				,@BatchID AS [KPIBatchId]
				
				
        FROM [landing].[kpi_ds_snapshot_client_current] AS src;

        -- Capture process counts
        SELECT 
            @targetRecords = COUNT(1),
            @insertedRecords = SUM(CASE WHEN [KPIBatchId] = @BatchID THEN 1 ELSE 0 END),
            @updatedRecords = 0
        FROM [kpi].[ds_snapshot_client_current];

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        -- Capture error details
        SET @pErrorRecords = @stagedRecords - @insertedRecords - @updatedRecords;
        SET @pInsertRecords = @insertedRecords;
        SET @pUpdateRecords = @updatedRecords;
        SET @pDeleteRecords = 0;
        SET @pCompleted = 0;
        SET @pTargetRecords = @targetRecords;

        IF (@pOutputParamsAsDataset = 1)
        BEGIN
            -- Return error dataset
            SELECT @pErrorRecords AS ErrorRecords,
                   @pInsertRecords AS InsertRecords,
                   @pUpdateRecords AS UpdateRecords,
                   @pDeleteRecords AS DeleteRecords,
                   @pCompleted AS Completed,
                   @targetRecords AS TargetRecords;
        END;

        THROW;
    END CATCH;

    -- Final output parameter assignments
    SET @pErrorRecords = @stagedRecords - @insertedRecords - @updatedRecords;
    SET @pInsertRecords = @insertedRecords;
    SET @pUpdateRecords = @updatedRecords;
    SET @pDeleteRecords = 0;
    SET @pCompleted = 1;
    SET @pTargetRecords = @targetRecords;

    IF (@pOutputParamsAsDataset = 1)
    BEGIN
        -- Return final dataset
        SELECT @pErrorRecords AS ErrorRecords,
               @pInsertRecords AS InsertRecords,
               @pUpdateRecords AS UpdateRecords,
               @pDeleteRecords AS DeleteRecords,
               @pCompleted AS Completed,
               @targetRecords AS TargetRecords;
    END;
END;