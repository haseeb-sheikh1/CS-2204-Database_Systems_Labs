# 🔑 Lab 03: Keys, Constraints, and Queries

![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Data Integrity](https://img.shields.io/badge/Data_Integrity-Enforced-Success?style=for-the-badge)

## 📖 Overview
This laboratory assignment demonstrates the architectural foundation of relational databases through the implementation of a **University Management System**. It focuses heavily on enforcing data integrity using various key constraints, as well as executing complex schema mutations (DDL) and data manipulations (DML).

## 🗄️ Relational Key Concepts Explored
The database schema strictly adheres to relational mapping standards, actively applying the following key architectures:

* **Primary Keys / Surrogate Keys:** System-generated `AUTO_INCREMENT` IDs used as the definitive identifier for records (e.g., `student_id`, `dept_id`).
* **Natural / Alternate Keys:** Real-world identifiers enforced with `UNIQUE` constraints to prevent real-world duplication (e.g., `national_id`, `email`, `course_code`).
* **Composite Keys:** A primary key utilizing multiple columns to ensure row uniqueness, demonstrated in the `enrollments` junction table (`student_id` + `course_id` + `semester`).
* **Foreign Keys:** Referential constraints utilized to link tables (e.g., mapping a student to a specific department).

## 🛠️ SQL Operations Executed
Beyond table creation, this script acts as a comprehensive sandbox testing multiple SQL operations:
1. **DQL (Data Query Language):** Table joining and filtered data retrieval.
2. **DML (Data Manipulation Language):** `INSERT`ing mock data, `UPDATE`ing specific records, and `DELETE`ing individual rows while respecting foreign key constraints.
3. **DDL Schema Mutations:** Utilizing `ALTER TABLE` to `ADD`, `MODIFY`, `RENAME`, and `DROP` columns, as well as applying late-stage constraints (`ADD CONSTRAINT`) to live tables.
4. **Data Purging:** Demonstrating the operational differences between `DELETE`, `TRUNCATE`, and `DROP`.

## 🚀 Getting Started
1. Open your local SQL environment (e.g., XAMPP phpMyAdmin, MySQL Workbench).
2. Execute the `2024-SE-31_Lab03_Keys.sql` script.
3. *Note:* Because the script contains an automated teardown at the end (`DROP DATABASE`), the schema will build, execute all operations, and cleanly delete itself to ensure no residual data is left on your local server. To inspect the live tables, simply comment out **Section 5.4** before running.