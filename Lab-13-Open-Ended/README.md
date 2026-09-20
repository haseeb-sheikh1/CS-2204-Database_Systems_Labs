# CarGo Rentals - DBMS Open-Ended Lab

CarGo Rentals is a relational database designed to replace a flat-file spreadsheet system for a car rental operation. This database management system was developed as part of a DBMS Open-Ended Lab assignment (Lab 13). It eliminates data redundancy, prevents double-booking of vehicles, and provides a normalized, 3NF schema for tracking customers, vehicles, rentals, returns, and payments.

## Project Overview
* **Author**: Sheikh Haseeb-ur-Rehman (Roll No: 2024-SE-31)
* **Target Engine**: MySQL 8.0+
* **Main Script**: `2024-SE-31_Lab13_OpenEnded.sql`
* **Project Type**: DBMS Open-Ended Lab

## Database Schema
The schema is normalized to the Third Normal Form (3NF) to eliminate insertion, update, and deletion anomalies. It consists of five core entities:
* **Customers**: Stores customer details, utilizing `UNIQUE` constraints on Phone and CNIC to prevent duplicate spreadsheet-style records.
* **Vehicles**: Manages the vehicle fleet and tracks current availability via a `Status` column (defaults to `Available`).
* **Rentals**: The central transaction table that links a single Customer to a single Vehicle for a specified date range.
* **Returns**: A one-to-one dependent table for completed rentals that logs the actual return date, vehicle condition, and any accumulated late fees.
* **Payments**: A one-to-many table linked to rentals that tracks payment amounts, dates, and methods (`Cash`, `Card`, `Online`).

## Key Features & Database Objects
* **Reporting View (`vw_RentalReport`)**: A consolidated view that provides management with a ready-to-query object containing customer, vehicle, rental period, status, and payment information without needing to manually rewrite multi-table JOINs.
* **State-Machine Triggers**: 
  * `trg_CheckVehicleAvailability`: Fires before an `INSERT` into the Rentals table and blocks the transaction (using `SIGNAL SQLSTATE '45000'`) if a vehicle is already rented.
  * `trg_MarkVehicleRented`: Automatically updates a vehicle's status to 'Rented' after a successful rental booking.
  * `trg_FreeVehicleOnReturn`: Automatically reverts a vehicle's status to 'Available' and marks the rental as 'Completed' once a return record is inserted.
* **Stored Procedure (`sp_RegisterRental`)**: A unified procedure that registers a new rental, calculates the total charge by multiplying the rental days by the daily rate, and logs the payment record in a single call.

## Performance Optimization
* To prevent slow full table scans as the database grows, indexes (`idx_rentals_vehicle` and `idx_rentals_customer`) were added to the foreign keys in the Rentals table.
* This optimization ensures that availability checks and management reports perform efficient index lookups (`type = ref`) instead of scanning every row (`type = ALL`), which was verified using the `EXPLAIN` statement.

## Installation and Usage Instructions
1. Open MySQL Workbench or your preferred terminal application and connect to your MySQL server.
2. Execute the `2024-SE-31_Lab13_OpenEnded.sql` script entirely from top to bottom.
3. If using MySQL Workbench, click the lightning-bolt "Execute" icon or select "Execute (All or Selection)" from the Query menu.
4. If using a terminal, use the command: `mysql -u root -p < 2024-SE-31_Lab13_OpenEnded.sql`
5. The script is divided into labeled sections, allowing you to run and verify individual blocks (e.g., table creation, sample data insertion, queries) one at a time.