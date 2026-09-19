# 🔗 Lab 08: SQL Joins (Inner, Left & Right)

![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Joins](https://img.shields.io/badge/Joins-Core_Mechanics-Success?style=for-the-badge)

## 📖 Overview
This repository focuses on resolving fragmented relational data by utilizing fundamental SQL JOIN operations. The script operates within a multi-table corporate schema, demonstrating how to extract cohesive business intelligence from separate entity tables (Departments, Employees, Projects, and Assignments)[cite: 13].

## 🧠 Concepts Applied
* **Inner Joins:** Employed strict intersection logic to retrieve rows only when a match exists in both parent and child tables[cite: 13].
* **Left & Right Joins:** Utilized directional joins to guarantee data retention from primary tables (e.g., retrieving all departments, even those with zero assigned employees)[cite: 13].
* **Null Value Filtering:** Leveraged outer joins combined with `IS NULL` checks to identify "orphaned" records, such as unassigned employees and dormant projects[cite: 13].
* **Full Outer Join Simulation:** Executed a `UNION` clause to combine Left and Right join outputs seamlessly[cite: 13].

## 📁 Files Included
* `2024-SE_31_Lab08_Joins_A.sql`: A self-contained script containing the corporate schema setup, sample data initialization, and the completion of all Part A join tasks[cite: 13].

## 🚀 How to Run
Execute the `.sql` script in any MySQL environment. It will sequentially build the `joins_lab` database, populate the four interconnected tables, and automatically run the 10 relational queries.