# Datasource to Bronze Notebooks

One page per source loaded into the bronze lakehouse (`lh_bronze`) by a Fabric notebook. The load pattern, metadata columns and conventions shared by all of them are on [Fabric Conversion - Overview](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion).

| Source | Replaces (Synapse / ADF) | Notebook(s) | Bronze target | Status |
|---|---|---|---|---|
| EmpLive - SFTP | ADF SFTP / zip load | [EmpLive - nb_emplive_sftp_bronze](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/EmpLive-%2D-Notebook-Summary/EmpLive-%2D-nb_emplive_sftp_bronze) | `lh_bronze.emplive.<table>` | Notebook available |
| EmpLive - API | *Extract Emplive API Master / Child* | [EmpLive - nb_emplive_api_bronze](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/EmpLive-%2D-Notebook-Summary/EmpLive-%2D-nb_emplive_api_bronze) | `lh_bronze.emplive.<endpoint>` | Notebook available |
| DataPay - Cost Allocation report | *Datapay Report Cost Allocation* | [DataPay - nb_datapay_report_bronze](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/DataPay-%2D-Notebook-Summary/DataPay-%2D-nb_datapay_report_bronze) | `lh_bronze.datapay.cost_allocations` | Draft, not yet run |
| Business Central - API | *Business Central ODS load (Generic_BC_ODSLoad dataflows)* | [Business Central - nb_bc_ingest](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/Business-Central-%2D-Notebook-Summary/Business-Central-%2D-nb_bc_ingest) | `lh_bronze.bc.bc_<entity>` | Notebook available (dev / sandbox) |

Shared helpers and setup:

- [EmpLive - nb_emplive_common](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/EmpLive-%2D-Notebook-Summary/EmpLive-%2D-nb_emplive_common)
- [DataPay - nb_datapay_common](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/DataPay-%2D-Notebook-Summary/DataPay-%2D-nb_datapay_common)
- [Business Central - nb_bc_setup_control](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/Business-Central-%2D-Notebook-Summary/Business-Central-%2D-nb_bc_setup_control)

Summary of all notebooks and how to run them:

- [EmpLive - Notebook Summary](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/EmpLive-%2D-Notebook-Summary)
- [DataPay - Notebook Summary](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/DataPay-%2D-Notebook-Summary)
- [Business Central - Notebook Summary](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/Business-Central-%2D-Notebook-Summary)

Design and ADF comparison: [DataPay - Cost Allocation to Bronze](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/DataPay-%2D-Notebook-Summary/DataPay-%2D-Cost-Allocation-to-Bronze)
