/***
*** Assignment 5
*** 2023-11-08
*** Yi Siang Chang
***/

USE JRMOVIE;
GO

/********** Q1 **********/

--CREATE LOGIN JenniferGarnet WITH PASSWORD = 'ychang2';
--CREATE LOGIN PhilBlat WITH PASSWORD = 'ychang2';
--CREATE LOGIN RhondaSeymore WITH PASSWORD = 'ychang2';
--GO

--CREATE USER jGarnet FOR LOGIN JenniferGarnet;
--CREATE USER pBlat FOR LOGIN PhilBlat;
--CREATE USER rSeymore FOR LOGIN RhondaSeymore;
--GO


---------- CREATE LOGIN

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'JenniferGarnet')
BEGIN
    CREATE LOGIN JenniferGarnet WITH PASSWORD = 'ychang2';
END;
GO

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'PhilBlat')
BEGIN
    CREATE LOGIN PhilBlat WITH PASSWORD = 'ychang2';
END;
GO

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'RhondaSeymore')
BEGIN
    CREATE LOGIN RhondaSeymore WITH PASSWORD = 'ychang2';
END;
GO

---------- CREATE USER

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'jGarnet')
BEGIN
    CREATE USER jGarnet FOR LOGIN JenniferGarnet;
END
ELSE
BEGIN
    ALTER USER jGarnet WITH LOGIN = JenniferGarnet;
END;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'pBlat')
BEGIN
    CREATE USER pBlat FOR LOGIN PhilBlat;
END
ELSE
BEGIN
    ALTER USER pBlat WITH LOGIN = PhilBlat;
END;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'rSeymore')
BEGIN
    CREATE USER rSeymore FOR LOGIN RhondaSeymore;
END
ELSE
BEGIN
    ALTER USER rSeymore WITH LOGIN = RhondaSeymore;
END;
GO

/********** Q2 **********/

CREATE ROLE receptionist_role;
GO

/********** Q3 **********/

GRANT SELECT ON dbo.CUSTOMER TO receptionist_role;
GRANT SELECT ON dbo.RENTALAGREEMENT TO receptionist_role;
GRANT SELECT ON dbo.MOVIERENTED TO receptionist_role;
GRANT SELECT ON dbo.MOVIE TO receptionist_role;
GO

/********** Q4 **********/

-- Give Jennifer Garnet the receptionist role
ALTER ROLE receptionist_role ADD MEMBER jGarnet;
GO


-- ********** Q5 **********

-- Create salesperson_role
CREATE ROLE salesperson_role;
GO

/********** Q6 **********/

-- Grant SELECT permission
GRANT SELECT ON dbo.CUSTOMER TO salesperson_role;
GRANT SELECT ON dbo.RENTALAGREEMENT TO salesperson_role;
GRANT SELECT ON dbo.MOVIERENTED TO salesperson_role;
GRANT SELECT ON dbo.MOVIE TO salesperson_role;

-- Grant INSERT permission on specified tables
GRANT INSERT ON dbo.RENTALAGREEMENT TO salesperson_role;
GRANT INSERT ON dbo.MOVIERENTED TO salesperson_role;
GO

/********** Q7 **********/

-- Assign salesperson_role to pBlat user
ALTER ROLE salesperson_role ADD MEMBER pBlat;
GO

/********** Q8 **********/

-- Create salesmanager_role
CREATE ROLE salesmanager_role;
GO

/********** Q9 **********/

-- Grant full permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.CUSTOMER TO salesmanager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.RENTALAGREEMENT TO salesmanager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.MOVIERENTED TO salesmanager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.MOVIE TO salesmanager_role;
GO

/********** Q10 **********/

-- Assign salesperson_role to rSeymore user
ALTER ROLE salesperson_role ADD MEMBER rSeymore;

-- Assign salesmanager_role to rSeymore user
ALTER ROLE salesmanager_role ADD MEMBER rSeymore;
GO

/********** Q11 **********/

-- Impersonate Jennifer Garnet
EXECUTE AS USER = 'jGarnet';
REVERT; -- To revert back to your account
GO

-- Impersonate Phil Blat
EXECUTE AS USER = 'pBlat';
REVERT;
GO

-- Impersonate Rhonda Seymore
EXECUTE AS USER = 'rSeymore';
REVERT;
GO


/***** Test Permissions *****/

-- For Jennifer Garnet (Should have SELECT permission only)
-- Test SELECT
SELECT * FROM dbo.CUSTOMER; -- success expected

-- Test INSERT (should fail for Jennifer Garnet)
INSERT INTO dbo.CUSTOMER (CUSTID, FNAME, LNAME) VALUES (24, 'Jennifer', 'Garnet'); -- failure expected

-- For Phil Blat (Should have SELECT and INSERT on specified tables)
-- Test INSERT on RENTALAGREEMENT
INSERT INTO dbo.RENTALAGREEMENT (AGREEMENTID, CUSTID, AGREEMENTDATE, MOVIECOUNT, DURATIONID) 
VALUES (99567, 261, GETDATE(), 1, 1); -- success expected

-- Test UPDATE (should fail for Phil Blat)
UPDATE dbo.CUSTOMER SET FNAME = 'Phil' WHERE CUSTID = 24; -- failure expected

-- For Rhonda Seymore (Should have full permissions)
-- Test UPDATE
UPDATE dbo.CUSTOMER SET FNAME = 'Rhonda' WHERE CUSTID = 23; -- success expected
