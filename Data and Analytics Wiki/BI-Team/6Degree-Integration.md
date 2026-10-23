# 6Degree Integration

## Overview

6Degree (6D) is a rostering and workforce management system. The objective of this data extraction is to establish a **mapping between the rostering services** provided and the entities (places of work) where services are delivered.

---

## Data Ingestion

- **Source:** Files are received from Theta as a **ZIP file**.
- **Upload method:** Files are manually uploaded to the Azure Storage Account.
- **Folder structure:** Files are organised by year and month folders.

> **Note:** 6D data is largely **static**. Changes only occur when there are additions or reductions in rostering hours for an entity (a place of work where services are provided).

---

## Data Model

6Degree data consists of **one dimension table** and **two fact tables**.

### Dimension Table

#### `six_degree_entity`
Builds the entity dimension with a **parent-child hierarchy** from the `sixdegrees.entity` table.

| Column | Description |
|--------|-------------|
| Entity ID | Unique identifier for the entity |
| Entity Name | Name of the place of work/service delivery location |
| Parent Entity | Parent in the hierarchy chain |

---

### Fact Tables

#### `fact_sixdegree_positionroster`
Surfaces **position-level roster data** (hours, FTE, allocated FTE) per entity, by joining `personnel_roster` to the position hierarchy.

| Column | Description |
|--------|-------------|
| Entity | Place of work |
| Position | Role/position title |
| Hours | Rostered hours |
| FTE | Full-time equivalent |
| Allocated FTE | FTE actually allocated |

---

#### `fact_six_degree_roster`
Contains **rostering data by pivoting the flattened table file**.

> **Important:** Raw data from 6D has been **flattened** and column names have been **renamed** to base mappings of 6D rostering. This means column names in the source CSV do not directly represent calendar months — they represent day abbreviations mapped to months based on the selected roster year.

---

## Column Mapping — Period to Month
![frontedroster.png](/.attachments/frontedroster-42bfeb72-0ce0-44c4-9458-8db3975fed39.png)

When data is extracted for a given roster year, the day-of-week columns map to calendar months as follows:

| Column Header | Actual Month |
|---------------|--------------|
| Mon | July |
| Tue | August |
| Wed | September |
| Thu | October |
| Fri | November |
| Sat | December |
| Sun | January |
| Shifts per week | Total |
| FTE per week | Roster |

---

## Important Filtering Notes

### Year CSV Behaviour
If `Year.csv` is set to eg:2025, the `roseter_fact_person` CSV will **not contain useful information**. 

This applies to other CSV files as well.

> At first glance it may appear that data matches, but filtering by `entity_name` will return **NULL** results. Always validate entity name filters before assuming data integrity.

### Required Filters per CSV

Apply the following filters to ensure only valid roster data is returned:

| CSV File | Filter Value |
|----------|--------------|
| `Scenario.csv` | `Roster` |
| `Staff.csv` | `Roster` |
| `Position.csv` | `NA` (to find roster staff for week)|
| `Year.csv` | `Roster` |

---

## Summary

| Item | Detail |
|------|--------|
| Data Source | Theta (ZIP file delivery) |
| Storage | Azure Storage Account (manual upload, year/month folders) |
| Data Frequency | Static — changes only on rostering hour adjustments |
| Dimension Table | `six_degree_entity` |
| Fact Table 1 | `fact_sixdegree_positionroster` |
| Fact Table 2 | `fact_six_degree_roster` |
| Primary Use Case | Mapping rostering services to entities |
