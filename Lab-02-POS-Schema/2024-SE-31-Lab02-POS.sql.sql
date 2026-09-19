-- ==============================================================================
-- LAB 02: POINT OF SALE (POS) DATABASE
-- Roll Number: 2024-SE-31
-- Description: A fully normalized POS schema featuring Role-Based Access Control 
--              (RBAC), inventory tracking, discounts, and sales reporting.
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS Point_of_Sale;
USE Point_of_Sale;

-- ==============================================================================
-- PART 1: SCHEMA ARCHITECTURE & TABLE CREATION
-- ==============================================================================

-- 1.1 Security & Access Control (RBAC)
-- Defines user hierarchies and granular permissions

CREATE TABLE roles (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE permissions (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    action_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE role_permissions (
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES roles(id),
    FOREIGN KEY (permission_id) REFERENCES permissions(id)
);

CREATE TABLE users (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    role_id INT NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (role_id) REFERENCES roles(id)
);

-- 1.2 Inventory Management
-- Manages product catalog and tracks stock adjustments over time

CREATE TABLE categories (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE products (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE inventory_logs (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    change_amount INT NOT NULL,
    reason VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 1.3 Sales & Billing
-- Handles promotional discounts, master orders, and individual line items

CREATE TABLE discount_rules (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    rule_name VARCHAR(100) NOT NULL,
    discount_percentage DECIMAL(5,2) NOT NULL,
    valid_until DATETIME NOT NULL,
    is_active TINYINT(4) NOT NULL DEFAULT 1
);

CREATE TABLE orders (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    discount_id INT NULL DEFAULT NULL,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (discount_id) REFERENCES discount_rules(id)
);

CREATE TABLE order_items (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price_at_purchase DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);


-- ==============================================================================
-- PART 2: DATA INITIALIZATION
-- ==============================================================================

-- Populating access control tiers and 10 sample users
INSERT INTO roles (name) VALUES ('Admin'), ('Salesman'), ('Customer');

INSERT INTO permissions (action_name) VALUES
('view_products'), ('add_product'), ('edit_product'), ('delete_product'),
('view_orders'), ('create_order'), ('apply_discount'), ('manage_users'),
('view_reports'), ('manage_inventory');

INSERT INTO role_permissions (role_id, permission_id) VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),
(2,1),(2,5),(2,6),(2,7),(2,9),(2,10),
(3,1),(3,5),(3,6);

INSERT INTO users (role_id, username, password) VALUES
(1, 'admin_hassan', MD5('admin123')), (1, 'admin_zara', MD5('admin456')),
(2, 'salesman_ali', MD5('sale123')), (2, 'salesman_bilal', MD5('sale456')),
(2, 'salesman_nida', MD5('sale789')), (3, 'customer_sara', MD5('cust123')),
(3, 'customer_umar', MD5('cust456')), (3, 'customer_hina', MD5('cust789')),
(3, 'customer_tariq', MD5('cust321')), (3, 'customer_layla', MD5('cust654'));

-- Populating product catalog and initial inventory audits
INSERT INTO categories (category_name) VALUES
('Electronics'), ('Clothing'), ('Groceries'), ('Beverages'),
('Stationery'), ('Footwear'), ('Dairy Products'), ('Bakery'),
('Cleaning Supplies'), ('Personal Care');

INSERT INTO products (category_id, product_name, price) VALUES
(1, 'Wireless Mouse', 850.00), (1, 'USB-C Hub', 1200.00),
(2, 'Mens Polo Shirt', 950.00), (3, 'Basmati Rice 5kg', 650.00),
(4, 'Mineral Water 1.5L', 60.00), (5, 'Ballpoint Pen (12-pack)', 120.00),
(6, 'Running Shoes', 3500.00), (7, 'Full Cream Milk 1L', 180.00),
(8, 'Whole Wheat Bread', 110.00), (9, 'Dishwashing Liquid 500ml', 160.00);

INSERT INTO inventory_logs (product_id, user_id, change_amount, reason) VALUES
(1, 1, 50, 'Initial Stock'), (2, 1, 30, 'Initial Stock'),
(3, 1, 100, 'Initial Stock'), (4, 1, 200, 'Initial Stock'),
(5, 3, -8, 'Sale'), (6, 3, -12, 'Sale'),
(7, 4, 20, 'Restock'), (8, 4, -5, 'Sale'),
(9, 1, 60, 'Initial Stock'), (10, 3, -10, 'Sale');

-- Populating promotional rules and transaction history
INSERT INTO discount_rules (rule_name, discount_percentage, valid_until, is_active) VALUES
('Eid Sale', 20.00, '2025-04-10 23:59:59', 0), ('Summer Deal', 15.00, '2025-08-31 23:59:59', 1),
('Flash Friday', 25.00, '2025-05-30 23:59:59', 1), ('New Year Offer', 10.00, '2025-01-05 23:59:59', 0),
('Loyalty Discount', 5.00, '2026-12-31 23:59:59', 1), ('Bulk Buy 10%', 10.00, '2026-06-30 23:59:59', 1),
('Student Discount', 8.00, '2026-12-31 23:59:59', 1), ('Weekend Special', 12.00, '2025-06-29 23:59:59', 1),
('Clearance Sale', 30.00, '2025-05-15 23:59:59', 1), ('First Purchase', 18.00, '2026-12-31 23:59:59', 1);

INSERT INTO orders (user_id, discount_id, total_amount, created_at) VALUES
(6, 10, 1530.00, '2025-04-01 10:15:00'), (7, NULL, 850.00, '2025-04-02 11:30:00'),
(8, 5, 2812.50, '2025-04-03 14:00:00'), (9, 3, 900.00, '2025-04-04 09:45:00'),
(10, NULL, 1200.00, '2025-04-05 16:20:00'), (6, 6, 585.00, '2025-04-06 12:00:00'),
(7, 8, 3080.00, '2025-04-07 13:10:00'), (8, NULL, 340.00, '2025-04-08 15:30:00'),
(9, 2, 3972.50, '2025-04-09 10:00:00'), (10, 7, 1011.60, '2025-04-10 17:45:00');

INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES
(1, 1, 1, 850.00), (1, 5, 8, 60.00), (2, 1, 1, 850.00),
(3, 7, 1, 3500.00), (4, 3, 1, 950.00), (5, 2, 1, 1200.00),
(6, 4, 1, 650.00), (7, 7, 1, 3500.00), (8, 9, 2, 110.00), (9, 7, 1, 3500.00);


-- ==============================================================================
-- PART 3: BUSINESS INTELLIGENCE & REPORTING QUERIES
-- ==============================================================================

-- Q1: Catalog Overview - Maps every product to its respective category
SELECT p.id, p.product_name, c.category_name, p.price 
FROM products p 
JOIN categories c ON p.category_id = c.id 
ORDER BY c.category_name;

-- Q2: Order Summary - Displays high-level transaction details and applied discounts
SELECT o.id AS order_id, u.username AS customer, d.rule_name AS discount_applied, 
       d.discount_percentage, o.total_amount, o.created_at 
FROM orders o 
JOIN users u ON o.user_id = u.id 
LEFT JOIN discount_rules d ON o.discount_id = d.id 
ORDER BY o.created_at;

-- Q3: Line-Item Breakdown - Calculates the subtotal for each item within an order
SELECT oi.order_id, u.username, p.product_name, oi.quantity, 
       oi.price_at_purchase, (oi.quantity * oi.price_at_purchase) AS line_total 
FROM order_items oi 
JOIN orders o ON oi.order_id = o.id 
JOIN users u ON o.user_id = u.id 
JOIN products p ON oi.product_id = p.id 
ORDER BY oi.order_id;

-- Q4: Customer Lifetime Value (CLV) - Ranks customers by their total historical spend
SELECT u.username, COUNT(o.id) AS total_orders, SUM(o.total_amount) AS total_spent 
FROM orders o 
JOIN users u ON o.user_id = u.id 
GROUP BY u.username 
ORDER BY total_spent DESC;

-- Q5: Top Performing Products - Identifies best-sellers based on total units moved
SELECT p.product_name, SUM(oi.quantity) AS total_sold 
FROM order_items oi 
JOIN products p ON oi.product_id = p.id 
GROUP BY p.product_name 
ORDER BY total_sold DESC;

-- Q6: Departmental Revenue - Aggregates total gross income per category
SELECT c.category_name, SUM(oi.quantity * oi.price_at_purchase) AS category_revenue 
FROM order_items oi 
JOIN products p ON oi.product_id = p.id 
JOIN categories c ON p.category_id = c.id 
GROUP BY c.category_name 
ORDER BY category_revenue DESC;

-- Q7: Active Promotions - Lists all valid discounts currently available to customers
SELECT rule_name, discount_percentage, valid_until 
FROM discount_rules 
WHERE is_active = 1 AND valid_until > NOW() 
ORDER BY discount_percentage DESC;

-- Q8: Promotion Impact - Compares revenue from discounted orders vs standard orders
SELECT CASE WHEN discount_id IS NULL THEN 'No Discount' ELSE 'Discounted' END AS order_type, 
       COUNT(*) AS total_orders, SUM(total_amount) AS total_revenue 
FROM orders 
GROUP BY order_type;

-- Q9: System Access Audit - Verifies the security role assigned to every registered user
SELECT u.username, r.name AS role 
FROM users u 
JOIN roles r ON u.role_id = r.id 
ORDER BY r.name, u.username;

-- Q10: Inventory Audit Trail - Chronological log of all manual stock adjustments and automated sales deductions
SELECT il.timestamp, u.username, p.product_name, il.change_amount, il.reason 
FROM inventory_logs il 
JOIN users u ON il.user_id = u.id 
JOIN products p ON il.product_id = p.id 
ORDER BY il.timestamp;