/**
 ** Course: DBMS-2006 Database Management Systems 2
 ** Name: Yi Siang Chang
 ** Assignment: 1
 ** Date: 2023-09-06
 **/

USE Challenge1;

-- 1. List all salesreps whose average sales are below the overall average sales.
SELECT s.EMPL_NUM, s.NAME, s.TITLE, AVG(o.AMOUNT) AS "AVERAGE SALES" FROM SALESREPS s
JOIN ORDERS o ON s.EMPL_NUM = o.REP
GROUP BY s.EMPL_NUM, s.NAME, s.TITLE
HAVING AVG(o.AMOUNT) < (SELECT AVG(o.AMOUNT) FROM ORDERS o) --¤]¥i¥H¼g(SELECT AVG(AMOUNT) FROM ORDERS o)
ORDER BY "AVERAGE SALES";

-- SELECT * FROM SALESREPS;
-- SELECT * FROM ORDERS;
GO
-- 2. Lists employees and their supervisor's, please include the following columns in the resultSet: 
-- Employee Name, EMPL_NUM, AGE, TITLE, Manager-Name, Manager-ID, Managers Title 
-- (please note this is a subset of columns available with the salesreps table).
-- self join left join
SELECT emp.NAME AS "Employee Name", emp.EMPL_NUM, emp.AGE, emp.TITLE,
       m.NAME AS "Manager-Name", emp.MANAGER AS "Manager-ID", m.TITLE AS "Managers Title"
FROM SALESREPS emp 
	 LEFT JOIN SALESREPS m ON emp.MANAGER = m.EMPL_NUM;

-- SELECT * FROM SALESREPS;
GO
-- 3. Update customer Chen Associates to Boyce and Codd Associates. The DB might throw an error, 
-- fix this using whatever method you think appropriate. Be sure to include the code on how you fixed this. 
-- Do not shorten the name of the company.

/*
--Error: String or binary data would be truncated
UPDATE CUSTOMERS
SET COMPANY = 'Boyce and Codd Associates'
WHERE COMPANY = 'Chen Associates';

SELECT * FROM CUSTOMERS;
*/

/*Change CHAT() to VARCHAR*/
ALTER TABLE CUSTOMERS ALTER COLUMN COMPANY VARCHAR(50);

UPDATE CUSTOMERS
SET COMPANY = 'Boyce and Codd Associates'
WHERE COMPANY = 'Chen Associates';

SELECT * FROM CUSTOMERS; ---WHERE
GO

--4. Show all products that fall within a given price range. Pick any price range you wish.
SELECT * 
FROM PRODUCTS
WHERE PRICE BETWEEN 200.00 AND 1000.00;
GO

SELECT * FROM PRODUCTS;

--5. Show the number of salesreps based in each city (include cities with NULL values).

/*Join the SALESREPS table with the OFFICES table.*/
SELECT o.CITY, COUNT(s.TITLE) AS NumOfSalesReps 
FROM OFFICES o
	 LEFT JOIN SALESREPS s ON o.OFFICE = s.REP_OFFICE
GROUP BY o.CITY;

/*SELECT o.CITY, COUNT(s.TITLE) AS NumOfSalesReps FROM SALESREPS s
RIGHT JOIN OFFICES o ON o.OFFICE = s.REP_OFFICE
GROUP BY o.CITY;*/

SELECT * FROM SALESREPS;
SELECT * FROM OFFICES;