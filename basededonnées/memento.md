## procedure avec curseur

````
DROP PROCEDURE IF EXISTS test_curseur;
DELIMITER |
CREATE PROCEDURE test_curseur()
BEGIN
 -- Déclaration des variables
 DECLARE l_idproduit CHAR(10);
 DECLARE l_libelle CHAR(50);
 DECLARE l_prix DECIMAL(9,2);
 DECLARE l_qstock MEDIUMINT(8);
 
 -- Déclaration des conditions
 DECLARE l_n_produits INT;

 -- Déclaration des curseurs
 DECLARE curseur_produits CURSOR
 FOR
 SELECT * FROM produit;
 
 -- Déclaration des gestionnaires d'erreur

 -- Début du traitement
 SELECT 'START PROCEDURE test_curseur';
 SELECT COUNT(*) INTO l_n_produits FROM produit ;
 OPEN curseur_produits;

 REPEAT
  FETCH curseur_produits INTO l_idproduit, l_libelle, l_prix, l_qstock;
  SELECT l_idproduit, l_libelle, l_prix, l_qstock;
  SET l_n_produits := l_n_produits – 1;
  
 UNTIL l_n_produits <= 0
 END REPEAT;

 CLOSE curseur_produits;
 SELECT 'END PROCEDURE test_curseur';
END|
DELIMITER ;
````

## procedure avec signal erreur

````
DROP PROCEDURE IF EXISTS test_declenchement;
DELIMITER |
CREATE PROCEDURE test_declenchement(IN pi_valeur INT)
BEGIN
 -- ERREUR PRECISE --
 DECLARE CONTINUE HANDLER FOR 1452
 BEGIN
  SELECT 'erreur rencontrée et gérée';
 END;
 
  -- ERREUR CUSTOM --
 DECLARE condition_test CONDITION FOR SQLSTATE '99999';
 
  -- ERREUR GLOBALE --
 DECLARE EXIT HANDLER FOR SQLWARNING, SQLEXCEPTION
 BEGIN
  SELECT 'Erreur détectée';
 END;

 IF pi_valeur > 10 THEN
 SIGNAL condition_test
 SET MESSAGE_TEXT = 'Test message';
 END IF;
END |
DELIMITER ;
````

## TRIGGER

````
DROP TRIGGER IF EXISTS client_before_insert;
DELIMITER |
CREATE TRIGGER client_before_insert
BEFORE INSERT
ON client
FOR EACH ROW
BEGIN
 SET NEW.cat := 'A0';
END|
DELIMITER ;
````
