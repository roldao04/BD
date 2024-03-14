    CREATE TABLE Airport (
        Airport_code VARCHAR(3) PRIMARY KEY,
        City VARCHAR(255) NOT NULL,
        State VARCHAR(255) NOT NULL,
        Name VARCHAR(255) NOT NULL
    );

    CREATE TABLE Airplane_Type (
        Type_name VARCHAR(255) PRIMARY KEY,
        Max_seats INT NOT NULL,
        Company VARCHAR(255) NOT NULL
    );

    CREATE TABLE Airplane (
        ID INT PRIMARY KEY,
        Total_no_of_seats INT NOT NULL,
        Type_name VARCHAR(255) NOT NULL,
        FOREIGN KEY (Type_name) REFERENCES Airplane_Type(Type_name)
    );

    CREATE TABLE Flight (
        Number VARCHAR(255) PRIMARY KEY,
        Airline VARCHAR(255) NOT NULL,
        Weekdays VARCHAR(255) NOT NULL
    );

    CREATE TABLE Flight_Leg (
        Leg_no INT PRIMARY KEY,
        Departure_Airport_code VARCHAR(3) NOT NULL,
        Arrival_Airport_code VARCHAR(3) NOT NULL,
        Scheduled_dep_time HOUR NOT NULL,
        Scheduled_arr_time HOUR NOT NULL,
        Flight_Number VARCHAR(255) NOT NULL,
        FOREIGN KEY (Departure_Airport_code) REFERENCES Airport(Airport_code),
        FOREIGN KEY (Arrival_Airport_code) REFERENCES Airport(Airport_code),
        FOREIGN KEY (Flight_Number) REFERENCES Flight(Number)
    );

    CREATE TABLE Leg_Instance (
        Date DATE PRIMARY KEY,
        No_of_avail_seats INT NOT NULL,
        Airplane_id INT NOT NULL,
        Scheduled_dep_time TIME NOT NULL,
        Scheduled_arr_time TIME NOT NULL,
        FOREIGN KEY (Airplane_id) REFERENCES Airplane(ID)
    );

    CREATE TABLE Seat (
        Seat_no VARCHAR(255) PRIMARY KEY,
        Customer_name VARCHAR(255) NOT NULL,
        Cphone VARCHAR(20) NOT NULL,
        Date DATE NOT NULL,
        FOREIGN KEY (Date) REFERENCES Leg_Instance(Date)
    );

    CREATE TABLE Fare (
        Code VARCHAR(255) PRIMARY KEY,
        Amount DECIMAL(10, 2) NOT NULL,
        Restrictions TEXT,
        Flight_Number VARCHAR(255) NOT NULL,
        FOREIGN KEY (Flight_Number) REFERENCES Flight(Number)
    );

    CREATE TABLE Can_Land (
        Airport_code VARCHAR(3) NOT NULL,
        Airplane_Type_name VARCHAR(255) NOT NULL,
        PRIMARY KEY (Airport_code, Airplane_Type_name),
        FOREIGN KEY (Airport_code) REFERENCES Airport(Airport_code),
        FOREIGN KEY (Airplane_Type_name) REFERENCES Airplane_Type(Type_name)
    );
