# Enrichment and Imputation

SELECT * FROM data_cleansing.tb_incidents;

# In the table data_cleansing.tb_incidents, column IncidentNum, consider the first 4 digits as the local code of the incident
# and the last 4 digits as the national incident code

# Function SUBSTR(x, position_inicial, num_places) and SUBSTRING()

SELECT IncidntNum,
       SUBSTR(IncidntNum, 1, 4) AS local_code,
       SUBSTR(IncidntNum, -4, 4) AS nacional_code
FROM data_cleansing.tb_incidents;

SELECT IncidntNum,
       SUBSTRING(IncidntNum, 1, 4) AS local_code,
       SUBSTRING(IncidntNum, -4, 4) AS nacional_code
FROM data_cleansing.tb_incidents;

# In table data_cleansing.tb_incidents, Address column, return everything up to the first space (possibly the address number)
SELECT Address,
       SUBSTR(Address, 1, POSITION(" " IN Address)) AS desc_final
FROM data_cleansing.tb_incidents;

# Imputation with Replace
SELECT * FROM data_cleansing.tb_map_animal_zoo;

# Replace 1001 to 1007
SELECT REPLACE(id_zoo, 1001, 1007) FROM data_cleansing.tb_map_animal_zoo;

