-- ==============================================================================
-- LAB 07: Advanced Filters (BETWEEN, IN, LIKE, IS NULL, ORDER BY, LIMIT)[cite: 12]
-- Roll Number: 2024-SE_31
-- Description: Applying advanced pattern matching, range filtering, and 
--              result limiting on the Employee and Bookstore databases.
-- ==============================================================================

-- ==============================================================================
-- SECTION 1: EMPLOYEE DATABASE SETUP & TASKS (PART B)
-- ==============================================================================
CREATE DATABASE IF NOT EXISTS filters_lab;
USE filters_lab;

DROP TABLE IF EXISTS Employee;

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

-- Task B1: Finding salaries within a specific range, sorted lowest to highest.
SELECT *
FROM Employee
WHERE Salary BETWEEN 75000 AND 100000
ORDER BY Salary ASC;

-- Task B2: Filtering for employees hired between 2020 and 2022.
SELECT *
FROM Employee
WHERE HireDate BETWEEN '2020-01-01' AND '2022-12-31';

-- Task B3: Excluding salaries that fall into the 80k to 100k bracket.
SELECT *
FROM Employee
WHERE Salary NOT BETWEEN 80000 AND 100000;

-- Task B4: Locating personnel in specific cities, utilizing a multi-column sort.
SELECT *
FROM Employee
WHERE City IN ('Lahore', 'Islamabad')
ORDER BY City ASC, Salary DESC;

-- Task B5: Excluding specific departments using a single IN clause.
SELECT *
FROM Employee
WHERE DeptName NOT IN ('Engineering', 'Sales', 'HR');

-- Task B6: Finding employees whose names begin with the letter 'M'.
SELECT EmpName
FROM Employee
WHERE EmpName LIKE 'M%';

-- Task B7: Extracting names containing the letter 'a' anywhere inside them.
SELECT *
FROM Employee
WHERE EmpName LIKE '%a%';

-- Task B8: Extracting names ending with the sequence 'an'.
SELECT *
FROM Employee
WHERE EmpName LIKE '%an';

-- Task B9: Locating engineers working outside the core Engineering department.
SELECT *
FROM Employee
WHERE JobTitle LIKE '%Engineer%' AND DeptName != 'Engineering';

-- Task B10: Finding records with missing city data.
SELECT EmpName
FROM Employee
WHERE City IS NULL;

-- Task B11: Filtering out incomplete records to show only confirmed city locations.
SELECT *
FROM Employee
WHERE City IS NOT NULL
ORDER BY City ASC;

-- Task B12: Retrieving the top 3 highest earners in the company.
SELECT EmpName, Salary
FROM Employee
ORDER BY Salary DESC
LIMIT 3;

-- Task B13: Finding the 5 most recently hired employees.
SELECT *
FROM Employee
ORDER BY HireDate DESC
LIMIT 5;

-- Task B14: Locating the 3 employees with the lowest salaries.
SELECT EmpName, Salary
FROM Employee
ORDER BY Salary ASC
LIMIT 3;

-- Task B15: Organizing the roster by department, then by seniority within the department.
SELECT *
FROM Employee
ORDER BY DeptName ASC, HireDate ASC;


-- ==============================================================================
-- SECTION 2: BOOKSTORE ASSESSMENT PROBLEM
-- ==============================================================================
CREATE DATABASE IF NOT EXISTS bookstore_lab;
USE bookstore_lab;

DROP TABLE IF EXISTS Book;

CREATE TABLE Book (
    BookID       INT          PRIMARY KEY,
    Title        VARCHAR(80)  NOT NULL,
    Author       VARCHAR(60),
    Genre        VARCHAR(30),
    Price        DECIMAL(8,2),
    StockQty     INT,
    PublishedYear INT,
    Publisher    VARCHAR(40),
    Language     VARCHAR(20)
);

INSERT INTO Book VALUES
(1,  'Pride and Prejudice',       'Jane Austen',       'Fiction',   850,  12, 1813, 'Penguin',       'English'),
(2,  'Emma',                      'Jane Austen',       'Fiction',   900,   8, 1815, 'Penguin',       'English'),
(3,  'Things Fall Apart',         'Chinua Achebe',     'Fiction',  1100,   5, 1958, 'Heinemann',     'English'),
(4,  'Norwegian Wood',            'Haruki Murakami',   'Fiction',  1500,   3, 1987, 'Vintage',       'English'),
(5,  'Kafka on the Shore',        'Haruki Murakami',   'Fiction',  1700,   0, 2002, 'Vintage',       'English'),
(6,  'Ice-Candy-Man',             'Bapsi Sidhwa',      'Fiction',  1200,  15, 1988, 'Penguin',       'English'),
(7,  'The Reluctant Fundamentalist','Mohsin Hamid',    'Fiction',  1300,   9, 2007, 'Penguin',       'English'),
(8,  'Exit West',                 'Mohsin Hamid',      'Fiction',  1450,   6, 2017, 'Riverhead',     'English'),
(9,  'Atomic Habits',             'James Clear',       'Self-help',1800,  20, 2018, 'Avery',         'English'),
(10, 'The Power of Habit',        'Charles Duhigg',    'Self-help',1600,  11, 2012, 'Random House',  'English'),
(11, 'Sapiens',                   'Yuval Harari',      'History',  2200,   7, 2011, 'Harper',        'English'),
(12, 'Rich Dad Poor Dad',         'Robert Kiyosaki',   'Finance',  1100,  25, 1997, 'Plata',         'English'),
(13, 'Aab-e-Hayat',               'Ibn-e-Safi',        'Mystery',   650,  18, 1955, 'Asrar',         'Urdu'),
(14, 'Raja Gidh',                 'Bano Qudsia',       'Fiction',   900,  14, 1981, 'Sang-e-Meel',   'Urdu'),
(15, 'Mystery Title',             NULL,                'Mystery',   950,   4, 2020, NULL,            'English');

-- Q1: Retrieving premium titles over 1500 PKR.
SELECT Title, Price
FROM Book
WHERE Price > 1500;

-- Q2: Finding 20th-century publications sorted chronologically.
SELECT Title, PublishedYear
FROM Book
WHERE PublishedYear BETWEEN 1900 AND 2000
ORDER BY PublishedYear ASC;

-- Q3: Filtering specific genres with healthy stock levels.
SELECT *
FROM Book
WHERE Genre IN ('Fiction', 'Mystery')
  AND StockQty > 5;

-- Q4: Locating books containing 'the' anywhere in the title (case-insensitive).
SELECT Title, Author
FROM Book
WHERE Title LIKE '%the%';

-- Q5: Identifying titles starting with 'A' or ending in 't'.
SELECT Title
FROM Book
WHERE Title LIKE 'A%'
   OR Title LIKE '%t';

-- Q6: Locating books missing author data.
SELECT Title
FROM Book
WHERE Author IS NULL;

-- Q7: Identifying books that need restocking or publisher updates.
SELECT *
FROM Book
WHERE StockQty = 0
   OR Publisher IS NULL;

-- Q8: Finding the top 3 most expensive books currently available in inventory.
SELECT *
FROM Book
WHERE StockQty > 0
ORDER BY Price DESC
LIMIT 3;

-- Q9: Displaying the Urdu collection chronologically.
SELECT *
FROM Book
WHERE Language = 'Urdu'
ORDER BY PublishedYear ASC;

-- Q10: Complex multi-column sorting for affordable classic books.
SELECT *
FROM Book
WHERE PublishedYear < 2000
  AND Price < 1200
ORDER BY Genre ASC, Title ASC;