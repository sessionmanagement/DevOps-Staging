# Business Intelligence Disaster Recovery Plan

**Document Owner:** BI Engineering Team
**Last Reviewed:** 2026-03-23
**Review Frequency:** Quarterly
**Classification:** Internal — Confidential

---

## Purpose

This document defines the Disaster Recovery (DR) plan for the Emerge Aotearoa Business Intelligence data platform. It provides step-by-step procedures to restore all platform components from an absolute beginning state through to full operational capability.

## Scope

This plan covers the complete BI data platform:

| Layer | Components |
|-------|-----------|
| **Data Landing Area (DLA)** | Azure Data Factory, ADLS Gen2 storage, Synapse Data Landing workspace |
| **Operational Data Store (ODS)** | Synapse SQL Serverless views, external tables, ODS data lake |
| **Enterprise Data Warehouse (EDW)** | Azure SQL Database, staging/landing/edw schemas |
| **Orchestration** | Synapse Integration pipelines, triggers, linked services |
| **Configuration** | Framework database, Manager database |
| **Reporting** | Power BI semantic models, reports, datasets, paginated reports |
| **Security** | Azure Key Vault, service principals, managed identities, Entra ID |

## Data Sovereignty

> **IMPORTANT:** All data must remain within the Australasia region (Australia East / Australia Southeast) to comply with New Zealand law. No recovery procedure may replicate or restore data to regions outside Australasia.

## Recovery Objectives

| Metric | Target | Notes |
|--------|--------|-------|
| **Recovery Time Objective (RTO)** | 24 hours per layer | Time to restore each platform tier to operational status |
| **Recovery Point Objective (RPO)** | 24 hours | Maximum acceptable data loss — aligns with daily load schedule |

> **Note:** These targets are initial baselines. They should be reviewed and refined during the peer review process with the organisation. Different layers may receive adjusted targets after the first DR test exercise.

## Architecture Overview

::: mermaid
flowchart TB
    subgraph Sources["Source Systems"]
        BC[Business Central]
        DP[DataPay]
        EL[EmpLive]
        IH[IntelliHR]
        AK[Akoranga]
        EP[EcoPortal]
        RB[RecordBase EAL/MNB]
        SH[SnapHire]
        TW[Tapui Waka]
        PBI[PowerBI Activity]
        MSG[MS Graph]
        WE[Web Expenses]
    end

    subgraph DLA["Data Landing Area"]
        ADF[ADF Data Landing<br/>adf-prod-aus-datalanding-01]
        ADLS[ADLS Gen2<br/>stprodaussvcdatalanding01]
        SDL[Synapse Data Landing<br/>Zavanti + SFTP]
    end

    subgraph ODS_Layer["ODS Layer"]
        ODSLAKE[ODS Data Lake<br/>stprodaussvcsyn]
        ODSSQL[ODS Synapse SQL Serverless<br/>21 schemas, 312+ views]
    end

    subgraph Transform["Orchestration"]
        SYN[Synapse Integration<br/>100+ pipelines]
        FW[Framework DB<br/>ETL metadata]
    end

    subgraph EDW_Layer["EDW Layer"]
        EDWDB[EDW Database<br/>sqldb-prod-datawarehouse-01]
        MGR[Manager DB<br/>sqldb-prod-manager]
    end

    subgraph Reporting["Reporting"]
        PBISVC[Power BI Service<br/>Production Reports workspace]
        PBIREP[137 projects<br/>50 reports + 80 datasets]
    end

    Sources --> ADF
    ADF --> ADLS
    SDL --> ODSLAKE
    ADLS --> ODSLAKE
    ODSLAKE --> ODSSQL
    ODSSQL --> SYN
    FW --> SYN
    SYN --> EDWDB
    SYN --> MGR
    EDWDB --> PBISVC
    PBISVC --> PBIREP
:::

## Recovery Priority Order

When recovering the full environment, follow this sequence. Each layer depends on the previous:

