# 🔤 Lab 10: Scalar SQL Functions (String Operations)

![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Data Cleaning](https://img.shields.io/badge/Data_Cleaning-Active-Success?style=for-the-badge)

## 📖 Overview
This repository focuses on data sanitization and transformation using single-row scalar functions. Specifically, it covers Part A of the lab, demonstrating how to manipulate, extract, and format text strings within a deliberately unpolished Customer and Product database.

## 🧠 Concepts Applied
* **Text Sanitization:** Applied `TRIM()` and `UPPER()`/`LOWER()` to resolve input inconsistencies like trailing spaces and mixed-casing.
* **String Parsing:** Utilized `SUBSTRING_INDEX()` and `LOCATE()` to dynamically split strings, effectively isolating usernames and email domains.
* **Data Masking & Concatenation:** Leveraged `CONCAT()` and `LEFT()` to format dynamic greeting messages and securely mask sensitive phone numbers.
* **Formatting:** Used `REPLACE()` and `LPAD()` to convert standard text into URL-friendly slugs and zero-padded ID formats.

## 📁 Files Included
* `2024-SE-31_Lab10_StringFunctions.sql`: A fully self-contained script featuring the schema initialization, sample data insertion, and all 12 string manipulation queries.

## 🚀 How to Run
Execute the `.sql` script in any MySQL environment. It will independently build the `scalar_lab` database, populate the unformatted records, and execute the queries to output the cleaned, transformed data.
