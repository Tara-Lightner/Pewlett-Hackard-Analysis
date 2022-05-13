-- Database: PH-EmployeeDB

-- DROP DATABASE IF EXISTS "PH-EmployeeDB";
--7.2.1 Create a Database (this was done by single clicking on PostgresSQL & selecting Create Database )
CREATE DATABASE "PH-EmployeeDB"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
	
--7.2.2 Create Tables in SQL	
-- Creating tables for PH-EmployeeDB
-- Create Departments Table
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

-- Create Employess Table
CREATE TABLE employees (
     emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

-- Create Department Managers Table
CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

-- Create Salaries Table
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

-- Create Department Employee Table
CREATE TABLE dept_emp (
  emp_no INT NOT NULL,
  dept_no VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

SELECT * FROM dept_emp

-- Create Titles Table
CREATE TABLE titles (
  emp_no INT NOT NULL,
  title VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no, title, from_date));

-- 7.2.3 Import Data
--Query for Confirmation
SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM dept_manager;
SELECT * FROM salaries;
SELECT * FROM dept_emp;
SELECT * FROM titles;

-- 7.2.4 Trouble Shooting
DROP TABLE employees CASCADE;

-- 7.3.1 Query Dates
-- Determine Retirement Eligibility if born between 1952 and 1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- Determine Retirement Eligibility if born in 1952 
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

--Skill Drill 7.3.1
-- Determine Retirement Eligibility if born between 1953
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

-- Determine Retirement Eligibility if born between 1954
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

-- Determine Retirement Eligibility if born between 1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Narrow the Search for Retirement Eligibility
-- Retirement eligibility & Hiring date
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Count the Queries
-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create Results Tables 
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Export Results Table

-- Verifying table was saved correctly (view table)
SELECT * FROM retirement_info;

-- 7.3.2 Join the Tables
-- Recreate the retirement_info Table with the emp_no Column
DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- 7.3.3 Joins in Action

-- Use Inner Join for Departments and dept-manager Tables
-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Using the same alias method and syntax as before, rename departments to "d" and dept_manager to "dm."
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Use Left Join to Capture (recreate this list??So do I need to delete again???) retirement-info Table
-- Joining retirement_info and dept_emp tables
SELECT 	retirement_info.emp_no,
    	retirement_info.first_name,
		retirement_info.last_name,
    	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;


--?????Do I need to e the table and then to add the INTO statement?
-- Use Aliases for Code Readability
-- Re do Joining retirement_info and dept_emp tables

DROP TABLE current_emp CASCADE;

SELECT ri.emp_no,
    ri.first_name,
	ri.last_name,
    de.to_date
--INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE to_date = '9999-01-01';

SELECT * FROM current_emp



-- with Sharon better option, using WHERE and code for currenlty employed
--SELECT departments.dept_name,
     -- dept_manager.emp_no,
     -- dept_manager.from_date,
     -- dept_manager.to_date
--FROM departments
--INNER JOIN dept_manager
--ON departments.dept_no = dept_manager.dept_no
--WHERE to_date = '9999-01-01'


-- 7.3.4 Use Count, Group By, and Order By
-- Employee count by department number
SELECT COUNT (ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no

SELECT * FROM Employeecount_dept

-- SKILL DRILL  ???? Do I need to just do my INTO it statement?
-- Bobby can present this table to his boss since it provides a breakdown for each department. 
-- Update the code block to create a new table, then export it as a CSV.
SELECT COUNT(ce.emp_no), de.dept_no
INTO emp_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no

-- 7.3.5 Create Additional Lists
-- List 1: Employee Information: A list of employees containing their unique employee number, their last name, first name, gender, and salary
--SELECT * FROM salaries
--ORDER BY to_date DESC;


--SELECT emp_no,
    --first_name,
	--last_name,
    --gender
--INTO emp_info
--FROM employees
--WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
--AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--From new temporary table (emp_info), we need to join it to the salaries table to add the to_date and Salary columns to our query.
SELECT e.emp_no,
    	e.first_name,
		e.last_name,
    	e.gender,
    	s.salary,
    	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
-- We have all of the joins, but we still need to make sure the filters are in place correctly. 
-- The birth and hire dates are still resting right under our joins, so update that with the proper aliases.
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

SELECT * FROM emp_info
-- List 2: Management: A list of managers for each department, including the department number, name, and the manager's employee number, 
-- last name, first name, and the starting and ending employment dates
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
SELECT * FROM manager_info
SELECT * FROM dept_manager
SELECT * FROM departments
SELECT * FROM current_emp

-- List 3: Department Retirees: An updated current_emp list that includes everything it currently has, but also 
-- the employee's departments
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
INTO dept_info
FROM current_emp AS ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

SELECT * FROM dept_info

-- 7.3.6 Create a Tailored List
-- SKILL DRILL
-- Create a query that will return only the information relevant to the Sales team. The requested list includes:
SELECT ri.emp_no,
ri.first_name,
ri.last_name,
d.dept_name
INTO salesteam_retirementinfo
FROM retirement_info AS ri
INNER JOIN dept_emp AS de
ON (ri.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE dept_name = 'Sales';

SELECT * FROM salesteam_retirementinfo

-- SKILL DRILL
-- Create another query that will return the following information for the Sales and Delopment teams:
Hint: You'll need to use the IN condition with the WHERE clause.
SELECT ri.emp_no,
ri.first_name,
ri.last_name,
d.dept_name
INTO salesanddevteams_retirementinfo
FROM retirement_info AS ri
INNER JOIN dept_emp AS de
ON (ri.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE dept_name IN ('Sales', 'Development');

SELECT * FROM salesanddevteams_retirementinfo

-- *** All talbes listed for Query for Confirmation
SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM dept_manager;
SELECT * FROM salaries;
SELECT * FROM dept_emp;
SELECT * FROM titles;
SELECT * FROM current_emp;
SELECT * FROM retirement_info;
SELECT * FROM