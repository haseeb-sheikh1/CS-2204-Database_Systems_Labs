-- ==============================================================================
-- LAB 03: KEYS AND QUERIES
-- Roll Number: 2024-SE-31
-- Description: Comprehensive demonstration of Relational Keys (Primary, Foreign, 
--              Composite, Surrogate, Natural), DDL, DML, and Database Mutations.
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS UniversityDB;
USE UniversityDB;

-- ==============================================================================
-- PART 1: SCHEMA ARCHITECTURE & KEY DEFINITIONS
-- ==============================================================================

-- 1.1 Departments Table
-- Keys: Surrogate PK (dept_id), Natural/Alternate Key (dept_name)
CREATE TABLE departments (
    dept_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100)
);

-- 1.2 Students Table
-- Keys: Surrogate PK (student_id), Natural/Alternate Keys (national_id, email)
CREATE TABLE students (
    student_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    national_id VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- 1.3 Courses Table
-- Keys: Surrogate PK (course_id), Natural/Alternate Key (course_code)
CREATE TABLE courses (
    course_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(10) NOT NULL UNIQUE,
    course_name VARCHAR(100) NOT NULL,
    dept_id INT,
    credits INT DEFAULT 3,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- 1.4 Professors Table
-- Keys: Surrogate PK (professor_id), Alternate Key (email)
CREATE TABLE professors (
    professor_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- 1.5 Enrollments Table (Junction Table)
-- Keys: Composite Primary Key (student_id + course_id + semester)
CREATE TABLE enrollments (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    semester VARCHAR(20) NOT NULL,
    grade CHAR(2),
    PRIMARY KEY (student_id, course_id, semester),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);


-- ==============================================================================
-- PART 2: DATA INITIALIZATION (DML - INSERT)
-- ==============================================================================

INSERT INTO departments (dept_name, location) VALUES
('Computer Science', 'Block A'),
('Mathematics', 'Block B'),
('Physics', 'Block C');

INSERT INTO students (national_id, first_name, last_name, email, dept_id) VALUES
('PK-001', 'Ali', 'Khan', 'ali.khan@uni.edu', 1),
('PK-002', 'Sara', 'Ahmed', 'sara.ahmed@uni.edu', 1),
('PK-003', 'Bilal', 'Malik', 'bilal.malik@uni.edu', 2),
('PK-004', 'Hina', 'Raza', 'hina.raza@uni.edu', 3);

INSERT INTO courses (course_code, course_name, dept_id, credits) VALUES
('CS101', 'Intro to Programming', 1, 3),
('CS201', 'Data Structures', 1, 3),
('MTH101', 'Calculus I', 2, 4),
('PHY101', 'Mechanics', 3, 3);

INSERT INTO professors (name, email, dept_id) VALUES
('Dr. Usman', 'usman@uni.edu', 1),
('Dr. Amna', 'amna@uni.edu', 2),
('Dr. Tariq', 'tariq@uni.edu', 3);

INSERT INTO enrollments (student_id, course_id, semester, grade) VALUES
(1, 1, 'Fall-2024', 'A'),
(1, 2, 'Fall-2024', 'B+'),
(2, 1, 'Fall-2024', 'A-'),
(3, 3, 'Fall-2024', 'B'),
(4, 4, 'Fall-2024', 'A');


-- ==============================================================================
-- PART 3: DATA RETRIEVAL (DQL - SELECT)
-- ==============================================================================

-- 3.1 Departmental Mapping
SELECT s.student_id, s.first_name, s.last_name, d.dept_name
FROM students s
JOIN departments d ON s.dept_id = d.dept_id;

-- 3.2 Master Enrollment Report
SELECT s.first_name, s.last_name, c.course_name, e.semester, e.grade
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
ORDER BY s.last_name, c.course_name;

-- 3.3 Curriculum Filter
SELECT course_code, course_name, credits
FROM courses
WHERE dept_id = 1;


-- ==============================================================================
-- PART 4: SCHEMA MUTATIONS (DDL - ALTER)
-- ==============================================================================

-- 4.1 Adding Columns
ALTER TABLE students ADD COLUMN phone VARCHAR(15);
ALTER TABLE professors ADD COLUMN office VARCHAR(50);

-- 4.2 Modifying Data Types
ALTER TABLE students MODIFY COLUMN phone VARCHAR(20);
ALTER TABLE professors MODIFY COLUMN office VARCHAR(100);

-- 4.3 Renaming Columns
ALTER TABLE students RENAME COLUMN phone TO contact_number;
ALTER TABLE professors RENAME COLUMN office TO office_location;

-- 4.4 Enforcing New Constraints (Unique & Foreign Keys)
ALTER TABLE professors ADD CONSTRAINT uq_prof_name UNIQUE (name);

ALTER TABLE courses ADD COLUMN professor_id INT;
ALTER TABLE courses ADD CONSTRAINT fk_course_professor 
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id);

-- 4.5 Dropping Columns
ALTER TABLE students DROP COLUMN contact_number;
ALTER TABLE professors DROP COLUMN office_location;


-- ==============================================================================
-- PART 5: DATA MUTATIONS & CLEANUP (UPDATE, DELETE, DROP)
-- ==============================================================================

-- 5.1 Updating Records
UPDATE enrollments SET grade = 'A' WHERE student_id = 1 AND course_id = 2 AND semester = 'Fall-2024';
UPDATE departments SET location = 'Block D' WHERE dept_id = 2;
UPDATE students SET email = 'ali.khan2024@uni.edu' WHERE student_id = 1;

-- 5.2 Deleting Specific Records (Ensuring referential integrity)
DELETE FROM enrollments WHERE student_id = 4 AND course_id = 4 AND semester = 'Fall-2024';
DELETE FROM students WHERE student_id = 4;

-- 5.3 Truncating Table (Instant wipe, resetting auto-increments)
TRUNCATE TABLE enrollments;

-- 5.4 Database Teardown (Drops dependencies first)
ALTER TABLE courses DROP FOREIGN KEY fk_course_professor;
ALTER TABLE courses DROP COLUMN professor_id;

DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS professors;
DROP TABLE IF EXISTS departments;
DROP DATABASE IF EXISTS UniversityDB;