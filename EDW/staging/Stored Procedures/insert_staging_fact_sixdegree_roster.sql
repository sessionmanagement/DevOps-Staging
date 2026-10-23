
CREATE PROC [staging].[insert_staging_fact_sixdegree_roster]

AS
/**********************************************************************************************************
 Procedure	[staging].[insert_staging_fact_sixdegree_roster]
 Author		Malhar Badheka
 Created		2026-03-17
 Purpose		Loads staging table from landing for fact_sixdegree_roster.
              Resolves dim_service_key via lookup on edw.dim_service using entity_code.
 Notes: 		Called by ETL batch prior to edw.UpdateEDWfact_sixdegree_roster
 =========================================================================================================
 REVISIONS:
 Version	 Date		   Author				Description
-------	 ------------  ---------------		--------------------------
 1.0		 2026-03-17   Malhar Badheka		Initial version
 1.1		 2026-04-17   Malhar Badheka		Rename dim_sixdegree_entity_key to dim_service_key; remove entity_key; add entity_code, entity_parent_code; join changed to dim_service on service_code
 1.2		 2026-04-24   Malhar Badheka		Filter on dim_service to remove duplicates from M&B service code
 1.3         2026-06-11   Greg Nuthall			Added Mind and Body link to pick up missing dim_service_key records
**********************************************************************************************************/

-- Clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_sixdegree_roster];

-- Insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_sixdegree_roster] (
	 [entity_code]
	,[entity_parent_code]
	,[dim_service_key]
	,[roster_shifts]
	,[monday]
	,[tuesday]
	,[wednesday]
	,[thursday]
	,[friday]
	,[saturday]
	,[sunday]
	,[total shift/week]
	,[roster - fte/week]
)
SELECT
	 sdp.[entity_code]
	,sdp.[entity_parent_code]
	,case when isnull(s.[dim_service_key],s2.[dim_service_key]) is null 
		then case when sdp.[entity_code] IS NOT NULL
			then -1 ELSE 0 end
		else isnull(s.[dim_service_key],s2.[dim_service_key])
	end as [dim_service_key]

	--,ISNULL(s.[dim_service_key], CASE WHEN sdp.[entity_code] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_service_key]
	,sdp.[roster_shifts]
	,sdp.[monday]
	,sdp.[tuesday]
	,sdp.[wednesday]
	,sdp.[thursday]
	,sdp.[friday]
	,sdp.[saturday]
	,sdp.[sunday]
	,sdp.[total shift/week]
	,sdp.[roster - fte/week]
FROM [Landing].[EDW_fact_sixdegree_roster] sdp
LEFT OUTER JOIN [edw].[dim_service] s ON s.[service_code] = sdp.[entity_code] AND s.[DWHIsCurrent] = 1  AND s.[dim_company_key] =  1
LEFT OUTER JOIN [edw].[dim_service] s2 ON s2.[service_code] = sdp.[entity_code] AND s2.[DWHIsCurrent] = 1  AND s2.[dim_company_key] =  5;