# Self-Service Semantic Model Standard Operating Procedure

> **Document Version:** 1.2.0 | **Effective Date:** 2026-01-29 | **Author:** Mike Gencic | **Parent Initiative:** #12229
> **Power BI Template:** [Template Semantic Model](/.attachments/Template%20Semantic%20Model-a0356c4e-b8d6-49ee-8048-eb6d52e6e9cd.zip)

This SOP establishes the guidelines, standards, and processes for creating, deploying, and maintaining **Self-Service Semantic Models** within the Emerge Aotearoa Power BI environment. It ensures consistency, quality, and discoverability across all self-service models while enabling business users to effectively explore and analyze data independently.

---

## Quick Reference Card

<details>
<summary><b>Critical Patterns at a Glance</b></summary><br>

| Pattern | Implementation |
|---------|----------------|
| **SCD Type 2 Filtering** | Always filter dimensions: `DWHIsCurrent = 1 AND DWHDMLOperation <> 'D'` |
| **Relationship Keys** | Use **business keys** (`property_id`) by default; use surrogate keys only for point-in-time analysis |
| **Naming Convention** | Apply `fnApplyNamingConventions` to all columns |
| **Technical Columns** | Hide all `*KEY`, `*ID`, and DWH audit columns (use Power BI Desktop UI) |
| **Display Folders** | Use numbered prefixes: `01. Property`, `02. Tenancy` |
| **Model Info Tables** | Create 4 DAX tables for self-documentation |
| **Changelog** | Maintain version history with Feature IDs |

</details>

---

## Process Overview

<details>
<summary><b>7-Phase Workflow Diagram</b></summary><br>

::: mermaid
graph TD
    classDef planning fill:#E3F2FD,stroke:#1565C0,stroke-width:2px
    classDef foundation fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px
    classDef schema fill:#FFF3E0,stroke:#E65100,stroke-width:2px
    classDef measures fill:#F3E5F5,stroke:#6A1B9A,stroke-width:2px
    classDef docs fill:#FFECB3,stroke:#FF8F00,stroke-width:2px
    classDef testing fill:#FCE4EC,stroke:#C2185B,stroke-width:2px
    classDef deploy fill:#B2DFDB,stroke:#00695C,stroke-width:3px

    A[Phase 1: Planning & Requirements]:::planning --> B[Phase 2: Foundation Setup]:::foundation
    B --> C[Phase 3: Schema Development]:::schema
    C --> D[Phase 4: Measures Development]:::measures
    D --> E[Phase 5: Documentation & Self-Service]:::docs
    E --> F[Phase 6: Testing & Validation]:::testing
    F --> G{All Tests Passed?}
    G -->|Yes| H[Phase 7: Deployment & Handoff]:::deploy
    G -->|No| C
:::

</details>

---

## Phase 1: Planning and Requirements

<details>
<summary><b>Step 1.1: Create Work Items</b></summary><br>

**Work Item Hierarchy:**
```
Initiative #12229: Self-Service Analytics Enablement
└── Epic: [Domain Name] Self-Service Semantic Model
    └── Feature: [Specific work item]
```

**Create Epic:**
1. Navigate to Azure DevOps → **Data and Analytics** project → Boards → Work Items
2. Create a new **Epic** with title: `[Domain Name] Self-Service Semantic Model`
3. Set the **Parent** link to Initiative **#12229 Self-Service Analytics Enablement**
4. Document in the Description:
   - Target audience
   - Data domains to include
   - Key metrics and measures required
   - Expected update frequency

**Create Feature:**
1. Create a new **Feature** under the Epic for the development work
2. Use naming convention: `Self-Service Semantic Model: [Domain Name] - [Phase/Work Description]`
3. All development work and commits reference the **Feature** work item ID

</details>

<details>
<summary><b>Step 1.2: Create Feature Branch (GitHub Desktop)</b></summary><br>

1. Open **GitHub Desktop**
2. Ensure the `Reports and Datasets` repository is selected
3. Click **Fetch origin** to get latest changes
4. Click **Current Branch** dropdown → **New Branch**
5. Name the branch: `feature/[FeatureID]-[Domain]-Self-Service-Dataset`
6. Base branch: `main`
7. Click **Create Branch**
8. Click **Publish branch** to push to Azure DevOps

**Example:** `feature/11331-Property-Self-Service-Dataset`

</details>

<details>
<summary><b>Step 1.3: Link Branch to Work Item</b></summary><br>

