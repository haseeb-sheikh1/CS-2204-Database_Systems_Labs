-- ==============================================================================
-- LAB 09: SQL Joins - Self Joins, Multi-Table, & Assessment (Part B)
-- Roll Number: 2024-SE_31
-- Description: Executing complex Multi-Table and Self Joins on the corporate 
--              schema, followed by the complete Library Database Assessment.
-- ==============================================================================

-- Relying on the previously established joins_lab database.
USE joins_lab;

-- ==============================================================================
-- SECTION 1: PART B TASKS (SELF JOINS & MULTI-TABLE)
-- ==============================================================================

-- Task B1: Mapping employees directly to their respective managers using a Self Join.
SELECT e.EmpName AS EmployeeName, m.EmpName AS ManagerName
FROM Employee e
LEFT JOIN Employee m ON e.ManagerID = m.EmpID;

-- Task B2: Identifying anomalies where subordinates earn more than their direct managers.
SELECT e.EmpName AS EmployeeName, e.Salary AS EmployeeSalary, 
       m.EmpName AS ManagerName, m.Salary AS ManagerSalary
FROM Employee e
INNER JOIN Employee m ON e.ManagerID = m.EmpID
WHERE e.Salary > m.Salary;

-- Task B3: Locating employees whose assigned department differs from their manager's department.
SELECT e.EmpName, m.EmpName AS ManagerName, 
       ed.DeptName AS EmployeeDept, md.DeptName AS ManagerDept
FROM Employee e
INNER JOIN Employee m ON e.ManagerID = m.EmpID
INNER JOIN Department ed ON e.DeptID = ed.DeptID
INNER JOIN Department md ON m.DeptID = md.DeptID
WHERE e.DeptID != m.DeptID;

-- Task B4: Linking an employee to their assigned project and logging their weekly hours.
SELECT e.EmpName, p.ProjectName, a.HoursPerWeek
FROM Employee e
INNER JOIN Assignment a ON e.EmpID = a.EmpID
INNER JOIN Project p ON a.ProjectID = p.ProjectID;

-- Task B5: A comprehensive 4-table join pulling employee, assignment, project, and department data.
SELECT e.EmpName, p.ProjectName, d.DeptName
FROM Assignment a
INNER JOIN Employee e ON a.EmpID = e.EmpID
INNER JOIN Project p ON a.ProjectID = p.ProjectID
LEFT JOIN Department d ON p.DeptID = d.DeptID;

-- Task B6: Isolating the specific roster allocated to the 'Mobile App' project.
SELECT e.EmpName, a.HoursPerWeek
FROM Employee e
INNER JOIN Assignment a ON e.EmpID = a.EmpID
INNER JOIN Project p ON a.ProjectID = p.ProjectID
WHERE p.ProjectName = 'Mobile App';

-- Task B7: Extracting assignments strictly for the Lahore branch.
SELECT e.EmpName, p.ProjectName, a.HoursPerWeek
FROM Employee e
LEFT JOIN Assignment a ON e.EmpID = a.EmpID
LEFT JOIN Project p ON a.ProjectID = p.ProjectID
WHERE e.City = 'Lahore';

-- Task B8: Finding employees assigned to projects owned by a different department.
SELECT e.EmpName
FROM Employee e
INNER JOIN Assignment a ON e.EmpID = a.EmpID
INNER JOIN Project p ON a.ProjectID = p.ProjectID
WHERE e.DeptID != p.DeptID;

-- Task B9: Mapping departments to projects initiated specifically within the 2024 fiscal year.
SELECT d.DeptName, p.ProjectName
FROM Department d
LEFT JOIN Project p ON d.DeptID = p.DeptID 
    AND p.StartDate >= '2024-01-01' 
    AND p.StartDate <= '2024-12-31';

-- Task B10: Aggregating the total weekly hours logged per employee across all projects.
SELECT e.EmpName, COALESCE(SUM(a.HoursPerWeek), 0) AS TotalHours
FROM Employee e
LEFT JOIN Assignment a ON e.EmpID = a.EmpID
GROUP BY e.EmpID, e.EmpName;


-- ==============================================================================
-- SECTION 2: LIBRARY ASSESSMENT PROBLEM
-- ==============================================================================
CREATE DATABASE IF NOT EXISTS library_lab;
USE library_lab;
DROP TABLE IF EXISTS Loan, Book, Member, Author;

CREATE TABLE Author (
    AuthorID INT PRIMARY KEY,
    AuthorName VARCHAR(60) NOT NULL,
    Country VARCHAR(30)
);

CREATE TABLE Book (
    BookID INT PRIMARY KEY,
    Title VARCHAR(80) NOT NULL,
    Genre VARCHAR(30),
    Price DECIMAL(8,2),
    AuthorID INT,
    PublishedYear INT,
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID)
);

CREATE TABLE Member (
    MemberID INT PRIMARY KEY,
    MemberName VARCHAR(60) NOT NULL,
    City VARCHAR(30),
    JoinDate DATE
);

