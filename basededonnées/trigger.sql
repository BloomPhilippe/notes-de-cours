/*
CREATE TABLE IF NOT EXISTS `commande_externe` (
  `fournisseur` char(10) NOT NULL,
  `idproduit` char(10) NOT NULL,
  `qcom` mediumint(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idproduit`),
  KEY `fk_detail_produit` (`idproduit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
*/

/* Exe 3 et 4 */
DROP TRIGGER IF EXISTS commande_details_before_insert;
DELIMITER |
CREATE TRIGGER commande_details_before_insert
BEFORE INSERT
ON detail
FOR EACH ROW
BEGIN
  DECLARE stock_insufisant CONDITION FOR SQLSTATE '99999';
  SET @stock_actuel := (SELECT qstock FROM produit WHERE idproduit = NEW.idproduit);
  SET @stock_minimal := (SELECT stock_minimal FROM produit WHERE idproduit = NEW.idproduit);

  IF @stock_actuel = 0 THEN
	  SIGNAL stock_insufisant
	  SET MESSAGE_TEXT = 'Stock actuel insufisant';
  END IF;

  IF @stock_actuel < NEW.qcom THEN
	  SET NEW.qcom := @stock_actuel;
  END IF;

  SET @rest := (@stock_actuel - NEW.qcom);

  IF @rest <= @stock_minimal THEN
	  INSERT INTO commande_externe(fournisseur, idproduit, qcom)
    VALUES('Machin', NEW.idproduit, 100);
  END IF;

  UPDATE produit SET qstock = @rest WHERE idproduit = NEW.idproduit;

END|
DELIMITER ;

/* EXE 5 */

/*
CREATE TABLE hist_produit LIKE produit;

ALTER TABLE hist_produit ADD COLUMN created_at DATETIME NULL;
ALTER TABLE hist_produit UPDATE COLUMN created_at DATETIME NULL;
ALTER TABLE `clicom`.`hist_produit` DROP PRIMARY KEY, ADD INDEX (`idproduit`)COMMENT '';
*/

DROP TRIGGER IF EXISTS add_historique_before_update;
DELIMITER |
CREATE TRIGGER add_historique_before_update
BEFORE UPDATE
ON produit
FOR EACH ROW
BEGIN

  INSERT INTO hist_produit(idproduit, libelle, prix, qstock, stock_minimal, created_at)
  VALUES(OLD.idproduit, OLD.libelle, OLD.prix, OLD.qstock, OLD.stock_minimal, NOW());

END|
DELIMITER ;



INSERT INTO commande(idcommande, idclient, datecom)
  VALUES(NULL, 4, NOW());

INSERT INTO detail(idcommande, idproduit, qcom)
  VALUES(LAST_INSERT_ID(), 'CS264', 300);

