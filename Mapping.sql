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