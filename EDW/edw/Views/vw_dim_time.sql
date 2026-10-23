


CREATE VIEW [edw].[vw_dim_time]
AS
SELECT [dim_time_key]
      ,[time]
      ,[hour_12h]
      ,[hour_24h]
      ,[minute]
      ,[second]
      ,[am.pm]
      ,[standard_time]
      ,[DWHBatchId]
      ,[DWHCreatedAt]
      ,[DWHModifiedOn]
      ,[DWHDMLOperation]
      ,[DWHSourceSystem]
  FROM [edw].[dim_time]