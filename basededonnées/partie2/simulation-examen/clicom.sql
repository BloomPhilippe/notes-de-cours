CREATE DATABASE IF NOT EXISTS clicom CHARACTER SET utf8;
USE  clicom;

--
-- Table client
--
CREATE TABLE IF NOT EXISTS client (
  idclient MEDIUMINT(8) UNSIGNED NOT NULL AUTO_INCREMENT,
  nom VARCHAR(30) NOT NULL,
  prenom VARCHAR(30) NOT NULL,
  adresse VARCHAR(50) NOT NULL,
  localite VARCHAR(30) NOT NULL,
  code_postal SMALLINT(4) UNSIGNED NOT NULL,
  cat CHAR(2),
  compte DECIMAL(9,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (idclient)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Données table client
--
INSERT INTO client VALUES 
(1,'GOFFIN','Patrick','72, rue de la gare','Namur',5000,'B2',-3200.00),
(2,'HANSENNE','Jean','23, rue dumont','Liège',4000,'C1',1250.00),
(3,'MONTI','Bruno','112, rue neuve','Bruxelles',1000,'B2',0.00),
(4,'GILLET','Guillaume','14, rue de l\'été','Mons',7000,'B1',-8700.00),
(5,'AVRON','Paul','8, rue de la cure','Mons',7000,'B1',-1700.00),
(6,'MERCIER','Jacques','25, rue Lemaitre','Namur',5000,'C1',-2300.00),
(7,'FERARD','Nadia','65, rue du tertre','Verviers',4800,'B2',350.00),
(8,'MERCIERS','Sylvain','201, boulevard du nord','Mons',7000,NULL,-2250.00),
(9,'TOUSSAINT','Vanessa','5, rue Godefroid','Verviers',4800,'C1',0.00),
(10,'PONCELET','Fabrice','17, clos des Erables','Mons',7000,'B2',0.00),
(11,'JACOB','Gunter','78, chaussée du Moulin','Bruxelles',1000,'C2',0.00),
(12,'VANBIST','Wim','180, rue Florimont','Liège',4000,'B1',720.00),
(13,'NEUMAN','Franz','40, rue Bransart','Mons',7000,NULL,0.00),
(14,'FRANCK','Anne','60, rue de Wépion','Namur',5000,'C1',0.00),
(15,'VANDERKA','Pierre','3, avenue des Roses','Namur',5000,'C1',-4580.00),
(16,'GUILLAUME','Guy','14a, chaussée des Roses','Verviers',4800,'B1',0.00);

--
-- Table commande
--
CREATE TABLE IF NOT EXISTS commande (
  idcommande MEDIUMINT(8) UNSIGNED NOT NULL AUTO_INCREMENT,
  idclient MEDIUMINT(8) UNSIGNED NOT NULL,
  datecom date NOT NULL,
  PRIMARY KEY (idcommande),
  CONSTRAINT idx_fk_commande_client FOREIGN KEY (idclient) REFERENCES client (idclient)
) ENGINE=InnoDB CHARACTER SET=utf8;

--
-- Données table commande
--
INSERT INTO commande VALUES 
(30178,13,'2008-12-22'),
(30179,8,'2008-12-22'),
(30182,16,'2008-12-23'),
(30184,8,'2008-12-23'),
(30185,11,'2009-01-02'),
(30186,8,'2009-01-02'),
(30188,4,'2009-01-02'),
(30190,5,'2013-02-20');

--
-- Table produit
--
CREATE TABLE IF NOT EXISTS produit (
  idproduit CHAR(10) NOT NULL,
  libelle CHAR(50) NOT NULL,
  prix DECIMAL(9,2) NOT NULL,
  qstock MEDIUMINT(8) NOT NULL DEFAULT 0,
  PRIMARY KEY (idproduit)
) ENGINE=InnoDB CHARACTER SET=utf8;


--
-- Données table produit
--
INSERT INTO produit VALUES 
('CS262','CHEV. SAPIN 200x6x2',75,45),
('CS264','CHEV. SAPIN 200x6x4',120,2690),
('CS464','CHEV. SAPIN 400x6x4',220,450),
('PA45','POINTE ACIER 45 (20K)',105,580),
('PA60','POINTE ACIER 60 (10K)',95,134),
('PH222','PL. HETRE 200x20x2',230,782),
('PS222','PL. SAPIN 200x20x2',185,1220);

--
-- Table detail
--
CREATE TABLE IF NOT EXISTS detail (
  idcommande MEDIUMINT(8) UNSIGNED NOT NULL,
  idproduit CHAR(10) NOT NULL,
  qcom MEDIUMINT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (idcommande, idproduit),
  CONSTRAINT idx_fk_detail_commande FOREIGN KEY (idcommande) REFERENCES commande (idcommande),
  CONSTRAINT idx_fk_detail_produit FOREIGN KEY (idproduit) REFERENCES produit (idproduit)
) ENGINE=InnoDB CHARACTER SET=utf8;

--
-- Données table detail
--
INSERT INTO detail VALUES 
(30178,'CS464',25),
(30179,'CS262',60),
(30179,'PA60',20),
(30182,'PA60',30),
(30184,'CS464',120),
(30184,'PA45',20),
(30185,'CS464',260),
(30185,'PA60',15),
(30185,'PS222',600),
(30186,'PA45',3),
(30188,'CS464',180),
(30188,'PA45',22),
(30188,'PA60',70),
(30188,'PH222',92);