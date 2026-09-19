# 🗃️ Lab 04: Database Normalization (Overview & 1NF)

![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Normalization](https://img.shields.io/badge/Normalization-1NF-Success?style=for-the-badge)

## 📖 Overview
This repository contains the foundational steps of database normalization applied to an online bookstore dataset. The primary focus is identifying inherent design flaws in flat tables and resolving them by achieving First Normal Form (1NF).

## 🧠 Concepts Applied
* **Functional Dependencies (FDs):** Mapped attribute relationships to clearly define the composite primary key.
* **Anomaly Identification:** Highlighted the exact Insertion, Update, and Deletion anomalies present in the original unnormalized structure.
* **First Normal Form (1NF):** Restructured the flat data to ensure atomicity by eliminating multi-valued cells and repeating groups.

## 📁 Files Included
* `2024-SE_31_Lab04_1NF.sql`: The main SQL script containing the FD analysis, anomaly breakdown, and the complete 1NF schema creation with populated data.

## 🚀 How to Run
Execute the SQL script in any MySQL environment (e.g., XAMPP phpMyAdmin, MySQL Workbench). The script will automatically create the `bookstore_norm` database, build the 1NF table, and insert the required atomic records.