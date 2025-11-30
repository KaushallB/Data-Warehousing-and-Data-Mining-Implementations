#Create a database
CREATE DATABASE kaushaldatawarehouse;

# Create a source table for data warehouse
CREATE TABLE company (id int AUTO_INCREMENT PRIMARY KEY,
item_name varchar(255), 
brand varchar(255), 
sold_by varchar(255), 
category varchar(255), 
day int,
month varchar(255), 
quarter varchar(255), 
years int,
location_name varchar(255), 
state varchar(255),
pin_code int,
branch_name varchar(255), 
branch_manager varchar(255), 
qty_sold int,
amt_sold int
);

INSERT INTO company(item_name,
brand,
sold_by,
category,
day,
month,
quarter,
years,
location_name,
state,
pin_code,
branch_name,
branch_manager,
qty_sold,
amt_sold)
VALUES("Car","Model X","Tesla","Four wheeler",13,"June","Q2",2021,"New
Baneshwor","Bagmati","123","Baneshwor 1","Ashish",2,15000),
("Car","Model Y","Tesla","Four wheeler",15,"October","Q4",2022,"Old
Baneshwor","Bagmati","123","Baneshwor 3","Manoj",1,5000);
SELECT * FROM company;
# Create time dimension table for data warehouse.
CREATE TABLE timedim (t_id int AUTO_INCREMENT PRIMARY KEY,
day int,
month varchar(255),
quarter varchar(255),
years int
);
INSERT INTO timedim(
day,
month,
quarter,
years
)
SELECT day,month,quarter,years FROM company;

SELECT * FROM timedim;

# Create item dimension table for data warehouse.
CREATE TABLE itemdim (i_id int AUTO_INCREMENT PRIMARY KEY,
item_name varchar(255),
brand varchar(255),
sold_by varchar(255),
category varchar(255)
);
INSERT INTO itemdim(
item_name,
brand,
sold_by,
category
)
SELECT item_name,brand,sold_by,category FROM company;
SELECT * FROM itemdim;

# Create location dimension table for data warehouse.
CREATE TABLE locationdim (l_id int AUTO_INCREMENT PRIMARY KEY,
location_name varchar(255),
state varchar(255),
pin_code int
);
INSERT INTO locationdim(
location_name,
state,
pin_code
)
SELECT location_name,state,pin_code FROM company;
SELECT * FROM locationdim;

# Create branch dimension table for data warehouse.
CREATE TABLE branchdim (b_id int AUTO_INCREMENT PRIMARY KEY,
branch_name varchar(255),
branch_manager varchar(255)
);

INSERT INTO branchdim(
branch_name,
branch_manager
)
SELECT branch_name,branch_manager FROM company;
SELECT * FROM branchdim;

# Create sales fact table for data warehouse using Foreign Key.
CREATE TABLE salesFact (t_id int,
i_id int,
l_id int,
b_id int,
qty_sold int,
amt_sold int,
FOREIGN Key(t_id) REFERENCES timedim(t_id),
FOREIGN Key(i_id) REFERENCES itemdim(i_id),
FOREIGN Key(l_id) REFERENCES locationdim(l_id),
FOREIGN Key(b_id) REFERENCES branchdim(b_id));
INSERT INTO salesFact(t_id,
i_id,
l_id,
b_id,
qty_sold,
amt_sold)

SELECT t_id,i_id,l_id,b_id,qty_sold,amt_sold FROM company c
LEFT OUTER JOIN timedim t ON t.day = c.day AND t.month = c.month AND t.quarter = c.quarter AND t.years = c.years
LEFT OUTER JOIN itemdim i ON i.item_name = c.item_name AND i.brand = c.brand AND
i.sold_by = c.sold_by AND i.category = c.category
LEFT OUTER JOIN locationdim l ON l.location_name = c.location_name AND l.state =
c.state AND l.pin_code = c.pin_code
LEFT OUTER JOIN branchdim b ON b.branch_name = c.branch_name AND
b.branch_manager = c.branch_manager;
SELECT * FROM salesFact;

# Query to select the records where years = 2022
SELECT * FROM salesFact s LEFT OUTER JOIN timedim t ON t.t_id = s.t_id WHERE
years=2022;
