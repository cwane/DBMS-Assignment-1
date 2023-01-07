/*1. Give an SQL schema definition for the employee database of Figure 5. Choose an appropriate
primary key for each relation schema, and insert any other integrity constraints (for example,
foreign keys) you find necessary.*/

CREATE DATABASE db_employee;
USE db_employee;

CREATE TABLE employee (
  employee_name VARCHAR(255) PRIMARY KEY,
  street VARCHAR(255),
  city VARCHAR(255)
);

CREATE TABLE works (
  employee_name VARCHAR(255) PRIMARY KEY,
  company_name VARCHAR(255) NOT NULL,
  salary INTEGER NOT NULL,
  FOREIGN KEY (employee_name) REFERENCES employee(employee_name)
);

CREATE TABLE company (
  company_name VARCHAR(255) PRIMARY KEY,
  city VARCHAR(255)
);

CREATE TABLE manages (
  employee_name VARCHAR(255) PRIMARY KEY,
  manager_name VARCHAR(255) NOT NULL,
  FOREIGN KEY (employee_name) REFERENCES employee(employee_name),
  FOREIGN KEY (manager_name) REFERENCES employee(employee_name)
);
SHOW TABLES;


INSERT INTO employee (employee_name,street,city)
VALUES('Shiwani Shah','Putalisadak','Kathmandu'),
	 ('John Smith', '123 Main St', 'California'),
     ('Wednesday Adam','456 Main St','Chicago'),
     ('Jane Doe', '456 Market St', 'San Francisco'),
     ('Reshma Giri','Maitidevi','Kathmandu'),
     ('Sweakshya Jha','Madhumara','Biratnagar'),
     ('Hulash Shah','Hatkhola','Biratnagar'),
     ('Shiva Pokharel','LakeSide','Pokharel');
     
    
INSERT INTO works (employee_name,company_name,salary)
VALUES('Shiwani Shah','First Bank Corporation',40000),
	 ('John Smith','Small Bank Corporation',70000 ),
     ('Wednesday Adam','Second Bank Corporation',10000),
     ('Jane Doe','Javra',20000),
     ('Reshma Giri','First Bank Corporation',50000),
     ('Sweakshya Jha','Cloudfactory',7000),
     ('Hulash Shah','Small Bank Corporation',9000),
     ('Shiva Pokharel','First Bank Corporation',6000);
     
drop table works;
     
     
INSERT INTO company (company_name,city)
VALUES('Second Bank Corporation','Kathmandu'),
      ('Nepal Bank Corporation','Kathmandu'),
      ('First Bank Corporation','Lalitpur'),
	  ('Small Bank Corporation','Kathmandu'),
      ('Javra','Biratnagar'),
      ('Cloudfactory','Bhaktapur');
      
      
INSERT INTO manages (employee_name,manager_name)
VALUES('Shiwani Shah','Reshma Giri'),
      ('John Smith','Reshma Giri'),
      ('Jane Doe','Hulash Shah'),
      ('Sweakshya Jha','Shiva Pokharel'),
      ('Wednesday Adam','Shiva Pokharel');

SELECT * FROM employee;
SELECT * FROM company;
SELECT * FROM works;
SELECT * FROM manages;


/*2. Consider the employee database of Figure 5, where the primary keys are underlined. Give
an expression in SQL for each of the following queries:*/

/*(a) Find the names of all employees who work for First Bank Corporation.*/

SELECT employee_name 
FROM works
WHERE 
company_name ='First Bank Corporation';

-- using join
SELECT w.employee_name
FROM works w
INNER JOIN company c ON w.company_name = c.company_name
WHERE c.company_name = 'First Bank Corporation';


/*(b) Find the names and cities of residence of all employees who work for First Bank Corporation.*/

SELECT employee_name,city
FROM employee
WHERE employee_name
IN (SELECT employee_name 
FROM works 
WHERE company_name ='First Bank Corporation');

-- using join 
SELECT w.employee_name, e.city
FROM works w
INNER JOIN employee e ON w.employee_name = e.employee_name
INNER JOIN company c ON w.company_name = c.company_name
WHERE c.company_name = 'First Bank Corporation';

/*Find the names, street addresses, and cities of residence of all employees who work for
First Bank Corporation and earn more than $10,000.*/

SELECT employee_name,street,city
FROM employee
WHERE employee_name
IN (SELECT employee_name 
FROM works 
WHERE company_name='First Bank Corporation' AND salary > 10000);

-- using join
SELECT w.employee_name, e.street, e.city
FROM works w
INNER JOIN employee e ON w.employee_name = e.employee_name
INNER JOIN company c ON w.company_name = c.company_name
WHERE c.company_name = 'First Bank Corporation' AND w.salary > 10000;

/*(d) Find all employees in the database who live in the same cities as the companies for
which they work.*/

SELECT employee_name
FROM employee
WHERE city = (
  SELECT city
  FROM company
  WHERE company_name = (
    SELECT company_name
    FROM works
    WHERE employee_name = employee.employee_name
  )
);

-- using join
SELECT w.employee_name
FROM works w
INNER JOIN employee e ON w.employee_name = e.employee_name
INNER JOIN company c ON w.company_name = c.company_name
WHERE e.city = c.city;


/*(e) Find all employees in the database who live in the same cities and on the same streets
as do their managers.*/

