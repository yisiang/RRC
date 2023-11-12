USE IntroductoryProject;
GO

CREATE OR ALTER PROCEDURE usp_FixDepartureArrivalTimes
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Table to store IDs of the rows that need to be updated
        DECLARE @UpdatedRows TABLE (trip_id INT);

        -- Temporary table to hold the original datetimes
        DECLARE @TempDates TABLE (trip_id INT, original_depart DATETIME, original_arrive DATETIME);




		UPDATE Trip
        SET depart_datetime = arrive_datetime,
            arrive_datetime = depart_datetime
        WHERE depart_datetime>arrive_datetime;


        -- Insert the original dates into the temp table
        INSERT INTO @TempDates (trip_id, original_depart, original_arrive)
        SELECT trip_id, depart_datetime, arrive_datetime
        FROM Trip
        WHERE DATEDIFF(MINUTE, depart_datetime, arrive_datetime) < 0;

        -- Updating the departure and arrival times
        UPDATE Trip
        SET depart_datetime = t.original_arrive,
            arrive_datetime = t.original_depart
        FROM Trip
        INNER JOIN @TempDates t ON Trip.trip_id = t.trip_id;
        OUTPUT inserted.trip_id INTO @UpdatedRows(trip_id);
		-- OUTPUT inserted.trip_id INTO @UpdatedRows(trip_id); is used to count the number of updated rows. 
		-- Without that, the message about the number of updated rows will always indicate zero updates.

        -- Commit the transaction if successful
        COMMIT TRANSACTION;
        
        -- Output the results
        DECLARE @UpdatedCount INT = (SELECT COUNT(*) FROM @UpdatedRows);
        DECLARE @TotalCount INT = (SELECT COUNT(*) FROM Trip);
        IF @UpdatedCount > 0
        BEGIN
            PRINT CAST(@UpdatedCount AS NVARCHAR) + ' swaps performed between departure and arrival times.';
        END
        ELSE
        BEGIN
            PRINT 'No swaps needed between departure and arrival times.';
        END
        PRINT CAST(@TotalCount - @UpdatedCount AS NVARCHAR) + ' rows have not been updated.';
    END TRY
    BEGIN CATCH
        -- Rollback the transaction if there is an error
        ROLLBACK TRANSACTION;
        -- Log error message
        PRINT 'An error occurred: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Anonymous block calls procedure
USE IntroductoryProject2;
GO

BEGIN
    EXEC usp_FixDepartureArrivalTimes;
END;
GO
