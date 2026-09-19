# 🧮 Lab 11: Scalar SQL Functions (Numeric & Date/Time)

![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Scalar Processing](https://img.shields.io/badge/Scalar_Processing-Active-Success?style=for-the-badge)

## 📖 Overview
This repository advances scalar operations by focusing heavily on numeric calculation and temporal logic. It completes the second half of the scalar functions module (Part B) and culminates in a comprehensive, graded assessment applied to an **Employee Database**.

## 🧠 Concepts Applied
* **Mathematical Adjustments:** Used `ROUND()`, `FLOOR()`, `CEIL()`, and `MOD()` to dynamically compute discounts, taxes, and structured salary brackets.
* **Temporal Extractions:** Applied `YEAR()`, `QUARTER()`, and `MONTHNAME()` to strip out meaningful segments from backend datetime columns.
* **Date Arithmetic:** Calculated precise intervals, ages, and tenures using `DATEDIFF()` and `TIMESTAMPDIFF()`, alongside forecasting future milestone dates via `DATE_ADD()`.
* **Deep Function Nesting:** Seamlessly combined formatting (`DATE_FORMAT`), string sanitization (`TRIM`, `UPPER`), calculation, and null-handling (`COALESCE`) into single, complex execution lines.

## 📁 Files Included
* `2024-SE-31_Lab11_NumericDate.sql`: A fully independent script that creates and handles the Part B testing database, followed by the complete schema build and all 10 queries for the Employee Assessment.

## 🚀 How to Run
Execute the `.sql` script in your preferred database environment. The script is entirely self-contained; it will establish the required databases (`scalar_lab_b` and `emp_lab`), insert all necessary testing data, and automatically output the results of all 25 operations.