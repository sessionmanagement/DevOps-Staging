
 /*=========================================================================================================

 REVISIONS:
 Version   Date       Author          Description
-------  ------------  ------------------  --------------------------
 1.0    06-2025       Manish singh     This view is created to calculate   
 1.1    13-06-2025    Mike Ryan - originally created vw_current_client_by_service.  Concept doesn't exist.  Needs to be referral.
 1.2    18-06-2025    Timi Boddington    Recoded as a referral table

 **********************************************************************************************************/


--====Rationale:
--====Any code that takes a client by service is not referring to a client but a referral.  
--1.  This table needs to be renamed vw_current_client_referrals_by_service
--2.  Original table limits the data to one referral per service so need to include the team as well - as an FYI - service is not the lowest grain

--New Code:
--==== because we're talking about referrals, we need to begin from the fact table not dim_client.

   create view [edw].[vw_current_clients_by_service] as
   SELECT DISTINCT
        vw_fact_client_referral.dim_company_key,
		vw_fact_client_referral.dim_client_key,
		vw_fact_client_referral.client_id,
		vw_fact_client_referral.dim_client_key_latest,
		vw_dim_client.dim_client_unique_key,
		--===added
		vw_fact_client_referral.dim_client_referral_key,
		vw_fact_client_referral.client_referral_id,
		vw_fact_client_referral.client_team_id,
		--========
       	vw_dim_service.dim_service_key,
		--===added
		vw_dim_service.service_code,
		vw_dim_service.service_id,
		vw_dim_client_referral.client_referral_status,
		ROW_NUMBER() OVER (PARTITION BY vw_fact_client_referral.client_id 
		ORDER BY vw_fact_client_referral.client_id, vw_fact_client_referral.dim_client_referral_key) AS row_num_by_client,
    
	--====rationale for the count.  If you want to know the active clients take row_number_by_client = 1
		ROW_NUMBER() OVER (PARTITION BY vw_fact_client_referral.client_id, vw_fact_client_referral.dim_service_key 
		ORDER BY  vw_fact_client_referral.dim_client_referral_key, vw_fact_client_referral.dim_service_key) AS row_num_by_client_per_service
	--====if you want to know the number of active client referrals then count(dim_client_referral_key).
	--====if you want to know the number of active clients per service then count by service where row_num_by_client_per_service = 1 
	
   
	FROM edw.vw_fact_client_referral 
	INNER JOIN edw.vw_dim_client 			 ON vw_fact_client_referral.dim_client_key = vw_dim_client.dim_client_key
	INNER JOIN edw.vw_dim_client_team        ON vw_dim_client_team.dim_client_team_key  = VW_fact_client_referral.dim_client_team_key 
    INNER JOIN edw.vw_dim_service            ON vw_fact_client_referral.dim_service_key = vw_dim_service.dim_service_key
	--====added
	INNER JOIN edw.vw_dim_client_referral    on vw_fact_client_referral.dim_client_referral_key = vw_dim_client_referral.dim_client_referral_key
	--===========
    WHERE 
		vw_fact_client_referral.DWHDMLOperation       <> 'D'
		--=== discussion with Thijs, he says we need waitlist and pending... therefore need to add an extra column for client_referral_status.  Any confusion is his doing
		--AND vw_fact_client_referral.client_referral_accepted_date_key is not null
		AND vw_dim_client_referral.client_referral_type = 'InboundReferral'
		AND vw_dim_client_referral.client_status_is_active = 'Active'
		--dim_client_team doesn't keep history - keep only the valid ones - because we're using team id.
		AND vw_dim_client_team.DWHDMLOperation       <> 'D'
		--and vw_dim_service.dwhiscurrent  = 1
		and vw_dim_service.dwhdmloperation <> 'd'
		

--===Original Code FYI
/****** Object:  View [edw].[vw_current_clients_by_service]    Script Date: 5/05/2025 9:56:56 am ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO



--/**********************************************************************************************************
	
-- Notes: View created on EDW tables
-- =========================================================================================================

-- REVISIONS:
-- Version	 Date		   Author			    Description
---------	------------  ------------------	--------------------------
-- 1.0		04-03-2025     Manish Singh		 This view is created to get current client record with service and team information

 
-- **********************************************************************************************************/

--create view [edw].[vw_current_clients_by_service] as


--WITH clients_and_services AS (
--    SELECT DISTINCT
--        fcr.dim_company_key,
--        ds.dim_service_key,
--        dim_client.dim_client_key,
--        dim_client.dim_client_unique_key,
--        dim_client.client_id
--    FROM edw.vw_dim_client dc
--    INNER JOIN edw.vw_fact_client_referral fcr
--        ON dim_client.dim_client_key = fcr.dim_client_key_latest
--    INNER JOIN edw.vw_dim_client_team dct
--        ON dim_client_team.client_team_id = fcr.client_team_id
--    INNER JOIN edw.vw_dim_service ds
--        ON ds.service_code = dim_client_team.service_id
--    WHERE dim_client.DWHDMLOperation       <> 'd'
--      AND dim_client.DWHIsCurrent           = 1
--      AND dim_client.client_status_is_active = 'Active'
--      AND fcr.DWHDMLOperation       <> 'D'
--      AND dim_client_team.DWHDMLOperation       <> 'D'
--      AND ds.DWHIsCurrent           = 1
--      AND ds.DWHDMLOperation       <> 'D'
--      AND (fcr.client_referral_end_date_key IS NULL 
--           OR fcr.client_referral_end_date_key > CAST(CONVERT(VARCHAR(8), GETDATE(), 112) AS INT))
--      AND (fcr.client_referral_accepted_date_key IS NULL 
--           OR fcr.client_referral_accepted_date_key <= CAST(CONVERT(VARCHAR(8), GETDATE(), 112) AS INT))
--),
--final_table AS (
--    SELECT
--        dim_company_key,
--        dim_service_key,
--        dim_client_key,
--        dim_client_unique_key,
--        client_id,
--        ROW_NUMBER() OVER (PARTITION BY client_id ORDER BY dim_client_key) AS row_num_by_client
--    FROM clients_and_services
--)
--SELECT * FROM final_table