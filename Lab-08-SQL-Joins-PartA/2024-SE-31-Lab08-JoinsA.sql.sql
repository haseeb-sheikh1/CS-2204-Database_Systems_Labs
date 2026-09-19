-- ==============================================================================
-- LAB 08: SQL Joins - Inner, Left, and Right (Part A)
-- Roll Number: 2024-SE_31
-- Description: Exploring fundamental join mechanics across a multi-table 
--              corporate schema (Departments, Employees, Projects, Assignments).
-- ==============================================================================

-- ==============================================================================
-- SECTION 1: SETUP SCRIPT & DATA INITIALIZATION
-- ==============================================================================
CREATE DATABASE IF NOT EXISTS joins_lab;
USE joins_lab;
DROP TABLE IF EXISTS Assignment, Project, Employee, Department;

CREATE TABLE Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(40) NOT NULL,
    Location VARCHAR(30),
    Budget DECIMAL(12,2)
);

CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50) NOT NULL,
    Gender CHAR(1),
    Salary DECIMAL(10,2),
    HireDate DATE,
    City VARCHAR(30),
    ManagerID INT,
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID),
    FOREIGN KEY (ManagerID) REFERENCES Employee(EmpID)
);

CREATE TABLE Project (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(50) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

CREATE TABLE Assignment (
    EmpID INT,
    ProjectID INT,
    HoursPerWeek INT,
    PRIMARY KEY (EmpID, ProjectID),
    FOREIGN KEY (EmpID) REFERENCES Employee(EmpID),
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
);

INSERT INTO Department VALUES
(10, 'Engineering', 'Lahore', 5000000), (20, 'Marketing', 'Karachi', 2000000),
(30, 'Finance', 'Islamabad',3000000), (40, 'Research', 'Lahore', 4000000),
(50, 'Sales', 'Karachi', NULL); 

INSERT INTO Employee VALUES
(101,'Ali Khan', 'M', 120000,'2018-03-15','Lahore', NULL, 10), (102,'Sara Iqbal', 'F', 95000,'2019-06-01','Lahore', 101, 10),
(103,'Hamza Raza', 'M', 85000,'2020-01-20','Karachi', 101, 10), (104,'Ayesha Noor', 'F', 110000,'2017-11-10','Karachi', NULL, 20),
(105,'Bilal Ahmed', 'M', 70000,'2021-04-05','Karachi', 104, 20), (106,'Fatima Sheikh','F', 90000,'2019-09-12','Islamabad', NULL, 30),
(107,'Usman Tariq', 'M', 78000,'2022-02-18','Islamabad', 106, 30), (108,'Maira Javed', 'F', 115000,'2016-07-22','Lahore', NULL, 40),
(109,'Zain Abbas', 'M', 60000,'2023-01-09','Lahore', 108, 40), (110,'Nida Yousaf', 'F', 72000,'2022-08-30',NULL, 108, 40);

INSERT INTO Project VALUES
(1001,'Website Revamp', '2024-01-10','2024-06-30', 10), (1002,'Mobile App', '2024-03-01','2024-12-31', 10),
(1003,'Brand Campaign', '2024-02-15','2024-05-15', 20), (1004,'Audit System', '2024-04-01',NULL, 30),
(1005,'AI Research', '2024-05-01','2025-04-30', 40), (1006,'Internal Tool', '2024-06-01','2024-09-30', NULL); 

INSERT INTO Assignment VALUES
(101, 1001, 10), (102, 1001, 20), (102, 1002, 15), (103, 1002, 30),
(104, 1003, 25), (105, 1003, 40), (106, 1004, 35), (108, 1005, 20), (109, 1005, 30);


-- ==============================================================================
-- SECTION 2: PART A TASKS (INNER, LEFT, RIGHT JOINS)
-- ==============================================================================

-- Task A1: Mapping employees to their respective department details.
SELECT e.EmpName, d.DeptName, d.Location
FROM Employee e
INNER JOIN Department d ON e.DeptID = d.DeptID;

-- Task A2: Same as A1, but retaining all employees even if unassigned.
SELECT e.EmpName, d.DeptName, d.Location
FROM Employee e
LEFT JOIN Department d ON e.DeptID = d.DeptID;

-- Task A3: Displaying all departments, including those with zero current employees.
SELECT d.DeptName, e.EmpName
FROM Department d
LEFT JOIN Employee e ON d.DeptID = e.DeptID;

-- Task A4: Mapping projects to departments, retaining projects with no assigned department.
SELECT p.ProjectName, d.DeptName, d.Location
FROM Project p
LEFT JOIN Department d ON p.DeptID = d.DeptID;

-- Task A5: Finding "benched" employees who currently have no project assignments.
SELECT e.EmpName
FROM Employee e
LEFT JOIN Assignment a ON e.EmpID = a.EmpID
WHERE a.ProjectID IS NULL;

-- Task A6: Identifying dormant projects that lack any assigned staff.
SELECT p.ProjectName
FROM Project p
LEFT JOIN Assignment a ON p.ProjectID = a.ProjectID
WHERE a.EmpID IS NULL;

-- Task A7: Extracting the Engineering roster, sorted by highest earner.
SELECT e.EmpName, e.Salary
FROM Employee e
INNER JOIN Department d ON e.DeptID = d.DeptID
WHERE d.DeptName = 'Engineering'
ORDER BY e.Salary DESC;

-- Task A8: Filtering for personnel operating out of the Lahore office.
SELECT e.EmpName, d.DeptName
FROM Employee e
INNER JOIN Department d ON e.DeptID = d.DeptID
WHERE d.Location = 'Lahore';

-- Task A9: Calculating the total headcount per department (including empty departments).
SELECT d.DeptName, COUNT(e.EmpID) AS EmployeeCount
FROM Department d
LEFT JOIN Employee e ON d.DeptID = e.DeptID
GROUP BY d.DeptID, d.DeptName;

-- Task A10: Simulating a Full Outer Join using a UNION between Left and Right joins.
SELECT e.EmpName, d.DeptName
FROM Employee e
LEFT JOIN Department d ON e.DeptID = d.DeptID
UNION
SELECT e.EmpName, d.DeptName
FROM Employee e
RIGHT JOIN Department d ON e.DeptID = d.DeptID;