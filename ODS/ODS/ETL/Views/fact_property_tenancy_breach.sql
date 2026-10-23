/****** Object:  View [ETL].[fact_property_tenancy_breach]    Script Date: 23/06/2025 3:59:40 pm ******/
/****** Object:  View [ETL].[fact_property_tenancy_breach]    Script Date: 23/06/2025 8:41:12 am ******/

CREATE       view [ETL].[fact_property_tenancy_breach]

/**********************************************************************************************************
 View		etl.fact_tenancy_breach
 Author		Mike Gencic and Greg Nuthall
 Created	2025/06/19	
 Purpose	To report on tenancy breach and tribunal dispute data from the EDW.  
  **************************************************************************************************************

--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2025/06/19		Greg Nuthall	Initial version
**************************************************************************************************************/

as 

WITH optionHashTable AS 
(
    SELECT
        [OptionSetName],
        [Option],
        [EntityName],
        HASHBYTES('MD5', [OptionSetName] + CAST([Option] AS nvarchar(100)) + [EntityName]) AS optionHash,
        [LocalizedLabel]
    FROM 
        [Zavanti].[vw_GlobalOptionsetMetadata]

    UNION

    SELECT
        [OptionSetName],
        [Option],
        [EntityName],
        HASHBYTES('MD5', [OptionSetName] + CAST([Option] AS nvarchar(100)) + [EntityName]) AS optionHash,
        [LocalizedLabel]
    FROM 
        [Zavanti].[vw_OptionsetMetadata]

    UNION

    SELECT
        'statuscodename' AS [OptionSetName],
        [status] AS [Option],
        [EntityName],
        HASHBYTES('MD5', 'statuscodename' + CAST([status] AS nvarchar(100)) + [EntityName]) AS optionHash,
        [LocalizedLabel]
    FROM 
        [Zavanti].[vw_StatusMetadata]

    UNION

    SELECT
        'statecodename' AS [OptionSetName],
        [state] AS [Option],
        [EntityName],
        HASHBYTES('MD5', 'statecodename' + CAST([state] AS nvarchar(100)) + [EntityName]) AS optionHash,
        [LocalizedLabel]
    FROM 
        [Zavanti].[vw_StateMetadata]
),
RecentZavTenancyBreach AS (
    SELECT
        zav_tenancybreachid,
        zav_name,
        zav_breachdate,
        zav_breachid,
        zav_tenancy,
		zav_breachstatus,
        SinkModifiedOn,
        ROW_NUMBER() OVER (PARTITION BY zav_tenancybreachid ORDER BY SinkModifiedOn DESC) AS rn
    FROM
        [Zavanti].[vw_zav_tenancybreach]
    WHERE 
        zav_tenancybreachid IS NOT NULL
),
RecentZavTribunalOrder AS (
    SELECT
        zav_tribunalorderid,
        zav_name,
        zav_enddate,
        zav_startdate,
        zav_tribunaloutcome,
        zav_casename,
        zav_tenancybreachname,
        zav_tribunaloutcomename,
        zav_tribunaloutcomereasonname,
        zav_tenancybreach,
        SinkModifiedOn,
        ROW_NUMBER() OVER (PARTITION BY zav_tribunalorderid ORDER BY SinkModifiedOn DESC) AS rn
    FROM
        [Zavanti].[vw_zav_tribunalorder]
    WHERE
        zav_tribunalorderid IS NOT NULL
)
SELECT
    rtb.zav_tenancybreachid as tenancy_breach_id,
    rtb.zav_tenancy as property_tenancy_id,
    rtb.zav_name as breach,
    rto.zav_tenancybreachname as tenancy_breach,
    rtb.zav_breachdate as breach_date,
    rtb.zav_breachid as breach_id,
    t1.LocalizedLabel AS breach_status,
    rto.zav_tribunalorderid as tribunal_order_id,
    rto.zav_name AS tribunal_order,  --tribunalorder_zav_name as
    rto.zav_enddate as breach_end_date,
    rto.zav_startdate as breach_start_date,
    rto.zav_tribunaloutcome as tribunal_outcome_id,
    rto.zav_tribunaloutcomename as tribunal_outcome,
    rto.zav_casename as case_number,
    rto.zav_tribunaloutcomereasonname as tribunal_outcome_reason
FROM 
    RecentZavTenancyBreach rtb
LEFT OUTER JOIN 
    optionHashTable t1 
ON 
    t1.optionHash = HASHBYTES('MD5', 'zav_breachstatus' + CAST(rtb.zav_breachstatus AS nvarchar(100)) + 'zav_tenancybreach')
LEFT OUTER JOIN 
    RecentZavTribunalOrder rto 
ON 
    rto.zav_tenancybreach = rtb.zav_tenancybreachid AND rto.rn = 1
WHERE
    rtb.rn = 1