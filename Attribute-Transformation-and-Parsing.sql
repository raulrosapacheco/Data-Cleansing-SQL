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



