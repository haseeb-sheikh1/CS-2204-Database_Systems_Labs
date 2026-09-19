-- ==============================================================================
-- LAB 04: NORMALIZATION - OVERVIEW AND 1NF
-- Roll Number : 2024-SE-31
-- Description : Initial analysis of the Bookstore data, identifying FDs, 
--               anomalies, and implementing First Normal Form (1NF).
-- ==============================================================================

/*
TASK 1: FD AND ANOMALY ANALYSIS
Analyzing the raw bookstore data reveals the following Functional Dependencies:
* OrderID -> OrderDate, CustID
* CustID -> CustName, CustEmail
* BookID -> BookTitle, Publisher, UnitPrice
* (OrderID, BookID) -> Qty

This unnormalized design suffers from three major anomalies:
* Insertion Anomaly: A new book cannot be added to the inventory unless a customer actually buys it.
* Update Anomaly: If a book's price changes, every single order row containing that book must be updated.
* Deletion Anomaly: Deleting order O-502 permanently erases Areeba's email address from the system.
*/

-- ==============================================================================
-- TASK 2: 1NF IMPLEMENTATION
-- ==============================================================================
CREATE DATABASE IF NOT EXISTS bookstore_norm;
USE bookstore_norm;

DROP TABLE IF EXISTS OrderBook_1NF;

-- To achieve 1NF, all values are made atomic and repeating groups are removed.
-- The combination of (OrderID, BookID) serves as the composite primary key.
CREATE TABLE OrderBook_1NF (
    OrderID VARCHAR(10),
    BookID VARCHAR(10),
    OrderDate DATE,
    CustID VARCHAR(10),
    CustName VARCHAR(50),
    CustEmail VARCHAR(50),
    BookTitle VARCHAR(60),
    Publisher VARCHAR(50),
    UnitPrice DECIMAL(10,2),
    Qty INT,
    PRIMARY KEY (OrderID, BookID)
);

-- Inserting the atomic data based on the original flat table.
INSERT INTO OrderBook_1NF VALUES
('O-501', 'B-1', '2026-04-02', 'C-11', 'Bilal', 'bilal@x.com', 'SQL Basics', 'Pearson', 1200, 1),
('O-501', 'B-2', '2026-04-02', 'C-11', 'Bilal', 'bilal@x.com', 'Python 101', 'OReilly', 1500, 2),
('O-502', 'B-1', '2026-04-03', 'C-12', 'Areeba', 'areeba@x.com', 'SQL Basics', 'Pearson', 1200, 3),
('O-503', 'B-3', '2026-04-05', 'C-11', 'Bilal', 'bilal@x.com', 'Networks', 'Pearson', 1800, 1),
('O-503', 'B-2', '2026-04-05', 'C-11', 'Bilal', 'bilal@x.com', 'Python 101', 'OReilly', 1500, 1);