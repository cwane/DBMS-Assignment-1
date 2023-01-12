/*Practical Task :
1. Create a university database that consists of tables such as the schema diagram above 
(SQL data definition and tuples of some tables as shown above)
2. Please complete SQL data definition and tuples of some tables others*/

CREATE DATABASE university;

USE university;

CREATE TABLE department (
dept_name VARCHAR (255) NOT NULL, 
building VARCHAR (255) NOT NULL, 
budget NUMERIC (12,2)NOT NULL, 
PRIMARY KEY (dept_name)
);

CREATE TABLE course (
course_id VARCHAR (255) NOT NULL,
title VARCHAR (255) NOT NULL, 
dept_name VARCHAR (255) NOT NULL, 
credits NUMERIC (2,0) NOT NULL,
PRIMARY KEY (course_id) ,
FOREIGN KEY (dept_name) REFERENCES department(dept_name)
);

CREATE TABLE section (
course_id VARCHAR (255) NOT NULL,
sec_id VARCHAR (255) NOT NULL, 
semester VARCHAR (255) NOT NULL, 
year NUMERIC (4,0) NOT NULL, 
building VARCHAR (255) NOT NULL, 
room_number VARCHAR (255) NOT NULL, 
time_slot_id varchar(255) NOT NULL, 
PRIMARY KEY (course_id, sec_id, semester, year), 
FOREIGN KEY (course_id) REFERENCES course (course_id)
);

CREATE TABLE instructor(
ID INT PRIMARY KEY NOT NULL,
name VARCHAR(255) NOT NULL,
dept_name VARCHAR(255) NOT NULL,
salary INT NOT NULL,
FOREIGN KEY (dept_name) REFERENCES department(dept_name)
);

CREATE TABLE teaches (
ID INT NOT NULL,
course_id VARCHAR (255) NOT NULL, 
sec_id VARCHAR (255) NOT NULL, 
semester VARCHAR (255) NOT NULL, 
year NUMERIC (4,0) NOT NULL, 
PRIMARY KEY (ID, course_id, sec_id, semester, year),
FOREIGN KEY (course_id, sec_id, semester, year) REFERENCES section (course_id, sec_id, semester, year),
FOREIGN KEY (ID) REFERENCES instructor(ID)
);

CREATE TABLE student(
ID INT PRIMARY KEY NOT NULL,
name VARCHAR(255) NOT NULL,
dept_name VARCHAR(255) NOT NULL,
tot_cred INT NOT NULL,
FOREIGN KEY (dept_name) REFERENCES department(dept_name)
);

/*3. Fillthe tuple of each table at least 10 tuples*/

INSERT INTO department (dept_name, building, budget)
VALUES
('Computer Science', 'Smith Hall', 50000.00),
('Biology', 'Jones Hall', 45000.00),
('Mathematics', 'Green Hall', 100000.00),
('Physics', 'Brown Hall', 52000.00),
('Chemistry', 'White Hall', 49000.00),
('History', 'Black Hall', 57000.00),
('Art', 'Yellow Hall', 42000.00),
('Geography', 'Orange Hall', 41000.00),
('Music', 'Purple Hall', 125000.00);

INSERT INTO course (course_id, title, dept_name, credits)
VALUES
('CSCI-101', 'Introduction to Computer Science', 'Computer Science', 3),
('BIOL-101', 'Introduction to Biology', 'Biology', 4),
('MATH-101', 'Calculus I', 'Mathematics', 4),
('PHYS-101', 'Introduction to Physics', 'Physics', 3),
('CHEM-101', 'Introduction to Chemistry', 'Chemistry', 4),
('HIS-101', 'Introduction to History', 'History', 3),
('CS-101', 'Game Design', 'Computer Science', 3),
('ART-101', 'Introduction to Art', 'Art', 3),
('GEOG-101', 'Introduction to Geography', 'Geography', 3),
('MUSIC-101', 'Introduction to Music', 'Music', 3);


INSERT INTO section (course_id, sec_id, semester, year, building, room_number, time_slot_id)
VALUES
('CSCI-101', '001', 'Fall', 2022, 'Smith Hall', 'S101', 'MWF 10:00'),
('BIOL-101', '001', 'Spring', 2023, 'Jones Hall', 'J101', 'TR 12:00'),
('MATH-101', '001', 'Fall', 2022, 'Green Hall', 'G101', 'MWF 9:00'),
('PHYS-101', '001', 'Spring', 2023, 'Brown Hall', 'B101', 'MWF 11:00'),
('CHEM-101', '001', 'Fall', 2022, 'White Hall', 'W101', 'TR 2:00'),
('HIS-101', '001', 'Spring', 2023, 'Black Hall', 'BK101', 'MWF 1:00'),
('CS-101', '001', 'Fall', 2022, 'Pink Hall', 'PK101', 'TR 10:00'),
('ART-101', '001', 'Spring', 2023, 'Yellow Hall', 'Y101', 'MWF 3:00'),
('GEOG-101', '001', 'Fall', 2022, 'Orange Hall', 'O101', 'TR 9:00'),
('MUSIC-101', '001', 'Spring', 2023, 'Purple Hall', 'P101','TR 4:00');