1. Navigate to Azure DevOps → **Data and Analytics** project → Boards → Work Items
2. Open the Feature (e.g., #11331)
3. Click **Add Link** → **Existing Item**
4. Link type: **Branch**
5. Browse or paste the branch name
6. Click **OK** to link the branch to the work item

</details>

<details>
<summary><b>Step 1.4: Identify Data Sources</b></summary><br>

1. Review EDW views (`edw.vw_*`) for relevant domain data
2. Document tables to include:
   - Dimension tables (e.g., `edw.vw_dim_property`)
   - Fact tables (e.g., `edw.vw_fact_property_inspection`)
   - Date dimension (`edw.vw_dim_date`)
3. Plan relationship key strategy: business keys by default, surrogate keys if point-in-time analysis is needed (see Step 3.3)

</details>

---

## Phase 2: Foundation Setup

> **Where to start:** Open **Power BI Desktop**. Ensure TMDL format is enabled: **File → Options → Preview Features → Store semantic model using TMDL format**.
>
> - **From the template:** Download the [Template Semantic Model](/.attachments/Template%20Semantic%20Model-a0356c4e-b8d6-49ee-8048-eb6d52e6e9cd.zip) ZIP from the link at the top of this SOP, extract it, and open the `.pbip` file.
> - **From scratch:** **File → Save As** → select **Power BI Project (`.pbip`)** format, and save into `Self Service Semantic Models/[Model Name].SemanticModel/`.

<details>
<summary><b>Step 2.1: Create Semantic Model Structure</b></summary><br>

1. Open Power BI Desktop
2. Save as PBIP format in: `Self Service Semantic Models/[Model Name].SemanticModel/`
3. File structure will be created automatically:
   ```
   [Model Name].SemanticModel/
   ├── definition/
   │   ├── model.tmdl
   │   ├── expressions.tmdl
   │   ├── relationships.tmdl
   │   ├── database.tmdl
   │   └── tables/
   │       └── *.tmdl
   └── .pbi/
   ```

</details>

<details>
<summary><b>Step 2.2: Configure Data Source Parameters</b></summary><br>

1. In Power BI Desktop, go to **Home → Manage Parameters → New Parameter**
2. Create the **Server** parameter:
   - Name: `Server`
   - Type: **Text**
   - Suggested Values: **List of values**
   - Values: `sql-dev-aue-svc-datawarehouse-01.database.windows.net` and `sql-prod-aus-svc-datawarehouse-01.database.windows.net`
   - Default Value: `sql-prod-aus-svc-datawarehouse-01.database.windows.net`
   - Current Value: `sql-prod-aus-svc-datawarehouse-01.database.windows.net`
3. Create the **Database** parameter:
   - Name: `Database`
   - Type: **Text**
   - Suggested Values: **List of values**
   - Values: `sqldb-dev-datawarehouse-01` and `sqldb-prod-datawarehouse-01`
   - Default Value: `sqldb-prod-datawarehouse-01`
   - Current Value: `sqldb-prod-datawarehouse-01`
4. Create the **Semantic Model** parameter:
   - Name: `Semantic Model`
   - Type: **Text**
   - Current Value: your model name (e.g., `Property Semantic Model`)
5. Power BI auto-saves these parameters to `expressions.tmdl`

<details>
<summary><i>Reference: What this looks like in TMDL</i></summary>

```
/// Azure SQL Server
expression Server = "sql-prod-aus-svc-datawarehouse-01.database.windows.net" meta [IsParameterQuery=true, List={"sql-dev-aue-svc-datawarehouse-01.database.windows.net", "sql-prod-aus-svc-datawarehouse-01.database.windows.net"}, DefaultValue="sql-prod-aus-svc-datawarehouse-01.database.windows.net", Type="Text", IsParameterQueryRequired=true]
	lineageTag: [generate new GUID]
	queryGroup: Parameters

	annotation PBI_NavigationStepName = Navigation

	annotation PBI_ResultType = Text

/// SQL Database
expression Database = "sqldb-prod-datawarehouse-01" meta [IsParameterQuery=true, List={"sqldb-dev-datawarehouse-01", "sqldb-prod-datawarehouse-01"}, DefaultValue="sqldb-prod-datawarehouse-01", Type="Text", IsParameterQueryRequired=true]
	lineageTag: [generate new GUID]
	queryGroup: Parameters

	annotation PBI_NavigationStepName = Navigation

	annotation PBI_ResultType = Text

/// Please enter the name of this dataset here.
expression 'Semantic Model' = "[Model Name]" meta [IsParameterQuery=true, Type="Text", IsParameterQueryRequired=true]
	lineageTag: [generate new GUID]
	queryGroup: Parameters

	annotation PBI_NavigationStepName = Navigation

	annotation PBI_ResultType = Exception
```

</details>

</details>

<details>
<summary><b>Step 2.3: Add Naming Convention Function</b></summary><br>

1. In Power BI Desktop, open **Power Query Editor** (Home → Transform Data)
2. Create a new blank query: **Home → New Source → Blank Query**
3. With the new query selected, open the **Advanced Editor** (Home → Advanced Editor)
4. Replace the contents with the following M function:

```m
(columnName as text) as text =>
let
    replaceClient = Text.Replace(columnName, "client_", "Tangata_Whaiora_"),
    replaceUnderscore = Text.Replace(replaceClient, "_", " "),
    capitaliseWords = Text.Proper(replaceUnderscore),
    // capitaliseID must run before fixIdentifier
    capitaliseID = Text.Replace(capitaliseWords, " Id", " ID"),
    // Fix Identifier after capitalising ID (fixes IDentifier back to Identifier)
    fixIdentifier = Text.Replace(capitaliseID, "IDentifier", "Identifier"),
    capitaliseKEY = Text.Replace(fixIdentifier, "Key", "KEY"),
    capitaliseDWH = Text.Replace(capitaliseKEY, "Dwh", "DWH"),
    capitaliseIRRS = Text.Replace(capitaliseDWH, "Irrs", "IRRS"),
    capitaliseDML = Text.Replace(capitaliseIRRS, "Dml", "DML"),
    capitaliseBOS = Text.Replace(capitaliseDML, "Bos", "BOS"),
    capitaliseHUD = Text.Replace(capitaliseBOS, "Hud", "HUD"),
    capitaliseMSD = Text.Replace(capitaliseHUD, "Msd", "MSD"),
    capitaliseSNG = Text.Replace(capitaliseMSD, "Sng", "SNG"),
    capitaliseEA = Text.Replace(capitaliseSNG, "Ea ", "EA ")
in
    capitaliseEA
```

5. Click **Done** to save the Advanced Editor
6. In the **Query Settings** pane (right side), rename the query to `fnApplyNamingConventions`
7. Right-click the query in the Queries pane (left side) → **Move to Group** → **New Group** → name it `Functions`
8. Click **Close & Apply** to return to Power BI Desktop
9. Power BI auto-saves this function to `expressions.tmdl`

**Naming Transformations:**

| Original | Transformed |
|----------|-------------|
| `property_id` | `Property ID` |
| `client_name` | `Tangata Whaiora Name` |
| `dim_date_key` | `Dim Date KEY` |
| `dwh_batch_id` | `DWH Batch ID` |
| `hud_code` | `HUD Code` |
| `msd_reference` | `MSD Reference` |

<details>
<summary><i>Reference: What this looks like in TMDL</i></summary>

```
/// Applies standard naming conventions to column names: replaces underscores with spaces, capitalises words, and fixes acronyms (ID, KEY, DWH, IRRS, DML, BOS, HUD, MSD, SNG, EA). Note: capitaliseID runs before fixIdentifier to correctly handle 'Identifier'.
expression fnApplyNamingConventions =
		(columnName as text) as text =>
		let
		    replaceClient = Text.Replace(columnName, "client_", "Tangata_Whaiora_"),
		    replaceUnderscore = Text.Replace(replaceClient, "_", " "),
		    capitaliseWords = Text.Proper(replaceUnderscore),
		    // capitaliseID must run before fixIdentifier
		    capitaliseID = Text.Replace(capitaliseWords, " Id", " ID"),
		    // Fix Identifier after capitalising ID (fixes IDentifier back to Identifier)
		    fixIdentifier = Text.Replace(capitaliseID, "IDentifier", "Identifier"),
		    capitaliseKEY = Text.Replace(fixIdentifier, "Key", "KEY"),
		    capitaliseDWH = Text.Replace(capitaliseKEY, "Dwh", "DWH"),
		    capitaliseIRRS = Text.Replace(capitaliseDWH, "Irrs", "IRRS"),
		    capitaliseDML = Text.Replace(capitaliseIRRS, "Dml", "DML"),
		    capitaliseBOS = Text.Replace(capitaliseDML, "Bos", "BOS"),
		    capitaliseHUD = Text.Replace(capitaliseBOS, "Hud", "HUD"),
		    capitaliseMSD = Text.Replace(capitaliseHUD, "Msd", "MSD"),
		    capitaliseSNG = Text.Replace(capitaliseMSD, "Sng", "SNG"),
		    capitaliseEA = Text.Replace(capitaliseSNG, "Ea ", "EA ")
		in
		    capitaliseEA
	lineageTag: [generate new GUID]
	queryGroup: Functions
```

</details>

</details>

<details>
<summary><b>Step 2.4: Create Changelog Table</b></summary><br>

Create `tables/Changelog.tmdl`:

```
table Changelog
	lineageTag: [generate new GUID]

	column 'Change ID'
		dataType: int64
		isHidden
		formatString: 0
		lineageTag: [generate new GUID]
		summarizeBy: none
		sourceColumn: Change ID

	column Version
		dataType: string
		lineageTag: [generate new GUID]
		summarizeBy: none
		sourceColumn: Version

	column 'Change Date'
		dataType: dateTime
		formatString: Short Date
		lineageTag: [generate new GUID]
		summarizeBy: none
		sourceColumn: Change Date

	column 'Changed By'
		dataType: string
		lineageTag: [generate new GUID]
		summarizeBy: none
		sourceColumn: Changed By

	column 'Feature ID'
		dataType: string
		lineageTag: [generate new GUID]
		summarizeBy: none
		sourceColumn: Feature ID

	column Description
		dataType: string
		lineageTag: [generate new GUID]
		summarizeBy: none
		sourceColumn: Description

	partition Changelog = m
		mode: import
		queryGroup: Changelog
		source =
			let
			    Source = #table(
			        type table [
			            Version = text,
			            #"Change Date" = date,
			            #"Changed By" = text,
			            #"Feature ID" = text,
			            Description = text
			        ],
			        {
			            {"0.0.0", #date(2025, 1, 20), "Your Name", "#[FeatureID]", "Initial semantic model creation"}
			        }
			    ),
			    AddIndex = Table.AddIndexColumn(Source, "Change ID", 1, 1, Int64.Type),
			    Reorder = Table.ReorderColumns(AddIndex, {"Change ID", "Version", "Change Date", "Changed By", "Feature ID", "Description"})
			in
			    Reorder
```

</details>

<details>
<summary><b>Step 2.5: Initial Commit (GitHub Desktop)</b></summary><br>

1. Open **GitHub Desktop** - changed files will appear in the left panel
2. Review changes in the diff view
3. Enter commit summary: `Initial semantic model scaffolding (#[FeatureID])`
4. Click **Commit to feature/[FeatureID]-[Domain]-Self-Service-Dataset**
5. Click **Push origin** to sync with Azure DevOps

</details>

---

## Phase 3: Schema Development

<details>
<summary><b>Step 3.1: Add Dimension Tables</b></summary><br>

For each dimension table, use this Power Query pattern:

```m
let
    Source = Sql.Database(Server, Database),
    Navigation = Source{[Schema = "edw", Item = "vw_dim_[entity]"]}[Data],
    FilterCurrent = Table.SelectRows(Navigation, each [DWHIsCurrent] = 1),
    RenameColumns = Table.TransformColumnNames(FilterCurrent, fnApplyNamingConventions)
in
    RenameColumns
```

**Critical SCD Type 2 Requirements:**
- Always filter `DWHIsCurrent = 1`
- For dimensions with delete tracking, also filter `DWHDMLOperation <> 'D'`
- Use business keys for relationships (NOT surrogate keys)
- Set `queryGroup: Dim Tables`

</details>

<details>
<summary><b>Step 3.2: Add Fact Tables</b></summary><br>

For each fact table (no SCD filter needed):

```m
let
    Source = Sql.Database(Server, Database),
    Navigation = Source{[Schema = "edw", Item = "vw_fact_[entity]"]}[Data],
    RenameColumns = Table.TransformColumnNames(Navigation, fnApplyNamingConventions)
in
    RenameColumns
```

Set `queryGroup: Fact Tables`

</details>

<details>
<summary><b>Step 3.3: Create Relationships</b></summary><br>

In `relationships.tmdl`:
```
relationship [Descriptive_Name]
    fromColumn: 'Fact Table'.'Key Column'
    toColumn: 'Dim Table'.'Key Column'
```

**Business Keys vs Surrogate Keys**

Business keys are the **recommended default** for most self-service scenarios. Use the table below to decide which key type to use:

| | Business Keys (e.g., `property_id`) | Surrogate Keys (e.g., `dim_property_key`) |
|---|---|---|
| **Stability** | Stable across SCD2 history changes | New key created for each SCD2 version |
| **Dimension values shown** | Always current values | Values as they were at the time of the fact event |
| **SCD2 dimension filter** | Filter `DWHIsCurrent = 1` (standard pattern) | Do NOT filter `DWHIsCurrent = 1` on the dimension |
| **Complexity** | Simpler to build and understand | Requires understanding of SCD2 history |
| **Best for** | Most reporting scenarios | Point-in-time analysis |

**When to Use Surrogate Keys**

Use surrogate keys when you need the dimension attribute **as it was at the time of the fact event**:
- **Point-in-time analysis:** e.g., a person's age at referral, the service name at the time of an activity
- **Historical referrals spanning years:** where the same person may have different attributes across referrals
- **Role-playing dimensions** where SCD2 history matters for each role

When using surrogate keys, do **not** filter `DWHIsCurrent = 1` on the dimension table — you need all historical versions so each fact row resolves to the correct dimension record.

| Relationship Type | Pattern |
|-------------------|---------|
| Fact → Dimension | Many-to-One (default) |
| Dimension → Sub-Dimension | Many-to-One |
| 1:1 Reference | One-to-One, bi-directional only if required |
| Role-Playing | Create inactive relationships |

</details>

<details>
<summary><b>Step 3.4: Hide Technical Columns</b></summary><br>

**How to Hide Columns:**

In **Power BI Desktop** (recommended):
1. In Model view or Data view, right-click the column
2. Select **Hide in report view**

Alternatively, in TMDL files add `isHidden` property:
```
column 'Dim Property KEY'
    isHidden
```

**Columns to Hide:**

**Surrogate Keys:**
- All `*KEY` columns

**Business Identifiers:**
- All `*ID` columns (except where needed for user filtering)

**DWH Audit Columns:**
- `DWHBatchId`, `DWHCreatedDate`, `DWHUpdatedDate`
- `DWHIsCurrent`, `DWHEffectiveFrom`, `DWHEffectiveTo`
- `DWHDMLOperation`, `DWHSourceSystem`

**Sensitive Data Categories:**
- PII: names, addresses, phone numbers, email (unless required)
- Financial: bank accounts, payment details
- Health: diagnosis codes, health status

</details>

<details>
<summary><b>Step 3.5: Standardize Date Formats</b></summary><br>

Apply `Short Date` format to all DateTime columns:

```
formatString: Short Date
```

</details>

---

## Phase 4: Measures Development

<details>
<summary><b>Step 4.1: Create Measures Table</b></summary><br>

Create `tables/Measures.tmdl`:

```
table Measures
	lineageTag: [generate new GUID]

	measure 'Latest Version' =
		CALCULATE(MAX(Changelog[Version]), TOPN(1, Changelog, Changelog[Change ID], DESC))
		lineageTag: [generate new GUID]

	partition Measures = m
		mode: import
		source = Table.FromRows({}, type table [])
```

</details>

<details>
<summary><b>Step 4.2: Organize Measures with Display Folders</b></summary><br>

Use numbered prefixes for folder ordering:

| Folder | Purpose | Example Measures |
|--------|---------|-----------------|
| `01. [Primary Entity]` | Core entity counts | Total Properties, Active Properties |
| `02. [Secondary Entity]` | Related entity measures | Total Tenancies, Occupied Units |
| `03. Financial` | Monetary calculations | Weekly Rent, Arrears Amount |
| `04. Operations` | Operational metrics | Avg Stay Weeks, Vacancy Rate |
| `05. Compliance` | Compliance percentages | Inspection Compliance % |

Example structure in TMDL:
```
measure 'Total Properties' =
    COUNTROWS(Property)
    formatString: #,0
    displayFolder: 01. Property Portfolio
    lineageTag: [GUID]
```

</details>

<details>
<summary><b>Step 4.3: DAX Format Strings</b></summary><br>

| Data Type | Format String |
|-----------|---------------|
| Currency (NZD) | `\$#,0.00;-\$#,0.00;\$#,0.00` |
| Percentage | `0.0%;-0.0%;0.0%` |
| Whole Number | `#,0` |
| Decimal | `#,0.00` |

</details>

<details>
<summary><b>Step 4.4: Common Measure Patterns</b></summary><br>

**Count Measure:**
```dax
measure 'Total [Entity]' = COUNTROWS([Table])
```

**Percentage Measure:**
```dax
measure '% [Metric]' =
    DIVIDE([Numerator Measure], [Denominator Measure], 0)
```

**Sum Measure:**
```dax
measure 'Total [Amount]' = SUM([Table][[Amount Column]])
```

**Average Measure:**
```dax
measure 'Avg [Metric]' = AVERAGE([Table][[Metric Column]])
```

**Year-to-Date (NZ Financial Year):**
```dax
measure '[Metric] YTD' =
    TOTALYTD([Metric], 'Date'[Date], "06/30")
```

</details>

---

## Phase 5: Documentation and Self-Service Features

<details>
<summary><b>Step 5.1: Add Column Descriptions</b></summary><br>

In each table TMDL file, add descriptions using triple-slash comments:

```
/// The unique business identifier for this property
column 'Property ID'

/// The current weekly rent amount charged for this property
column 'Weekly Rent'
```

</details>

<details>
<summary><b>Step 5.2: Create Model Info Tables</b></summary><br>

Create four DAX-calculated tables for model self-documentation:

**_Model Info - Tables** (`tables/_Model Info - Tables.tmdl`):
```
/// Model documentation table listing all tables in this semantic model with their descriptions, visibility, and storage mode. Use this to understand what data is available. This is metadata only - not for reporting data.
table '_Model Info - Tables'
	isHidden
	lineageTag: [generate new GUID]

	column 'Table Name'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Table Name]

	column Description
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Description]

	column 'Is Hidden'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Is Hidden]

	column 'Storage Mode'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Storage Mode]

	column 'Data Category'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Data Category]

	partition '_Model Info - Tables' = calculated
		mode: import
		source =
				SELECTCOLUMNS(
				    FILTER(
				        INFO.VIEW.TABLES(),
				        NOT(CONTAINSSTRING([Name], "LocalDateTable_")) &&
				        NOT(CONTAINSSTRING([Name], "DateTableTemplate_"))
				    ),
				    "Table Name", [Name],
				    "Description", [Description],
				    "Is Hidden", [IsHidden],
				    "Storage Mode", [StorageMode],
				    "Data Category", [DataCategory]
				)
```

**_Model Info - Columns** (`tables/_Model Info - Columns.tmdl`):
```
/// Model documentation table listing all columns in this semantic model. Shows column names, their parent tables, data types, descriptions, and formatting. Use this to find specific fields and understand data types. This is metadata only - not for reporting data.
table '_Model Info - Columns'
	isHidden
	lineageTag: [generate new GUID]

	column 'Column Name'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Column Name]

	column 'Table Name'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Table Name]

	column 'Data Type'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Data Type]

	column Description
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Description]

	column 'Is Hidden'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Is Hidden]

	column 'Format String'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Format String]

	column 'Sort By Column'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Sort By Column]

	column 'Display Folder'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Display Folder]

	column 'Data Category'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Data Category]

	partition '_Model Info - Columns' = calculated
		mode: import
		source =
				SELECTCOLUMNS(
				    FILTER(
				        INFO.VIEW.COLUMNS(),
				        NOT(CONTAINSSTRING([Table], "LocalDateTable_")) &&
				        NOT(CONTAINSSTRING([Table], "DateTableTemplate_"))
				    ),
				    "Column Name", [Name],
				    "Table Name", [Table],
				    "Data Type", [DataType],
				    "Description", [Description],
				    "Is Hidden", [IsHidden],
				    "Format String", [FormatString],
				    "Sort By Column", [SortByColumn],
				    "Display Folder", [DisplayFolder],
				    "Data Category", [DataCategory]
				)
```

**_Model Info - Measures** (`tables/_Model Info - Measures.tmdl`):
```
/// Model documentation table listing all measures in this semantic model. Shows measure names, DAX expressions, descriptions, and formatting. Use this to understand calculations and find specific measures. This is metadata only - not for reporting data.
table '_Model Info - Measures'
	isHidden
	lineageTag: [generate new GUID]

	column 'Measure Name'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Measure Name]

	column 'Table Name'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Table Name]

	column Description
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Description]

	column Expression
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Expression]

	column 'Format String'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Format String]

	column 'Is Hidden'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Is Hidden]

	column 'Display Folder'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Display Folder]

	column State
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [State]

	partition '_Model Info - Measures' = calculated
		mode: import
		source =
				SELECTCOLUMNS(
				    FILTER(
				        INFO.VIEW.MEASURES(),
				        NOT(CONTAINSSTRING([Table], "LocalDateTable_")) &&
				        NOT(CONTAINSSTRING([Table], "DateTableTemplate_"))
				    ),
				    "Measure Name", [Name],
				    "Table Name", [Table],
				    "Description", [Description],
				    "Expression", [Expression],
				    "Format String", [FormatString],
				    "Is Hidden", [IsHidden],
				    "Display Folder", [DisplayFolder],
				    "State", [State]
				)
```

**_Model Info - Relationships** (`tables/_Model Info - Relationships.tmdl`):
```
/// Model documentation table showing how tables are connected in this semantic model. Shows relationship direction, cardinality, and filter behavior. Use this to understand the data model structure. This is metadata only - not for reporting data.
table '_Model Info - Relationships'
	isHidden
	lineageTag: [generate new GUID]

	column Relationship
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Relationship]

	column 'From Table'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [From Table]

	column 'From Column'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [From Column]

	column 'From Cardinality'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [From Cardinality]

	column 'To Table'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [To Table]

	column 'To Column'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [To Column]

	column 'To Cardinality'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [To Cardinality]

	column 'Is Active'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Is Active]

	column 'Cross Filter Direction'
		isHidden
		lineageTag: [generate new GUID]
		isNameInferred
		sourceColumn: [Cross Filter Direction]

	partition '_Model Info - Relationships' = calculated
		mode: import
		source =
				SELECTCOLUMNS(
				    FILTER(
				        INFO.VIEW.RELATIONSHIPS(),
				        NOT(CONTAINSSTRING([FromTable], "LocalDateTable_")) &&
				        NOT(CONTAINSSTRING([ToTable], "LocalDateTable_")) &&
				        NOT(CONTAINSSTRING([FromTable], "DateTableTemplate_")) &&
				        NOT(CONTAINSSTRING([ToTable], "DateTableTemplate_"))
				    ),
				    "Relationship", [Relationship],
				    "From Table", [FromTable],
				    "From Column", [FromColumn],
				    "From Cardinality", [FromCardinality],
				    "To Table", [ToTable],
				    "To Column", [ToColumn],
				    "To Cardinality", [ToCardinality],
				    "Is Active", [IsActive],
				    "Cross Filter Direction", [CrossFilteringBehavior]
				)
```

</details>

<details>
<summary><b>Step 5.3: Update Changelog</b></summary><br>

Add entries for each significant version:

```m
{"0.1.0", #date(2025, 1, 1), "Your Name", "#[FeatureID]", "Added dimension tables with SCD2 filtering"},
{"0.1.1", #date(2025, 1, 2), "Your Name", "#[FeatureID]", "Added fact tables and relationships"},
{"0.1.2", #date(2025, 1, 3), "Your Name", "#[FeatureID]", "Added comprehensive measures"},
{"0.1.3", #date(2025, 1, 4), "Your Name", "#[FeatureID]", "Added self-documenting Model Info tables"},
{"1.0.0", #date(2025, 1, 5), "Your Name", "#[FeatureID]", "Release version - ready for production"}
```

</details>

---

## Phase 6: Testing and Validation

<details>
<summary><b>Testing Checklist</b></summary><br>

**1. Data Integrity Testing**
- [ ] Compare row counts and completeness against EDW published views
- [ ] Verify no data missing, duplicated, or incorrectly aggregated
- [ ] Confirm SCD2 filtering shows only current dimension records

**2. Cross-Validation Against Existing Reports**
- [ ] Identify existing production Power BI reports that cover the same domain
- [ ] Compare key metrics (totals, counts, percentages) between the new semantic model and existing reports
- [ ] If discrepancies exist, investigate whether the new model or the existing report has the correct logic

**3. Source System Validation**
- [ ] For critical metrics, spot-check a sample against the source system (e.g., verify a property's inspection count in the source application)
- [ ] This catches issues across the full pipeline, not just the semantic model layer

**4. Functional Testing**
- [ ] Test all relationships function correctly
- [ ] Verify measures return expected values
- [ ] Test drill-down and roll-up on hierarchies
- [ ] Confirm all display folders appear correctly

**5. Integration Testing**
- [ ] Verify table relationships are correctly defined
- [ ] Test cross-filtering behavior
- [ ] Confirm business keys (not surrogate keys) link correctly

**6. Performance Testing**
- [ ] Dataset refresh completes within acceptable time (<30 minutes)
- [ ] Scheduled refresh works without errors
- [ ] Complex measures respond within 5 seconds

**7. Self-Service Validation**
- [ ] Model Info tables display correct metadata
- [ ] Column descriptions appear in tooltips
- [ ] Technical columns are hidden
- [ ] Display folders organize measures logically

</details>

---

## Phase 7: Deployment and Handoff

<details>
<summary><b>Pre-Deployment Checklist</b></summary><br>

- [ ] All tests passed
- [ ] Changelog updated to release version (e.g., 1.0.0)
- [ ] Feature work item linked and updated
- [ ] Peer review completed

</details>

<details>
<summary><b>Create Pull Request</b></summary><br>

**In GitHub Desktop:**
1. Commit final changes with summary: `Release version 1.0.0 (#[FeatureID])`
2. Click **Push origin** to ensure all commits are synced

**In Azure DevOps:**
1. Navigate to **Repos** → **Pull Requests**
2. Click **New Pull Request**
3. Source branch: `feature/[FeatureID]-[Domain]-Self-Service-Dataset`
4. Target branch: `main`
5. Link the related Feature (#[FeatureID])

Create PR with:
- Summary of model contents
- Tables and measures included
- Target audience
- Test plan results

</details>

<details>
<summary><b>Merge and Deploy</b></summary><br>

1. Obtain PR approval from BI Team Lead
2. Merge to main branch
3. Publish to Power BI Service workspace
4. Configure scheduled refresh (6:30-7:30 AM NZT)
5. Set refresh failure alerts to `"BI Tasks!" email`

</details>

<details>
<summary><b>User Communication</b></summary><br>

1. Notify target audience of model availability
2. Share Model Info tables for self-service discovery
3. Provide workspace location and access instructions

</details>

---

## Standards Reference

<details>
<summary><b>Query Groups Organization</b></summary><br>

| Order | Query Group | Contents |
|-------|-------------|----------|
| 0 | Changelog | Version tracking table |
| 1 | Parameters | Server, Database, Semantic Model |
| 2 | Dim Date | Date dimension tables |
| 3 | Dim Tables | All other dimension tables |
| 4 | Functions | M code functions |
| 5 | Fact Tables | All fact tables |

</details>

<details>
<summary><b>Branch Naming Convention</b></summary><br>

```
feature/[FeatureID]-[Domain]-Self-Service-Dataset
```

Example: `feature/11331-Property-Self-Service-Dataset`

</details>

<details>
<summary><b>Commit Message Format</b></summary><br>

```
[Action] [Component] [Context] (#[FeatureID])
```

**Good Examples:**
- `Add Property dimension table with SCD2 filtering (#11331)`
- `Hide sensitive columns in Tenancy and Tenant tables (#11331)`
- `Add comprehensive property and tenancy measures (#11331)`

**Avoid:**
- `Update` (too vague)
- `Today's changes` (non-descriptive)
- `Fix` (without context)

</details>

<details>
<summary><b>Version Numbering</b></summary><br>

| Change Type | Version Increment | Example |
|-------------|-------------------|---------|
| Initial development | 0.x.x | 0.1.0, 0.2.0, 0.3.0 |
| Bug fix | x.x.+1 | 0.3.1, 0.3.2 |
| New feature | x.+1.0 | 0.4.0 |
| Breaking change | +1.0.0 | 1.0.0 |

**Note:** Version numbering continues incrementally. When ready for release, simply continue from your current version (e.g., if you're at 0.5.2, release as 0.5.2 or increment to 0.6.0). Do not restart numbering at 1.0.0.

</details>

---

## Common Pitfalls

<details>
<summary><b>Using the Wrong Key Type for Relationships</b></summary><br>

**Problem:** Using surrogate keys (`dim_property_key`) when you only need current dimension values causes unexpected behaviour — SCD Type 2 creates new surrogate keys for each historical version, leading to broken or duplicated relationships.

**Solution:** Use **business keys** by default. Only use surrogate keys when you specifically need point-in-time analysis (see Step 3.3 for guidance).

```m
// DEFAULT: Business keys (current dimension values)
relationship Property_Fact_BusinessKey
    fromColumn: Fact.'Property ID'
    toColumn: Property.'Property ID'

// POINT-IN-TIME: Surrogate keys (dimension values at time of fact event)
// NOTE: Do NOT filter DWHIsCurrent = 1 on the dimension when using this approach
relationship Property_Fact_SurrogateKey
    fromColumn: Fact.'Dim Property KEY'
    toColumn: Property.'Dim Property KEY'
```

</details>

<details>
<summary><b>Not Filtering SCD Type 2 Dimensions</b></summary><br>

**Problem:** Historical dimension records appear in reports, causing inflated counts.

**Solution:** Always filter dimensions to current records:

```m
FilterCurrent = Table.SelectRows(Navigation, each [DWHIsCurrent] = 1)
```

For dimensions with delete tracking:
```m
FilterCurrent = Table.SelectRows(Navigation, each [DWHIsCurrent] = 1 and [DWHDMLOperation] <> "D")
```

</details>

<details>
<summary><b>Exposing Technical Columns</b></summary><br>

**Problem:** Users see confusing technical columns (KEYs, IDs, DWH audit columns).

**Solution:** Systematically hide all technical columns in Power BI Desktop:
1. Right-click the column in Model view or Data view
2. Select **Hide in report view**

Alternatively via TMDL:
```
column 'Dim Property KEY'
    isHidden
```

</details>

<details>
<summary><b>Missing Changelog Updates</b></summary><br>

**Problem:** No version history for troubleshooting or user reference.

**Solution:** Update Changelog for every significant change. Include Feature ID.

</details>

<details>
<summary><b>Auto Date/Time Tables</b></summary><br>

**Problem:** 95+ auto-generated LocalDateTable instances increase model size.

**Solution:** Disable auto date/time in Power BI options if using a central Date Table:
- File > Options > Data Load > Time Intelligence > Uncheck "Auto date/time"

</details>

---

## Resources and References

<details>
<summary><b>Wiki Documentation</b></summary><br>

| Document | Purpose |
|----------|---------|
| [Power-BI-Semantic-Model-Creation-Guide](/BI-Team/Documentation-%2D-Analysts/Power-BI-Semantic-Model-Creation-Guide) | Comprehensive creation guide |
| [Testing-and-Sign-Off-process](/BI-Team/Documentation-%2D-Analysts/Testing-and-Sign%2DOff-process) | QA checklists |
| [Git-Workflow-for-Power-BI-Development](/BI-Team/Documentation-%2D-Analysts/Git-Workflow-for-Power-BI-Development) | Version control procedures |
| [Report-Release-Standard-Operating-Procedure](/BI-Team/Documentation-%2D-Analysts/Report-Release-Standard-Operating-Procedure) | T-day release timeline |

</details>

<details>
<summary><b>Example Model</b></summary><br>

| Model | Description | Location |
|-------|-------------|----------|
| Property Semantic Model | Reference implementation | `Self Service Semantic Models/Property Semantic Model.SemanticModel/` |

</details>

<details>
<summary><b>Tools and Resources</b></summary><br>

| Tool | Purpose | Access |
|------|---------|--------|
| Power BI Desktop | Model development | Local install |
| GitHub Desktop | Version control (branches, commits, push) | desktop.github.com |
| Azure DevOps | Work items, PRs, branch linking | EmergeAotearoa organization |
| DAX Studio | Advanced DAX analysis | Included with Power BI Desktop |
| Performance Analyzer | Visual performance | Included with Power BI Desktop |
| ALM Toolkit | Schema comparison and deployment | Included with Power BI Desktop |
| Bravo | DAX formatting and documentation | Included with Power BI Desktop |
| Tabular Editor | Advanced model editing | Included with Power BI Desktop |

</details>

<details>
<summary><b>Support Contacts</b></summary><br>

| Role | Contact | For |
|------|---------|-----|
| BI Team | "Analysts Assemble!" team chat in MS Teams | General inquiries, questions, support |
| BI Team Lead | Via Azure DevOps | Approvals, escalations |
| Data Engineering | Via Azure DevOps | EDW source issues |

</details>

---

## Glossary

| Term | Definition |
|------|------------|
| **Business Key** | Natural identifier from source system (e.g., property_id) |
| **Surrogate Key** | System-generated key (e.g., dim_property_key) |
| **SCD Type 2** | Slowly Changing Dimension with historical tracking |
| **DWHIsCurrent** | Flag indicating the current version of an SCD2 record |
| **TMDL** | Tabular Model Definition Language (Power BI metadata format) |
| **PBIP** | Power BI Project format (folder-based) |
| **RLS** | Row-Level Security |
| **EDW** | Enterprise Data Warehouse |
| **Epic** | Azure DevOps work item representing a semantic model project, parented to Initiative #12229 |
| **Feature** | Azure DevOps work item for development tasks, parented to an Epic |

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | 2025-01-01 | Mike Gencic | Initial SOP creation |
| 1.1.0 | 2025-01-20 | Mike Gencic | Enhanced with Property Semantic Model patterns, moved to Wiki |
| 1.1.1 | 2025-01-20 | Mike Gencic | Updated to Data and Analytics project, Epic/Feature hierarchy, UI-based column hiding |
| 1.1.2 | 2025-01-20 | Mike Gencic | Updated tools list, version numbering guidance, support contacts |
| 1.2.0 | 2026-01-29 | Mike Gencic | Rewrote Steps 2.2/2.3 as UI-first with TMDL reference sections; added "where to start" preamble to Phase 2; reframed business keys as recommended default with surrogate key guidance for point-in-time analysis; added cross-validation and source system validation to Phase 6 testing |

---

*This SOP should be reviewed annually and updated as practices evolve. For questions or feedback, contact the BI Team.*
