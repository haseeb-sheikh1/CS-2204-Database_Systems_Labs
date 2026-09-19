-- ==============================================================================
-- LAB 05: CONVERSION TO 2NF AND 3NF (PLUS ASSESSMENT)
-- Roll Number : 2024-SE-31
-- Description : Step-by-step decomposition of the Bookstore data into 2NF/3NF, 
--               followed by a complete solution for the Hospital Assessment.
-- ==============================================================================

-- Ensuring this script runs independently by creating the database first.
CREATE DATABASE IF NOT EXISTS bookstore_norm;
USE bookstore_norm;

-- ==============================================================================
-- TASK 1: 2NF CONVERSION (Bookstore)
-- Removing partial dependencies. The data is split so non-prime attributes 
-- depend entirely on the whole Primary Key, not just a part of it.
-- ==============================================================================
DROP TABLE IF EXISTS OrderDetail_2NF, Order_2NF, Book_2NF;

CREATE TABLE Order_2NF (
    OrderID VARCHAR(10) PRIMARY KEY,
    OrderDate DATE,
    CustID VARCHAR(10),
    CustName VARCHAR(50),
    CustEmail VARCHAR(50)
);

CREATE TABLE Book_2NF (
    BookID VARCHAR(10) PRIMARY KEY,
    BookTitle VARCHAR(60),
    Publisher VARCHAR(50),
    UnitPrice DECIMAL(10,2)
);

CREATE TABLE OrderDetail_2NF (
    OrderID VARCHAR(10),
    BookID VARCHAR(10),
    Qty INT,
    PRIMARY KEY (OrderID, BookID),
    FOREIGN KEY (OrderID) REFERENCES Order_2NF(OrderID),
    FOREIGN KEY (BookID) REFERENCES Book_2NF(BookID)
);

-- ==============================================================================
-- TASK 2: 3NF CONVERSION (Bookstore)
-- A transitive dependency exists in the Order_2NF table (OrderID -> CustID -> CustName).
-- Customer details are extracted into a separate table to achieve 3NF.
-- ==============================================================================
DROP TABLE IF EXISTS OrderDetail_3NF, Order_3NF, Book_3NF, Customer_3NF;

CREATE TABLE Customer_3NF (
    CustID VARCHAR(10) PRIMARY KEY,
    CustName VARCHAR(50),
    CustEmail VARCHAR(50)
);

CREATE TABLE Book_3NF (
    BookID VARCHAR(10) PRIMARY KEY,
    BookTitle VARCHAR(60),
    Publisher VARCHAR(50),
    UnitPrice DECIMAL(10,2)
);

CREATE TABLE Order_3NF (
    OrderID VARCHAR(10) PRIMARY KEY,
    OrderDate DATE,
    CustID VARCHAR(10),
    FOREIGN KEY (CustID) REFERENCES Customer_3NF(CustID)
);

CREATE TABLE OrderDetail_3NF (
    OrderID VARCHAR(10),
    BookID VARCHAR(10),
    Qty INT,
    PRIMARY KEY (OrderID, BookID),
    FOREIGN KEY (OrderID) REFERENCES Order_3NF(OrderID),
    FOREIGN KEY (BookID) REFERENCES Book_3NF(BookID)
);

-- Populating the final 3NF tables
INSERT INTO Customer_3NF VALUES ('C-11', 'Bilal', 'bilal@x.com'), ('C-12', 'Areeba', 'areeba@x.com');
INSERT INTO Book_3NF VALUES ('B-1', 'SQL Basics', 'Pearson', 1200), ('B-2', 'Python 101', 'OReilly', 1500), ('B-3', 'Networks', 'Pearson', 1800);
INSERT INTO Order_3NF VALUES ('O-501', '2026-04-02', 'C-11'), ('O-502', '2026-04-03', 'C-12'), ('O-503', '2026-04-05', 'C-11');
INSERT INTO OrderDetail_3NF VALUES ('O-501', 'B-1', 1), ('O-501', 'B-2', 2), ('O-502', 'B-1', 3), ('O-503', 'B-3', 1), ('O-503', 'B-2', 1);

-- ==============================================================================
-- TASK 3 & 4: VERIFICATION & REFLECTION (Bookstore)
-- ==============================================================================
-- Joining the 3NF tables to ensure the original flat report can be perfectly recreated.
SELECT o.OrderID, b.BookTitle, b.Publisher, b.UnitPrice, od.Qty
FROM OrderDetail_3NF od
JOIN Order_3NF o ON od.OrderID = o.OrderID
JOIN Book_3NF b ON od.BookID = b.BookID;

-- Querying the total spend per customer from the normalized schema.
SELECT c.CustName, SUM(b.UnitPrice * od.Qty) AS TotalSpend
FROM Customer_3NF c
JOIN Order_3NF o ON c.CustID = o.CustID
JOIN OrderDetail_3NF od ON o.OrderID = od.OrderID
JOIN Book_3NF b ON od.BookID = b.BookID
GROUP BY c.CustID, c.CustName;

/*
Reflection: Breaking the data down into 3NF ensures every entity is stored exactly once. 
This successfully resolves the insertion anomaly (books can be added without orders), 
the update anomaly (updating a price in Book_3NF updates it everywhere), 
and the deletion anomaly (deleting an order leaves the customer's data intact).
*/


-- ==============================================================================
-- HOSPITAL ASSESSMENT PROBLEM (Complete 1NF to 3NF Solution)
-- ==============================================================================
CREATE DATABASE IF NOT EXISTS hospital_norm;
USE hospital_norm;

/*
DELIVERABLE 1: FDs & CANDIDATE KEY
Candidate Key: VisitID
Identified Functional Dependencies:
1. VisitID -> VisitDate, PatientID, DoctorID, Diagnosis, Fee
2. PatientID -> PatientName, PatientPhone
3. DoctorID -> DoctorName, Specialty, DeptName, DeptHead
*/

