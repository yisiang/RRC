/**
 ** Course: DBMS-2006 Database Management Systems 2
 ** Name: Yi Siang Chang
 ** Assignment: 4
 ** Date: 2023-10-17
 **/


USE JRMOVIE;
GO

/*** Exercise 1: Create and call a Stored Procedure ***/
-- Stored Procedure
CREATE OR ALTER PROCEDURE usp_AddOne (
    @InputParam INT,
    @OutputParam INT OUTPUT
)
AS
BEGIN
    SET @OutputParam = @InputParam + 2;
END;
GO

-- Anonymous block calls procedure
DECLARE @Result INT, @TestInput INT = 5;
BEGIN
	EXEC usp_AddOne @TestInput, @Result OUTPUT;
	PRINT @Result; -- print: 6
END 
GO

/*** Exercise 2: Create and call a Scalar function ***/
CREATE OR ALTER FUNCTION ufn_ConcatenateTwoString(
	@String1 NCHAR(25), 
	@String2 NCHAR(25)
)
RETURNS NVARCHAR(51) -- the space between
AS
BEGIN
    RETURN RTRIM(@String1) + ' ' + RTRIM(@String2);
END;
GO

-- Anonymous block calls procedure
DECLARE @FirstName NCHAR(25) = 'FirstName'
      , @LastName NCHAR(25) = 'LastName'
	  , @Result NVARCHAR(51);
BEGIN
	SET @Result = dbo.ufn_ConcatenateTwoString(@FirstName, @LastName);
	PRINT @Result; -- print: "FirstName LastName"
END
GO


/*** Exercise 3: Create and call a Table function ***/
CREATE FUNCTION ufn_GetMovieRating_YiSiang_Chang(
	@MovieName NCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
	-- SELECT statement fetches the movie details based on the provided name
    SELECT Name, r.RatingId, Description
    FROM Movie m
	     JOIN Rating r ON m.RatingId=r.RatingId
    WHERE LOWER(Name) = LOWER(TRIM(@MovieName)) -- Using LOWER() to make the search case-insensitive
);
GO

-- Test
SELECT * FROM dbo.ufn_GetMovieRating_YiSiang_Chang('rOCky');


/*
DROP TABLE MOVIE;

CREATE TABLE "MOVIE"(	
	"MOVIEID" Decimal(7,0) NOT NULL, 
	"NAME" NVarchar(100) NOT NULL,
	"DESCRIPTION" NVarchar(100) NOT NULL,
	"RATINGID" nchar(3)
) ;

Insert into MOVIE (MOVIEID,NAME,DESCRIPTION,RATINGID) values (131,'Registration Day','convert(datetime,2001-07-13) 0.88 1.6 2','A');
Insert into MOVIE (MOVIEID,NAME,DESCRIPTION,RATINGID) values (115,'Beauty and the beast','convert(datetime,1991-09-29) 2.02 4.28','G');
Insert into MOVIE (MOVIEID,NAME,DESCRIPTION,RATINGID) values (24,'WALL-E','convert(datetime,2008-06-27),2.15,4.52,8','G');
Insert into MOVIE (MOVIEID,NAME,DESCRIPTION,RATINGID) values (47,'Kingdom of Heaven','convert(datetime,2005-05-02),1.87,3.85,7','R');
Insert into MOVIE (MOVIEID,NAME,DESCRIPTION,RATINGID) values (56,'Grease','convert(datetime,1978-06-13),1.82,3.89,7','14A');
Insert into MOVIE (MOVIEID,NAME,DESCRIPTION,RATINGID) values (61,'The Longest Yard','convert(datetime,2005-05-27),1.66,3.43,6','14A');
Insert into MOVIE (MOVIEID,NAME,DESCRIPTION,RATINGID) values (84,'Bird on a Wire','convert(datetime,1990-05-18),1.47,3.06,6','14A');
Insert into MOVIE (MOVIEID,NAME,DESCRIPTION,RATINGID) values (57,'The Last Five Years','convert(datetime,2014-09-07),1.77,3.51,6','14A');

SELECT * FROM MOVIE;
*/