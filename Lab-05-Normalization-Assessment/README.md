# 🗃️ Lab 05: Database Normalization (2NF & 3NF)

![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Normalization](https://img.shields.io/badge/Normalization-2NF_to_3NF-Success?style=for-the-badge)

## 📖 Overview
This repository covers advanced database normalization, progressing from First Normal Form (1NF) through to Third Normal Form (3NF). It features the systematic decomposition of two datasets: finalizing the **Online Bookstore** scenario and solving the complete **Hospital Management System** assessment from scratch.

## 🧠 Concepts Applied
* **Second Normal Form (2NF):** Eliminated partial dependencies from composite keys, ensuring non-prime attributes rely on the *entire* primary key.
* **Third Normal Form (3NF):** Extracted transitive dependencies into distinct tables, strictly separating independent entities (like Customers, Doctors, and Departments) from transaction records (like Orders and Visits).
* **Anomaly Resolution:** Verified through SQL `JOIN` reconstruction that data redundancy is minimized and structural anomalies are completely eliminated.

## 📁 Files Included
`2024-SE-31_Lab05_2NF_3NF.sql`: A fully independent SQL script containing the 2NF and 3NF conversions for the Bookstore, alongside the complete, end-to-end solution for the graded Hospital Assessment Problem.

## 🚀 How to Run
Execute the script in your preferred MySQL environment. It operates completely independently—establishing its own databases (`bookstore_norm` and `hospital_norm`), decomposing the tables into 3NF, populating the data, and running the final verification queries automatically.