SELECT employee_name
FROM employee e
WHERE city = (
  SELECT city
  FROM employee m
  WHERE m.employee_name = (
    SELECT manager_name
    FROM manages
    WHERE employee_name = e.employee_name
  )
) AND street = (
  SELECT street
  FROM employee m
  WHERE m.employee_name = (
    SELECT manager_name
    FROM manages
    WHERE employee_name = e.employee_name
  )
);

/*(f) Find all employees in the database who do not work for First Bank Corporation*/

SELECT employee_name
FROM employee
WHERE NOT employee_name IN (
  SELECT employee_name
  FROM works
  WHERE company_name = 'First Bank Corporation'
);

/*Alternatives*/

SELECT employee_name
FROM employee
WHERE employee_name NOT IN (
  SELECT employee_name
  FROM works
  WHERE company_name = 'First Bank Corporation'
);


SELECT employee_name
FROM employee
WHERE NOT EXISTS (
  SELECT *
  FROM works
  WHERE works.employee_name = employee.employee_name AND works.company_name = 'First Bank Corporation'
);


/*(g) Find all employees in the database who earn more than each employee of Small Bank
Corporation.*/


SELECT employee_name
FROM employee
WHERE EXISTS (
	SELECT 1
    FROM works
    WHERE works.salary > ALL (
		SELECT w2.salary
		FROM works w2
        WHERE w2.company_name = 'Small Bank Corporation'
    )
);

/*(h) Assume that the companies may be located in several cities. Find all companies located
in every city in which Small Bank Corporation is located.*/

/* With the inclusion of Small Bank Corporation in Output*/
SELECT c.company_name
FROM company c
WHERE c.company_name != 'Small Bank Corporation' AND NOT EXISTS (
  SELECT city
  FROM company
  WHERE company_name = 'Small Bank Corporation'
    AND city NOT IN (SELECT city FROM company WHERE company_name = c.company_name)
);

/* Without the inclusion of Small Bank Corporation in Output*/
SELECT c.company_name
FROM company c
WHERE c.company_name != 'Small Bank Corporation' AND NOT EXISTS (
  SELECT city
  FROM company
  WHERE company_name = 'Small Bank Corporation'
    AND city NOT IN (SELECT city FROM company WHERE company_name = c.company_name)
);


/*(i) Find all employees who earn more than the average salary of all employees of their
company.*/

SELECT w.employee_name, w.salary
FROM works w
WHERE w.salary > (
  SELECT AVG(salary)
  FROM works
  WHERE company_name = w.company_name
);

/*(j) Find the company that has the most employees.*/

SELECT company_name, COUNT(*) AS num_employees
FROM works
GROUP BY company_name
HAVING COUNT(*) = (SELECT MAX(num_employees)
                   FROM (SELECT COUNT(*) AS num_employees 
                   FROM works 
                   GROUP BY company_name)
                   AS t);

/*Alternatives*/

SELECT company_name, cnt
FROM (
    SELECT company_name, count(employee_name) AS cnt
    FROM works
    GROUP BY company_name
) w1
ORDER BY cnt DESC
LIMIT 1;


SELECT company_name, COUNT(*) as num_employee
FROM works
GROUP BY company_name
ORDER BY num_employee DESC
LIMIT 1;


/*(k) Find the company that has the smallest payroll.*/

SELECT company_name, MIN(salary) AS payroll
FROM works
GROUP BY company_name
HAVING MIN(salary) = (SELECT MIN(payroll)
                      FROM (SELECT MIN(salary) AS payroll 
                      FROM works
                      GROUP BY company_name) 
                      AS t);

/*Alternative*/
SELECT  company_name,MIN(salary) as payroll
FROM works
GROUP BY company_name
ORDER BY payroll ASC
LIMIT 1;


/*(l) Find those companies whose employees earn a higher salary, on average, than the
average salary at First Bank Corporation.*/

SELECT company_name, AVG(salary) AS avg_salary
FROM works
WHERE company_name <> 'First Bank Corporation'
GROUP BY company_name
HAVING AVG(salary) > (SELECT AVG(salary)
                      FROM works
                      WHERE company_name = 'First Bank Corporation');



/*3. Consider the relational database of Figure 5. Give an expression in SQL for each of the
following queries:*/

/*(a) Modify the database so that Jones now lives in Newtown.*/

UPDATE employee
SET city = 'Newtown'
WHERE employee_name LIKE('Shiva%');

/*(b) Give all employees of First Bank Corporation a 10 percent raise.*/

UPDATE works
SET salary = salary * 1.1
WHERE company_name = 'First Bank Corporation';

select * from works;


/*(c) Give all managers of First Bank Corporation a 10 percent raise.*/

UPDATE works
SET salary = salary * 1.1
WHERE employee_name IN (SELECT manager_name
                        FROM manages
                        WHERE company_name = 'First Bank Corporation');


/*(d) Give all managers of First Bank Corporation a 10 percent raise unless the salary becomes 
greater than $100,000; in such cases, give only a 3 percent raise.*/

UPDATE works
SET salary = CASE
              WHEN salary * 1.1 <= 100000 THEN salary * 1.1
              ELSE salary * 1.03
            END
WHERE employee_name IN (SELECT manager_name FROM manages WHERE company_name = 'First Bank Corporation');

/*(e) Delete all tuples in the works relation for employees of Small Bank Corporation.*/

DELETE FROM works
WHERE company_name = 'Small Bank Corporation';

-- using join
DELETE w
FROM works w
INNER JOIN company c ON w.company_name = c.company_name
WHERE c.company_name = 'Small Bank Corporation';