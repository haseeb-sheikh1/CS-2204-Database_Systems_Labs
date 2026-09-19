# 🔍 Lab 07: Advanced Filtering & Sorting

![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Advanced Filters](https://img.shields.io/badge/Advanced_Filters-Active-Success?style=for-the-badge)

## 📖 Overview
This repository showcases the implementation of advanced SQL filtering logic. It covers pattern matching, list containment, and missing-data checks, applied across two distinct datasets: an **HR Employee Database** and a graded **Online Bookstore Assessment**[cite: 12].

## 🧠 Concepts Applied
* **Range & List Filtering:** Utilized `BETWEEN` for date/salary brackets and `IN` to efficiently filter against multiple specific values.
* **Pattern Matching:** Implemented `LIKE` with wildcards (`%`) to search for substrings, prefixes, and suffixes.
* **Data Integrity Checks:** Used `IS NULL` and `IS NOT NULL` to isolate records with missing information.
* **Sorting & Pagination:** Applied multi-column `ORDER BY` clauses combined with `LIMIT` to extract "Top N" results (e.g., top earners, most expensive books).

## 📁 Files Included
* `2024-SE_31_Lab07_AdvancedFilters.sql`: A self-contained script featuring Part B of the Employee filtering tasks, alongside the complete setup and queries for the Bookstore Assessment.

## 🚀 How to Run
Execute the `.sql` script in any MySQL environment. It will sequentially handle the creation of both databases (`filters_lab` and `bookstore_lab`), insert the necessary sample data, and automatically output the results of all 25 queries.