# Create table Customers Locals
CREATE TABLE data_cleansing.tb_customer_loc (
  name_customer text,
  billing double DEFAULT NULL,
  number_employees int DEFAULT NULL
);

# Load the dataset5.csv in previous table by MySQL Workbench

# Create table Customers Internationals
CREATE TABLE data_cleansing.tb_customer_int (
  name_customer text,
  billing double DEFAULT NULL,
  number_employees int DEFAULT NULL,
  local_head text
);

# Load the dataset6.csv in previous table by MySQL Workbench

SELECT * FROM data_cleansing.tb_customer_loc;
SELECT * FROM data_cleansing.tb_customer_int;

# Return all customers and their locations. Local customers are in the US.
SELECT L.name_customer
FROM data_cleansing.tb_customer_loc L
UNION
SELECT I.name_customer, I.local_head
FROM data_cleansing.tb_customer_int I;
# Error Code: 1222. The used SELECT statements have a different number of columns

SELECT L.name_customer, 'USA' AS local_head
FROM data_cleansing.tb_customer_loc L
UNION
SELECT I.name_customer, I.local_head
FROM data_cleansing.tb_customer_int I;

# Does customer 'Ganjaflex' appear in both customer tables?
SELECT L.name_customer, 'USA' AS local_head
FROM data_cleansing.tb_customer_loc L
WHERE L.name_customer = 'Ganjaflex'
UNION
SELECT I.name_customer, I.local_head
FROM data_cleansing.tb_customer_int I
WHERE I.name_customer = 'Ganjaflex';

# Which international customers appear in the local customers table?
SELECT name_customer FROM data_cleansing.tb_customer_int
WHERE name_customer IN ( SELECT name_customer FROM data_cleansing.tb_customer_loc);

SELECT name_customer FROM data_cleansing.tb_customer_int
WHERE TRIM(name_customer) IN ( SELECT TRIM(name_customer) FROM data_cleansing.tb_customer_loc);

# What is the average revenue per location?
# Local customers are in the USA and the result should be sorted by average revenue
SELECT I.local_head, AVG(I.billing) avg_revenue
FROM data_cleansing.tb_customer_int I
GROUP BY I.local_head
UNION
SELECT "USA" AS local_head, AVG(L.billing) avg_revenue
FROM data_cleansing.tb_customer_loc L
GROUP BY local_head
ORDER BY avg_revenue;

# Use the tables tb_pipeline_sales and tb_sellers
# Return total sales value for all sales agents and subtotals by regional office
# Return the result of successfully completed sales only
SELECT
	COALESCE(S.Regional_Office, "TOTAL") "Regional Office",
	COALESCE(P.Sales_Agent, "TOTAL") "Sales Agent",
    SUM(P.Close_Value) total_value
FROM data_cleansing.tb_pipeline_sales P, data_cleansing.tb_sellers S
WHERE P.Sales_Agent = S.Sales_Agent
AND P.Deal_Stage = "Won"
GROUP BY S.Regional_Office, P.Sales_Agent WITH ROLLUP;

# Use the tables tb_pipeline_sales and tb_sellers
# Return manager, regional office, customer, number of sales and subtotals of number of sales
# Do this only for successfully completed sales
SELECT 
	COALESCE(S.Manager, "TOTAL") Manager,
    COALESCE(S.Regional_Office, "TOTAL") Regional_Office,
    COALESCE(P.Account, "TOTAL") Account,
    COUNT(P.Close_Value) num_sales
FROM data_cleansing.tb_pipeline_sales P, data_cleansing.tb_sellers S
WHERE P.Sales_Agent = S.Sales_Agent
AND P.Deal_Stage = "Won"
GROUP BY S.Manager, S.Regional_Office, P.Account WITH ROLLUP;

# Solve the above problem using CTE
WITH temp_table AS
(
SELECT 
	S.Manager, 
    S.Regional_Office,
    P.Account,
	P.Deal_Stage
FROM data_cleansing.tb_pipeline_sales P, data_cleansing.tb_sellers S
WHERE P.Sales_Agent = S.Sales_Agent
)
SELECT 
	COALESCE(Manager, "TOTAL") Manager,
    COALESCE(Regional_Office, "TOTAL") Regional_Office,
    COALESCE(Account, "TOTAL") Account,
    COUNT(*) num_sales
FROM temp_table
WHERE Deal_Stage = "Won"
GROUP BY Manager, Regional_Office, Account WITH ROLLUP;

CREATE TABLE data_cleansing.tb_orders_products (
  sales_agent text,
  account text,
  product text,
  order_value int DEFAULT NULL,
  create_date text
);

# Load the dataset7.csv in previous table by MySQL Workbench

SELECT * FROM data_cleansing.tb_orders_products ORDER BY account;

# Function WINDOW

SELECT account, 
       CAST(create_date AS DATE) AS date_order,
       AVG(order_value) OVER() AS avg_value_order
FROM data_cleansing.tb_orders_products
WHERE account = 'Acme Corporation'
ORDER BY date_order;

SELECT account, 
       CAST(create_date AS DATE) AS date_order,
       order_value,
       AVG(order_value) OVER(PARTITION BY account ORDER BY CAST(create_date AS DATE)) AS avg_value_order
FROM data_cleansing.tb_orders_products
WHERE account = 'Acme Corporation'
ORDER BY date_order;

# Function FIRST_VALUE
SELECT account, 
       CAST(create_date AS DATE) AS date_order,
       order_value,
       FIRST_VALUE(order_value) OVER(PARTITION BY account ORDER BY CAST(create_date AS DATE)) AS firt_value_order
FROM data_cleansing.tb_orders_products
WHERE account = 'Acme Corporation'
ORDER BY date_order;

# LEAD: Moving data backwards over time, 1 position and when empty padded with -1
SELECT account, 
       CAST(create_date AS DATE) AS date_order,
       order_value,
       LEAD(order_value, 1, -1) OVER(PARTITION BY account ORDER BY CAST(create_date AS DATE)) AS lead_value_order
FROM data_cleansing.tb_orders_products
WHERE account = 'Acme Corporation'
ORDER BY date_order;

# LAG: Moving data forward over time, 1 position and when empty padded with -1
SELECT account, 
       CAST(create_date AS DATE) AS date_order,
       order_value,
       LAG(order_value, 1, -1) OVER(PARTITION BY account ORDER BY CAST(create_date AS DATE)) AS lag_value_order
FROM data_cleansing.tb_orders_products
WHERE account = 'Acme Corporation'
ORDER BY date_order;

# Calculate the difference between the order value of the day and the previous day.
SELECT account, 
       CAST(create_date AS DATE) AS date_order,
       order_value,
       LAG(order_value, 1, 0) OVER(PARTITION BY account ORDER BY CAST(create_date AS DATE)) AS lag_value_order,
       order_value - LAG(order_value, 1, 0) OVER(PARTITION BY account ORDER BY CAST(create_date AS DATE)) AS lag_value_order
FROM data_cleansing.tb_orders_products
WHERE account = 'Acme Corporation';

WITH temp_table AS
(
SELECT account, 
       CAST(create_date AS DATE) AS date_order,
       order_value,
       LAG(order_value, 1, 0) OVER(PARTITION BY account ORDER BY CAST(create_date AS DATE)) AS lag_value_order
FROM data_cleansing.tb_orders_products
WHERE account = 'Acme Corporation'
ORDER BY date_order
)
SELECT account,
       date_order,
       order_value,
       lag_value_order,
       (order_value - lag_value_order) AS diff
FROM temp_table;
