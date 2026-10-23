CREATE VIEW [ETL].[fact_property_risk]

/**********************************************************************************************************
 View		[ETL].[fact_property_risk]
 Author		Mike Gencic
 Created	2025-04-17	
 Purpose	Used to build the edw.fact_property_risk

 **************************************************************************************************************
--REVISIONS:
--Version	 Date		   Author			description
---------	 ------------  ---------------	--------------------------
--1.0		 2025-04-17	   Greg Nuthall	    Initial version
--1.1		 2026-02-20	   GitHub Copilot   No columns removed (8 redundant columns) per work item 12210
**************************************************************************************************************/


AS
    SELECT
        ----------------------------------------------------------------------------
        -- 1. Surrogate Key for EDW / Fact
        ----------------------------------------------------------------------------
        rr.zav_riskregisterid AS property_risk_id, -- primary key in EDW

        -- Underlying CRM row ID
        rr.Id AS riskregister_row_id,

        ----------------------------------------------------------------------------
        -- 2. References to property/tenancy/household/contact/application
        ----------------------------------------------------------------------------
        rr.zav_property        AS property_id,
        rr.zav_tenancy         AS property_tenancy_id,
        rr.zav_household       AS property_household_id,
        rr.zav_householdmember AS property_householdmember_id,
        rr.zav_contact         AS property_risk_contact_id,
        rr.zav_application     AS property_risk_application_id,

        ----------------------------------------------------------------------------
        -- 3. Category & Subcategory references (IDs plus textual names)
        ----------------------------------------------------------------------------
        rr.zav_riskcategory    AS property_risk_category_id,
        CAST(rr.zav_riskcategoryname AS VARCHAR(200)) AS property_risk_category_name,

        rr.zav_risksubcategory AS property_risk_subcategory_id,
        CAST(rr.zav_risksubcategoryname AS VARCHAR(200)) AS property_risk_subcategory_name,

        ----------------------------------------------------------------------------
        -- 4. Risk Status Label (removed risk_status_code per work item 12210)
        ----------------------------------------------------------------------------
        rstatusOm.LocalizedLabel           AS risk_status_label,

        ----------------------------------------------------------------------------
        -- 5. Additional textual fields
        ----------------------------------------------------------------------------
        -- Basic text fields from the risk record
        CAST(rr.zav_name AS VARCHAR(2000)) AS property_risk_name,
        CAST(rr.zav_comments AS VARCHAR(MAX)) AS property_risk_comments,
        -- Removed: property_risk_subcategory_description, property_risk_contact_with_hazardous_customers

        -- Various "friendly" names from the record
        CAST(rr.zav_contactname AS VARCHAR(200))          AS property_risk_contact_name,
        CAST(rr.zav_householdmembername AS VARCHAR(200))  AS property_risk_householdmember_name,
        CAST(rr.zav_householdname AS VARCHAR(200))        AS property_risk_household_name,
        CAST(rr.zav_tenancyname AS VARCHAR(200))          AS property_risk_tenancy_name,
        CAST(rr.zav_propertyname AS VARCHAR(200))         AS property_risk_property_name,

        -- Possibly the 'zav_applicationname' if needed
        CAST(rr.zav_applicationname AS VARCHAR(200)) AS property_risk_application_name,

        -- The chintaro ID if used
        CAST(rr.zav_chintaroid AS VARCHAR(100)) AS property_risk_chintaro_id,

        ----------------------------------------------------------------------------
        -- 6. Key dates (removed _key columns per work item 12210)
        ----------------------------------------------------------------------------
        -- The date the risk was registered
        rr.zav_dateriskregistered AS property_risk_date_registered,

        -- The next risk review date
        rr.zav_nextriskreviewdate AS property_risk_date_next_review,

        ----------------------------------------------------------------------------
        -- 7. CRM State/Status
        -- (removed ownership & audit fields: owner_id, created_by_id, modified_by_id, etc.)
        ----------------------------------------------------------------------------
        rr.statecode  AS risk_state_code,
        rr.statuscode AS risk_status_code_crm,
        CAST(CAST(rr.IsDelete AS BIT) AS INT) AS risk_is_delete_flag
    -- Removed: SinkCreatedOn, SinkModifiedOn

    FROM [Zavanti].[vw_zav_riskregister] AS rr

        -- Local Option Set => [Zavanti].[vw_OptionsetMetadata]
        LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS rstatusOm
        ON rstatusOm.EntityName    = 'zav_riskregister'
            AND rstatusOm.OptionSetName = 'zav_riskregisterstatus'
            AND rstatusOm.[Option]      = rr.zav_riskregisterstatus

-- Optionally filter or not:
-- WHERE rr.zav_riskregisterid IS NOT NULL;