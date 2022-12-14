# The script deals with transforming data from a table, from rows to columns

# Create table
CREATE TABLE data_cleansing.tb_managers( id INT, colID INT, name CHAR(20) );

INSERT INTO data_cleansing.tb_managers VALUES
  (1, 1, 'Bob'),
  (1, 2, 'Silva'),
  (1, 3, 'Office Manager'),
  (2, 1, 'Mary'),
  (2, 2, 'Luz'),
  (2, 3, 'Vice Presidente');
  
SELECT * FROM data_cleansing.tb_managers;

# Create columns(first_name, last_name, occupation)
SELECT 
	id,
    GROUP_CONCAT(if(colID = 1, name, NULL)) 'first_name',
    GROUP_CONCAT(if(colID = 2, name, NULL)) 'last_name',
    GROUP_CONCAT(if(colID = 3, name, NULL)) 'occupation'
FROM data_cleansing.tb_managers
GROUP BY id;

# Create table
CREATE TABLE data_cleansing.tb_resource ( employee varchar(8), resource varchar(8), quantity int );

INSERT INTO data_cleansing.tb_resource VALUES
  ('Mary', 'email', 5),
  ('Bob', 'email', 7),
  ('Juca', 'print', 2),
  ('Mary', 'sms', 14),
  ('Bob', 'sms', 2);
  
SELECT * FROM data_cleansing.tb_resource;

# Creat columns emails, prints, sms
SELECT
	employee,
    SUM(IF(resource = 'email', quantity, 0)) emails,
    SUM(IF(resource = 'print', quantity, 0)) prints,
    SUM(IF(resource = 'sms', quantity, 0)) sms
FROM data_cleansing.tb_resource
GROUP BY employee;

SELECT
	employee,
    GROUP_CONCAT(IF(resource = 'email', quantity, NULL)) emails,
    GROUP_CONCAT(IF(resource = 'print', quantity, NULL)) prints,
    GROUP_CONCAT(IF(resource = 'sms', quantity, NULL)) sms
FROM data_cleansing.tb_resource
GROUP BY employee;

# Creat table
CREATE TABLE data_cleansing.tb_sales (empID INT, year SMALLINT, sale_value DECIMAL(10,2));

INSERT data_cleansing.tb_sales VALUES
(1, 2020, 12000),
(1, 2021, 18000),
(1, 2022, 25000),
(2, 2021, 15000),
(2, 2022, 6000),
(3, 2021, 20000),
(3, 2022, 24000);

SELECT * FROM data_cleansing.tb_sales;

SELECT 
	COALESCE(empID, 'Total') empID,
	SUM(IF(year = 2020, sale_value, 0)) '2020',
    SUM(IF(year = 2021, sale_value, 0)) '2021',
    SUM(IF(year = 2022, sale_value, 0)) '2022'
FROM data_cleansing.tb_sales
GROUP BY empID WITH ROLLUP;

# Create Table
CREATE TABLE data_cleansing.tb_orders (
  id_order INT NOT NULL,
  id_employee INT NOT NULL,
  id_supplier INT NOT NULL,
  PRIMARY KEY (id_order)
);

INSERT data_cleansing.tb_orders(id_order, id_employee, id_supplier) VALUES (1, 258, 1580);
INSERT data_cleansing.tb_orders(id_order, id_employee, id_supplier) VALUES (2, 254, 1496);
INSERT data_cleansing.tb_orders(id_order, id_employee, id_supplier) VALUES (3, 257, 1494);
INSERT data_cleansing.tb_orders(id_order, id_employee, id_supplier) VALUES (4, 261, 1650);
INSERT data_cleansing.tb_orders(id_order, id_employee, id_supplier) VALUES (5, 251, 1654);
INSERT data_cleansing.tb_orders(id_order, id_employee, id_supplier) VALUES (6, 253, 1664);
INSERT data_cleansing.tb_orders(id_order, id_employee, id_supplier) VALUES (7, 255, 1678);
INSERT data_cleansing.tb_orders(id_order, id_employee, id_supplier) VALUES (8, 256, 1616);
INSERT data_cleansing.tb_orders(id_order, id_employee, id_supplier) VALUES (9, 259, 1492);
INSERT data_cleansing.tb_orders(id_order, id_employee, id_supplier) VALUES (10, 250, 1602);
INSERT data_cleansing.tb_orders(id_order, id_employee, id_supplier) VALUES (11, 258, 1540);

SELECT * FROM data_cleansing.tb_orders;

# How many orders each employee has per supplier?
#Columns: id_supplier, emp250, emp251, emp252, emp253, emp254
SELECT 
	id_supplier,
    COUNT(IF(id_employee = 250, id_order, NULL)) emp250,
    COUNT(IF(id_employee = 251, id_order, NULL)) emp251,
    COUNT(IF(id_employee = 252, id_order, NULL)) emp252,
    COUNT(IF(id_employee = 253, id_order, NULL)) emp253,
    COUNT(IF(id_employee = 254, id_order, NULL)) emp254
FROM data_cleansing.tb_orders
WHERE id_employee BETWEEN 250 AND 254
GROUP BY id_supplier;
    


