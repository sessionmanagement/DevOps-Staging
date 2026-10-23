
CREATE   view [ETL].[dim_property_breach_type] as 

--=========================================================================================================
--View		    etl.dim_property_breach_type 
--Author		Greg Nuthall
--Created		2025-07-15
--Purpose		property breach type from zavanti.vw_zav_tenancybreach to generate dim_property_breach_type
--				This script extracts individual breach type IDs from a semicolon-delimited string in the 
--              zavanti.vw_zav_tenancybreach view, maps them to their corresponding localized labels using the vw_GlobalOptionsetMetadata
--              view, and returns a distinct list of breach type IDs and their descriptions. 
--              The script uses a common table expression (CTE) to split the breach type string and then joins to metadata for descriptive output.
--=========================================================================================================
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		 2025-07-15    Greg Nuthall		Initial version
----------------------------------------------------------------------

    with breach_split as (
    SELECT
        tb.zav_breachtype
        ,value AS SplitValue
    FROM
        zavanti.vw_zav_tenancybreach tb
    CROSS APPLY
        STRING_SPLIT(tb.zav_breachtype, ';'))

    select cast(SplitValue as int) as breach_type_id
    ,cast(m.LocalizedLabel as nvarchar(80)) as breach_type

    from breach_split
    inner join [Zavanti].[vw_GlobalOptionsetMetadata] m on SplitValue = m.[Option]
    and optionsetname = 'zav_breachtype'

    group by SplitValue
    ,m.LocalizedLabel