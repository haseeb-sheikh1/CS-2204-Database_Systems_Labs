-- =====================================================================
--  CarGo Rentals - Car Rental Management System
--  DBMS Open-Ended Lab
--  Author: Sheikh Haseeb-ur-Rehman        Roll No: 2024-SE-31
--  Engine : MySQL 8.0+
-- =====================================================================
--  HOW TO RUN
--  1. Open MySQL Workbench (or terminal) and connect to your server.
--  2. Run this entire file top to bottom (Workbench: the lightning-bolt
--     "Execute" icon, or "Execute (All or Selection)" under the Query
--     menu). In terminal:  mysql -u root -p < CarGo_Rentals.sql
--  3. Sections are separated and labelled with banners like the one
--     above so you can also run them one block at a time and take a
--     screenshot after each block (see the report / instructions doc
--     for exactly which screenshots are required).
-- =====================================================================


-- =====================================================================
-- SECTION 1: DATABASE CREATION
-- =====================================================================
DROP DATABASE IF EXISTS CarGoRentals;
CREATE DATABASE CarGoRentals;
USE CarGoRentals;


-- =====================================================================
-- SECTION 2: TABLE DEFINITIONS (with PK, FK, and constraints)
-- =====================================================================

-- ---------------------------------------------------------------
-- Table: Customers
-- ---------------------------------------------------------------
CREATE TABLE Customers (
    CustomerID      INT AUTO_INCREMENT PRIMARY KEY,
    FullName        VARCHAR(100)      NOT NULL,
    Phone           VARCHAR(15)       NOT NULL UNIQUE,
    Email           VARCHAR(100)      UNIQUE,
    CNIC            VARCHAR(15)       NOT NULL UNIQUE,
    Address         VARCHAR(200),
    RegisteredOn    DATE              NOT NULL DEFAULT (CURRENT_DATE)
);

-- ---------------------------------------------------------------
-- Table: Vehicles
-- ---------------------------------------------------------------
CREATE TABLE Vehicles (
    VehicleID       INT AUTO_INCREMENT PRIMARY KEY,
    VehicleNumber   VARCHAR(20)       NOT NULL UNIQUE,
    Model           VARCHAR(50)       NOT NULL,
    VehicleType     VARCHAR(30)       NOT NULL DEFAULT 'Sedan',
    DailyRate       DECIMAL(10,2)     NOT NULL CHECK (DailyRate > 0),
    Status          ENUM('Available','Rented','Maintenance')
                                       NOT NULL DEFAULT 'Available'
);

-- ---------------------------------------------------------------
-- Table: Rentals
--  A vehicle cannot be double-booked: enforced in application logic
--  via the stored procedure AND at the database level via the
--  BEFORE INSERT trigger trg_CheckVehicleAvailability (Section 6).
-- ---------------------------------------------------------------
CREATE TABLE Rentals (
    RentalID            INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID          INT           NOT NULL,
    VehicleID           INT           NOT NULL,
    RentalDate          DATE          NOT NULL,
    ExpectedReturnDate  DATE          NOT NULL,
    Status              ENUM('Ongoing','Completed','Cancelled')
                                       NOT NULL DEFAULT 'Ongoing',
    CONSTRAINT fk_rental_customer FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_rental_vehicle FOREIGN KEY (VehicleID)
        REFERENCES Vehicles(VehicleID)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_rental_dates CHECK (ExpectedReturnDate >= RentalDate)
);

