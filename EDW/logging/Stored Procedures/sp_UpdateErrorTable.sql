 
CREATE PROCEDURE [logging].[sp_UpdateErrorTable]
   @DataFactory_Name [nvarchar](500) NULL,
   @Pipeline_Name [nvarchar](500) NULL,
   @RunId [nvarchar](500) NULL,
   @Source [nvarchar](500) NULL,
   @Destination [nvarchar](500) NULL,
   @TriggerType [nvarchar](500) NULL,
   @TriggerId [nvarchar](500) NULL,
   @TriggerName [nvarchar](500) NULL,
   @TriggerTime [nvarchar](500) NULL,
   @No_ParallelCopies [int] NULL,
   @copyDuration_in_secs [nvarchar](500) NULL,
   @effectiveIntegrationRuntime [nvarchar](500) NULL,
   @Source_Type [nvarchar](500) NULL,
   @Sink_Type [nvarchar](500) NULL,
   @Execution_Status [nvarchar](500) NULL,
   @ErrorDescription [nvarchar](max) NULL,
   @ErrorCode [nvarchar](500) NULL,
   @ErrorLoggedTime [nvarchar](500) NULL,
   @FailureType [nvarchar](500) NULL
AS
INSERT INTO [logging].[pipeline_errors]
           ([DataFactory_Name]
           ,[Pipeline_Name]
           ,[RunId]
           ,[Source]
           ,[Destination]
           ,[TriggerType]
           ,[TriggerId]
           ,[TriggerName]
           ,[TriggerTime]
           ,[No_ParallelCopies]
           ,[copyDuration_in_secs]
           ,[effectiveIntegrationRuntime]
           ,[Source_Type]
           ,[Sink_Type]
           ,[Execution_Status]
           ,[ErrorDescription]
           ,[ErrorCode]
           ,[ErrorLoggedTime]
           ,[FailureType])
VALUES
(
   @DataFactory_Name,
   @Pipeline_Name,
   @RunId,
   @Source,
   @Destination,
   @TriggerType,
   @TriggerId,
   @TriggerName,
   @TriggerTime,
   @No_ParallelCopies,
   @copyDuration_in_secs,
   @effectiveIntegrationRuntime,
   @Source_Type,
   @Sink_Type,
   @Execution_Status,
   @ErrorDescription,
   @ErrorCode,
   @ErrorLoggedTime,
   @FailureType
)