# Create a database named "snowcompany"
CREATE DATABASE snowcompany;

# Create a source table for data warehouse.
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
department_name varchar(255),
department_code int,
supplier_name varchar(255),
supplier_address varchar(255),
supplier_type varchar(255),
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
department_name,
department_code,
supplier_name,
supplier_address,
supplier_type,
qty_sold,
amt_sold)
VALUES("Car","Model X","Tesla","Four wheeler",13,"June","Q2",2021,"New
Baneshwor","Bagmati","123","Baneshwor 1","Ashish","sales",013,"C&C
Auto","Koteshwor","Auto Four Wheeler",2,15000),

("Car","Model Y","Tesla","Four wheeler",15,"October","Q4",2022,"Old
Baneshwor","Bagmati","123","Baneshwor 3","Manoj","finance",420,"T&T
Auto","Tripureshwor","Auto",1,5000);

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
# Create department dimension table for data warehouse.
CREATE TABLE departmentdim(dept_id int AUTO_INCREMENT PRIMARY KEY,
dept_name varchar(255),
dept_code int);
INSERT INTO departmentdim(dept_name,dept_code)
SELECT department_name,department_code FROM company;
SELECT * FROM departmentdim;
# Create branch dimension table for data warehouse.
CREATE TABLE branchdim (b_id int AUTO_INCREMENT PRIMARY KEY,
branch_name varchar(255),
branch_manager varchar(255),
depart_id int,
FOREIGN KEY(depart_id) REFERENCES departmentdim(dept_id)
);
INSERT INTO branchdim(
branch_name,
branch_manager,
depart_id
)
SELECT branch_name,branch_manager,dept_id FROM company c
JOIN departmentdim d ON c.department_name = d.dept_name AND c.department_code = d.dept_code;
SELECT * FROM branchdim;
# Create Supplier dimension table for data warehouse.
CREATE TABLE supplierdim(supp_id int AUTO_INCREMENT PRIMARY KEY,
supp_name varchar(255),
supp_address varchar(255),
supp_type varchar(255));
INSERT INTO supplierdim(supp_name,supp_address,supp_type)
SELECT supplier_name,supplier_address,supplier_type FROM company;
SELECT * FROM supplierdim;
# Create item dimension table for data warehouse.
CREATE TABLE itemdim (i_id int AUTO_INCREMENT PRIMARY KEY,
item_name varchar(255),
brand varchar(255),
sold_by varchar(255),
category varchar(255),
supplier_id int,
FOREIGN KEY(supplier_id) REFERENCES supplierdim(supp_id)
);
INSERT INTO itemdim(
item_name,
brand,
sold_by,
category,
supplier_id
)
SELECT item_name,brand,sold_by,category,supp_id FROM company c
LEFT OUTER JOIN supplierdim s ON c.supplier_name = s.supp_name AND
c.supplier_address = s.supp_address AND
c.supplier_type = s.supp_type;
SELECT * FROM itemdim;

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
LEFT OUTER JOIN timedim t ON t.day = c.day AND t.month = c.month AND t.quarter
= c.quarter AND t.years = c.years
LEFT OUTER JOIN itemdim i ON i.item_name = c.item_name AND i.brand = c.brand AND
i.sold_by = c.sold_by AND i.category = c.category
LEFT OUTER JOIN locationdim l ON l.location_name = c.location_name AND l.state =
c.state AND l.pin_code = c.pin_code
LEFT OUTER JOIN branchdim b ON b.branch_name = c.branch_name AND
b.branch_manager = c.branch_manager;
SELECT * FROM salesFact;
# Query to show the records of sales fact table with the department dimension table
SELECT * FROM salesFact s LEFT OUTER JOIN branchdim b ON b.b_id = s.b_id
LEFT OUTER JOIN departmentdim d ON b.depart_id = d.dept_id;