-- ---------------------------------------------------------------
-- Table: Returns  (one return record per rental)
-- ---------------------------------------------------------------
CREATE TABLE Returns (
    ReturnID          INT AUTO_INCREMENT PRIMARY KEY,
    RentalID          INT           NOT NULL UNIQUE,
    ActualReturnDate  DATE          NOT NULL,
    VehicleCondition  VARCHAR(50)   NOT NULL DEFAULT 'Good',
    LateFee           DECIMAL(10,2) NOT NULL DEFAULT 0.00 CHECK (LateFee >= 0),
    CONSTRAINT fk_return_rental FOREIGN KEY (RentalID)
        REFERENCES Rentals(RentalID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ---------------------------------------------------------------
-- Table: Payments
-- ---------------------------------------------------------------
CREATE TABLE Payments (
    PaymentID       INT AUTO_INCREMENT PRIMARY KEY,
    RentalID        INT           NOT NULL,
    Amount          DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
    PaymentDate     DATE          NOT NULL DEFAULT (CURRENT_DATE),
    PaymentMethod   ENUM('Cash','Card','Online') NOT NULL DEFAULT 'Cash',
    CONSTRAINT fk_payment_rental FOREIGN KEY (RentalID)
        REFERENCES Rentals(RentalID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Helpful indexes for reporting / JOIN performance (see Task 7 - Optimization)
CREATE INDEX idx_rentals_customer ON Rentals(CustomerID);
CREATE INDEX idx_rentals_vehicle  ON Rentals(VehicleID);
CREATE INDEX idx_payments_rental  ON Payments(RentalID);


-- =====================================================================
-- SECTION 3: SAMPLE DATA
-- =====================================================================

INSERT INTO Customers (FullName, Phone, Email, CNIC, Address) VALUES
('Ali Khan',        '0300-1234567', 'ali.khan@example.com',      '35202-1111111-1', 'Model Town, Lahore'),
('Sara Ahmed',       '0321-2345678', 'sara.ahmed@example.com',    '35202-2222222-2', 'Gulberg, Lahore'),
('Bilal Hussain',    '0333-3456789', 'bilal.h@example.com',       '42101-3333333-3', 'Clifton, Karachi'),
('Ayesha Raza',      '0345-4567890', 'ayesha.raza@example.com',   '42101-4444444-4', 'North Nazimabad, Karachi'),
('Usman Tariq',      '0301-5678901', 'usman.tariq@example.com',   '61101-5555555-5', 'G-9, Islamabad');

INSERT INTO Vehicles (VehicleNumber, Model, VehicleType, DailyRate, Status) VALUES
('ABC-123', 'Toyota Corolla',  'Sedan', 5000.00, 'Available'),
('LEA-456', 'Honda Civic',     'Sedan', 5500.00, 'Available'),
('KHI-789', 'Suzuki Cultus',   'Hatchback', 3500.00, 'Available'),
('ISB-321', 'Toyota Hiace',    'Van',   9000.00, 'Available'),
('LEB-654', 'Honda City',      'Sedan', 4800.00, 'Available');

-- Rentals: some completed (with returns+payments), some still ongoing
INSERT INTO Rentals (CustomerID, VehicleID, RentalDate, ExpectedReturnDate, Status) VALUES
(1, 1, '2026-09-01', '2026-09-04', 'Completed'),   -- Ali Khan  -> Corolla
(2, 2, '2026-09-05', '2026-09-08', 'Completed'),   -- Sara Ahmed -> Civic
(3, 3, '2026-09-10', '2026-09-12', 'Completed'),   -- Bilal Hussain -> Cultus
(1, 4, '2026-09-15', '2026-09-17', 'Ongoing'),     -- Ali Khan  -> Hiace (currently rented)
(4, 5, '2026-09-18', '2026-09-20', 'Ongoing');     -- Ayesha Raza -> Honda City (currently rented)
-- Note: Usman Tariq (CustomerID 5) has NOT rented any vehicle yet -> used to
-- demonstrate LEFT JOIN / "customers with no rentals" queries.

-- Reflect that vehicles 4 and 5 are currently out (normally done by the
-- trigger automatically when a rental is inserted through the procedure;
-- set explicitly here since these two rows were inserted directly).
UPDATE Vehicles SET Status = 'Rented' WHERE VehicleID IN (4, 5);

-- Returns for the three completed rentals
INSERT INTO Returns (RentalID, ActualReturnDate, VehicleCondition, LateFee) VALUES
(1, '2026-09-04', 'Good', 0.00),
(2, '2026-09-09', 'Good', 500.00),   -- returned 1 day late
(3, '2026-09-12', 'Minor scratch', 0.00);

-- Payments matching the completed rentals (DailyRate * days + late fee)
INSERT INTO Payments (RentalID, Amount, PaymentDate, PaymentMethod) VALUES
(1, 15000.00, '2026-09-04', 'Cash'),    -- 3 days * 5000
(2, 17000.00, '2026-09-09', 'Card'),    -- 3 days * 5500 + 500 late fee
(3, 7000.00,  '2026-09-12', 'Online');  -- 2 days * 3500


-- =====================================================================
-- SECTION 4: TASK 3 - JOIN QUERIES
-- =====================================================================

-- ---------------------------------------------------------------
-- Q1. Customer name, vehicle number, vehicle model, rental date,
--     and return date for EVERY rental.
--     (INNER JOIN: only rows that have a matching customer & vehicle;
--      LEFT JOIN to Returns because ongoing rentals have no return yet)
-- ---------------------------------------------------------------
SELECT
    c.FullName                         AS CustomerName,
    v.VehicleNumber,
    v.Model                            AS VehicleModel,
    r.RentalDate,
    COALESCE(rt.ActualReturnDate, r.ExpectedReturnDate) AS ReturnDate,
    r.Status
FROM Rentals r
INNER JOIN Customers c ON r.CustomerID = c.CustomerID
INNER JOIN Vehicles  v ON r.VehicleID  = v.VehicleID
LEFT  JOIN Returns   rt ON r.RentalID  = rt.RentalID
ORDER BY r.RentalDate;

-- ---------------------------------------------------------------
-- Q2. All customers and the vehicles they have rented.
--     Customers who never rented must still appear (LEFT JOIN).
-- ---------------------------------------------------------------
SELECT
    c.FullName                         AS CustomerName,
    v.VehicleNumber,
    v.Model                            AS VehicleModel,
    r.RentalDate
FROM Customers c
LEFT JOIN Rentals  r ON c.CustomerID = r.CustomerID
LEFT JOIN Vehicles v ON r.VehicleID  = v.VehicleID
ORDER BY c.FullName;

-- ---------------------------------------------------------------
-- Q3. All vehicles and their current rental information.
--     Vehicles that are currently NOT rented must still appear.
-- ---------------------------------------------------------------
SELECT
    v.VehicleNumber,
    v.Model                            AS VehicleModel,
    v.Status                           AS VehicleStatus,
    c.FullName                         AS CurrentRenter,
    r.RentalDate,
    r.ExpectedReturnDate
FROM Vehicles v
LEFT JOIN Rentals   r ON v.VehicleID = r.VehicleID AND r.Status = 'Ongoing'
LEFT JOIN Customers c ON r.CustomerID = c.CustomerID
ORDER BY v.VehicleNumber;

-- ---------------------------------------------------------------
-- Q4. Total number of rentals made by each customer, including
--     customers who have made no rentals at all.
-- ---------------------------------------------------------------
SELECT
    c.CustomerID,
    c.FullName                         AS CustomerName,
    COUNT(r.RentalID)                  AS TotalRentals
FROM Customers c
LEFT JOIN Rentals r ON c.CustomerID = r.CustomerID
GROUP BY c.CustomerID, c.FullName
ORDER BY TotalRentals DESC;


-- =====================================================================
-- SECTION 5: TASK 4 - VIEW
-- =====================================================================
-- vw_RentalReport gives management a single, ready-to-query object
-- with everything needed for a rental report (customer, vehicle,
-- rental period, status, and payment) instead of writing the same
-- multi-table JOIN by hand every time.
-- =====================================================================
CREATE OR REPLACE VIEW vw_RentalReport AS
SELECT
    r.RentalID,
    c.FullName            AS CustomerName,
    c.Phone                AS CustomerPhone,
    v.VehicleNumber,
    v.Model                AS VehicleModel,
    v.DailyRate,
    r.RentalDate,
    r.ExpectedReturnDate,
    rt.ActualReturnDate,
    r.Status                AS RentalStatus,
    p.Amount                AS AmountPaid,
    p.PaymentMethod
FROM Rentals r
JOIN Customers c        ON r.CustomerID = c.CustomerID
JOIN Vehicles  v        ON r.VehicleID  = v.VehicleID
LEFT JOIN Returns  rt   ON r.RentalID   = rt.RentalID
LEFT JOIN Payments p    ON r.RentalID   = p.RentalID;

-- Demonstrate / screenshot this:
SELECT * FROM vw_RentalReport ORDER BY RentalID;


-- =====================================================================
-- SECTION 6: TRIGGER
-- =====================================================================
-- trg_CheckVehicleAvailability
--   Business rule from the scenario: "A vehicle should not be available
--   for another rental while it is already rented."
--   Fires BEFORE INSERT on Rentals and blocks the insert (SIGNAL) if the
--   vehicle's Status is not 'Available'. On a successful insert it also
--   flips the vehicle to 'Rented' automatically.
-- =====================================================================
DELIMITER $$

CREATE TRIGGER trg_CheckVehicleAvailability
BEFORE INSERT ON Rentals
FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(20);

    SELECT Status INTO v_status
    FROM Vehicles
    WHERE VehicleID = NEW.VehicleID;

    IF v_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Vehicle does not exist.';
    ELSEIF v_status <> 'Available' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'This vehicle is already rented / unavailable.';
    END IF;
END$$

-- Companion trigger: once a rental row is actually inserted, mark the
-- vehicle as Rented so the rule above works for the NEXT booking attempt.
CREATE TRIGGER trg_MarkVehicleRented
AFTER INSERT ON Rentals
FOR EACH ROW
BEGIN
    UPDATE Vehicles
    SET Status = 'Rented'
    WHERE VehicleID = NEW.VehicleID;
END$$

-- Companion trigger: when a Return is recorded, free the vehicle again
-- and close the rental.
CREATE TRIGGER trg_FreeVehicleOnReturn
AFTER INSERT ON Returns
FOR EACH ROW
BEGIN
    UPDATE Vehicles
    SET Status = 'Available'
    WHERE VehicleID = (SELECT VehicleID FROM Rentals WHERE RentalID = NEW.RentalID);

    UPDATE Rentals
    SET Status = 'Completed'
    WHERE RentalID = NEW.RentalID;
END$$

DELIMITER ;

-- ---------------------------------------------------------------
-- Vehicle 4 (Hiace) is currently 'Rented', so this insert MUST fail.
-- ---------------------------------------------------------------
-- INSERT INTO Rentals (CustomerID, VehicleID, RentalDate, ExpectedReturnDate)
-- VALUES (2, 4, '2026-09-21', '2026-09-23');
-- Expected result: Error 1644 (45000): This vehicle is already rented / unavailable.


-- =====================================================================
-- SECTION 7: STORED PROCEDURE
-- =====================================================================
-- sp_RegisterRental
--   Registers a new rental for an available vehicle and calculates the
--   rental charge as (number of days * vehicle's daily rate). It also
--   creates the matching Payment record. Relies on trg_CheckVehicleAvailability
--   to reject the booking if the vehicle is not free.
-- =====================================================================
DELIMITER $$

CREATE PROCEDURE sp_RegisterRental (
    IN  p_CustomerID    INT,
    IN  p_VehicleID     INT,
    IN  p_RentalDate    DATE,
    IN  p_ReturnDate    DATE,
    IN  p_PaymentMethod VARCHAR(10),
    OUT p_RentalID      INT,
    OUT p_TotalCharge   DECIMAL(10,2)
)
BEGIN
    DECLARE v_DailyRate DECIMAL(10,2);
    DECLARE v_Days      INT;

    -- Fetch the vehicle's daily rate (fails naturally if VehicleID invalid)
    SELECT DailyRate INTO v_DailyRate
    FROM Vehicles
    WHERE VehicleID = p_VehicleID;

    SET v_Days = GREATEST(DATEDIFF(p_ReturnDate, p_RentalDate), 1);
    SET p_TotalCharge = v_Days * v_DailyRate;

    -- This INSERT will be blocked by trg_CheckVehicleAvailability if the
    -- vehicle is already rented, so the whole procedure fails safely.
    INSERT INTO Rentals (CustomerID, VehicleID, RentalDate, ExpectedReturnDate, Status)
    VALUES (p_CustomerID, p_VehicleID, p_RentalDate, p_ReturnDate, 'Ongoing');

    SET p_RentalID = LAST_INSERT_ID();

    INSERT INTO Payments (RentalID, Amount, PaymentDate, PaymentMethod)
    VALUES (p_RentalID, p_TotalCharge, p_RentalDate, p_PaymentMethod);
END$$

DELIMITER ;

-- ---------------------------------------------------------------

-- registers vehicle 3 (Cultus, currently Available)
-- to Usman Tariq (CustomerID 5, who had zero rentals before this).
-- ---------------------------------------------------------------
CALL sp_RegisterRental(5, 3, '2026-09-21', '2026-09-23', 'Cash', @newRentalID, @charge);
SELECT @newRentalID AS NewRentalID, @charge AS TotalCharge;


SELECT * FROM Vehicles WHERE VehicleID = 3;
SELECT * FROM vw_RentalReport WHERE RentalID = @newRentalID;


-- =====================================================================
-- SECTION 8: TASK 7 - OPTIMIZATION (see report for full analysis)
-- =====================================================================
-- Example: finding all currently rented vehicles without an index would
-- force a full table scan on Rentals as it grows. idx_rentals_vehicle
-- (created in Section 2) lets MySQL use an index lookup instead.

EXPLAIN SELECT * FROM Rentals WHERE VehicleID = 3 AND Status = 'Ongoing';

-- =====================================================================
-- END OF FILE
-- =====================================================================
