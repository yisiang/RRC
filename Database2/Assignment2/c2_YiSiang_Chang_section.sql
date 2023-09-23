/**
 ** Course: DBMS-2006 Database Management Systems 2
 ** Name: Yi Siang Chang
 ** Assignment: 2
 ** Date: 2023-09-21
 **/

CREATE DATABASE Assignment2;
-- SELECT * FROM Assignmnet2;

USE Assignment2;

/* Create Actor Table */
CREATE TABLE Actor (
    ActID INT PRIMARY KEY,
    FirstName NVARCHAR(30),
    LastName NVARCHAR(30),
    DOB DATE
);
-- SELECT * FROM Actor;
GO

/* SELECT name AS 'Database Name', 
       (SELECT name FROM sys.tables WHERE name = 'Actor') AS 'Table Name'
FROM sys.databases
WHERE name IN 
(SELECT DISTINCT DB_NAME(database_id) 
FROM sys.dm_db_partition_stats WHERE object_id = OBJECT_ID('Actor')); */

/* Create Movie Table */
CREATE TABLE Movie (
    MovieID INT PRIMARY KEY,
    Title NVARCHAR(50),
    Genre NVARCHAR(50),
    YearReleased DATE
);
-- SELECT * FROM Movie;
GO

/* Create PerformsIn Table */
CREATE TABLE PerformsIn (
    ActID INT,
    MovieID INT,
    RoleType NVARCHAR(50),
    CONSTRAINT FK_PerformsIn_ActorID 
		FOREIGN KEY (ActID) 
		REFERENCES Actor(ActID),
    CONSTRAINT FK_PerformsIn_MovieID 
		FOREIGN KEY (MovieID) 
		REFERENCES Movie(MovieID)
);
-- SELECT * FROM PerformsIn;
GO

/* Adding non-clustered indexes for Foreign Keys in PerformsIn */
CREATE NONCLUSTERED INDEX IDX_PerformsIn_ActID ON PerformsIn(ActID);
CREATE NONCLUSTERED INDEX IDX_PerformsIn_MovieID ON PerformsIn(MovieID);

-- SELECT * FROM PerformsIn;
GO

/* The order of the DROP statements respects the dependencies between tables */
DROP TABLE IF EXISTS PerformsIn;
DROP TABLE IF EXISTS Movie;
DROP TABLE IF EXISTS Actor;

-- sp_Help PerformsIn;
-- sp_Help Movie;
-- sp_Help Actor;

-- SELECT * FROM Assignmnet2;

GO