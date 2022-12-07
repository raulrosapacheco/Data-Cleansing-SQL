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

# Deleting duplicate records with CTE
SET SQL_SAFE_UPDATES = 0;

WITH cte_table
AS
(
SELECT PdId, Category,
	ROW_NUMBER() OVER(PARTITION BY PdId ORDER BY PdId) num
FROM data_cleansing.tb_incidents_dup
)
DELETE FROM data_cleansing.tb_incidents_dup
USING data_cleansing.tb_incidents_dup
JOIN cte_table ON cte_table.PdId = data_cleansing.tb_incidents_dup.PdId
WHERE cte_table.num > 1;

SET SQL_SAFE_UPDATES = 1;

# Confirming that there are no more duplicate records
SELECT PdId, Count(*) num
FROM data_cleansing.tb_incidents_dup
GROUP BY PdId
HAVING num > 1;

# Truncate the table tb_incidents_dup

# Deleting duplicate records with subquery
SET SQL_SAFE_UPDATES = 0;

DELETE FROM data_cleansing.tb_incidents_dup
WHERE PdId IN 
		(
		SELECT PdId 
		FROM(
			SELECT PdId, ROW_NUMBER() OVER(PARTITION BY PdId ORDER BY PdId) num
			FROM data_cleansing.tb_incidents_dup) q1
		WHERE q1.num > 1
        );

SET SQL_SAFE_UPDATES = 1;
            
# Confirming that there are no more duplicate records
SELECT PdId, Count(*) num
FROM data_cleansing.tb_incidents_dup
GROUP BY PdId
HAVING num > 1;        

# The duplicate records that we worked above have all the identical attributes
# So we can delete any of the duplicate records
# Now let's work with non-identical lines

# Create Table
CREATE TABLE data_cleansing.tb_students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL, 
    email VARCHAR(255) NOT NULL
);

# Insert data
INSERT INTO data_cleansing.tb_students (first_name, last_name, email) 
VALUES ('Carine ','Schmitt','carine.schmitt@verizon.net'),
       ('Jean','King','jean.king@me.com'),
       ('Peter','Ferguson','peter.ferguson@google.com'),
       ('Janine ','Labrune','janine.labrune@aol.com'),
       ('Jonas ','Bergulfsen','jonas.bergulfsen@mac.com'),
       ('Janine ','Labrune','janine.labrune@aol.com'),
       ('Susan','Nelson','susan.nelson@comcast.net'),
       ('Zbyszek ','Piestrzeniewicz','zbyszek.piestrzeniewicz@att.net'),
       ('Roland','Keitel','roland.keitel@yahoo.com'),
       ('Julie','Murphy','julie.murphy@yahoo.com'),
       ('Kwai','Lee','kwai.lee@google.com'),
       ('Jean','King','jean.king@me.com'),
       ('Susan','Nelson','susan.nelson@comcast.net'),
       ('Roland','Keitel','roland.keitel@yahoo.com');

SELECT * FROM data_cleansing.tb_students ORDER BY email;

# id <>, email =
SELECT email, COUNT(*) count
FROM data_cleansing.tb_students
GROUP BY email
HAVING count > 1;

# Deleting duplicates records non-identical
SET SQL_SAFE_UPDATES = 0;

USE data_cleansing;
DELETE n1
FROM tb_students n1, tb_students n2
WHERE n1.id > n2.id
AND n1.email = n2.email;

SET SQL_SAFE_UPDATES = 1;
