



CREATE PROC [staging].[insert_staging_dim_time] 
AS

/***************************************************************************
NAME:     [staging].[insert_staging_dim_time]
PURPOSE:  used to stage data for dim_time

NOTES: this code was not generated via the Frameowork

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-04-11    Manish Singh		Initial version
1.1		 2026-02-11    Pankaj Bhatt		Fix for hour_12h and hour_24h values swap


****************************************************************************/
--Variable 
declare @source_row_count int = 0;

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_time] ;

WITH cte AS (
    SELECT 1 AS Seconds
    UNION ALL
    SELECT Seconds + 1 FROM cte WHERE Seconds < 86400 -- 86400 seconds in a day
)
	
--)
INSERT INTO [Staging].[ODSETLdim_time]
           ([timekey]
           ,[time]
           ,[hour_12h]
           ,[hour_24h]
           ,[minute]
           ,[second]
           ,[am.pm]
           ,[standard_time])
SELECT
    Seconds,
   cast( DATEADD(SECOND, Seconds, '2000-01-01 00:00:00') as time(0)) AS [time],
    DATEPART(HOUR, DATEADD(SECOND, Seconds, '2000-01-01 00:00:00')) % 12 AS hour12h,
    DATEPART(HOUR, DATEADD(SECOND, Seconds, '2000-01-01 00:00:00')) AS hour24h,
    DATEPART(MINUTE, DATEADD(SECOND, Seconds, '2000-01-01 00:00:00')) AS minute,
    DATEPART(SECOND, DATEADD(SECOND, Seconds, '2000-01-01 00:00:00')) AS second,
    CASE WHEN DATEPART(HOUR, DATEADD(SECOND, Seconds, '2000-01-01 00:00:00')) >= 12 THEN 'PM' ELSE 'AM' END AS ampm,
    CONVERT(VARCHAR(8), DATEADD(SECOND, Seconds, '2000-01-01 00:00:00'), 108) AS standardtime
--INTO [edw].[dim_time]
FROM cte
option (maxrecursion 0);


	Select @source_row_count =  COUNT(*) from [Staging].[ODSETLdim_time]

	-- Select return parameters as a dataset
	select	@source_row_count	as source_row_count

	return;