| Priority | Component | Dependency | Recovery Page |
|----------|-----------|------------|---------------|
| **P0** | Azure Key Vault & Security | None — all other layers depend on this | [Key-Vault-and-Security-Recovery](Key-Vault-and-Security-Recovery) |
| **P1** | SQL Databases (Framework, Manager, EDW, DLA) | Key Vault credentials | [Database-Recovery-Procedures](Database-Recovery-Procedures) |
| **P2** | Storage Accounts & ODS Data Lake | Key Vault, SQL databases | [Storage-and-ODS-Recovery](Storage-and-ODS-Recovery) |
| **P3** | ADF Data Landing Pipelines | Storage accounts, Key Vault, Framework DB | [ADF-Data-Landing-Recovery](ADF-Data-Landing-Recovery) |
| **P4** | Synapse Integration Pipelines | All upstream layers | [Synapse-and-Pipeline-Recovery](Synapse-and-Pipeline-Recovery) |
| **P5** | Power BI Reports & Datasets | EDW database operational | [Power-BI-Recovery](Power-BI-Recovery) |
| **P6** | End-to-end validation | All components | [DR-Testing-and-Validation](DR-Testing-and-Validation) |

For a **complete environment rebuild** from scratch, see: [Full-Environment-Rebuild](Full-Environment-Rebuild)

## Escalation Matrix

| Role | Name | Contact Method | Responsibility |
|------|------|---------------|----------------|
| **BI Manager** | Chris Negus | Teams / Phone | Final authority on DR decisions, stakeholder communication |
| **Data Engineering Lead** | Greg Nuthall | Teams / Phone | Infrastructure recovery, pipeline restoration, database DR |
| **Analyst Lead** | Mike Gencic | Teams / Phone | Report recovery, data validation, business communication |
| **On-Call Engineer** | See [On-Call Roster](/BI-Team/On%2DCall-Roster) | Pae Awhina | First responder, initial triage |

### Escalation Process

1. **On-Call Engineer** detects or is notified of incident
2. Classify severity using the [SOP Data and Report Issue Management](/BI-Team/Documentation-%2D-Cumulative/SOP-Data-and-Report-Issue-Management)
3. If DR scenario confirmed → Escalate to **both leads** (Greg Nuthall + Mike Gencic)
4. Leads assess scope → Engage **BI Manager** (Chris Negus) if full DR activation required
5. BI Manager authorises DR activation and communicates to stakeholders

### Communication Channels

| Channel | Usage |
|---------|-------|
| **Microsoft Teams** | Primary communication during incident |
| **Phone** | Escalation when Teams unavailable |
| **Email** | Stakeholder updates, post-incident reports |
| **Pae Awhina** | Incident ticket creation and tracking |

## Disaster Scenarios Covered

| Scenario | Severity | Pages |
|----------|----------|-------|
| Single database corruption/failure | Medium | [Database-Recovery-Procedures](Database-Recovery-Procedures) |
| Storage account data loss | Medium | [Storage-and-ODS-Recovery](Storage-and-ODS-Recovery) |
| Synapse workspace failure | High | [Synapse-and-Pipeline-Recovery](Synapse-and-Pipeline-Recovery) |
| ADF pipeline corruption/failure | Medium | [ADF-Data-Landing-Recovery](ADF-Data-Landing-Recovery) |
| Key Vault deletion/compromise | Critical | [Key-Vault-and-Security-Recovery](Key-Vault-and-Security-Recovery) |
| Full resource group deletion | Critical | [Full-Environment-Rebuild](Full-Environment-Rebuild) |
| Complete Azure region outage | Critical | [Full-Environment-Rebuild](Full-Environment-Rebuild) |
| Ransomware / security breach | Critical | [Key-Vault-and-Security-Recovery](Key-Vault-and-Security-Recovery) |
| Service principal / credential expiry | Low–Medium | [Key-Vault-and-Security-Recovery](Key-Vault-and-Security-Recovery) |

## External Vendor Dependencies

| System | Vendor | DR Contact | SLA | Notes |
|--------|--------|-----------|-----|-------|
| **RecordBase** | External vendor | _To be documented_ | _To be documented_ | EAL/MNB databases hosted by us, data sourced from vendor |
| **Business Central** | Microsoft / Theta | _No DR for API currently_ | N/A | **GAP:** DR process for BC API needs to be established |
| **EcoPortal** | EcoPortal | _To be documented_ | _To be documented_ | REST/GraphQL API |
| **IntelliHR** | IntelliHR | _To be documented_ | _To be documented_ | REST API |
| **DataPay** | DataPay | _To be documented_ | _To be documented_ | REST API |
| **SnapHire** | SnapHire | _To be documented_ | _To be documented_ | File-based extraction |
| **EmpLive** | EmpLive | _To be documented_ | _To be documented_ | REST API + file extraction |

> **ACTION REQUIRED:** Obtain DR contacts and SLA information from each vendor. Document in this table.

## Sub-Pages

[[_TOSP_]]
