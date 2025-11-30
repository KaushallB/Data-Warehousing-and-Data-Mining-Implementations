# Creating a database named "constellation_db"
CREATE DATABASE constellation_db;
# Create base table
CREATE TABLE autoxyz (
  id INT AUTO_INCREMENT PRIMARY KEY,
  item_name VARCHAR(255),
  brand VARCHAR(255),
  sold_by VARCHAR(255),
  category VARCHAR(255),
  day INT,
  month VARCHAR(255),
  quarter VARCHAR(255),
  year INT,
  location_name VARCHAR(255),
  state VARCHAR(255),
  pin_code INT,
  driver_name VARCHAR(255),
  duty_time VARCHAR(255),
  qty_sold INT,
  amt_sold INT
);

# Insert sample data
INSERT INTO autoxyz (
item_name, 
brand, 
sold_by, 
category, 
day, 
month, 
quarter, 
year,
location_name, 
state, 
pin_code, 
driver_name, 
duty_time, 
qty_sold, 
amt_sold
) VALUES
('Car', 'Model X', 'Tesla', 'Four wheeler', 13, 'June', 'Q2', 2024, 'New Baneshwor', 'Bagmati', 123, 'Jack', 'Evening', 2, 13000),
('Car', 'Model Y', 'Tesla', 'Four wheeler', 21, 'November', 'Q4', 2024, 'Koteshwor', 'Bagmati', 123, 'Candace', 'Morning', 1, 8000);

# Create dimension tables
CREATE TABLE timedim (
t_id INT AUTO_INCREMENT PRIMARY KEY,
day INT,
month VARCHAR(255),
quarter VARCHAR(255),
year INT
);
INSERT INTO timedim (day, month, quarter, year)
SELECT DISTINCT day, month, quarter, year FROM autoxyz;

CREATE TABLE locationdim (
l_id INT AUTO_INCREMENT PRIMARY KEY,
location_name VARCHAR(255),
state VARCHAR(255),
pin_code INT
);
INSERT INTO locationdim (location_name, state, pin_code)
SELECT DISTINCT location_name, state, pin_code FROM autoxyz;

CREATE TABLE itemdim (
i_id INT AUTO_INCREMENT PRIMARY KEY,
item_name VARCHAR(255),
brand VARCHAR(255),
sold_by VARCHAR(255),
category VARCHAR(255)
);

INSERT INTO itemdim (item_name, brand, sold_by, category)
SELECT DISTINCT item_name, brand, sold_by, category FROM autoxyz;

CREATE TABLE vehicledim (
vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
driver_name VARCHAR(255),
duty_time VARCHAR(255)
);

INSERT INTO vehicledim (driver_name, duty_time)
SELECT DISTINCT driver_name, duty_time FROM autoxyz;

# Create fact tables
CREATE TABLE salesfact (
item_id INT,
time_id INT,
location_id INT,
qty_sold INT,
FOREIGN KEY (item_id) REFERENCES itemdim(i_id),
FOREIGN KEY (time_id) REFERENCES timedim(t_id),
FOREIGN KEY (location_id) REFERENCES locationdim(l_id)
);
INSERT INTO salesfact (item_id, time_id, location_id, qty_sold)
SELECT 
i.i_id,
t.t_id,
l.l_id,
c.qty_sold
FROM autoxyz c
LEFT JOIN timedim t ON t.day = c.day AND t.month = c.month AND t.quarter = c.quarter AND t.year = c.year
LEFT JOIN itemdim i ON i.item_name = c.item_name AND i.brand = c.brand AND i.sold_by = c.sold_by AND i.category = c.category
LEFT JOIN locationdim l ON l.location_name = c.location_name AND l.state = c.state AND l.pin_code = c.pin_code;

CREATE TABLE deliveryfact (
item_id INT,
location_id INT,
vehicle_id INT,
FOREIGN KEY (item_id) REFERENCES itemdim(i_id),
FOREIGN KEY (location_id) REFERENCES locationdim(l_id),
FOREIGN KEY (vehicle_id) REFERENCES vehicledim(vehicle_id)
);
INSERT INTO deliveryfact (item_id, location_id, vehicle_id)
SELECT 
i.i_id,
l.l_id,
v.vehicle_id
FROM autoxyz c
LEFT JOIN itemdim i ON i.item_name = c.item_name AND i.brand = c.brand AND i.sold_by = c.sold_by AND i.category = c.category
LEFT JOIN locationdim l ON l.location_name = c.location_name AND l.state = c.state AND l.pin_code = c.pin_code
LEFT JOIN vehicledim v ON v.driver_name = c.driver_name AND v.duty_time = c.duty_time;

#  Query from deliveryfact where duty time is Morning
SELECT 
d.item_id, 
d.location_id, 
v.vehicle_id, 
v.driver_name, 
v.duty_time
FROM deliveryfact d
LEFT JOIN vehicledim v ON d.vehicle_id = v.vehicle_id
WHERE v.duty_time = 'Morning';
