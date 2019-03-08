# Procédure & fonction

La différence entre une procédure et une fonction :

- Dans la procédure on peut utiliser une à plusieurs transaction et dans une fonction les transactions sont interdites
- Une fonction est souvent destinée à être utilisée dans une requête (count, max, min, avg,...)
- Une procédure est souvent destiné à être une ou plusieur requête (plusieurs actions)
- Une procédure ne peut fournir une valeur qu'avec une variable de sortie

:exclamation: Déclarer toutes ses variable juste après BEGIN

```sql
drop procedure if exists `client_list`;
delimiter |
create procedure client_list(IN pi_nom VARCHAR(30))
begin
	select * from client
	where nom = pi_nom;
end|
delimiter ;


delimiter |
create function test_compteur() returns int deterministic
begin
	declare l_compt int default 0;
	return 1;
end|
delimiter ; 



-- procedure select client by locality:

DROP PROCEDURE IF EXISTS get_clients_by_cp;
delimiter |
CREATE procedure get_clients_by_cp(IN pi_cp VARCHAR(255))
BEGIN
	SELECT * FROM client
	WHERE code_postal = pi_cp;
END|
delimiter ;

SET @cp := '5000';
CALL get_clients_by_cp(@cp);


-- procedure select by command by client name:

DROP PROCEDURE IF EXISTS get_commande_by_client_name;
delimiter |
CREATE PROCEDURE get_commande_by_client_name(IN pi_name VARCHAR(255))
BEGIN
	SELECT * FROM client
	LEFT JOIN commande ON client.idclient = commande.idclient
	LEFT JOIN detail ON commande.idcommande = detail.idcommande
	WHERE client.nom = pi_name;
END|
delimiter ;

SET @name := 'MERCIERS';
CALL get_commande_by_client_name(@name);


/*
 * Sur base d'un paramètre représentant l'id d'un client, vous
 * afficherez s'il existe des commandes ainsi que leur nombre
 */

DROP FUNCTION IF EXISTS has_command;
DELIMITER |
CREATE FUNCTION has_command(pi_count INT) RETURNS BOOLEAN 
DETERMINISTIC
BEGIN
	IF pi_count = 0 THEN
		RETURN FALSE;
	ELSE
		RETURN TRUE;
	END IF;
END |
DELIMITER ;

SELECT count(*), has_command(count(*))
FROM commande
WHERE idclient = 8;


/*
 * Sur base d'un paramètre représentant l'id d'un client, vous
 * déterminerez et afficherez si l'état de son compte est supérieur,
 * égal ou inférieur à la moyenne des comptes, que vous afficherez
 * également
 */

DROP FUNCTION IF EXISTS compare_solde;
DELIMITER |
CREATE FUNCTION compare_solde(solde decimal(9,2), moyenne decimal(9,2)) RETURNS VARCHAR(255) 
DETERMINISTIC
BEGIN
	IF solde > moyenne THEN
		RETURN 'Supérieur';
	ELSE
		RETURN 'Inférieur';
	END IF;
END |
DELIMITER ;

SET @moyenne_global := (SELECT AVG(`compte`) FROM client);
SELECT compte, @moyenne_global AS moyenne, compare_solde(compte, @moyenne_global) AS Resultat
FROM client
WHERE idclient = 8;


/*
 * Sur base d'un paramètre représentant l'id d'un produit, vous
 * afficherez le libellé et la quantité totale commandée
 *
 */
 
 DROP PROCEDURE IF EXISTS produit_nbr_command;
DELIMITER |
CREATE PROCEDURE produit_nbr_command(IN pi_produit VARCHAR(255))
BEGIN
		SELECT (SELECT libelle FROM produit WHERE idproduit=pi_produit) AS nom, (SELECT count(*) FROM detail WHERE idproduit=pi_produit) AS nbr;
END |
DELIMITER ;

SET @produit := 'PS222';
CALL produit_nbr_command(@produit);



/*
 * Sur base d'un paramètre représentant l'id d'un client, vous
   afficherez, en fonction de son compte et selon les gammes
   suivantes, le message correspondant :
 */
 
 DROP PROCEDURE IF EXISTS gamme_client;
DELIMITER |
CREATE PROCEDURE gamme_client(IN pi_client INT)
BEGIN
	 DECLARE solde decimal(9,2);
	 DECLARE gamme VARCHAR(255);

	 SET solde := (SELECT compte FROM client WHERE idclient=pi_client);
	 
	 IF solde <= 0 THEN
	  	SET gamme := 'Gamme 0';
	  	SELECT gamme AS 'La gamme';
	 ELSEIF solde <= 2000 THEN
	 	SET gamme := 'Gamme 1';
	 ELSEIF solde <= 4000 THEN
	 	SET gamme := 'Gamme 2';
	 ELSEIF solde <= 6000 THEN
	 	SET gamme := 'Gamme 3';
	 ELSE
	  	SET gamme := 'Gamme 4';
	 END IF;

	 SELECT solde AS 'Le solde', gamme AS 'La gamme';
END |
DELIMITER ;

SET @client := 2;
CALL gamme_client(@client);
 

/*
 * Multiplication
 */
 
 DROP PROCEDURE IF EXISTS multiplication;
DELIMITER |
CREATE PROCEDURE multiplication(IN pi_nbr INT)
BEGIN
	DECLARE l_max INT DEFAULT 10;
 	DECLARE l_compteur INT DEFAULT 1;
 	DECLARE valeur INT DEFAULT 1;
 	DECLARE result VARCHAR(255) DEFAULT '';
 	DECLARE actuel_requete VARCHAR(255) DEFAULT '';

 WHILE l_compteur <= l_max DO
 	SET valeur := pi_nbr * l_compteur;
	SET actuel_requete := CONCAT_WS('','(SELECT ', valeur,') AS x',l_compteur);
	IF l_compteur = 1 THEN
	  	SET result := actuel_requete;
	 ELSE
	  	SET result := CONCAT_WS(',',result, actuel_requete);
	 END IF;
	SET l_compteur := l_compteur + 1;
	# Reset variable actual request
	SET actuel_requete := '';
 END WHILE;

 SET @query := CONCAT_WS(' ','SELECT', result);
 PREPARE select_multiplication
 FROM @query;
 EXECUTE select_multiplication;

END |
DELIMITER ;

SET @nbr := 3;
CALL multiplication(@nbr);
```
