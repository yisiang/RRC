USE IntroductoryProject;
GO

--DROP TABLE IF EXISTS Class;
--DROP TABLE IF EXISTS State;
--DROP TABLE IF EXISTS Station;
--DROP TABLE IF EXISTS Train;
--DROP TABLE IF EXISTS Gender;
--GO

/********** State **********/
CREATE TABLE State (
    state_id INT PRIMARY KEY IDENTITY(1,1),
    state_name NVARCHAR(30) NOT NULL UNIQUE
);
GO

BULK INSERT State
FROM 'C:\RRCworkspace\Modified_IntroProject\StateCSV.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
GO

/********** City **********/
CREATE TABLE City (
    city_id INT PRIMARY KEY IDENTITY(1,1),
    city_name NVARCHAR(30) NOT NULL,
    state_id INT NOT NULL,
    FOREIGN KEY (state_id) REFERENCES State(state_id)
);
GO

BULK INSERT City
FROM 'C:\RRCworkspace\Modified_IntroProject\CityCSV.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
GO

/********** Gender **********/
CREATE TABLE Gender (
    gender_id INT PRIMARY KEY IDENTITY(1,1),
    gender_name NVARCHAR(10) NOT NULL UNIQUE
);
GO

BULK INSERT Gender
FROM 'C:\RRCworkspace\Modified_IntroProject\GenderCSV.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
GO

/********** Customer **********/
CREATE TABLE Customer (
    cust_id INT PRIMARY KEY IDENTITY(1,1),
    first_name NVARCHAR(30) NOT NULL,
    last_name NVARCHAR(30) NOT NULL,
    gender_id INT,
    phone NVARCHAR(20),
    addr NVARCHAR(40) NOT NULL,
    city_id INT NOT NULL,
    FOREIGN KEY (gender_id) REFERENCES Gender(gender_id),
    FOREIGN KEY (city_id) REFERENCES City(city_id)
);
GO

BULK INSERT Customer
FROM 'C:\RRCworkspace\Modified_IntroProject\CustomerCSV.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
GO

/********** Station **********/
CREATE TABLE Station (
    station_id INT PRIMARY KEY IDENTITY(1,1),
    station_name NVARCHAR(30) NOT NULL UNIQUE
);
GO

BULK INSERT Station
FROM 'C:\RRCworkspace\Modified_IntroProject\StationCSV.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
GO

/********** Class **********/
CREATE TABLE Class (
    class_id INT PRIMARY KEY IDENTITY(1,1),
    train_name NVARCHAR(20) NOT NULL UNIQUE
);
GO

BULK INSERT Class
FROM 'C:\RRCworkspace\Modified_IntroProject\ClassCSV.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
GO

/********** Train **********/
CREATE TABLE Train (
    train_id INT PRIMARY KEY IDENTITY(1,1),
    train_name NVARCHAR(20) NOT NULL UNIQUE
);
GO

BULK INSERT Train
FROM 'C:\RRCworkspace\Modified_IntroProject\TrainCSV.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
GO

/********** Trip **********/
CREATE TABLE Trip (
    trip_id INT PRIMARY KEY IDENTITY(1,1),
    trip_no NVARCHAR(20) NOT NULL UNIQUE,
    station_id_depart INT,
    station_id_arrive INT,
    depart_datetime DATETIME,
    arrive_datetime DATETIME,
    cost_paid DECIMAL(6,2),
    class_id INT,
    train_id INT,
    FOREIGN KEY (station_id_depart) REFERENCES Station(station_id),
    FOREIGN KEY (station_id_arrive) REFERENCES Station(station_id),
    FOREIGN KEY (class_id) REFERENCES Class(class_id),
    FOREIGN KEY (train_id) REFERENCES Train(train_id)
);
GO

BULK INSERT Trip
FROM 'C:\RRCworkspace\Modified_IntroProject\TripCSV.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
GO

/********** Ticket **********/
CREATE TABLE Ticket (
    ticket_id INT PRIMARY KEY IDENTITY(1,1),
    ticket_no NVARCHAR(20) NOT NULL UNIQUE,
    cust_id INT NOT NULL,
    trip_id INT NOT NULL,
    class_id INT NOT NULL,
    cost_paid DECIMAL(6,2),
    FOREIGN KEY (cust_id) REFERENCES Customer(cust_id),
    FOREIGN KEY (trip_id) REFERENCES Trip(trip_id),
    FOREIGN KEY (class_id) REFERENCES Class(class_id)
);
GO

BULK INSERT Ticket
FROM 'C:\RRCworkspace\Modified_IntroProject\TicketCSV.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
GO

/* Sample Train Ticket: Train Booking System */
SELECT 
    t.ticket_no AS 'Confirmation Number',
    tr.train_name AS 'Train',
    c.train_name AS 'Class',
    s1.station_name AS 'Departure',
    s2.station_name AS 'Destination',
    FORMAT(trp.depart_datetime, 'MM/dd/yy hh:mmtt') AS 'Departure Date/Time',
    FORMAT(trp.arrive_datetime, 'MM/dd/yy hh:mmtt') AS 'Arrival Date/Time',
    cu.first_name + ' ' + cu.last_name AS 'Passenger(s)',
    t.ticket_no AS 'Ticket Number'
FROM Ticket t
INNER JOIN Customer cu ON t.cust_id = cu.cust_id
INNER JOIN Trip trp ON t.trip_id = trp.trip_id
INNER JOIN Station s1 ON trp.station_id_depart = s1.station_id
INNER JOIN Station s2 ON trp.station_id_arrive = s2.station_id
INNER JOIN Train tr ON trp.train_id = tr.train_id
INNER JOIN Class c ON trp.class_id = c.class_id;
GO