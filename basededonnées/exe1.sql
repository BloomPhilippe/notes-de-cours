CREATE DATABASE IF NOT EXISTS exe_1 CHARACTER SET utf8;
USE  exe_1;

CREATE TABLE IF NOT EXISTS people (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_id` int(11),
  `lastname` varchar(255) NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `birthday` date NOT NULL,
  PRIMARY KEY(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `personne`  ADD `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ;

CREATE TABLE IF NOT EXISTS job (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `company` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
   PRIMARY KEY(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `job`  ADD `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ;

INSERT INTO `exe_1`.`people` (`id`, `job_id`, `lastname`, `firstname`, `birthday`) VALUES (NULL, NULL, 'Bloom', 'Philippe', '1985-10-18');
INSERT INTO `exe_1`.`people` (`id`, `job_id`, `lastname`, `firstname`, `birthday`) VALUES (NULL, NULL, 'Bloom', 'Didier', '1985-10-18');

ALTER TABLE people
ADD FOREIGN KEY (job_id) REFERENCES job(id);

CREATE USER 'admin_all'@'localhost' 
IDENTIFIED BY 'password';

GRANT ALL ON `exe_1`.* TO 'admin_all'@'localhost';

CREATE USER 'admin_create_table'@'localhost'
IDENTIFIED BY 'password';

GRANT CREATE ON `exe_1`.* TO 'admin_create_table'@'localhost';