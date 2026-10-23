# Star Schema Design for Dim_Ethnicity

_Exported on 5/20/2025 at 16:19:59 GMT+12 from Cursor (0.50.5)_

  

---

  

**User**

  

can you create a star schema for all tables linking dim_ethnicity in the edw/tables folder

  

---

  

**Cursor**

  

Based on the table definitions and references, here is a star schema for all tables in the `edw/edw/Tables` folder that link to `dim_ethnicity`:

  

### Central Dimension Table

- **dim_ethnicity**

  - Primary Key: `dim_ethnicity_key`

  

### Fact Tables Linking to `dim_ethnicity`

These fact tables have a foreign key column `dim_ethnicity_key` that links to `dim_ethnicity`:

1. **fact_employee_leave**

   - Foreign Key: `dim_ethnicity_key`

   - Other Dimensions: `dim_company_key`, `dim_business_unit_hierarchy_key`, `dim_employee_key`, `dim_leave_type_key`, `dim_payroll_category_key`, etc.

  

2. **fact_employee_hours_worked**

   - Foreign Key: `dim_ethnicity_key`

   - Other Dimensions: `dim_company_key`, `dim_employee_key`, `dim_payroll_category_key`, `dim_leave_type_key`, etc.

  

3. **fact_employee_remuneration**

   - Foreign Key: `dim_ethnicity_key`

   - Other Dimensions: `dim_company_key`, `dim_location_key`, `dim_employee_key`, `dim_service_key`, `dim_role_hierarchy_key`, etc.

  

### Star Schema Diagram (Textual)

```

                +-------------------+

                |   dim_ethnicity   |

                |-------------------|

                | dim_ethnicity_key |<-------------------+

                | ...               |                    |

                +-------------------+                    |

                      ^                                   |

                      |                                   |

+---------------------+---------------------+   +---------+---------------------+   +-----------------------------+

|   fact_employee_leave                      |   | fact_employee_hours_worked   |   | fact_employee_remuneration   |

|--------------------------------------------|   |-----------------------------|   |-----------------------------|

| fact_employee_leave_key (PK)               |   | fact_employee_hours_worked_key (PK) | fact_employee_remuneration_key (PK) |

| dim_ethnicity_key (FK) --------------------+   | dim_ethnicity_key (FK) -----+   | dim_ethnicity_key (FK) -----+

| ...                                        |   | ...                         |   | ...                         |

+--------------------------------------------+   +-----------------------------+   +-----------------------------+

```

  

### Summary

- **dim_ethnicity** is the dimension table.

- The following fact tables link to it via `dim_ethnicity_key`:

  - `fact_employee_leave`

  - `fact_employee_hours_worked`

  - `fact_employee_remuneration`

  

If you need a graphical diagram or want to see the relationships with other dimensions in these fact tables, let me know!

  

```plaintext

                +-------------------+

                |   dim_ethnicity   |

                |-------------------|

                | dim_ethnicity_key |<-------------------+

                | ...               |                    |

                +-------------------+                    |

                      ^                                   |

                      |                                   |

+---------------------+---------------------+   +---------+---------------------+   +-----------------------------+

|   fact_employee_leave                      |   | fact_employee_hours_worked   |   | fact_employee_remuneration   |

|--------------------------------------------|   |-----------------------------|   |-----------------------------|

| fact_employee_leave_key (PK)               |   | fact_employee_hours_worked_key (PK) | fact_employee_remuneration_key (PK) |

| dim_ethnicity_key (FK) --------------------+   | dim_ethnicity_key (FK) -----+   | dim_ethnicity_key (FK) -----+

| ...                                        |   | ...                         |   | ...                         |

+--------------------------------------------+   +-----------------------------+   +-----------------------------+

```