# Audit Power BI Updates (PBIP / PBIR / TMDL)

Use this when you need to create or refresh the audit copies in the [Financial Audit Workspace](https://app.powerbi.com/groups/a9ec2a35-0d2c-4e2e-af53-f49019a73c02/list?experience=power-bi).

Start from the **main repo assets** in your local clone of the `Reports and Datasets` repo, not from the copies already sitting in the audit workspace.

Do this work in a **separate folder outside the repo**. Use the repo as the source only.

## Outcome

End with **two fattened audit copies** published to the Financial Audit Workspace:

- Statement of Service Waharoa
- Statement of Service Recordbase

Each one should have its own report and its own semantic model in the workspace.

## The simple idea

For each audit copy:

1. Start with the **dataset** project from `Datasets\` as your base
2. Copy that base project into a **working folder outside the repo**
3. Copy the **contents** of the matching report folder from `Reports\` into the base `.Report` folder
4. When Windows asks about `definition.pbir`, **keep the file that is already in the dataset folder**
5. Open the working **dataset `.pbip`** file and publish it to the Financial Audit Workspace

## One file to treat differently

When you copy the report files into the dataset report folder, **do not overwrite** `definition.pbir`.

In plain language:

- copy the report folder contents
- if Windows asks whether to replace `definition.pbir`, choose **Keep the file already in the destination folder**
- always keep the `definition.pbir` that came from the **dataset** project, not the **report** project

## Example 1 - Statement of Service Waharoa

### Files you start with

From `Datasets\` copy these into your working folder:

- `Statement of Service - Waharoa Dataset.pbip`
- `Statement of Service - Waharoa Dataset.Report\`
- `Statement of Service - Waharoa Dataset.SemanticModel\`

From `Reports\` use these as the report source:

- `Statement of Service Audit - Waharoa.pbip`
- `Statement of Service - Waharoa.Report\`

### Example working folder

```text
[your working folder]\Waharoa\
├── Statement of Service - Waharoa Dataset.pbip
├── Statement of Service - Waharoa Dataset.Report\
└── Statement of Service - Waharoa Dataset.SemanticModel\
```

### What to copy

Copy **from** this report folder:

```text
[your repo]\Reports\Statement of Service - Waharoa.Report\
```

Copy **into** this dataset report folder:

```text
[your working folder]\Waharoa\Statement of Service - Waharoa Dataset.Report\
```

### Step-by-step

1. Copy the files and subfolders from:

   ```text
   [your repo]\Reports\Statement of Service - Waharoa.Report\
   ```

2. Paste them into:

   ```text
   [your working folder]\Waharoa\Statement of Service - Waharoa Dataset.Report\
   ```

3. If Windows asks whether to replace `definition.pbir`, choose **No**, **Skip**, or **Keep the existing file**.

4. Do **not** rename any folders.

5. Open this file:

```text
Statement of Service - Waharoa Dataset.pbip
```

6. Publish it to the Financial Audit Workspace.

### Quick reminder

- **Keep:** `Statement of Service - Waharoa Dataset.pbip`
- **Keep:** `Statement of Service - Waharoa Dataset.Report\`
- **Keep:** `Statement of Service - Waharoa Dataset.SemanticModel\`
- **Use as source only:** `Statement of Service Audit - Waharoa.pbip`
- **Copy from:** `Statement of Service - Waharoa.Report\`

## Example 2 - Statement of Service Recordbase

### Files you start with

From `Datasets\` copy these into your working folder:

- `Statement of Service Audit - Recordbase Dataset.pbip`
- `Statement of Service Audit - Recordbase Dataset.Report\`
- `Statement of Service Audit - Recordbase Dataset.Dataset\`

From `Reports\` use these as the report source:

- `Statement of Service Audit - Recordbase.pbip`
- `Statement of Service Audit - Recordbase.Report\`

### Example working folder

```text
[your working folder]\Recordbase\
├── Statement of Service Audit - Recordbase Dataset.pbip
├── Statement of Service Audit - Recordbase Dataset.Report\
└── Statement of Service Audit - Recordbase Dataset.Dataset\
```

### What to copy

Copy **from** this report folder:

```text
[your repo]\Reports\Statement of Service Audit - Recordbase.Report\
```

Copy **into** this dataset report folder:

```text
[your working folder]\Recordbase\Statement of Service Audit - Recordbase Dataset.Report\
```

### Step-by-step

1. Copy the files and subfolders from:

   ```text
   [your repo]\Reports\Statement of Service Audit - Recordbase.Report\
   ```

2. Paste them into:

   ```text
   [your working folder]\Recordbase\Statement of Service Audit - Recordbase Dataset.Report\
   ```

3. If Windows asks whether to replace `definition.pbir`, choose **No**, **Skip**, or **Keep the existing file**.

4. Do **not** rename any folders.

5. Open this file:

```text
Statement of Service Audit - Recordbase Dataset.pbip
```

6. Publish it to the Financial Audit Workspace.

### Quick reminder

- **Keep:** `Statement of Service Audit - Recordbase Dataset.pbip`
- **Keep:** `Statement of Service Audit - Recordbase Dataset.Report\`
- **Keep:** `Statement of Service Audit - Recordbase Dataset.Dataset\`
- **Use as source only:** `Statement of Service Audit - Recordbase.pbip`
- **Copy from:** `Statement of Service Audit - Recordbase.Report\`

## Final check

Before publishing, confirm:

- you are working outside the repo
- the `.pbip` file you opened is the **dataset** `.pbip`
- the `.Report` folder kept the **dataset** folder name
- you did **not** overwrite `definition.pbir`
- Power BI Desktop opens the file without errors

## Related guidance

- [Git Workflow for Power BI Development](/BI-Team/Documentation-%2D-Analysts/Git-Workflow-for-Power-BI-Development)
- [Report Creation Process](/BI-Team/Documentation-%2D-Analysts/Report-Creation/Report-Creation-Process)
- [Self Service Semantic Model SOP](/BI-Team/Documentation-%2D-Analysts/Self-Service-Semantic-Model-SOP)
