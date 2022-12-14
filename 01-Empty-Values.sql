# Create Schema data-cleansing

# Create Table
CREATE TABLE data_cleansing.tb_incidents (
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

# Loading dataset1.csv via MySQL Workbench
# Truncate: Clear table before loading

# Treatment of missing values

SELECT DISTINCT Resolution
FROM data_cleansing.tb_incidents;
# The Resolution column represents the completion of the incident.
# We can see that it has several empty records.

SELECT Resolution, Count(*) total
FROM data_cleansing.tb_incidents
GROUP BY Resolution;
# Most records are empty

SELECT COUNT(*)
FROM data_cleansing.tb_incidents 
WHERE Resolution IS NULL;
# Technically for the DBMS, null and empty values are treated differently
# The main difference between null and empty values is that null is used to refer to nothing 
# whereas empty refers to a single string with zero length.

SELECT COUNT(*)
FROM data_cleansing.tb_incidents
WHERE Resolution = '';

SELECT COUNT(*)
FROM data_cleansing.tb_incidents
WHERE NULLIF(Resolution,'') IS NULL;
# NULLIF: If Resolution is empty, change it to null

SELECT COUNT(*)
FROM data_cleansing.tb_incidents
WHERE TRIM(COALESCE(Resolution, ''))= '';
# COALESCE: If Resolution is null, change it empty
# TRIM: Remove blankspace from beginning an end

SELECT COUNT(*)
FROM data_cleansing.tb_incidents
WHERE LENGTH(RTRIM(LTRIM(Resolution))) = 0;

SELECT ISNULL(NULLIF(Resolution, ''))
FROM data_cleansing.tb_incidents;
# Encoding/Binarization
# ISNULL: where it is null it will be 1, where it is not null it will be 0;

# Replace empty record with OTHER
SELECT 
	CASE
		WHEN Resolution = '' THEN 'OTHER'
        ELSE Resolution
	END AS Resolution
FROM data_cleansing.tb_incidents;

# The examples above do not solve the problem at source, only at runtime.
# Whenever possible change the data in the source

SET SQL_SAFE_UPDATES = 0;

UPDATE data_cleansing.tb_incidents
SET Resolution = 'OTHER'
WHERE Resolution = '';

SET SQL_SAFE_UPDATES = 1;




