--==================================================================================================
/*
	Access Control Language Speaking Notes - comments can be used 
	as speaking notes. Everything else can be run in SSMS!
	
	Required Database for lesson: Northwind
	
	Northwind - a MS database that originally shipped with 
	MS Access to hilight its features, ported to MS SQL Server 
	& other RMDS e.g. postre, mysql, etc...
	
	Business model - a fictitious company called Northwind Traders 
	that is in the business of importing/exporting specialty foods around
	the word? 
	
	ERD provided, please see ERDs folder, Northwind.pdf ...

	Security is one of the added benefits to using a RDMS, permissions
	can be controlled at a granular level

	Authentication is about validating a user or determining they are the person they claim to be
	A password is typically used to authenticate a user.
	Authentication gets a user onto the SQL Server

	Authorization is all about being giving access to interact with objects and data in the database(s)

	No permissions are given out by default, users must be assigned permission in order to do anything
	on SQL Server!


	Vocabulary and Terms:

	Principal - is any user or component that can be assigned a permission
	Privilege - broad set of rights(permissions) issued to a principal
	Permission - is a right to access a protected resource within a database
	Role - like a group in windows, but confined to database
	User - principal that has access to database objects
	Login - principal that has access to some objects in a server instance
	group - principal that the login is associated with

	In short... A user or role can be assigned permissions. A user can be assigned to a role where he/she 
	inherits the permissions of the role.

	Best Practice
		- follow the principle of least privilege - give only the permissions to users required to do their job. 

	Access Control Language (ACL)

	Common Permissions Types
	-CREATE
	-ALTER
	-DELETE
	-INSERT
	-SELECT - most common permission users require
	-UPDATE
	
	Permission Statements
	-GRANT - allow acess to object and/or data
	-REVOKE - remove access to object and/or data
	-DENY - most restrictive 
*/
--========================================================================================================

USE Northwind;

-- see sproc implmentation: sp_helptext
exec sp_helptext SalesByCategory

-- 10 most expensive products
exec [Ten Most Expensive Products]
-- see how this sproc is implemented
exec sp_helptext [Ten Most Expensive Products]

-- run SalesByCategory sproc, despite its name it this sproc is returning total sale for each product in 
-- seafood category
-- what the sproc does isn't really important here, we want to control permissions to this object in some
-- way
exec salesByCategory 'seafood'



-- find out who the database believes we are
select user

-- expand Security-->Logins folder to show class current logins
-- Next create a new login
CREATE LOGIN seafood_mgr WITH PASSWORD='seafood', DEFAULT_DATABASE=Northwind, CHECK_POLICY=OFF;

--now refresh logins folder, seafood_mgr login now apears

-- next check the Security --> Users folder in the Northwind database, does the seafood_mgr user appear? No...
CREATE USER Michael	 FOR LOGIN seafood_mgr WITH Default_Schema = [DBO] -- note that the user name is not the same as Login name, but can be

GRANT EXEC ON SalesByCategory to Michael 
DENY EXEC ON [Ten Most Expensive Products] to Michael 

-- time to impersonate another user
EXECUTE AS user = 'Michael'
SELECT user

--Test Michael's permissions
exec salesByCategory 'seafood' -- able to access!
exec [Ten Most Expensive Products] -- access denied

--let's try querying something we haven't explicitly given permissions to
select * from Employees; -- The SELECT permission was denied on the object 'Employees', database 'Northwind', schema 'dbo'.

-- Recall no database permissions are given out of the box, everything must be assigned.
-- time to revert back to SA user
REVERT;
select user; --dbo is the database owner and has full access to that database

/*
	Open a 2 instance of SSMS and demonstrate that 
	seafood_mgr (LOGIN)
	seafood (password) 

	Note: seafood_mgr login, user(Michael) is able to see databases but 
	not able to access their contents, default database context is set to Northwind
*/
Select user; -- shows user Michael is mapped to LOGIN seafood_mgr

--Test Michael's permissions
exec salesByCategory 'seafood' -- able to access!
exec [Ten Most Expensive Products] -- access denied

/*
 Roles
 From a management perspective, makes more sense to assign
 permissions to a ROLE instead of directly to a user
 Roles can be thought of as folders having permissions assigned to
 them, users can then be added to folders  and they inherent those
 permissions

 In fact in practice, many organizations create Oganizational units (OUs) in 
 Active directory for this purpose. Users requiring access to database would gain
 access to it by being added to an AD group intead of adding users directly inside database
 */

 -- allow dataentry operations to be performed on Categories table
 CREATE ROLE DataEntry
 GRANT SELECT,INSERT,UPDATE on Categories to DataEntry
 DENY SELECT ON Region to DataEntry;

-- create data_entry Login
CREATE LOGIN data_entry WITH PASSWORD='data', DEFAULT_DATABASE=Northwind, CHECK_POLICY=OFF;
CREATE USER Bob	 FOR LOGIN data_entry WITH Default_Schema = [DBO] 

-- add user Bob to the data_entry Role
sp_addrolemember 'DataEntry','Bob'

--test Bob's access
select user;
execute as user = 'Bob'

Select * from Region; -- denied access
select * from Categories; -- allowed access

-- insert a new category
INSERT INTO Categories(CategoryName,Description,Picture)
VALUES('ICE CREAM','Soft and hard ice creams',null)

select * from Categories; -- allowed access

/* 
 * with 2nd instance of SSMS, login as data_entry
   LOGIN: data_entry
   PW: data

   Good to show students that alot of the objects are not accessible, besides
   Northwind Database, specifically the Categories table since data_entry role 
   only has access to that table
 */

 --=========================================== 
 /*
	Windows Authentication type - not working as expected, perhaps a docker issue?

	CREATE LOGIN [<domainName>\<login_name>] FROM WINDOWS;

	select user
	revert
	
 */
 
 

 
