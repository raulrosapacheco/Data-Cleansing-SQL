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

SELECT
	employee,
    SUM(IF(resource = 'email', quantity, 0)) emails,
    SUM(IF(resource = 'print', quantity, 0)) prints,
    SUM(IF(resource = 'sms', quantity, 0)) sms
FROM data_cleansing.tb_resource
GROUP BY employee;

SELECT
	employee,
    GROUP_CONCAT(IF(resource = 'email', quantity, 0)) emails,
    GROUP_CONCAT(IF(resource = 'print', quantity, 0)) prints,
    GROUP_CONCAT(IF(resource = 'sms', quantity, 0)) sms
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

