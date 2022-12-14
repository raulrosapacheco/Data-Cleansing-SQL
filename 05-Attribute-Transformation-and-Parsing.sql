# Adding a column(commission) of type decimal with attributes with 
# 10 positions and 2 decimal places, after the column sale_value
ALTER TABLE `data_cleansing`.`tb_sales`
ADD COLUMN `commission`DECIMAL(10,2) NULL AFTER `sale_value`;

SELECT * FROM data_cleansing.tb_sales;

SET SQL_SAFE_UPDATES = 0;

UPDATE data_cleansing.tb_sales
SET commission = 5
WHERE empID = 1;

UPDATE data_cleansing.tb_sales
SET commission = 6
WHERE empID = 2;

UPDATE data_cleansing.tb_sales
SET commission = 8
WHERE empID = 3;

SET SQL_SAFE_UPDATES = 1;

# Calcule the amount of commision to be paid to each employee
SELECT empID, ROUND(sale_value*commission/100, 0) commission_value
FROM data_cleansing.tb_sales;

# How much will be paid for the employee of empID 1 if the commission equals 15%?
# The function GREATEST() return the greater value
SELECT empID, ROUND(sale_value*GREATEST(15, commission)/100, 0) commission_value
FROM data_cleansing.tb_sales
WHERE empID = 1;

# How much will be paid for the employee of empID 1 if the commission equals 2%?
# The function LEAST() return the least value
SELECT empID, ROUND(sale_value*LEAST(2, commission)/100, 0) commission_value
FROM data_cleansing.tb_sales
WHERE empID = 1;

SELECT * FROM data_cleansing.tb_sales;

# Transformation of information from numerical type to categorical type
# Category 1 = 3 to 5 commission
# Category 2 = 5.1 to 7.9 commission
# Category 3 >= 8
SELECT 
	empID,
    year,
    sale_value,
    CASE 
		WHEN commission BETWEEN 3 AND 5 THEN 'Category 1'
		WHEN commission BETWEEN 5.1 AND 7.9 THEN 'Category 2'
        WHEN commission >= 8 THEN 'Category 3'
	END AS commission
FROM data_cleansing.tb_sales;

# Create Table
CREATE TABLE data_cleansing.tb_stock (day INT, num_sales INT, stock_value DECIMAL(10,2));

INSERT INTO data_cleansing.tb_stock VALUES
(1, 32, 0.3),
(1, 4, 70),
(1, 44, 200),
(1, 9, 0.01),
(1, 8, 0.03),
(1, 41, 0.03),
(2, 52, 0.4),
(2, 10, 70),
(2, 53, 200),
(2, 5, 0.01),
(2, 25, 0.55),
(2, 7, 50);

SELECT * FROM data_cleansing.tb_stock;

# Let's separate the data into 3 categories.
# We want records per day.
# If the stock_value is between 0 and 10, we want the highest num_sales in this range and we will call it Group 1
# If the stock_value is between 10 and 100 we want the highest num_sales of this range and we will call it Group 2
# If the stock_value is greater than 100, we want the largest sales_num of this range and call it Group 3
SELECT 
	day,
	MAX(CASE WHEN stock_value BETWEEN 0 AND 9 THEN num_sales ELSE 0 END) AS 'Group 1',
    MAX(CASE WHEN stock_value BETWEEN 10 AND 100 THEN num_sales ELSE 0 END) AS 'Group 2',
	MAX(CASE WHEN stock_value > 100 THEN num_sales ELSE 0 END) AS 'Group 3'
FROM data_cleansing.tb_stock
GROUP BY day;

# Parsing 
SELECT * FROM data_cleansing.tb_sales;

ALTER TABLE `data_cleansing`.`tb_sales`
ADD COLUMN `data_sale` DATETIME NULL AFTER `commission`;

SELECT * FROM data_cleansing.tb_sales;

SET SQL_SAFE_UPDATES = 0;

UPDATE data_cleansing.tb_sales
SET data_sale = '2022-03-15'
WHERE empID = 1;

UPDATE data_cleansing.tb_sales
SET data_sale = '2022-03-16'
WHERE empID = 2;

UPDATE data_cleansing.tb_sales
SET data_sale = '2022-03-17'
WHERE empID = 3;

SET SQL_SAFE_UPDATES = 1;        
        
SELECT * FROM data_cleansing.tb_sales;

# https://www.w3resource.com/mysql/date-and-time-functions/mysql-date_format-function.php

SELECT empID, sale_value, commission, data_sale, DATE_FORMAT(data_sale, '%d-%b-%y') AS data_sale_p
FROM data_cleansing.tb_sales;

SELECT empID, sale_value, commission, data_sale, DATE_FORMAT(data_sale, '%d-%b-%Y') AS data_sale_p
FROM data_cleansing.tb_sales;

SELECT empID, sale_value, commission, data_sale, DATE_FORMAT(data_sale, '%a-%b-%Y') AS data_sale_p
FROM data_cleansing.tb_sales;

SELECT empID, sale_value, commission, data_sale, DATE_FORMAT(data_sale, '%a-%b-%Y-%f') AS data_sale_p
FROM data_cleansing.tb_sales;

SELECT empID, sale_value, commission, data_sale, DATE_FORMAT(data_sale, '%a-%b-%Y-%j') AS data_sale_p
FROM data_cleansing.tb_sales;

SELECT empID, sale_value, commission, data_sale, DATE_FORMAT(data_sale, '%a-%b-%Y-%u') AS data_sale_p
FROM data_cleansing.tb_sales;

SELECT empID, sale_value, commission, data_sale, DATE_FORMAT(data_sale, '%d/%c/%Y') AS data_sale_p
FROM data_cleansing.tb_sales;







