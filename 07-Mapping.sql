# Mapping    
CREATE TABLE data_cleansing.tb_animal(
id INT NOT NULL,
name VARCHAR(45) NULL,
PRIMARY KEY(`id`));

INSERT INTO data_cleansing.tb_animal (id, name)
VALUES (1, 'Zebra'), (2, 'Elefante'), (3, 'Girafa'), (4, 'Tigre');

CREATE TABLE data_cleansing.tb_zoo (
  id INT NOT NULL,
  name VARCHAR(45) NULL,
  PRIMARY KEY (`id`));

INSERT INTO data_cleansing.tb_zoo (id, name)
VALUES (1000, 'Zoo do Rio de Janeiro'), (1001, 'Zoo de Recife'), (1002, 'Zoo de Palmas');

CREATE TABLE data_cleansing.tb_map_animal_zoo (
  id_animal INT NOT NULL,
  id_zoo INT NOT NULL,
  PRIMARY KEY (`id_animal`, `id_zoo`));

INSERT INTO data_cleansing.tb_map_animal_zoo (id_animal, id_zoo)
VALUES (1, 1001), (1, 1002), (2, 1001), (3, 1000), (4, 1001);

SELECT * FROM data_cleansing.tb_animal;
SELECT * FROM data_cleansing.tb_zoo;
SELECT * FROM data_cleansing.tb_map_animal_zoo;

SELECT A.name Animal, Z.name Zoo
FROM data_cleansing.tb_animal A, data_cleansing.tb_zoo Z, data_cleansing.tb_map_animal_zoo M
WHERE A.id = M.id_animal AND Z.id = M.id_zoo
ORDER BY animal;

SELECT A.name animal, Z.name zoo 
FROM data_cleansing.tb_animal A, data_cleansing.tb_map_animal_zoo AS AtoZ, data_cleansing.tb_zoo Z
WHERE AtoZ.id_animal = A.id AND Z.id = AtoZ.id_zoo 
UNION
SELECT B.name animal, Z.name zoo 
FROM data_cleansing.tb_animal B, data_cleansing.tb_map_animal_zoo AS BtoZ, data_cleansing.tb_zoo Z
WHERE BtoZ.id_animal = B.id AND Z.id = BtoZ.id_zoo
ORDER BY animal;

INSERT INTO data_cleansing.tb_animal (id, name)
VALUES (5, 'Macaco');

SELECT A.name AS animal, COALESCE(C.name, 'Sem Zoo') AS zoo
FROM data_cleansing.tb_animal AS A 
LEFT OUTER JOIN (data_cleansing.tb_map_animal_zoo AS B INNER JOIN data_cleansing.tb_zoo AS C ON C.id = B.id_zoo)
ON B.id_animal = A.id
ORDER BY animal;
