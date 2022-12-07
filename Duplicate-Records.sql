# CREATE TABLE

CREATE TABLE data_cleansing.tb_incidents_dup (
  `PdId` bigint DEFAULT NULL,
  `IncidntNum` text,
  `Incident Code` text,
  `Category` text,
  `Descript` text,
  `DayOfWeek` text,
  `Date` text,
  `Time` text,
  `PdDistrict` text,
  `Resolution` text,
  `Address` text,
  `X` double DEFAULT NULL,
  `Y` double DEFAULT NULL,
  `location` text,
  `SF Find Neighborhoods 2 2` text,
  `Current Police Districts 2 2` text,
  `Current Supervisor Districts 2 2` text,
  `Analysis Neighborhoods 2 2` text,
  `DELETE - Fire Prevention Districts 2 2` text,
  `DELETE - Police Districts 2 2` text,
  `DELETE - Supervisor Districts 2 2` text,
  `DELETE - Zip Codes 2 2` text,
  `DELETE - Neighborhoods 2 2` text,
  `DELETE - 2017 Fix It Zones 2 2` text,
  `Civic Center Harm Reduction Project Boundary 2 2` text,
  `Fix It Zones as of 2017-11-06  2 2` text,
  `DELETE - HSOC Zones 2 2` text,
  `Fix It Zones as of 2018-02-07 2 2` text,
  `CBD, BID and GBD Boundaries as of 2017 2 2` text,
  `Areas of Vulnerability, 2016 2 2` text,
  `Central Market/Tenderloin Boundary 2 2` text,
  `Central Market/Tenderloin Boundary Polygon - Updated 2 2` text,
  `HSOC Zones as of 2018-06-05 2 2` text,
  `OWED Public Spaces 2 2` text,
  `Neighborhoods 2` text
);

# Loading the dataset2.csv via MySQL Workbench

# Query the duplicate data with the same PdId an Category
SELECT PdId, Category, COUNT(*) count
FROM data_cleansing.tb_incidents_dup
GROUP BY PdId, Category
HAVING count > 1;

# Identifying duplicate records and returning each row in duplicate
SELECT * FROM data_cleansing.tb_incidents_dup
WHERE PdId in (SELECT PdId FROM data_cleansing.tb_incidents_dup GROUP BY PdId HAVING COUNT(*) > 1)
ORDER BY PdId;

# Identifying duplicate records and returning ONE row in duplicate with the window function
SELECT * 
FROM( 
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY PdId, Category ORDER BY PdId) row_number1
	FROM data_cleansing.tb_incidents_dup 
) d
WHERE d.row_number1 > 1
ORDER BY PdId;

# Identifying duplicate records with CTE
WITH cte_table
AS 
(
SELECT PdId, Category,
	ROW_NUMBER() OVER(PARTITION BY PdId, Category ORDER BY PdId) cont
FROM data_cleansing.tb_incidents_dup    
)
SELECT * FROM cte_table WHERE cont > 1;


