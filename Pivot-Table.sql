# The script deals with transforming data from a table, from rows to columns

# Create table
CREATE TABLE data_cleansing.tb_managers( id INT, colID INT, name CHAR(20) );

INSERT INTO data_cleansing.tb_managers VALUES
  (1, 1, 'Bob'),
  (1, 2, 'Silva'),
  (1, 3, 'Office Manager'),
  (2, 1, 'Mary'),
  (2, 2, 'Luz'),
  (2, 3, 'Vice Presidente');
  
SELECT * FROM data_cleansing.tb_managers;

# Create columns(first_name, last_name, occupation)
SELECT 
	id,
    GROUP_CONCAT(if(colID = 1, name, NULL)) 'first_name',
    GROUP_CONCAT(if(colID = 2, name, NULL)) 'last_name',
    GROUP_CONCAT(if(colID = 3, name, NULL)) 'occupation'
FROM data_cleansing.tb_managers
GROUP BY id;


