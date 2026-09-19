-- ==============================================================================
-- LAB 06: Comparison & Logical Operators (Part A)
-- Roll Number: 2024-SE_31
-- Description: Utilizing standard comparison and logical operators to filter 
--              employee records based on specific business rules.
-- ==============================================================================

-- Setting up the local database environment and ensuring a clean slate.
CREATE DATABASE IF NOT EXISTS filters_lab;
USE filters_lab;

DROP TABLE IF EXISTS Employee;

-- Creating the main Employee table to store company data.
CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50) NOT NULL,
    Gender CHAR(1),
    Salary DECIMAL(10,2),
    HireDate DATE,
    City VARCHAR(30),
    JobTitle VARCHAR(40),
    DeptName VARCHAR(40)
);

-- Populating the table with the provided sample records for testing queries.
INSERT INTO Employee VALUES
(101,'Ali Khan', 'M',120000,'2018-03-15','Lahore', 'Senior Engineer','Engineering'),
(102,'Sara Iqbal', 'F', 95000,'2019-06-01','Lahore', 'Software Engineer','Engineering'),
(103,'Hamza Raza', 'M', 85000,'2020-01-20','Karachi', 'Software Engineer','Engineering'),
(104,'Ayesha Noor', 'F',110000,'2017-11-10','Karachi', 'Marketing Lead', 'Marketing'),
(105,'Bilal Ahmed', 'M', 70000,'2021-04-05','Karachi', 'Marketing Exec', 'Marketing'),
(106,'Fatima Sheikh', 'F', 90000,'2019-09-12','Islamabad','Accountant', 'Finance'),
(107,'Usman Tariq', 'M', 78000,'2022-02-18','Islamabad','Accountant', 'Finance'),
(108,'Maira Javed', 'F',115000,'2016-07-22','Lahore', 'Research Lead', 'Research'),
(109,'Zain Abbas', 'M', 60000,'2023-01-09','Lahore', 'Research Analyst','Research'),
(110,'Nida Yousaf', 'F', 72000,'2022-08-30',NULL, 'Research Analyst','Research'),
(111,'Adeel Akhtar', 'M', 88000,'2020-05-14','Lahore', 'QA Engineer', 'Engineering'),
(112,'Sana Malik', 'F',102000,'2018-12-01','Karachi', 'Sales Manager', 'Sales'),
(113,'Talha Hussain', 'M', 65000,'2023-07-18','Islamabad','Sales Exec', 'Sales'),
(114,'Mehwish Anwar', 'F', 80000,'2021-10-25','Lahore', 'HR Officer', 'HR'),
(115,'Imran Shafi', 'M',125000,'2015-04-30',NULL, 'Director', 'Engineering');

-- ==============================================================================
-- LAB TASKS - PART A
-- ==============================================================================

-- Task A1: Retrieving employees earning strictly more than 90,000.
SELECT EmpID, EmpName, Salary
FROM Employee
WHERE Salary > 90000;

-- Task A2: Extracting a list of employees earning 75,000 or less.
SELECT EmpName, Salary
FROM Employee
WHERE Salary <= 75000;

-- Task A3: Identifying high earners specifically located in Lahore.
SELECT *
FROM Employee
WHERE City = 'Lahore' AND Salary > 90000;

-- Task A4: Filtering for employees based in either Karachi or Islamabad.
SELECT EmpName, City
FROM Employee
WHERE City = 'Karachi' OR City = 'Islamabad';

-- Task A5: Finding female employees working outside the Engineering department.
SELECT *
FROM Employee
WHERE Gender = 'F' AND DeptName != 'Engineering';

-- Task A6: Filtering male employees within the 70k to 90k salary bracket.
SELECT *
FROM Employee
WHERE Gender = 'M' AND Salary >= 70000 AND Salary <= 90000;

-- Task A7: Locating software engineers OR anyone earning over 100,000.
SELECT *
FROM Employee
WHERE JobTitle = 'Software Engineer' OR Salary > 100000;

-- Task A8: Excluding all personnel belonging to Marketing or Sales.
SELECT *
FROM Employee
WHERE DeptName != 'Marketing' AND DeptName != 'Sales';