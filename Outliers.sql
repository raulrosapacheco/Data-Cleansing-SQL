# CREATE TABLE
CREATE TABLE data_cleansing.tb_children(name varchar(20), age int, weight float);

# INSERT DATA
INSERT INTO data_cleansing.tb_children
VALUES ('Bob', 3, 15), ('Maria', 42, 98), ('Julia', 3, 16), ('Maximiliano', 2, 12), 
('Roberto', 1, 11), ('Jamil', 2, 14), ('Alberto', 3, 17);

SELECT * FROM data_cleansing.tb_children;
# It's possible to notice the presence of an outlier

# AVERAGE AND STANDARD DEVIATION

SELECT AVG(age) avg_age, STDDEV(age) standard_deviation_age
FROM data_cleansing.tb_children;

SELECT AVG(age) avg_age, STDDEV(age) standard_deviation_age
FROM data_cleansing.tb_children
WHERE age < 5;

SELECT AVG(weight) avg_weight, STDDEV(weight) standard_deviation_weight
FROM data_cleansing.tb_children;

SELECT AVG(weight) avg_weight, STDDEV(weight) standard_deviation_weight
FROM data_cleansing.tb_children
WHERE age < 5;

# IMPUTATION: REPLACE THE OUTLIER WITH A VALID STATISTICAL VARIABLE.
#  Median: middle value when the data are sorted

SELECT * FROM data_cleansing.tb_children ORDER BY age;

# Calculation the median of the age variable
SET @rowindex := -1;

SELECT 
	AVG(age) median
FROM
	(SELECT @rowindex:=@rowindex+1 rowindex, age
	FROM data_cleansing.tb_children
    ORDER BY age) d
WHERE d.rowindex IN (FLOOR(@rowindex/2), CEIL(@rowindex/2));

SELECT * FROM data_cleansing.tb_children ORDER BY weight;

# Calculating the median of the weight variable
SET @rowindex := -1;

SELECT 
	AVG(weight) median
FROM
	(SELECT @rowindex:=@rowindex+1 rowindex, weight
	FROM data_cleansing.tb_children
    ORDER BY weight) d
WHERE d.rowindex IN (FLOOR(@rowindex/2), CEIL(@rowindex/2));

# Usually, when the standard deviation is greater than 3, 
# there are 1 or more outliers in the data source.

# Solving the outlier problem with median imputation
SET SQL_SAFE_UPDATES = 0;

UPDATE data_cleansing.tb_children
SET age = 3
WHERE age = 42;

UPDATE data_cleansing.tb_children
SET weight = 15
WHERE weight = 98;

SET SQL_SAFE_UPDATES = 1;

SELECT AVG(age) avg_age, STDDEV(age) standard_deviation_age
FROM data_cleansing.tb_children;

SELECT AVG(weight) avg_weight, STDDEV(weight) standard_deviation_weight
FROM data_cleansing.tb_children;