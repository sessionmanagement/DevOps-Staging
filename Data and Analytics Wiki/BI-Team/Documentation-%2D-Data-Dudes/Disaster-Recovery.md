# Disaster Recovery

**Business Intelligence Disaster Recovery Documentation**

> Legacy document: [Business Intelligence Disaster Recovery Plan .docx](https://emergeaotearoaltd.sharepoint.com/:w:/r/sites/DRCollaboration/Shared%20Documents/General/BI-Engineering/Disaster%20Recovery/Business%20Intelligence%20Disaster%20Recovery%20Plan%20.docx?d=wf7d89e27811b4228b8b4658149085332&csf=1&web=1&e=cfGvrR)

## DR Documentation

| Page | Purpose |
|------|---------|
| [DR-Overview-and-Recovery-Plan](Disaster-Recovery/DR-Overview-and-Recovery-Plan) | Master plan — RTO/RPO targets, escalation matrix, scenario index |
| [Infrastructure-Inventory](Disaster-Recovery/Infrastructure-Inventory) | Complete inventory of all Azure resources, servers, databases, storage |
| [Key-Vault-and-Security-Recovery](Disaster-Recovery/Key-Vault-and-Security-Recovery) | **P0** — Key Vault, credentials, service principals, ransomware response |
| [Database-Recovery-Procedures](Disaster-Recovery/Database-Recovery-Procedures) | **P1** — EDW, Framework, Manager, DLA SQL, RecordBase database restore |
| [Storage-and-ODS-Recovery](Disaster-Recovery/Storage-and-ODS-Recovery) | **P2** — ADLS Gen2 storage, ODS data lake, Synapse SQL views |
| [ADF-Data-Landing-Recovery](Disaster-Recovery/ADF-Data-Landing-Recovery) | **P3** — Azure Data Factory, source extractions, triggers |
| [Synapse-and-Pipeline-Recovery](Disaster-Recovery/Synapse-and-Pipeline-Recovery) | **P4** — Synapse Integration, 100+ pipelines, linked services |
| [Power-BI-Recovery](Disaster-Recovery/Power-BI-Recovery) | **P5** — Semantic models, reports, workspace recovery |
| [Full-Environment-Rebuild](Disaster-Recovery/Full-Environment-Rebuild) | Complete rebuild from absolute zero (worst case) |
| [DR-Testing-and-Validation](Disaster-Recovery/DR-Testing-and-Validation) | Test procedures, validation queries, baseline snapshots |

## Existing Playbooks & Resources

| Page | Purpose |
|------|---------|
| [Decision Trees](Disaster-Recovery/Decision-Trees) | Synapse Analytics restoration decision tree |
| [Play-books](Disaster-Recovery/Play-books) | Step-by-step: SQL restore, ODS file restore, user maintenance |
| [Resources](Disaster-Recovery/Resources) | Key Vault configuration reference |

## Quick Reference

- **RTO:** 24 hours per layer | **RPO:** 24 hours
- **Key Vault:** `kv-prod-aus-svc-syn-01` (90-day purge protection)
- **EDW Server:** `sql-prod-aus-svc-datawarehouse-01`
- **Data Sovereignty:** All resources must remain in Australasia (Australia East / Australia Southeast)

_Azure Key Vault — Purge Protection: 90 days_
![image.png](/.attachments/image-6a188e8c-62b4-4496-b540-206e7dd46e05.png)