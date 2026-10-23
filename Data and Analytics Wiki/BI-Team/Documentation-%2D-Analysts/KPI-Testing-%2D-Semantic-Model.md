# KPI stored-procedure testing framework

This semantic model has a built-in, **parameter-gated** capability to test new / updated KPI stored
procedures directly in Power Query (mashup) **before** they are deployed to the EDW and wired into
`kpi.fact_kpi_current`.

You paste a stored procedure's code **verbatim** into a test query; when testing is enabled the framework
runs it, shapes its output to the `fact_kpi` schema, swaps it in for the production version of that KPI in
**Fact KPI**, and summarises new-vs-current in the **KPI Test Comparison** table.

**It ships dormant.** The `Enable KPI Testing` parameter defaults to **False**, so a normal refresh behaves
exactly like production — no procedures run, no rows are swapped, the comparison table is empty.

---

## The switch: `Enable KPI Testing`

A True/False parameter in the **KPI Testing** query group.

- **False (default)** → testing off. Fact KPI = pure production. No test procedure runs on refresh.
- **True** → the wired test query(ies) run; their KPIs replace the production versions in Fact KPI and
  populate KPI Test Comparison.

Set it in **Power BI Desktop** → Home ▸ *Transform data* ▸ *Manage Parameters* (or the Model-view
Parameters pane), or in the **Service** → dataset ▸ *Settings* ▸ *Parameters*. Flip to **True**, refresh.

---

## What's wired

```
 Enable KPI Testing (False ──► no procs run, model = production)
        │ True
        ▼
 Test KPI 63 Inspections ──► Test KPIs Combined ─► (a) injected into Fact KPI (prod rows for the
   (the one placeholder)                                tested kpi_ids removed, test rows appended)
                                                   (b) summarised in KPI Test Comparison vs prod
```

One placeholder test query ships in the model: **`Test KPI 63 Inspections`**. It is the template you edit
to test whatever procedure you're working on.

Each `Test KPI …` query:
1. Holds the **entire `CREATE PROCEDURE … AS BEGIN … END` text, unchanged**, in an M string.
2. `fnExtractProcBody` strips the `CREATE PROCEDURE … AS` header **at runtime** (you never edit the SQL).
3. `Value.NativeQuery(… , [EnableFolding = false])` runs the `BEGIN…END` batch against the server/database
   the report points at. Temp tables and `;WITH` CTEs are supported; the procedure only `SELECT`s.
4. `fnAlignToFactKpi` pads the procedure's columns up to the full 21-column `fact_kpi_current` shape and
   coerces `snapshot_date` to a pure `date` (so it matches the navigation-sourced production column).

`Test KPIs Combined` is the gate + collector:
```m
parts    = if #"Enable KPI Testing" then { #"Test KPI 63 Inspections" } else {},
combined = if List.IsEmpty(parts) then fnAlignToFactKpi(#table({}, {})) else Table.Combine(parts),
```
When disabled, `parts` is empty so **no test query is referenced and no procedure runs**; it returns an
empty 21-column table. Fact KPI then sees no test rows, removes nothing, and behaves exactly as before.

**Fact KPI** (partition M) injects at the snake-case source level and auto-excludes the production version
of each tested KPI; the old `{12, 26, 67, 71, 92}` hard-exclusion was widened so it never deletes a KPI you
are testing. With testing off, `TestKpiIds` is empty and this all reduces to the original behaviour.

---

## Test a KPI

1. **Set `Enable KPI Testing` = True** (Manage Parameters), if it isn't already.
2. Decide what to test:
   - **Replace the placeholder** — open `Test KPI 63 Inspections` in the Advanced Editor and paste your
     procedure verbatim between the `"` quotes after `ProcText =`. Done. (To keep it labelled correctly,
     rename the query to match the KPI you're testing.)
   - **Add another** alongside it — create a blank query in the **KPI Testing** group with this skeleton:
     ```m
     let
         ProcText = "PASTE THE WHOLE CREATE PROCEDURE … END HERE, VERBATIM",
         Body = fnExtractProcBody(ProcText),
         Result = Value.NativeQuery(Sql.Database(Server, Database, [CommandTimeout=#duration(0,0,10,0)]), Body, null, [EnableFolding=false]),
         Aligned = fnAlignToFactKpi(Result)
     in
         Aligned
     ```
     then add it to `Test KPIs Combined` → `parts`:
     ```m
     parts = if #"Enable KPI Testing" then {
         #"Test KPI 63 Inspections",
         #"Test KPI 200 Something"        // ← your new query
     } else {},
     ```
3. **Refresh.** The tested KPI(s) replace their production version in Fact KPI; `New (test)` vs
   `Current (prod)` rows appear in KPI Test Comparison.
4. **When finished**, set `Enable KPI Testing` = False (and/or revert the placeholder's proc text).

The prod-row exclusion is automatic from the `kpi_id` each procedure emits — nothing else to maintain.

> Pasting verbatim: the Advanced Editor keeps your line breaks; on save Power BI stores them as `#(lf)`.
> The executed SQL is identical to what you save as the stored proc. The only two characters that ever need
> touching are a literal `"` → `""` and the rare sequence `#(` → `#(#)(` (none of the shipped procs use them).

---

## KPI Test Comparison table

A small, non-related diagnostic. For each tested `kpi_id` it shows a `Current (prod)` row and a `New (test)`
row: **Rows**, distinct **Entities**, **Green/Amber/Red** (`kpi_status` 3/2/1), **Avg/Sum Value**. Drop
**Kpi ID** + **Version** on a matrix with the measures to see whether the new logic moved row counts, the
R/A/G mix, or the value distribution before you deploy. With testing disabled the table is empty.

Production data for the `Current` side is read by a dedicated source query, **`Prod KPI Snapshot`**, and
filtered to the tested ids locally (a Formula-Firewall requirement — see below). When disabled it isn't
scanned at all.