-- ==============================================================================
-- DELIVERABLE 2: 1NF SCHEMA
-- ==============================================================================
DROP TABLE IF EXISTS Hospital_1NF;

CREATE TABLE Hospital_1NF (
    VisitID VARCHAR(10) PRIMARY KEY,
    VisitDate DATE,
    PatientID VARCHAR(10),
    PatientName VARCHAR(50),
    PatientPhone VARCHAR(20),
    DoctorID VARCHAR(10),
    DoctorName VARCHAR(50),
    Specialty VARCHAR(50),
    DeptName VARCHAR(50),
    DeptHead VARCHAR(50),
    Diagnosis VARCHAR(50),
    Fee DECIMAL(10,2)
);

INSERT INTO Hospital_1NF VALUES
('V-9001', '2026-04-10', 'P-201', 'Hassan', '0300-1112233', 'D-30', 'Dr. Imran', 'Cardiology', 'Heart Care', 'Dr. Tariq', 'Hypertension', 2500),
('V-9002', '2026-04-10', 'P-202', 'Mehreen', '0301-4445566', 'D-31', 'Dr. Asma', 'Dermatology', 'Skin Clinic', 'Dr. Asma', 'Eczema', 2000),
('V-9003', '2026-04-11', 'P-201', 'Hassan', '0300-1112233', 'D-31', 'Dr. Asma', 'Dermatology', 'Skin Clinic', 'Dr. Asma', 'Allergy', 2000),
('V-9004', '2026-04-12', 'P-203', 'Junaid', '0302-7778899', 'D-30', 'Dr. Imran', 'Cardiology', 'Heart Care', 'Dr. Tariq', 'Arrhythmia', 3000);

-- ==============================================================================
-- DELIVERABLE 3: 2NF SCHEMA JUSTIFICATION
-- Because the primary key (VisitID) is a single column, partial dependencies 
-- cannot exist. Therefore, the 1NF table is automatically in 2NF.
-- ==============================================================================

-- ==============================================================================
-- DELIVERABLE 4: 3NF SCHEMA (Final Decomposed Schema)
-- Eliminating all transitive dependencies (e.g., DoctorID -> Specialty) 
-- by splitting the data into focused, independent tables.
-- ==============================================================================
DROP TABLE IF EXISTS Visits, Patients, Doctors, Departments;

CREATE TABLE Departments (
    Specialty VARCHAR(100) PRIMARY KEY,
    DeptName  VARCHAR(100) NOT NULL,
    DeptHead  VARCHAR(100) NOT NULL
);

CREATE TABLE Doctors (
    DoctorID   VARCHAR(10) PRIMARY KEY,
    DoctorName VARCHAR(100) NOT NULL,
    Specialty  VARCHAR(100) NOT NULL,
    FOREIGN KEY (Specialty) REFERENCES Departments(Specialty)
);

CREATE TABLE Patients (
    PatientID    VARCHAR(10) PRIMARY KEY,
    PatientName  VARCHAR(100) NOT NULL,
    PatientPhone VARCHAR(20)  NOT NULL
);

CREATE TABLE Visits (
    VisitID   VARCHAR(10) PRIMARY KEY,
    VisitDate DATE NOT NULL,
    PatientID VARCHAR(10) NOT NULL,
    DoctorID  VARCHAR(10) NOT NULL,
    Diagnosis VARCHAR(200) NOT NULL,
    Fee       DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID)  REFERENCES Doctors(DoctorID)
);

-- Populating the 3NF Tables
INSERT INTO Departments VALUES ('Cardiology', 'Heart Care', 'Dr. Tariq'), ('Dermatology', 'Skin Clinic', 'Dr. Asma');
INSERT INTO Doctors VALUES ('D-30', 'Dr. Imran', 'Cardiology'), ('D-31', 'Dr. Asma', 'Dermatology');
INSERT INTO Patients VALUES ('P-201', 'Hassan', '0300-1112233'), ('P-202', 'Mehreen', '0301-4445566'), ('P-203', 'Junaid', '0302-7778899');
INSERT INTO Visits VALUES 
('V-9001', '2026-04-10', 'P-201', 'D-30', 'Hypertension', 2500.00),
('V-9002', '2026-04-10', 'P-202', 'D-31', 'Eczema', 2000.00),
('V-9003', '2026-04-11', 'P-201', 'D-31', 'Allergy', 2000.00),
('V-9004', '2026-04-12', 'P-203', 'D-30', 'Arrhythmia', 3000.00);

-- ==============================================================================
-- DELIVERABLE 5 & 6: RECONSTRUCTION & ANOMALY RESOLUTION
-- ==============================================================================
-- Rebuilding the original hospital view using the normalized tables.
SELECT v.VisitID, v.VisitDate, p.PatientID, p.PatientName, p.PatientPhone, 
       d.DoctorID, d.DoctorName, d.Specialty, dep.DeptName, dep.DeptHead, v.Diagnosis, v.Fee
FROM Visits v
JOIN Patients p ON v.PatientID = p.PatientID
JOIN Doctors d ON v.DoctorID = d.DoctorID
JOIN Departments dep ON d.Specialty = dep.Specialty
ORDER BY v.VisitID;

/*
Anomaly Resolution Summary:
1. Update Anomaly Eliminated: If a doctor's name changes, it only needs to be updated once in the Doctors table.
2. Insertion Anomaly Eliminated: A new department can be added to the Departments table before any doctors or patients are assigned to it.
3. Deletion Anomaly Eliminated: Deleting a patient's only visit leaves the associated doctor and department records perfectly intact.
*/