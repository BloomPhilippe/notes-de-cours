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
 DECLARE plus_d_enregistrement CONDITION FOR 1329;

 -- Déclaration des curseurs
 DECLARE curseur_produits CURSOR
 FOR
 SELECT * FROM produit;
 
 -- Déclaration des gestionnaires d'erreur
 DECLARE CONTINUE HANDLER FOR plus_d_enregistrement
 BEGIN
  SET l_fin_de_boucle:=TRUE;
 END;

 -- Début du traitement
 SELECT 'START PROCEDURE test_curseur';
 OPEN curseur_produits;

 REPEAT
   FETCH curseur_produits INTO l_idproduit, l_libelle, l_prix, l_qstock;
   SELECT l_idproduit, l_libelle, l_prix, l_qstock;
   UNTIL l_fin_de_boucle>0
 END REPEAT;

 CLOSE curseur_produits;
 SELECT 'END PROCEDURE test_curseur';
END|
DELIMITER ;
````
