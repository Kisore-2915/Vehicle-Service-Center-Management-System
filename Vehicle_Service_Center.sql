USE vehicle_service_center;

-- Practice Queries

-- 1. Display vehicles serviced today

SELECT vehicle_number, vehicle_model, service_type, service_date
FROM Vehicles
JOIN Service_Records
ON Vehicles.vehicle_id = Service_Records.vehicle_id
WHERE service_date = CURDATE();

-- 2. Find the mechanic handling the most services

SELECT mechanic_name, COUNT(service_id) AS total_services
FROM Mechanics
JOIN Service_Records
ON Mechanics.mechanic_id = Service_Records.mechanic_id
GROUP BY mechanic_name
ORDER BY total_services DESC
LIMIT 1;


-- 3. Calculate customer-wise bill amount

SELECT customer_name, SUM(total_amount) AS total_bill
FROM Customers
JOIN Vehicles
ON Customers.customer_id = Vehicles.customer_id
JOIN Service_Records
ON Vehicles.vehicle_id = Service_Records.vehicle_id
JOIN Bills
ON Service_Records.service_id = Bills.service_id
GROUP BY customer_name;

-- 4. Find vehicles not serviced in the last year

SELECT vehicle_number, vehicle_model
FROM Vehicles
WHERE vehicle_id NOT IN
(
    SELECT vehicle_id
    FROM Service_Records
    WHERE service_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);

-- 5. Display service history for a vehicle

SELECT vehicle_number, service_type, service_date, cost
FROM Vehicles
JOIN Service_Records
ON Vehicles.vehicle_id = Service_Records.vehicle_id
WHERE vehicle_number = 'TN10AB1234'
ORDER BY service_date;

-- 6. Count services by type

SELECT service_type, COUNT(*) AS total
FROM Service_Records
GROUP BY service_type;

-- 7. Find customers with more than three visits

SELECT customer_name, COUNT(service_id) AS visits
FROM Customers
JOIN Vehicles
ON Customers.customer_id = Vehicles.customer_id
JOIN Service_Records
ON Vehicles.vehicle_id = Service_Records.vehicle_id
GROUP BY customer_name
HAVING COUNT(service_id) > 3;

-- 8. Display pending payments

SELECT customer_name, vehicle_number, total_amount
FROM Customers
JOIN Vehicles
ON Customers.customer_id = Vehicles.customer_id
JOIN Service_Records
ON Vehicles.vehicle_id = Service_Records.vehicle_id
JOIN Bills
ON Service_Records.service_id = Bills.service_id
WHERE payment_status = 'Pending';

-- 9. Find the most common service

SELECT service_type, COUNT(*) AS frequency
FROM Service_Records
GROUP BY service_type
ORDER BY frequency DESC
LIMIT 1;

-- 10. Calculate monthly service revenue

SELECT
    MONTH(service_date) AS month,
    SUM(cost) AS total_revenue
FROM Service_Records
GROUP BY MONTH(service_date)
ORDER BY month;

-- 11. Find the highest bill

SELECT MAX(total_amount) AS highest_bill
FROM Bills;

-- 12. Find mechanic with highest revenue

SELECT mechanic_name, SUM(cost) AS total_revenue
FROM Mechanics
JOIN Service_Records
ON Mechanics.mechanic_id = Service_Records.mechanic_id
GROUP BY mechanic_name
ORDER BY total_revenue DESC
LIMIT 1;

-- 13. Display customers who own more than one vehicle

SELECT customer_name, COUNT(vehicle_id) AS total_vehicles
FROM Customers
JOIN Vehicles
ON Customers.customer_id = Vehicles.customer_id
GROUP BY customer_name
HAVING COUNT(vehicle_id) > 1;

-- 14. Find average service cost

SELECT AVG(cost) AS average_cost
FROM Service_Records;

-- 15. Find the most experienced mechanic

SELECT mechanic_name, experience
FROM Mechanics
ORDER BY experience DESC
LIMIT 1;

-- 16. Display all engine repairs

SELECT *
FROM Service_Records
WHERE service_type = 'Engine Repair';

-- 17. Find customers from Chennai

SELECT customer_name, phone, city
FROM Customers
WHERE city = 'Chennai';

-- 18. Find all services by a particular mechanic

SELECT mechanic_name, service_type, service_date, cost
FROM Mechanics
JOIN Service_Records
ON Mechanics.mechanic_id = Service_Records.mechanic_id
WHERE mechanic_name = 'Ramesh';

-- 19. Display unpaid bill details with service information

SELECT
    bill_id,
    customer_name,
    vehicle_number,
    service_type,
    total_amount,
    payment_status
FROM Bills
JOIN Service_Records
ON Bills.service_id = Service_Records.service_id
JOIN Vehicles
ON Service_Records.vehicle_id = Vehicles.vehicle_id
JOIN Customers
ON Vehicles.customer_id = Customers.customer_id
WHERE payment_status = 'Pending';

-- 20. Rank mechanics based on number of services

SELECT
    mechanic_name,
    COUNT(service_id) AS total_services,
    RANK() OVER (ORDER BY COUNT(service_id) DESC) AS service_rank
FROM Mechanics
JOIN Service_Records
ON Mechanics.mechanic_id = Service_Records.mechanic_id
GROUP BY mechanic_name;