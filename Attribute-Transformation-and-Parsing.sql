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
    