INSERT INTO instructor (ID, name, dept_name, salary)
VALUES
(1, 'John Smith', 'Computer Science', 80000),
(2, 'Jane Doe', 'Biology', 75000),
(3, 'Bob Johnson', 'Mathematics', 78000),
(4, 'Sara Lee', 'Physics', 72000),
(5, 'Michael Brown', 'Chemistry', 85000),
(6, 'Chris Davis', 'History', 80000),
(7, 'Emily Wilson', 'Computer Science', 75000),
(8, 'Jacob Garcia', 'Art', 78000),
(9, 'Natalie Martinez', 'Geography', 72000),
(10, 'Brian Rodriguez', 'Music', 85000);


INSERT INTO teaches (ID, course_id, sec_id, semester, year)
VALUES
(1, 'CSCI-101', '001', 'Fall', 2022),
(2, 'BIOL-101', '001', 'Spring', 2023),
(3, 'MATH-101', '001', 'Fall', 2022),
(4, 'PHYS-101', '001', 'Spring', 2023),
(5, 'CHEM-101', '001', 'Fall', 2022),
(6, 'HIS-101', '001', 'Spring', 2023),
(7, 'CS-101', '001', 'Fall', 2022),
(8, 'ART-101', '001', 'Spring', 2023),
(9, 'GEOG-101', '001', 'Fall', 2022),
(10, 'MUSIC-101', '001', 'Spring', 2023);

INSERT INTO student (ID, name, dept_name, tot_cred)
VALUES
(1, 'Alice Smith', 'Computer Science', 120),
(2, 'Bob Johnson', 'Biology', 115),
(3, 'Chris Davis', 'Mathematics', 118),
(4, 'Emily Wilson', 'Physics', 112),
(5, 'Jacob Garcia', 'Chemistry', 125),
(6, 'Natalie Martinez', 'History', 120),
(7, 'Brian Rodriguez', 'Computer Science', 115),
(8, 'Sophia Lee', 'Art', 118),
(9, 'Michael Brown', 'Geography', 112),
(10, 'Jane Doe', 'Music', 125);

/*4. Write the following queries in Relational Algebra and SQL*/

/*1. Finds the names of all instructors in the History department*/

SELECT name
FROM instructor 
WHERE dept_name='History';


/*2. Finds the instructor ID and department name of all instructors associated with a 
department with budget of greater than $95,000*/

SELECT instructor.ID, department.dept_name
FROM instructor
JOIN department
ON instructor.dept_name = department.dept_name
WHERE department.budget > 95000;

/*3. Findsthe names of all instructors in the Comp. Sci. department together with the
course titles of all the courses that the instructors teach*/

SELECT instructor.name, course.title
FROM teaches
JOIN course
	ON teaches.course_id = course.course_id
JOIN instructor
	ON teaches.ID = instructor.ID
WHERE course.dept_name = 'Computer Science';

-- Alternative

SELECT instructor.name, course.title 
FROM instructor 
JOIN teaches 
ON instructor.ID = teaches.ID 
JOIN course 
ON teaches.course_id = course.course_id 
WHERE instructor.dept_name = 'Computer Science';

-- 4. Find the names of all students who have taken the course title of “Game Design”

/*5. For each department, find the maximum salary of instructors in that department. You 
may assume that every department has at least one instructor*/

SELECT department.dept_name, MAX(instructor.salary) as max_salary
FROM department
JOIN instructor ON department.dept_name = instructor.dept_name
GROUP BY department.dept_name;

-- Alternative
SELECT dept_name, MAX(Salary)
FROM instructor
GROUP BY Dept_Name;

/*6. Find the lowest, across all departments, of the per-department maximum salary 
computed by the preceding query*/

SELECT dept_name, salary
FROM instructor
WHERE salary
	IN (
		SELECT MAX(salary)
		FROM instructor
		GROUP BY dept_name
	)
ORDER BY salary
LIMIT 1;

-- subquery

SELECT MIN(max_salary) 
FROM (
  SELECT dept_name, MAX(salary) as max_salary
  FROM instructor
  GROUP BY dept_name
) as subquery;

-- Join
SELECT MIN(i.max_salary) FROM department d 
LEFT JOIN (
  SELECT dept_name, MAX(salary) as max_salary
  FROM instructor
  GROUP BY dept_name
) i ON d.dept_name = i.dept_name;

/*7. Find the ID and names of all students who do not have an advisor.*/
