
create   view [ETL].[dim_location_new]
as

/**********************************************************************************************************
 View		[ETL].[dim_location_new]
 Author		Pankaj Bhatt
 Created	2026-04-15
 Purpose	Used to build the edw.dim_location_new table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2026-04-15		Pankaj Bhatt	Initial version
--1.1        2026-06-22     Greg Nuthall    Changed to include older IntelliHR location data where it has been  
                                            isEnabled = 1 but is no longer isEnabled = 1
**************************************************************************************************************/


WITH 
IntelliHR_Data AS (
    SELECT
         l.locations_id AS LocationID
         ,case 
            when len(l.address) < 1 then 'NoLocation'
            else l.address 
            end 
         AS LocationCode
        ,l.name AS LocationName
        ,l.parentId AS ParentLocationID
        ,pl.address AS ParentLocationCode
        ,pl.name AS ParentLocationName
        ,l.ODSEffectiveFrom AS LastModifiedDateTime
        ,'IntelliHR' AS DataSource
        ,1 as ExistsInIntelliHR
    FROM (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY case 
            when len([address]) < 1 then 'NoLocation'
        	else [address] 
            end  ORDER BY isEnabled DESC) AS rn
        FROM [IntelliHR].[locations]
        WHERE ODSIsCurrent = 1
        AND name NOT LIKE '%UNKNOWN%'
    ) l
    LEFT OUTER JOIN (
        SELECT * FROM [IntelliHR].[locations] WHERE ODSIsCurrent = 1 and isEnabled = 1
    ) pl ON l.parentId = pl.locations_id
    WHERE l.rn = 1
),


--IntelliHR_Data AS (
--SELECT
--    l.locations_id AS LocationID
--    ,case
--    when len(l.address) < 1 then 'NoLocation'
--    else l.address
--    end AS LocationCode
--    ,l.name AS LocationName
--    ,l.parentId AS ParentLocationID
--    ,pl.address AS ParentLocationCode
--    ,pl.name AS ParentLocationName
--    ,l.ODSEffectiveFrom AS LastModifiedDateTime
--    ,'IntelliHR' AS DataSource
--    ,1 as ExistsInIntelliHR
--    FROM [IntelliHR].[locations] l
--    LEFT OUTER JOIN (
--    SELECT * FROM [IntelliHR].[locations] WHERE ODSIsCurrent = 1 and isEnabled = 1
--    ) pl ON l.parentId = pl.locations_id
--    WHERE l.ODSIsCurrent = 1
--    and l.isEnabled = 1
--    and l.name not like '%UNKNOWN%'
-- ),


BusinessCentral_Data AS (
    SELECT 
         Dimension_Value_ID AS LocationID
        ,Code AS LocationCode
        ,Name AS LocationName
        ,CompanyName 
        ,Last_Modified_Date_Time AS LastModifiedDateTime
        ,'BusinessCentral' AS DataSource
        ,1 as ExistsInBusinessCentral
    FROM (
        SELECT 
            ROW_NUMBER() OVER (
                PARTITION BY [dimensionValueID], Company_Name 
                ORDER BY lastModifiedDateTime DESC
            ) AS row_num
            ,[dimensionValueID] AS Dimension_Value_ID
            ,Code
            ,Name
            ,REPLACE(Company_Name, '_', ' ') AS CompanyName
            ,lastModifiedDateTime AS Last_Modified_Date_Time
        FROM [BusinessCentral].[dimensionValues]
        WHERE [dimensionCode] = 'LOCATE'
        AND ODSIsCurrent = 1
    ) AS x
    WHERE row_num = 1
)
SELECT 
    i.LocationID as intelliHR_location_id,
    b.LocationID as business_central_location_id,
    cast(COALESCE(i.LocationCode, b.LocationCode) as nvarchar(4000)) AS location_code,
    i.LocationName as intelliHR_location_name,
    b.LocationName as business_central_location_name,
    i.ParentLocationID as parent_location_id,
    i.ParentLocationCode as parent_location_code,
    i.ParentLocationName as parent_location_name,
    COALESCE(b.LastModifiedDateTime,i.LastModifiedDateTime) as last_modified_datetime,   
    COALESCE(ExistsInIntelliHR,0) as exists_in_intelliHR,
    COALESCE(ExistsInBusinessCentral,0) as exists_in_business_central,
    b.CompanyName as company_name
FROM IntelliHR_Data i
FULL OUTER JOIN BusinessCentral_Data b ON i.LocationCode = b.LocationCode;