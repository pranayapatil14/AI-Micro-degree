create database Airports;

use Airports;

CREATE TABLE Airports (
    airport_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100),
    code CHAR(3) UNIQUE
);

CREATE TABLE Flights (
    flight_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_number VARCHAR(10) UNIQUE,
    departure_airport_id INT,
    arrival_airport_id INT,
    departure_time DATETIME,
    arrival_time DATETIME,
    base_price DECIMAL(10,2),
    FOREIGN KEY (departure_airport_id) REFERENCES Airports(airport_id),
    FOREIGN KEY (arrival_airport_id) REFERENCES Airports(airport_id)
);

CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    passport_number VARCHAR(20) UNIQUE
);

CREATE TABLE Seats (
    seat_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_id INT,
    seat_number VARCHAR(5),
    class ENUM('Economy', 'Business', 'First'),
    is_available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
    UNIQUE(flight_id, seat_number)
);

CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    passenger_id INT,
    flight_id INT,
    seat_id INT,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    price_paid DECIMAL(10, 2),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
    FOREIGN KEY (seat_id) REFERENCES Seats(seat_id)
);

CREATE TABLE Staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    role VARCHAR(50),
    assigned_flight_id INT,
    FOREIGN KEY (assigned_flight_id) REFERENCES Flights(flight_id)
);

INSERT INTO Airports (name, city, country, code) VALUES
('John F. Kennedy Intl', 'New York', 'USA', 'JFK'),
('Los Angeles Intl', 'Los Angeles', 'USA', 'LAX'),
('Heathrow Airport', 'London', 'UK', 'LHR');

INSERT INTO Flights (flight_number, departure_airport_id, arrival_airport_id, departure_time, arrival_time, base_price)
VALUES 
('AA101', 1, 2, '2025-06-01 08:00:00', '2025-06-01 11:00:00', 300.00),
('BA202', 3, 1, '2025-06-02 14:00:00', '2025-06-02 17:00:00', 450.00);

INSERT INTO Passengers (first_name, last_name, email, passport_number) VALUES
('Pranaya', 'Patil', 'pranayapatil@gmail.com', 'P12241419'),
('Ankita', 'Gholap', 'ankitagholap@gmail.com', 'P87654321'),
('Shravani', 'Dalvi', 'shravnidalvi@gmail.com', 'P64567503'),
('Chaitali', 'More', 'chaitalimore@gmail.com', 'P87570246');

-- For Flight AA101
INSERT INTO Seats (flight_id, seat_number, class) VALUES
(1, '12A', 'Economy'),
(1, '12B', 'Economy'),
(1, '1A', 'Business');

-- For Flight BA202
INSERT INTO Seats (flight_id, seat_number, class) VALUES
(2, '14C', 'Economy'),
(2, '2A', 'Business');

INSERT INTO Staff (name, role, assigned_flight_id) VALUES
('Captain Mike', 'Pilot', 1),
('Sarah Lee', 'Flight Attendant', 1),
('Captain Emma', 'Pilot', 2);

SELECT s.seat_id, s.seat_number, s.class
FROM Seats s
JOIN Flights f ON s.flight_id = f.flight_id
WHERE f.flight_number = 'AA101' AND s.is_available = TRUE;

SELECT f.flight_number, f.departure_time, f.arrival_time,
       a1.code AS from_airport, a2.code AS to_airport
FROM Flights f
JOIN Airports a1 ON f.departure_airport_id = a1.airport_id
JOIN Airports a2 ON f.arrival_airport_id = a2.airport_id
WHERE a1.code = 'JFK' AND a2.code = 'LAX';

SELECT 
    f.flight_number,
    f.base_price,
    COUNT(s.seat_id) AS total_seats,
    SUM(CASE WHEN s.is_available THEN 1 ELSE 0 END) AS available_seats,
    ROUND(
        f.base_price + (f.base_price * (1 - (SUM(CASE WHEN s.is_available THEN 1 ELSE 0 END) / COUNT(s.seat_id))) * 0.5),
        2
    ) AS dynamic_price
FROM Flights f
JOIN Seats s ON f.flight_id = s.flight_id
GROUP BY f.flight_id;

-- 1. Check seat_id for 12A
SELECT seat_id FROM Seats WHERE flight_id = 1 AND seat_number = '12A';

-- 2. Mark seat as booked (unavailable)
UPDATE Seats SET is_available = FALSE WHERE seat_id = 1;

SELECT 
    b.booking_id,
    f.flight_number,
    s.seat_number,
    b.price_paid,
    b.booking_date
FROM Bookings b
JOIN Flights f ON b.flight_id = f.flight_id
JOIN Seats s ON b.seat_id = s.seat_id
WHERE b.passenger_id = 1;

SELECT name, role
FROM Staff
WHERE assigned_flight_id = 1;

SELECT 
    f.flight_number,
    COUNT(s.seat_id) AS total_seats,
    SUM(CASE WHEN s.is_available THEN 0 ELSE 1 END) AS booked_seats,
    CONCAT(ROUND((SUM(CASE WHEN s.is_available THEN 0 ELSE 1 END) / COUNT(s.seat_id)) * 100, 2), '%') AS occupancy_rate
FROM Flights f
JOIN Seats s ON f.flight_id = s.flight_id
GROUP BY f.flight_id;


