USE IntroductoryProject;
GO

--DROP TABLE IF EXISTS CustomersAuditLog;
--DROP TRIGGER IF EXISTS trigger_CustomerAuditLog;
--GO

CREATE TABLE CustomersAuditLog (
    customerAuditID INT PRIMARY KEY IDENTITY(1,1),
    cust_id INT,
    modifiedBy NVARCHAR(50),
    modifiedDate DATETIME,
    operationType NVARCHAR(10),
    first_name NVARCHAR(30),
    last_name NVARCHAR(30),
    gender_id INT,
    phone NVARCHAR(20),
    addr NVARCHAR(40),
    city_id INT
);
GO

CREATE TRIGGER trigger_CustomerAuditLog
ON Customer
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Use this to capture the user name or change as per your authentication mechanism
    DECLARE @ModifiedBy NVARCHAR(50) = SUSER_SNAME();

    -- Handle inserted rows
    INSERT INTO CustomersAuditLog (cust_id, modifiedBy, modifiedDate, operationType, first_name, last_name, gender_id, phone, addr, city_id)
    SELECT i.cust_id, @ModifiedBy, GETDATE(), 'INSERT', i.first_name, i.last_name, i.gender_id, i.phone, i.addr, i.city_id
    FROM inserted i
    WHERE NOT EXISTS (SELECT 1 FROM deleted);
   
    -- Handle deleted rows
    INSERT INTO CustomersAuditLog (cust_id, modifiedBy, modifiedDate, operationType, first_name, last_name, gender_id, phone, addr, city_id)
    SELECT d.cust_id, @ModifiedBy, GETDATE(), 'DELETE', d.first_name, d.last_name, d.gender_id, d.phone, d.addr, d.city_id
    FROM deleted d
    WHERE NOT EXISTS (SELECT 1 FROM inserted);

    -- Handle old values before update
    --INSERT INTO CustomersAuditLog (cust_id, modifiedBy, modifiedDate, operationType, first_name, last_name, gender_id, phone, addr, city_id)
    --SELECT d.cust_id, @ModifiedBy, GETDATE(), 'UPDATE_OLD', d.first_name, d.last_name, d.gender_id, d.phone, d.addr, d.city_id
    --FROM deleted d
    --WHERE EXISTS (SELECT 1 FROM inserted);

    -- Handle new values after update
    INSERT INTO CustomersAuditLog (cust_id, modifiedBy, modifiedDate, operationType, first_name, last_name, gender_id, phone, addr, city_id)
    SELECT i.cust_id, @ModifiedBy, GETDATE(), 'UPDATE', i.first_name, i.last_name, i.gender_id, i.phone, i.addr, i.city_id
    FROM inserted i
    WHERE EXISTS (SELECT 1 FROM deleted);
END;
GO

--TRUNCATE TABLE CustomersAuditLog;

-- Insert 4 new customers
INSERT INTO Customer (first_name, last_name, gender_id, phone, addr, city_id)
VALUES
('Jen', 'Irving', 1, '431-123-1111', '111 Main St', 1),
('Gene', 'Simons', 2, '431-123-2222', '222 Main St', 1),
('Sidney', 'Mark', 2, '431-123-3333', '333 Main St', 1),
('Prescot', 'Mandy', 2, '431-123-4444', '444 Main St', 1);
GO

SELECT * FROM CustomersAuditLog;
SELECT * FROM Customer;


--DELETE FROM Customer
--WHERE
--    (first_name = 'Jen' AND last_name = 'Irving' AND phone = '431-123-1111') OR
--    (first_name = 'Gene' AND last_name = 'Simons' AND phone = '431-123-2222') OR
--    (first_name = 'Sidney' AND last_name = 'Mark' AND phone = '431-123-3333') OR
--    (first_name = 'Prescot' AND last_name = 'Mandy' AND phone = '431-123-4444');
--GO

--DELETE FROM Customer
--WHERE (first_name = 'Chris' AND last_name = 'Irving' AND phone = '431-123-1111');
--GO


-- Update Jen Irving to Chris Irving
SELECT cust_id FROM Customer WHERE first_name = 'Jen' AND last_name = 'Irving';
UPDATE Customer SET first_name = 'Chris' WHERE cust_id = 1045;
GO

-- Delete Prescot Mandy
SELECT cust_id FROM Customer WHERE first_name = 'Prescot' AND last_name = 'Mandy';
DELETE FROM Customer WHERE cust_id = 1048;
GO

-- Check the Audit Log
SELECT * FROM CustomersAuditLog;
GO