# 🗄️ CS-2204: Database Systems Lab Course

![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Status](https://img.shields.io/badge/Course_Status-Active-Success?style=for-the-badge)
![Semeseter](https://img.shields.io/badge/Semester-Spring_2026-blue?style=for-the-badge)

Welcome to my official repository for **CS-2204 Database Systems Labs**. This repository tracks my coursework from foundational environment setup through advanced SQL querying, relational normalization, scalar transformations, and aggregate business intelligence reporting. 

Every lab directory is fully self-contained, featuring dedicated schema definitions, sample data initializations, and modular documentation.

---

## 📂 Comprehensive Lab Index

| Lab Module | Core Topic & Description | Primary Artifacts |
| :--- | :--- | :--- |
| **[LAB 01](./Lab-01-XAMPP-Setup)** | Installation of XAMPP & Environment Verification | `2024-SE-31-Lab01.pdf` |
| **[LAB 02](./Lab-02-POS-Schema)** | Point of Sale (POS) Database Schema & Basic DML | `2024-SE-31-Lab02_POS.sql` |
| **[LAB 03](./Lab-03-Hospital-Constraints)** | Primary/Foreign Keys, Constraints, & Management Schema | `2024-SE-31-Lab03-keys.sql` |
| **[LAB 04](./Lab-04-Normalization-1NF)** | Database Normalization Overview & 1NF Compliance | `RollNo_Lab04_1NF.sql` |
| **[LAB 05](./Lab-05-Normalization-Assessment)** | Advanced Normalization (2NF & 3NF) & Hospital Assessment | `RollNo_Lab05_2NF_3NF.sql` |
| **[LAB 06](./Lab-06-Advanced-Filters)** | Filters Part 01: Comparison & Logical Operators (`AND`, `OR`) | `RollNo_Lab06_Filters.sql` |
| **[LAB 07](./Lab-07-Pattern-Matching)** | Filters Part 02: Ranges (`BETWEEN`), Lists (`IN`), & Wildcards (`LIKE`) | `RollNo_Lab07_Patterns.sql` |
| **[LAB 08](./Lab-08-SQL-Joins-PartA)** | Joins Part 01: Inner, Left, & Right Relational Joins[cite: 1] | `RollNo_Lab08_JoinsA.sql` |
| **[LAB 09](./Lab-09-SQL-Joins-PartB)** | Joins Part 02: Self Joins, Multi-Table Chaining, & Library Lab[cite: 1] | `RollNo_Lab09_JoinsB.sql` |
| **[LAB 10](./Lab-10-Scalar-String-Functions)** | Scalar Functions Part 01: String Sanitization & Extractions | `RollNo_Lab10_String.sql` |
| **[LAB 11](./Lab-11-Scalar-Numeric-Date)** | Scalar Functions Part 02: Numeric Calculations & Date Arithmetic | `RollNo_Lab11_NumericDate.sql` |
| **[LAB 12](./Lab-12-Aggregates)** | Aggregate Functions (`GROUP BY`, `HAVING`) & University Assessment | `RollNo_Lab12_Aggregates.sql` |
| **[LAB 13](./Lab-13-Open-Ended)** | Open-Ended Final Lab Challenge & Custom Implementation | `RollNo_Lab13_OpenEnded.sql` |

---

## 🚀 Execution Instructions
1. Ensure **MySQL 8.x** or a compatible runtime environment is running locally via XAMPP[cite: 1].
2. Navigate into any specific lab folder above to access its standalone `.sql` script or documentation.
3. Open and execute the script inside **MySQL Workbench** or your preferred command line tool. Each script automatically establishes its target database, builds constraints, populates records, and executes the target queries.