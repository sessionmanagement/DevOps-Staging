# Healthy Homes

## Table of Contents
1. [Overview](#overview)
2. [Data Classification](#data-classification)
3. [Column Reference](#column-reference)
4. [Source SQL](#source-sql)
5. [Transformation Notes](#transformation-notes)
6. [Relationships](#relationships)
7. [Related Measures](#related-measures)

---

## Overview

| Property | Value |
|----------|-------|
| **Power BI Table Name** | Healthy Homes |
| **Source** | `edw.dim_property_healthy_homes` |
| **Query Group** | Dim Tables |
| **Row Description** | Each row represents Healthy Homes Standards compliance data for a single property |
| **Column Count** | 69 |
| **Overall Classification** | In-Confidence |

The Healthy Homes table tracks compliance with New Zealand's Healthy Homes Standards for each property. It contains insulation (ceiling, underfloor, wall), heating, ventilation, moisture barrier, and draught-stopping compliance data. This table has a 1:1 bidirectional relationship with the Property table, as each property has at most one Healthy Homes compliance record. All compliance data is classified as In-Confidence due to its regulatory nature.

---

## Data Classification

Per the **Emerge Aotearoa Data Classification & Handling Policy**, columns are classified:

| Level | Description | Examples in this table |
|-------|-------------|----------------------|
| :green_circle: **Public** | Non-sensitive business data | Property ID (hidden, key only) |
| :yellow_circle: **In-Confidence** | Regulatory compliance data requiring controlled access | All insulation, heating, ventilation, moisture, and draught compliance fields |
| :red_circle: **Sensitive** | No sensitive (PII) columns in this table | N/A |

---

## Column Reference

| # | Column Name | Data Type | Visibility | Classification | Description |
|---|------------|-----------|------------|----------------|-------------|
| 1 | Property ID | string | Hidden | :green_circle: Public | FK to Property (business key) |
| 2 | General Non-Compliance Reason | string | Visible | :yellow_circle: In-Confidence | Reason for general non-compliance |
| 3 | Kitchen Exemption Reason | string | Visible | :yellow_circle: In-Confidence | Reason for kitchen standard exemption |
| 4 | Exterior Walls Insulated | string | Visible | :yellow_circle: In-Confidence | Whether exterior walls are insulated |
| 5 | Has Bathroom Extractor Fan | string | Visible | :yellow_circle: In-Confidence | Whether bathroom has extraction fan venting outside |
| 6 | Has Kitchen Extractor Fan | string | Visible | :yellow_circle: In-Confidence | Whether kitchen has extraction fan venting outside |
| 7 | Underfloor Insulation Coverage | string | Visible | :yellow_circle: In-Confidence | Extent of underfloor insulation |
| 8 | Are Open Fireplaces Blocked | string | Visible | :yellow_circle: In-Confidence | Whether open fireplaces have been blocked |
| 9 | Compliance Statement | string | Visible | :yellow_circle: In-Confidence | Overall Healthy Homes compliance statement |
| 10 | Moisture Barrier Absence Reason | string | Visible | :yellow_circle: In-Confidence | Reason moisture barrier is not in place |
| 11 | Ceiling Insulation Exemption Reason | string | Visible | :yellow_circle: In-Confidence | Reason for ceiling insulation exemption |
| 12 | Underfloor Insulation Exemption Reason | string | Visible | :yellow_circle: In-Confidence | Reason for underfloor insulation exemption |
| 13 | Is Exempt From Moisture Barrier | string | Visible | :yellow_circle: In-Confidence | Whether exempt from moisture barrier requirement |
| 14 | Bathroom Vent Non-Compliance Reason | string | Visible | :yellow_circle: In-Confidence | Reason for bathroom ventilation non-compliance |
| 15 | Is Exempt From Kitchen Standard | string | Hidden | :yellow_circle: In-Confidence | Whether exempt from kitchen standard |
| 16 | Heating Insufficiency Reason | string | Visible | :yellow_circle: In-Confidence | Reason heating is insufficient |
| 17 | Ceiling Insulation Condition | string | Visible | :yellow_circle: In-Confidence | Condition of ceiling insulation |
| 18 | Has Ceiling Insulation | string | Visible | :yellow_circle: In-Confidence | Whether ceiling insulation is present |
| 19 | Ceiling Insulation Type | string | Visible | :yellow_circle: In-Confidence | Type of ceiling insulation |
| 20 | Has Wall Insulation | string | Visible | :yellow_circle: In-Confidence | Whether wall insulation is present |
| 21 | Has Underfloor Insulation | string | Visible | :yellow_circle: In-Confidence | Whether underfloor insulation is present |
| 22 | Has Subfloor Moisture Barrier | string | Visible | :yellow_circle: In-Confidence | Whether subfloor moisture barrier is in place |
| 23 | Is Bathroom Ventilation Compliant | string | Visible | :yellow_circle: In-Confidence | Bathroom ventilation compliance status |
| 24 | Has Adequate Guttering | string | Visible | :yellow_circle: In-Confidence | Whether guttering and downpiping is adequate |
| 25 | Is Property Draught-Free | string | Visible | :yellow_circle: In-Confidence | Whether property is free of unreasonable gaps |
| 26 | Is Kitchen Ventilation Compliant | string | Visible | :yellow_circle: In-Confidence | Kitchen ventilation compliance status |
| 27 | Main Heat Source | string | Visible | :yellow_circle: In-Confidence | Primary heat source type |
| 28 | Ceiling Insulation Exemption Details | string | Visible | :yellow_circle: In-Confidence | Details of ceiling insulation exemption |
| 29 | Kitchen Vent Exemption Reason | string | Visible | :yellow_circle: In-Confidence | Reason for kitchen ventilation exemption |
| 30 | Bathroom Vent Exemption Reason | string | Visible | :yellow_circle: In-Confidence | Reason for bathroom ventilation exemption |
| 31 | Secondary Heat Source | string | Visible | :yellow_circle: In-Confidence | Secondary heat source type |
| 32 | Underfloor Insulation Type | string | Visible | :yellow_circle: In-Confidence | Type of underfloor insulation |
| 33 | Wall Insulation Type | string | Visible | :yellow_circle: In-Confidence | Type of wall insulation |
| 34 | Underfloor Insulation Condition | string | Visible | :yellow_circle: In-Confidence | Condition of underfloor insulation |
| 35 | Bathroom Fan Install Date | string | Visible | :yellow_circle: In-Confidence | When bathroom extraction fan was installed |
| 36 | Kitchen Fan Install Date | string | Visible | :yellow_circle: In-Confidence | When kitchen extraction fan was installed |
| 37 | Habitable Rooms Without Door Or Window | string | Visible | :yellow_circle: In-Confidence | Which rooms lack a door or window |
| 38 | Habitable Room Exemption Reason | string | Visible | :yellow_circle: In-Confidence | Reason room is exempt from the standard |
| 39 | Ceiling Insulation Year Installed | string | Visible | :yellow_circle: In-Confidence | Year ceiling insulation was installed |
| 40 | Underfloor Insulation Year Installed | string | Visible | :yellow_circle: In-Confidence | Year underfloor insulation was installed |
| 41 | Wall Insulation Year Installed | string | Visible | :yellow_circle: In-Confidence | Year wall insulation was installed |
| 42 | Is Generally Exempt | int64 | Visible | :yellow_circle: In-Confidence | 1 = general exemption applies (flag) |
| 43 | Ceiling Insulation Meets Standard | int64 | Visible | :yellow_circle: In-Confidence | 1 = meets standard (flag) |
| 44 | Kitchen Standard Exemption Type | string | Hidden | :yellow_circle: In-Confidence | Type of kitchen standard exemption |
| 45 | Bathroom Fan Capacity (L/s) | double | Visible | :yellow_circle: In-Confidence | Bathroom extraction fan capacity in litres/second |
| 46 | Kitchen Fan Capacity (L/s) | double | Visible | :yellow_circle: In-Confidence | Kitchen extraction fan capacity in litres/second |
| 47 | Ceiling Insulation Last Inspected | date | Visible | :yellow_circle: In-Confidence | Date ceiling insulation was last inspected |
| 48 | Underfloor Insulation Last Inspected | date | Visible | :yellow_circle: In-Confidence | Date underfloor insulation was last inspected |
| 49 | Healthy Homes Compliance Date | date | Visible | :yellow_circle: In-Confidence | Date of compliance assessment |
| 50 | Healthy Homes Statement Date | date | Visible | :yellow_circle: In-Confidence | Date of compliance statement |
| 51 | Bathroom Ventilation Comments | string | Visible | :yellow_circle: In-Confidence | Free-text comments on bathroom ventilation |
| 52 | Ceiling Insulation Comments | string | Visible | :yellow_circle: In-Confidence | Free-text comments on ceiling insulation |
| 53 | Draught Stopping Comments | string | Visible | :yellow_circle: In-Confidence | Free-text comments on draught stopping |
| 54 | Exterior Wall Comments | string | Visible | :yellow_circle: In-Confidence | Free-text comments on exterior walls |
| 55 | Habitable Rooms Comments | string | Visible | :yellow_circle: In-Confidence | Free-text comments on habitable rooms |
| 56 | Heating Compliance Comments | string | Visible | :yellow_circle: In-Confidence | Free-text comments on heating compliance |
| 57 | Kitchen Ventilation Comments | string | Visible | :yellow_circle: In-Confidence | Free-text comments on kitchen ventilation |
| 58 | Moisture & Drainage Comments | string | Visible | :yellow_circle: In-Confidence | Free-text comments on moisture and drainage |
| 59 | Underfloor Insulation Comments | string | Visible | :yellow_circle: In-Confidence | Free-text comments on underfloor insulation |
| 60 | Kitchen Fan Duct Diameter (mm) | double | Visible | :yellow_circle: In-Confidence | Kitchen fan duct diameter in millimetres |
| 61 | Main Heat Source Capacity (kW) | double | Visible | :yellow_circle: In-Confidence | Main heat source capacity in kilowatts |
| 62 | Required Living Area Heating (kW) | double | Visible | :yellow_circle: In-Confidence | Required heating for living area in kilowatts |
| 63 | Ceiling Insulation R-Value | double | Visible | :yellow_circle: In-Confidence | R-value of ceiling insulation |
| 64 | Underfloor Insulation R-Value | double | Visible | :yellow_circle: In-Confidence | R-value of underfloor insulation |
| 65 | Wall Insulation R-Value | double | Visible | :yellow_circle: In-Confidence | R-value of wall insulation |
| 66 | Secondary Heat Source Capacity (kW) | double | Visible | :yellow_circle: In-Confidence | Secondary heat source capacity in kilowatts |
| 67 | Ceiling Insulation Thickness (mm) | double | Visible | :yellow_circle: In-Confidence | Ceiling insulation thickness in millimetres |
| 68 | Bathroom Fan Duct Diameter (mm) | double | Visible | :yellow_circle: In-Confidence | Bathroom fan duct diameter in millimetres |
| 69 | Do All Habitable Rooms Have a Door | string | Visible | :yellow_circle: In-Confidence | Whether all habitable rooms have a door |

---

## Source SQL

```sql
SELECT
    [property_healthy_homes_id]                                                             AS [Property ID],
    [property_healthy_homes_if_not_what_is_the_reason]                                      AS [General Non-Compliance Reason],
    [property_healthy_homes_reason_for_kitchen_exemption]                                    AS [Kitchen Exemption Reason],
    [property_healthy_homes_are_the_exterior_walls_insulated]                                AS [Exterior Walls Insulated],
    [property_healthy_homes_does_the_bathrooms_have_an_extraction_fan_which_vents_outside]   AS [Has Bathroom Extractor Fan],
    [property_healthy_homes_does_the_kitchen_have_an_extraction_fan_which_vents_outside]     AS [Has Kitchen Extractor Fan],
    [property_healthy_homes_extent_of_underfloor_insulation]                                 AS [Underfloor Insulation Coverage],
    [property_healthy_homes_have_all_open_fireplaces_been_blocked]                           AS [Are Open Fireplaces Blocked],
    [property_healthy_homes_healthy_homes_compliance_statement]                              AS [Compliance Statement],
    [property_healthy_homes_if_a_moisture_barrier_is_not_in_place_what_is_the_reason]        AS [Moisture Barrier Absence Reason],
    [property_healthy_homes_if_the_ceiling_insulation_is_exempt_from_the_healthy_homes]      AS [Ceiling Insulation Exemption Reason],
    [property_healthy_homes_if_the_ceiling_insulation_is_exempt_underfloor]                  AS [Underfloor Insulation Exemption Reason],
    [property_healthy_homes_if_the_property_is_exempt_from_requiring_a_moisture_barrier]     AS [Is Exempt From Moisture Barrier],
    [property_healthy_homes_reason_for_non_compliance_of_bathroom_ventilation]               AS [Bathroom Vent Non-Compliance Reason],
    [property_healthy_homes_if_the_property_is_exempt_from_the_healthy_homes_kitchen]        AS [Is Exempt From Kitchen Standard],
    [property_healthy_homes_if_there_is_not_enough_heating_what_is_the_reason]               AS [Heating Insufficiency Reason],
    [property_healthy_homes_insulation_ceiling_condition]                                    AS [Ceiling Insulation Condition],
    [property_healthy_homes_insulation_ceiling_status]                                       AS [Has Ceiling Insulation],
    [property_healthy_homes_insulation_ceiling_type]                                         AS [Ceiling Insulation Type],
    [property_healthy_homes_insulation_in_wall_status]                                       AS [Has Wall Insulation],
    [property_healthy_homes_insulation_under_floor_status]                                   AS [Has Underfloor Insulation],
    [property_healthy_homes_is_an_appropriate_moisture_barrier_in_place_in_the_enclosed_subfloor] AS [Has Subfloor Moisture Barrier],
    [property_healthy_homes_is_the_bathroom_ventilation_compliant_with_the_healthy_homes]    AS [Is Bathroom Ventilation Compliant],
    [property_healthy_homes_is_the_guttering_and_downpiping_sufficient_for_drainage]         AS [Has Adequate Guttering],
    [property_healthy_homes_is_the_property_free_of_unintentional_or_unreasonable_gaps]      AS [Is Property Draught-Free],
    [property_healthy_homes_kitchen_is_the_bathroom_ventilation_compliant]                   AS [Is Kitchen Ventilation Compliant],
    [property_healthy_homes_main_heatsource]                                                 AS [Main Heat Source],
    [property_healthy_homes_reason_for_ceiling_insulation_exemption]                         AS [Ceiling Insulation Exemption Details],
    [property_healthy_homes_reason_for_exemption_kitchen_ventilation]                        AS [Kitchen Vent Exemption Reason],
    [property_healthy_homes_reason_for_exemption_bathroom_ventilation]                       AS [Bathroom Vent Exemption Reason],
    [property_healthy_homes_secondary_heat_source]                                           AS [Secondary Heat Source],
    [property_healthy_homes_type_of_insulation_underfloor]                                   AS [Underfloor Insulation Type],
    [property_healthy_homes_type_of_insulation_wall]                                         AS [Wall Insulation Type],
    [property_healthy_homes_underfloor_insulation_condition]                                 AS [Underfloor Insulation Condition],
    [property_healthy_homes_when_was_the_extraction_fan_installed]                           AS [Bathroom Fan Install Date],
    [property_healthy_homes_when_was_the_extraction_fan_installed_kitchen_ventilation]        AS [Kitchen Fan Install Date],
    [property_healthy_homes_which_habitable_rooms_have_no_door_or_window]                    AS [Habitable Rooms Without Door Or Window],
    [property_healthy_homes_why_is_this_room_exempt_from_the_healthy_homes_standard]         AS [Habitable Room Exemption Reason],
    [property_healthy_homes_year_insulation_was_installed_if_known]                           AS [Ceiling Insulation Year Installed],
    [property_healthy_homes_year_insulation_was_installed_if_known_underfloor]                AS [Underfloor Insulation Year Installed],
    [property_healthy_homes_year_insulation_was_installed_if_known_wall]                      AS [Wall Insulation Year Installed],
    [property_healthy_homes_a_general_exemption_applies_to_this_property_flag]                AS [Is Generally Exempt],
    [property_healthy_homes_ceiling_insulation_meets_standard_flag]                           AS [Ceiling Insulation Meets Standard],
    [property_healthy_homes_kitchen_the_property_is_exempt_from_the_healthy_home]             AS [Kitchen Standard Exemption Type],
    [property_healthy_homes_what_is_exhaust_capacity_of_the_extraction_unit]                  AS [Bathroom Fan Capacity (L/s)],
    [property_healthy_homes_what_is_exhaust_capacity_of_unit]                                 AS [Kitchen Fan Capacity (L/s)],
    CAST([property_healthy_homes_date_insulation_was_last_inspected] AS DATE)                 AS [Ceiling Insulation Last Inspected],
    CAST([property_healthy_homes_date_the_underfloor_insulation_was_last_inspected] AS DATE)  AS [Underfloor Insulation Last Inspected],
    CAST([property_healthy_homes_compliance_date] AS DATE)                                    AS [Healthy Homes Compliance Date],
    CAST([property_healthy_homes_statement_date] AS DATE)                                     AS [Healthy Homes Statement Date],
    [property_healthy_homes_bathroom_vent_compliance_comments]                                AS [Bathroom Ventilation Comments],
    [property_healthy_homes_ceiling_compliance_comments]                                      AS [Ceiling Insulation Comments],
    [property_healthy_homes_draught_compliance_comments]                                      AS [Draught Stopping Comments],
    [property_healthy_homes_external_wall_compliance_comments]                                AS [Exterior Wall Comments],
    [property_healthy_homes_habitable_rooms_compliance_comments]                              AS [Habitable Rooms Comments],
    [property_healthy_homes_heating_compliance_comments]                                      AS [Heating Compliance Comments],
    [property_healthy_homes_kitchen_vent_compliance_comments]                                 AS [Kitchen Ventilation Comments],
    [property_healthy_homes_moist_drain_compliance_comments]                                  AS [Moisture & Drainage Comments],
    [property_healthy_homes_underfloor_compliance_comments]                                   AS [Underfloor Insulation Comments],
    [property_healthy_homes_kitchen_extraction_unit_diameter]                                 AS [Kitchen Fan Duct Diameter (mm)],
    [property_healthy_homes_main_heat_source_capacity_kw]                                    AS [Main Heat Source Capacity (kW)],
    [property_healthy_homes_required_heating_capacity_for_living_area_kw]                     AS [Required Living Area Heating (kW)],
    [property_healthy_homes_r_value_of_insulation]                                           AS [Ceiling Insulation R-Value],
    [property_healthy_homes_r_value_of_insulation_underfloor]                                AS [Underfloor Insulation R-Value],
    [property_healthy_homes_r_value_of_insulation_wall]                                      AS [Wall Insulation R-Value],
    [property_healthy_homes_secondaryheatsourcecapacitykw]                                   AS [Secondary Heat Source Capacity (kW)],
    [property_healthy_homes_thickness_of_insulation]                                         AS [Ceiling Insulation Thickness (mm)],
    [property_healthy_homes_extraction_unit_diameter]                                        AS [Bathroom Fan Duct Diameter (mm)],
    [property_healthy_homes_do_all_habitable_rooms_of_the_property_have_a_door]              AS [Do All Habitable Rooms Have a Door]
FROM [edw].[dim_property_healthy_homes]
WHERE [DWHDMLOperation] <> 'D'
    AND [DWHIsCurrent] = 1
    AND [property_healthy_homes_id] IS NOT NULL
    AND [property_healthy_homes_is_delete_flag] IS NULL;
```

---

## Transformation Notes

- **fnApplyNamingConventions**: Replaces underscores with spaces, applies proper case. Capitalises ID, KEY, DWH.
- **Column rename in M**: "Do All Habitable Rooms Havea Door" corrected to "Do All Habitable Rooms Have a Door" (fixing source typo with missing space).
- **Filters**:
  - `DWHDMLOperation <> 'D'` (exclude deleted records)
  - `DWHIsCurrent = 1` (current SCD Type 2 record only)
  - `property_healthy_homes_id IS NOT NULL`
  - `property_healthy_homes_is_delete_flag IS NULL` (exclude soft-deleted records)
- **Type conversions**: `property_healthy_homes_date_insulation_was_last_inspected`, `property_healthy_homes_date_the_underfloor_insulation_was_last_inspected`, `property_healthy_homes_compliance_date`, `property_healthy_homes_statement_date` all CAST to DATE

---

## Relationships

| From Table | From Column | To Table | To Column | Cardinality | Cross Filter |
|-----------|-------------|----------|-----------|-------------|-------------|
| Healthy Homes | Property ID | Property | Property ID | One-to-One | Both |

---

## Related Measures

| Measure | Folder | Description |
|---------|--------|-------------|
| Compliant Properties | 07. Healthy Homes | Count of properties with compliant status |
| Non-Compliant Properties | 07. Healthy Homes | Count of properties with non-compliant status |
| Compliance Rate % | 07. Healthy Homes | Percentage of properties meeting Healthy Homes Standards |
| Has Ceiling Insulation Count | 07. Healthy Homes | Count of properties with ceiling insulation |
| Has Underfloor Insulation Count | 07. Healthy Homes | Count of properties with underfloor insulation |
| Has Wall Insulation Count | 07. Healthy Homes | Count of properties with wall insulation |
| Adequate Heating Count | 07. Healthy Homes | Count of properties with adequate heating |
| Exempt Properties | 07. Healthy Homes | Count of generally exempt properties |