CREATE TABLE Loan (
    LoanID INT PRIMARY KEY,
    MemberID INT,
    BookID INT,
    LoanDate DATE,
    ReturnDate DATE, 
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID),
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
);

INSERT INTO Author VALUES
(1,'Jane Austen', 'UK'), (2,'Chinua Achebe', 'Nigeria'), (3,'Haruki Murakami', 'Japan'),
(4,'Bapsi Sidhwa', 'Pakistan'), (5,'Mohsin Hamid', 'Pakistan'), (6,'Anonymous Writer', NULL); 

INSERT INTO Book VALUES
(101,'Pride and Prejudice','Fiction', 850.00, 1, 1813), (102,'Emma', 'Fiction', 900.00, 1, 1815),
(103,'Things Fall Apart', 'Fiction', 1100.00, 2, 1958), (104,'Norwegian Wood', 'Fiction', 1500.00, 3, 1987),
(105,'Kafka on the Shore', 'Fiction', 1700.00, 3, 2002), (106,'Ice-Candy-Man', 'Fiction', 1200.00, 4, 1988),
(107,'The Reluctant Fundamentalist','Fiction',1300.00, 5, 2007), (108,'Exit West', 'Fiction', 1450.00, 5, 2017),
(109,'Mystery Title', 'Mystery', 950.00, NULL, 2020); 

INSERT INTO Member VALUES
(201,'Ahmad Raza', 'Lahore', '2023-01-15'), (202,'Sara Imran', 'Karachi', '2023-03-20'),
(203,'Bilal Khan', 'Lahore', '2024-02-10'), (204,'Fatima Ali', 'Islamabad', '2022-09-05'),
(205,'Hira Yousaf', NULL, '2024-05-01'); 

INSERT INTO Loan VALUES
(1, 201, 101, '2024-03-01', '2024-03-15'), (2, 201, 104, '2024-04-10', NULL),
(3, 202, 103, '2024-02-20', '2024-03-05'), (4, 202, 107, '2024-05-01', NULL),
(5, 203, 105, '2024-04-25', '2024-05-15'), (6, 204, 102, '2024-01-10', '2024-01-30'),
(7, 204, 108, '2024-06-01', NULL);

-- Q1: Linking books directly to author profiles.
SELECT b.Title, a.AuthorName, a.Country
FROM Book b
INNER JOIN Author a ON b.AuthorID = a.AuthorID;

-- Q2: Pulling all authors, including those without associated books in inventory.
SELECT a.AuthorName, b.Title
FROM Author a
LEFT JOIN Book b ON a.AuthorID = b.AuthorID;

-- Q3: Identifying members who have never checked out a book.
SELECT m.MemberName
FROM Member m
LEFT JOIN Loan l ON m.MemberID = l.MemberID
WHERE l.LoanID IS NULL;

-- Q4: A massive 4-table join mapping the entire lifecycle of a loan.
SELECT l.LoanID, m.MemberName, b.Title, a.AuthorName
FROM Loan l
INNER JOIN Member m ON l.MemberID = m.MemberID
INNER JOIN Book b ON l.BookID = b.BookID
LEFT JOIN Author a ON b.AuthorID = a.AuthorID;

-- Q5: Identifying active (unreturned) loans and the responsible members.
SELECT b.Title, m.MemberName, m.City
FROM Loan l
INNER JOIN Book b ON l.BookID = b.BookID
INNER JOIN Member m ON l.MemberID = m.MemberID
WHERE l.ReturnDate IS NULL;

-- Q6: Filtering the catalog specifically for Pakistani authors.
SELECT a.AuthorName, b.Title
FROM Author a
LEFT JOIN Book b ON a.AuthorID = b.AuthorID
WHERE a.Country = 'Pakistan';

-- Q7: Pulling all books along with loan history, keeping books that have never been checked out.
SELECT b.Title, m.MemberName
FROM Book b
LEFT JOIN Loan l ON b.BookID = l.BookID
LEFT JOIN Member m ON l.MemberID = m.MemberID;

-- Q8: Identifying authors whose books have strictly zero checkout history.
SELECT DISTINCT a.AuthorName
FROM Author a
INNER JOIN Book b ON a.AuthorID = b.AuthorID
LEFT JOIN Loan l ON b.BookID = l.BookID
WHERE l.LoanID IS NULL;

-- Q9: Full outer join simulation for Authors and Books.
SELECT a.AuthorName, b.Title
FROM Author a
LEFT JOIN Book b ON a.AuthorID = b.AuthorID
UNION
SELECT a.AuthorName, b.Title
FROM Author a
RIGHT JOIN Book b ON a.AuthorID = b.AuthorID;

-- Q10: A focused 4-table join to extract loan histories strictly for Pakistani literature.
SELECT m.MemberName, b.Title, a.AuthorName
FROM Loan l
INNER JOIN Member m ON l.MemberID = m.MemberID
INNER JOIN Book b ON l.BookID = b.BookID
INNER JOIN Author a ON b.AuthorID = a.AuthorID
WHERE a.Country = 'Pakistan';