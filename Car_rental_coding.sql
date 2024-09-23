use coding_challenge_car_rental_system;

CREATE TABLE Vehicle (
    vehicleID INT PRIMARY KEY,
    make VARCHAR(50),
    model VARCHAR(50),
    year INT,
    dailyRate DECIMAL(5, 2),
    status TINYINT,  -- 1 = available, 0 = notAvailable
    passengerCapacity INT,
    engineCapacity DECIMAL(6, 2)
);

CREATE TABLE Customer (
    customerID INT PRIMARY KEY,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    email VARCHAR(100),
    phoneNumber VARCHAR(20)
);

CREATE TABLE Lease (
    leaseID INT PRIMARY KEY,
    vehicleID INT,
    customerID INT,
    startDate DATE,
    endDate DATE,
    leaseType VARCHAR(20),  -- 'Daily' or 'Monthly'
    FOREIGN KEY (vehicleID) REFERENCES Vehicle(vehicleID),
    FOREIGN KEY (customerID) REFERENCES Customer(customerID)
);


CREATE TABLE Payment (
    paymentID INT PRIMARY KEY,
    leaseID INT,
    transactionDate DATE,
    amount DECIMAL(10, 2),
    FOREIGN KEY (leaseID) REFERENCES Lease(leaseID)
);


INSERT INTO Vehicle (vehicleID, make, model, year, dailyRate, status, passengerCapacity, engineCapacity)
VALUES
(1, 'Toyota', 'Camry', 2022, 50.00, 1, 4, 1450),
(2, 'Honda', 'Civic', 2023, 45.00, 1, 7, 1500),
(3, 'Ford', 'Focus', 2022, 48.00, 0, 4, 1400),
(4, 'Nissan', 'Altima', 2023, 52.00, 1, 7, 1200),
(5, 'Chevrolet', 'Malibu', 2022, 47.00, 1, 4, 1800),
(6, 'Hyundai', 'Sonata', 2023, 49.00, 0, 7, 1400),
(7, 'BMW', '3 Series', 2023, 60.00, 1, 7, 2499),
(8, 'Mercedes', 'C-Class', 2022, 58.00, 1, 8, 2599),
(9, 'Audi', 'A4', 2022, 55.00, 0, 4, 2500),
(10, 'Lexus', 'ES', 2023, 54.00, 1, 4, 2500);

INSERT INTO Customer (customerID, firstName, lastName, email, phoneNumber)
VALUES
(1, 'John', 'Doe', 'johndoe@example.com', '555-555-5555'),
(2, 'Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
(3, 'Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
(4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
(5, 'David', 'Lee', 'david@example.com', '555-987-6543'),
(6, 'Laura', 'Hall', 'laura@example.com', '555-234-5678'),
(7, 'Michael', 'Davis', 'michael@example.com', '555-876-5432'),
(8, 'Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
(9, 'William', 'Taylor', 'william@example.com', '555-321-6547'),
(10, 'Olivia', 'Adams', 'olivia@example.com', '555-765-4321');

INSERT INTO Lease (leaseID, vehicleID, customerID, startDate, endDate, leaseType)
VALUES
(1, 1, 1, '2023-01-01', '2023-01-05', 'Daily'),
(2, 2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
(3, 3, 3, '2023-03-10', '2023-03-15', 'Daily'),
(4, 4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
(5, 5, 5, '2023-05-05', '2023-05-10', 'Daily'),
(6, 4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
(7, 7, 7, '2023-07-01', '2023-07-10', 'Daily'),
(8, 8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
(9, 3, 3, '2023-09-07', '2023-09-10', 'Daily'),
(10, 10, 10, '2023-10-10', '2023-10-31', 'Monthly');

INSERT INTO Payment (paymentID, leaseID, transactionDate, amount)
VALUES
(1, 1, '2023-01-03', 200.00),
(2, 2, '2023-02-20', 1000.00),
(3, 3, '2023-03-12', 75.00),
(4, 4, '2023-04-25', 900.00),
(5, 5, '2023-05-07', 60.00),
(6, 6, '2023-06-18', 1200.00),
(7, 7, '2023-07-03', 40.00),
(8, 8, '2023-08-14', 1100.00),
(9, 9, '2023-09-09', 80.00),
(10, 10, '2023-10-25', 1500.00);

--1)
UPDATE Vehicle SET dailyRate = 68 WHERE make = 'Mercedes';


--2)
DELETE FROM Payment WHERE leaseID IN (SELECT leaseID FROM Lease WHERE customerID = 1);
DELETE FROM Lease WHERE customerID = 1;
DELETE FROM Customer WHERE customerID = 1;
select * from Payment;

--3)
EXEC sp_rename 'paymentDate',  'transactionDate', 'COLUMN';

--4)
SELECT * FROM Customer WHERE email = 'janesmith@example.com';


--5)
SELECT * FROM Lease JOIN Vehicle ON Lease.vehicleID=Vehicle.vehicleID 
WHERE Lease.customerID = 2 AND Vehicle.status=1;

--6)
SELECT p.* FROM Payment p JOIN Lease l ON p.leaseID = l.leaseID JOIN Customer c ON l.customerID = c.customerID
WHERE c.phoneNumber = '555-123-4567';

--7)
SELECT AVG(dailyRate) AS avgDailyRate FROM Vehicle WHERE status = 1;

--8)
SELECT TOP(1)* FROM Vehicle ORDER BY dailyRate DESC;

--9)
SELECT * FROM Vehicle WHERE vehicleID IN( SELECT vehicleID FROM Lease WHERE customerID=(SELECT customerID
FROM Customer WHERE firstName='Sarah'));

--10)
SELECT * FROM Lease WHERE endDate = (SELECT MAX(endDate) FROM Lease);

--11)
SELECT * FROM Payment WHERE YEAR(transactionDate) = 2023;

--12)
SELECT c.* FROM Customer c JOIN Lease l ON l.customerID=c.customerID WHERE leaseID NOT IN(
SELECT leaseID FROM Payment);

SELECT * FROM Payment;



--13)
SELECT v.vehicleID, v.make, v.model, COALESCE(SUM(p.amount), 0) AS TotalPayments FROM Vehicle v
LEFT JOIN Lease l ON v.vehicleID = l.vehicleID LEFT JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY v.vehicleID, v.make, v.model;

--14)
SELECT c.customerID, c.firstName, c.lastName, SUM(p.amount) AS TotalPayments FROM Customer c
LEFT JOIN Lease l ON c.customerID = l.customerID LEFT JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.customerID, c.firstName, c.lastName;

--15)
SELECT l.leaseID, v.make, v.model, v.year, l.startDate, l.endDate, l.leaseType FROM Lease l 
JOIN Vehicle v ON l.vehicleID = v.vehicleID;

--16)
SELECT l.leaseID,l.leaseType,c.firstName,v.make,v.model,v.status FROM Lease l JOIN Customer c ON l.customerID=c.customerID
JOIN Vehicle v ON l.vehicleID=v.vehicleID WHERE v.status=1;


--17)
SELECT TOP 1 c.customerID, c.firstName, c.lastName, SUM(p.amount) AS TotalSpent FROM Customer c
JOIN Lease l ON c.customerID = l.customerID JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.customerID, c.firstName, c.lastName ORDER BY TotalSpent DESC;

--18)
SELECT v.vehicleID,v.make,v.model,v.dailyRate,l.* FROM Vehicle v LEFT JOIN
Lease l ON v.vehicleID=l.vehicleID;

