
CREATE   VIEW [ETL].[dim_client_referral_service_level]

AS

/*************************************************************************************************************
 View        [ETL].[dim_client_service_level]
 Author      Greg Nuthall
 Created     2025-05-27    
 Purpose     Used to build the edw.dim_client_service_level table 
**************************************************************************************************************
-- REVISIONS:
-- Version    Date            Author        Description
---------    ------------    -----------    --------------------------
-- 1.0        2025-05-27      GN - Copilot  Initial version
-- 1.1		  2025-06-30	  Greg Nuthall	Added effective_date and changed to get just the latest record per referral 
**************************************************************************************************************/

with CTE_latest_record_EAL as (SELECT 
    rsl.referralid
    ,rsl.ReferralServiceLevelDefinitionId
    ,max(rsl.ReferralServiceLevelCreatedDate) as ReferralServiceLevelCreatedDate
    
FROM 
    rbeal.dlfactreferralservicelevel AS rsl
    group by rsl.referralid, rsl.ReferralServiceLevelDefinitionId
),

CTE_latest_record_MNB as (SELECT 
    rsl.referralid 
    , rsl.ReferralServiceLevelDefinitionId
    ,max(rsl.ReferralServiceLevelCreatedDate) as ReferralServiceLevelCreatedDate
FROM 
    rbeal.dlfactreferralservicelevel AS rsl
    group by rsl.referralid, rsl.ReferralServiceLevelDefinitionId
)


SELECT
    rsl.ReferralServiceLevelId as client_referral_service_level_id
    ,1 as company_id
    ,p.personid AS client_id
    ,rsl.referralid AS client_referral_id
    ,l.lookupvalue AS service_level_code
    ,l.lookuptext AS service_level
    --,rsl.ReferralServiceLevelCreatedDate as created_date
    ,rsl.ReferralServiceLevelEffectiveFrom as effective_date
     ,case 
        when (rsl.ReferralServiceLevelDefinitionId in (3,4)) then 'Frequency'
        when (rsl.ReferralServiceLevelDefinitionId in (7,8)) then 'Level'
        when (rsl.ReferralServiceLevelDefinitionId in (24,25,26,27,28,29,32,33)) then 'Service_Level'
        when (rsl.ReferralServiceLevelDefinitionId in (31,34,35,42,38,40)) then 'Location'
        else 'Unknown'
    end as service_level_group
FROM 
    rbeal.dlfactreferralservicelevel AS rsl
INNER JOIN 
    rbeal.dldimlookup AS l ON rsl.lookupid = l.lookupid
INNER JOIN 
    rbeal.dlfactreferral AS r ON rsl.referralid = r.referralid
INNER JOIN 
    rbeal.dldimperson AS p ON r.personid = p.personid
inner join 
    CTE_latest_record_EAL c 
        on rsl.ReferralServiceLevelCreatedDate = c.ReferralServiceLevelCreatedDate
        and rsl.referralid = c.ReferralId 
        and rsl.ReferralServiceLevelDefinitionId = c.ReferralServiceLevelDefinitionId

--where l.lookupvalue in ('SL2','SL1','SL3')
--where rsl.referralid in (18239,138462,150814,18170,142178,18201,43641,50887,18223,133546,18197,18179)

UNION ALL

SELECT
    rsl.ReferralServiceLevelId as client_referral_service_level_id
    ,5 as company_id
    ,p.personid AS client_id
    ,rsl.referralid AS client_referral_id
    ,l.lookupvalue AS service_level_code
    ,l.lookuptext AS service_level
    --,rsl.ReferralServiceLevelCreatedDate as created_date
    ,rsl.ReferralServiceLevelEffectiveFrom as effective_date
    ,case 
        when (rsl.ReferralServiceLevelDefinitionId in (3,4)) then 'Level'
        when (rsl.ReferralServiceLevelDefinitionId in (7,8)) then 'Amount'
        when (rsl.ReferralServiceLevelDefinitionId in (24,25,26,27,28,29,32,33)) then 'Service_Level'
        when (rsl.ReferralServiceLevelDefinitionId in (31,34,35,42,38,40)) then 'Location'
        else 'Unknown'
    end as service_level_group


FROM 
    rbmnb.dlfactreferralservicelevel AS rsl
INNER JOIN 
    rbmnb.dldimlookup AS l ON rsl.lookupid = l.lookupid
INNER JOIN 
    rbmnb.dlfactreferral AS r ON rsl.referralid = r.referralid
INNER JOIN 
    rbmnb.dldimperson AS p ON r.personid = p.personid
inner join 
    CTE_latest_record_MNB c on rsl.ReferralServiceLevelCreatedDate = c.ReferralServiceLevelCreatedDate
    and rsl.referralid = c.ReferralId 
    and rsl.ReferralServiceLevelDefinitionId = c.ReferralServiceLevelDefinitionId