# Filtering, summarizing and aggregation

# Create table pipeline sales
CREATE TABLE data_cleansing.tb_pipeline_sales (
  `Account` text,
  `Opportunity_ID` text,
  `Sales_Agent` text,
  `Deal_Stage` text,
  `Product` text,
  `Created_Date` text,
  `Close_Date` text,
  `Close_Value` text DEFAULT NULL
);

#  Load the dataset3.csv in the previous table by MySQL Workbench

# Create table 
CREATE TABLE data_cleansing.tb_sellers (
  `Sales_Agent` text,
  `Manager` text,
  `Regional_Office` text,
  `Status` text
);

# Load the dataset4.csv in the previous table by MySQL Workbench

# Answer the items below with SQL Language

# 1- Total sales
SELECT COUNT(*) total_sales 
FROM data_cleansing.tb_pipeline_sales;

# 2- Total amount sold
SELECT SUM(CAST(Close_Value AS UNSIGNED)) total_amount 
FROM data_cleansing.tb_pipeline_sales;

# 3- Number of sales completed successfully
SELECT COUNT(*) total_sales 
FROM data_cleansing.tb_pipeline_sales 
WHERE Deal_Stage = 'Won';

# 4- Average value of sales completed successfully
SELECT AVG(CAST(Close_Value AS UNSIGNED)) avg_amount 
FROM data_cleansing.tb_pipeline_sales
WHERE Deal_Stage = 'Won';

# 5- Maximum amounts sold
SELECT MAX(CAST(Close_Value AS UNSIGNED)) max_amount 
FROM data_cleansing.tb_pipeline_sales;

# 6- Minimum amount sold among successfully completed sales
SELECT MIN(CAST(Close_Value AS UNSIGNED)) min_amount 
FROM data_cleansing.tb_pipeline_sales
WHERE Deal_Stage = 'Won';

# 7- Average value of successfully completed sales per sales agent
SELECT Sales_Agent, AVG(CAST(Close_Value AS UNSIGNED)) avg_amount 
FROM data_cleansing.tb_pipeline_sales
WHERE Deal_Stage = 'Won'
GROUP BY Sales_Agent
ORDER BY avg_amount DESC;

#8- Average value of successfully completed sales per sales agent manager
SELECT S.Manager, AVG(CAST(P.Close_Value AS UNSIGNED)) avg_amount 
FROM data_cleansing.tb_pipeline_sales P, data_cleansing.tb_sellers S
WHERE S.Sales_Agent = P.Sales_Agent
AND Deal_Stage = 'Won'
GROUP BY S.Manager;

# 9- Total closing value of the sale per sales agent and on account of successfully completed sales
SELECT Sales_Agent, Account, SUM(CAST(Close_Value AS UNSIGNED)) sum_amount 
FROM data_cleansing.tb_pipeline_sales
WHERE Deal_Stage = 'Won'
GROUP BY Sales_Agent, Account
ORDER BY Sales_Agent, Account;

# 10- Number of sales per sales agent for successfully completed sales and sales value greater than 1000

# There is a filter function called FILTER(), but it is not available in MySQL
# https://modern-sql.com/feature/filter

# Doesn't work in MySQL
SELECT sales_agent,
       COUNT(tbl.close_value) AS total,
       COUNT(tbl.close_value)
FILTER(WHERE tbl.close_value > 1000) AS `Acima de 1000`
FROM cap08.TB_PIPELINE_VENDAS AS tbl
WHERE tbl.deal_stage = "Won"
GROUP BY tbl.sales_agent;

# Solution in MySQL
SELECT Sales_Agent, COUNT(CAST(Close_Value AS UNSIGNED)) num_sales 
FROM data_cleansing.tb_pipeline_sales
WHERE Deal_Stage = 'Won'
AND Close_Value > 1000
GROUP BY Sales_Agent;

# 11- Number of sales and average sales value per sales agent
SELECT Sales_Agent, 
	COUNT(CAST(Close_Value AS UNSIGNED)) num_sales, 
    AVG(CAST(Close_Value AS UNSIGNED)) avg_value  
FROM data_cleansing.tb_pipeline_sales
GROUP BY Sales_Agent
ORDER BY num_sales DESC;

#12- Which sales agents had more than 30 sales?
SELECT Sales_Agent, COUNT(CAST(Close_Value AS UNSIGNED)) num_sales, AVG(CAST(Close_Value AS UNSIGNED)) avg_value  
FROM data_cleansing.tb_pipeline_sales
GROUP BY Sales_Agent
HAVING num_sales > 30;