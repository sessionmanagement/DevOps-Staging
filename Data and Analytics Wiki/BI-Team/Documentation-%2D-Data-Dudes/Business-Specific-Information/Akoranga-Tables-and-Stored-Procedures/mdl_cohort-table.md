## mdl_cohort Table Schema

| Column Name         | Data Type        | Nullable | Default     | Description                                 |
|---------------------|-----------------|----------|-------------|---------------------------------------------|
| id                  | BIGINT          | No       | AUTO_INCREMENT | Primary key, unique identifier             |
| contextid           | BIGINT          | No       |             | Context the cohort belongs to               |
| name                | VARCHAR(254)    | No       |             | Name of the cohort                          |
| idnumber            | VARCHAR(100)    | Yes      | NULL        | Optional external identifier                |
| description         | TEXT            | Yes      | NULL        | Description of the cohort                   |
| descriptionformat   | SMALLINT        | No       | 0           | Format of the description                   |
| visible             | TINYINT(1)      | No       | 1           | 1 = visible, 0 = hidden                     |
| component           | VARCHAR(100)    | Yes      | NULL        | Optional, used for plugins/components       |
| timecreated         | BIGINT          | No       |             | Timestamp of creation                       |
| timemodified        | BIGINT          | No       |             | Timestamp of last modification              |

**Primary Key:** `id`